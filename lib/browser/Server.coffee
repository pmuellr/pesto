# Licensed under the Apache License. See footer for details.

events = require "events"

_ = require "underscore"

utils = require "../common/utils"

#-------------------------------------------------------------------------------
# emits:
#     event(message)
#     event-{eventName}(message)
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
module.exports = class Server extends events.EventEmitter

    #---------------------------------------------------------------------------
    constructor: (@url, @options) ->
        @logger       = @options.logger
        @tracer       = @logger.tracer __filename
        @callbacks    = {}
        @nextCallback = utils.getSequencer "bcb"

    #---------------------------------------------------------------------------
    connect: ->
        opts = 
            reconnect: !!@options.reconnect

        @socket = io.connect @url, opts

        @socket.on "connect", =>
            # @logger.log "connected to server"

        @socket.on "disconnect", =>
            # @logger.log "disconnected from server"

        @socket.on "message", (message) =>
            message = JSON.parse(message)
            return @_onEvent    message if message.event
            return @_onResponse message if message.response 

            @logger.log "received invalid message: #{utils.Jl message}"

    #---------------------------------------------------------------------------
    send_v8_request:             (body, callback) -> @_sendRequest "v8-request",             body, callback
    send_pesto_attach:          (body, callback) -> @_sendRequest "pesto-attach",          body, callback
    send_pesto_detach:          (body, callback) -> @_sendRequest "pesto-detach",          body, callback
    send_pesto_get_info:        (body, callback) -> @_sendRequest "pesto-get-info",        body, callback
    send_pesto_get_client_info: (body, callback) -> @_sendRequest "pesto-get-client-info", body, callback
    send_pesto_get_target_info: (body, callback) -> @_sendRequest "pesto-get-target-info", body, callback
    send_pesto_connect:         (body, callback) -> @_sendRequest "pesto-connect",         body, callback
    send_pesto_disconnect:      (body, callback) -> @_sendRequest "pesto-disconnect",      body, callback

    #---------------------------------------------------------------------------
    _sendRequest: (request, body, callbackFn) ->
        callback = @nextCallback()
        message    = {request, callback, body}
        
        @callbacks[callback] = callbackFn || ->

        # @tracer.vlog "_sendRequest(#{utils.Jl message})"
            
        @socket.send JSON.stringify(message)

    #---------------------------------------------------------------------------
    _onResponse: (message) ->
        # @tracer.vlog "_onResponse(#{utils.Jl message})"

        {response, callback, body} = message

        callbackFn = @callbacks[callback]
        delete @callbacks[callback]
        
        callbackFn body

    #---------------------------------------------------------------------------
    _onEvent: (message) ->
        # @tracer.vlog "_onEvent(#{utils.Jl message})"

        method = "_on_event_#{message.event.replace /-/g, '_'}"
        method = @[method]

        return @logger.log "unhandled event '#{message.event}'" if !method

        method.call @, message

    #---------------------------------------------------------------------------
    _on_event_v8_event: (message) ->
        @tracer.vlog "_on_event_v8_event(#{utils.Jl message})"
        target = @_getTarget message; return if !target

        target.v8_event message.body.event

    #---------------------------------------------------------------------------
    _on_event_pesto_error: (message) ->
        @logger.log "pesto error from server: #{message}"

    #---------------------------------------------------------------------------
    _on_event_pesto_connected: (message) ->
        client = @_getClient message; return if !client
        target = @_getTarget message; return if !target

        @connManager.connect client, target

    #---------------------------------------------------------------------------
    _on_event_pesto_disconnected: (message) ->
        client = @_getClient message; return if !client
        target = @_getTarget message; return if !target

        @connManager.disconnect client, target

    #---------------------------------------------------------------------------
    _on_event_pesto_client_attached: (message) ->
        client = @_getClient message; return if !client
        return if @connManager.getClient client.id

        @connManager.clientAttached client

    #---------------------------------------------------------------------------
    _on_event_pesto_client_detached: (message) ->
        client = @_getClient message; return if !client

        @connManager.clientDetached client

    #---------------------------------------------------------------------------
    _on_event_pesto_target_attached: (message) ->
        target = @_getTarget message; return if !target
        return if @connManager.getTarget target.id

        @connManager.targetAttached target

    #---------------------------------------------------------------------------
    _on_event_pesto_target_detached: (message) ->
        target = @_getTarget message; return if !target

        @connManager.targetDetached target

    #---------------------------------------------------------------------------
    _getTarget: (message) ->
        targetId = message.body.targetId
        target   = @connManager.getTarget targetId

        return target if target

        @logger.log "unknown target '#{targetId}'" if !@target
        return null

    #---------------------------------------------------------------------------
    _getClient: (message) ->
        clientId = message.body.clientId
        client   = @connManager.getClient clientId

        return client if client

        @logger.log "unknown client '#{clientId}'" if !@client
        return null
 
#-------------------------------------------------------------------------------
# Copyright 2013 I.B.M.
# 
# Licensed under the Apache License, Version 2.0 (the "License")
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#-------------------------------------------------------------------------------

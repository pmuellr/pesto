# Licensed under the Apache License. See footer for details.

dns  = require "dns"
util = require "util"

pkg                = require "../../package.json"
utils              = require "../common/utils"
# PestoClientEvents = require "./PestoClientEvents"

NextClientId = utils.getSequencer "c"

#-------------------------------------------------------------------------------
module.exports = class Client

    #---------------------------------------------------------------------------
    constructor: (@opts, @socket) ->
        @id             = NextClientId()
        @connManager    = @opts.connManager
        @logger         = @opts.logger
        @tracer         = @logger.tracer __filename
        @callbacks      = {}
        @nextCallbackId = utils.getSequencer "scb"
        @attached       = false
        @info           = null
        @ip             = @socket.handshake.address.address

        # @tracer.vlog "new Client(#{@id})"

        reverseIP @ip, (hostname) => 
            @hostname = hostname

        @socket.on "message", (request) => @_on_request request
        @socket.on "disconnect",        => @_on_disconnect()

    #---------------------------------------------------------------------------
    sendResponse: (request, body) ->
        message =
            response: request.request
            callback: request.callback
            body:     body

        # @tracer.vlog "sendResponse(#{utils.Jl message}"
        @socket.send JSON.stringify(message)
    
    #---------------------------------------------------------------------------
    sendEvent: (eventName, body) ->
        message =
            event: eventName
            body:  body

        # @tracer.vlog "sendEvent(#{utils.Jl message}"
        @socket.send JSON.stringify(message)
        
    #---------------------------------------------------------------------------
    sendErrorEvent: (error) ->
        @sendEvent "pesto-error", message: error

    #---------------------------------------------------------------------------
    _on_request: (request) ->
        request = JSON.parse request

        # @tracer.vlog "_on_request(#{utils.Jl request})"
       
        return @sendErrorEvent "no request body"      if !request?
        return @sendErrorEvent "no request specified" if !request.request?

        request.body = {} if !request.body?

        if !@attached and (request.request isnt "pesto-attach")
            return @sendErrorEvent "not attached" 

        method = "_on_request_#{request.request.replace /-/g, '_'}"

        method = @[method]
        return @sendErrorEvent "invalid request '#{request}'" if !method

        method.call @, request

    #---------------------------------------------------------------------------
    _on_disconnect: ->
        @tracer.vlog "_on_disconnect()"
        @connManager.clientDetached @

    #---------------------------------------------------------------------------
    _on_request_v8_request: (request) ->
        targetId = request.body.targetId
        target = @connManager.getTarget targetId
        if !target
            @logger.log "v8 request to unattached target: #{targetId}"
            return

        target.sendRequest request.body.request, (response) =>
            @sendResponse request,
                targetId: targetId
                response: response 

    #---------------------------------------------------------------------------
    _on_request_pesto_attach: (request) ->
        @info     = request.info 
        @attached = true

        @sendResponse request, 
            clientId: @id

        @connManager.clientAttached @

    #---------------------------------------------------------------------------
    _on_request_pesto_detach: (request) ->
        @connManager.clientDetached @
        @sendResponse request, null

    #---------------------------------------------------------------------------
    _on_request_pesto_get_info: (request) ->
        @sendResponse request,
            name:      pkg.name
            version:   pkg.version
            clientIds: @connManager.getAttachedClientIds()
            targetIds: @connManager.getAttachedTargetIds()

    #---------------------------------------------------------------------------
    _on_request_pesto_get_client_info: (request) ->
        client = @connManager.getClient request.body.clientId
        return @sendResponse request, null if !client

        @sendResponse request,
            ip:               client.ip
            hostname:         client.hostname
            info:             client.info
            connectedTargets: @connManager.getConnectedTargetIds client

    #---------------------------------------------------------------------------
    _on_request_pesto_get_target_info: (request) ->
        target = @connManager.getTarget request.body.targetId
        return @sendResponse request, null if !target

        @sendResponse request,
            connectedClients: @connManager.getConnectedClientIds target
            running:          target.running
            node:             target.node

    #---------------------------------------------------------------------------
    _on_request_pesto_connect: (request) ->
        target = @connManager.getTarget request.targetId
        return @sendResponse request, {success: false} if !target

        @connManager.connect @, target
        @sendResponse request, 
            success: true

    #---------------------------------------------------------------------------
    _on_request_pesto_disconnect: (request) ->
        target = @connManager.getTarget request.targetId
        return @sendResponse request, {success: false} if !target

        @connManager.disconnect @, target
        @sendResponse request,
            success: true

#-------------------------------------------------------------------------------
reverseIP = (addr, callback) ->
    dns.reverse addr, (err, domains) ->
        domains = ["<unknown>"] if err
        domains = ["<unknown>"] if domains.length is 0

        callback domains[0]

#-------------------------------------------------------------------------------
# Copyright 2013 I.B.M.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
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

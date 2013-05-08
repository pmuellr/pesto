# Licensed under the Apache License. See footer for details.

path   = require "path"
events = require "events"

_ = require "underscore"

#-------------------------------------------------------------------------------
# moved to the bottom to avoid recursive requires
#-------------------------------------------------------------------------------
utils                  = require "../common/utils"
BasicConnectionManager = require "../common/BasicConnectionManager"

Client = require "./Client"
Target = require "./Target"

#-------------------------------------------------------------------------------
# responsible for maintaining client/target attached/connected state,
# and sending events to clients when these states change
#-------------------------------------------------------------------------------
module.exports = class ConnectionManager extends BasicConnectionManager

    #---------------------------------------------------------------------------
    constructor: (@opts) ->
        super

        @tracer  = @logger.tracer __filename
        @emitter = new events.EventEmitter

    #---------------------------------------------------------------------------
    start: ->
        @initFromServer()

    #---------------------------------------------------------------------------
    addListener:    (event, listener)  -> @emitter.addListener    event, listener
    removeListener: (event, listener)  -> @emitter.removeListener event, listener
    emit:           (event, eventData) -> @emitter.emit           event, eventData

    #---------------------------------------------------------------------------
    sendEvent: (event, body) ->
        @emitter.emit event, body

    #---------------------------------------------------------------------------
    getClient: (clientId) -> 
        client = super
        return client if client

        client = new Client clientId
        @attachedClients[clientId] = client

        @server.send_pesto_get_client_info {clientId}, (body) =>
            return if !body
            client.refresh body
            @clientAttached client

        return client

    #---------------------------------------------------------------------------
    getTarget: (targetId) -> 
        target = super
        return target if target

        target = new Target targetId
        @attachedTargets[targetId] = target

        @server.send_pesto_get_target_info {targetId}, (body) =>
            return if !body
            target.refresh body
            @targetAttached target

        return target

    #---------------------------------------------------------------------------
    initFromServer: ->

        info = 
            location: window.location.href

        @server.send_pesto_attach info, ({clientId}) =>
            # @getClient clientId

            @server.send_pesto_get_info null, (body) =>

                for clientId in body.clientIds
                    @getClient clientId

                for targetId in body.targetIds
                    @getTarget targetId

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


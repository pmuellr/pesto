# Licensed under the Apache License. See footer for details.

path   = require "path"
events = require "events"

_ = require "underscore"

#-------------------------------------------------------------------------------
# moved to the bottom to avoid recursive requires
#-------------------------------------------------------------------------------
utils                  = require "../common/utils"
BasicConnectionManager = require "../common/BasicConnectionManager"

#-------------------------------------------------------------------------------
# responsible for maintaining client/target attached/connected state,
# client/target ids, and sending events to clients when these states change
#-------------------------------------------------------------------------------
module.exports = class BasicConnectionManager

    #---------------------------------------------------------------------------
    constructor: (@opts) ->
        @connections       = []
        @attachedClients   = {}
        @attachedTargets   = {}
        @logger            = @opts.logger
        @tracer            = @logger.tracer __filename

    #---------------------------------------------------------------------------
    getClient:             (clientId) -> return @attachedClients[clientId]
    getTarget:             (targetId) -> return @attachedTargets[targetId]
    getAttachedClients:               -> return _.values @attachedClients
    getAttachedClientIds:             -> return _.keys   @attachedClients
    getAttachedTargets:               -> return _.values @attachedTargets
    getAttachedTargetIds:             -> return _.keys   @attachedTargets
    getConnectedTargets:   (clientId) -> return _.values @_getConnectedTargets clientId
    getConnectedTargetIds: (clientId) -> return _.keys   @_getConnectedTargets clientId
    getConnectedClients:   (targetId) -> return _.values @_getConnectedClients targetId
    getConnectedClientIds: (targetId) -> return _.keys   @_getConnectedClients targetId

    #---------------------------------------------------------------------------
    _getConnectedClients: (targetId) ->
        connections = _.filter @connections, (connection) ->
            return connection.target.id is targetId

        result = {}

        for connection in connections
            client = connection.client
            result[client.id] = client

        return result

    #---------------------------------------------------------------------------
    _getConnectedTargets: (clientId) ->
        connections = _.filter @connections, (connection) ->
            return connection.client.id is clientId

        result = {}

        for connection in connections
            target = connection.target
            result[target.id] = target

        return result

    #---------------------------------------------------------------------------
    clientAttached: (client) ->
        @tracer.vlog "client attached: #{client.id}"

        @attachedClients[client.id] = client

        @sendEvent "pesto-client-attached",
            clientId: client.id

    #---------------------------------------------------------------------------
    clientDetached: (client) ->
        @tracer.vlog "client detached: #{client.id}"

        for targets in @getConnectedTargets client.id
            @disconnect client, target

        delete @attachedClients[client.id]

        @sendEvent "pesto-client-detached",
            clientId: client.id

    #---------------------------------------------------------------------------
    targetAttached: (target) ->
        @tracer.vlog "target attached: #{target.id}"

        @attachedTargets[target.id] = target

        @sendEvent "pesto-target-attached",
            targetId: target.id
        
    #---------------------------------------------------------------------------
    targetDetached: (target) ->
        @tracer.vlog "target detached: #{target.id}"

        for client in @getConnectedClients target.id
            @disconnect client, target
        
        delete @attachedTargets[target.id]

        @sendEvent "pesto-target-detached",
            targetId: target.id

    #---------------------------------------------------------------------------
    connect: (client, target) ->
        @tracer.vlog "connect: #{client.id}, #{target.id}"

        targets = @getConnectedTargets client
        return if target in targets

        @connections.push {client, target}

        @sendEvent "pesto-connected",
            clientId: client.id
            targetId: target.id

    #---------------------------------------------------------------------------
    disconnect: (client, target) ->
        @tracer.vlog "disconnect: #{client.id}, #{target.id}"

        targets = @getConnectedTargets client
        return if target !in targets

        @connections = _.reject @connections, (connection) ->
            return (connection.client is client) and (connection.target is target)

        @sendEvent "pesto-disconnected",
            clientId: client.id
            targetId: target.id

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


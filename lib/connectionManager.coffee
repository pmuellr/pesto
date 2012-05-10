#-------------------------------------------------------------------------------
# Copyright 2012 Patrick Mueller
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#-------------------------------------------------------------------------------

events = require 'events'

_ = require 'underscore'

utils         = null
PestoEvents   = null
PestoRequests = null

#-------------------------------------------------------------------------------
class ConnectionManager

    #---------------------------------------------------------------------------
    constructor: () ->
        @nextId            = 1
        @connections       = []
        @clientAttachments = []
        @targetAttachments = []
        @seqMap            = {}
        @agentMap          = {}

    #---------------------------------------------------------------------------
    handleClientRequest: (client, message) ->
        # utils.logTrace "ConnectionManager.handleClientRequest", "message: #{utils.Jl(message)}"
        
        if message.command.match /^pesto-/
            @handlePestoClientRequest client, message
            return
            
        target = @getConnectedTarget client
        return if !target
        
        oldSeq = message.seq
        newSeq = target.sendRequest message
        
        @seqMap[newSeq] = [client, oldSeq]

    #---------------------------------------------------------------------------
    handlePestoClientRequest: (client, message) ->

        if message.command == 'pesto-getInfo'
            PestoRequests.pesto_getInfo client, message
            return
        
        if message.command == 'pesto-getTargets'
            PestoRequests.pesto_getTargets client, message
            return

        if message.command == 'pesto-connectTarget'
            PestoRequests.pesto_connectTarget client, message
            return
            
        utils.logError "unknown pesto command #{message.command}"

    #---------------------------------------------------------------------------
    handleTargetResponse: (target, message) ->
        [client, oldSeq] = @seqMap[message.request_seq]
        return if !client
        
        delete @seqMap[message.request_seq]
        
        message.request_seq = oldSeq
        client.sendResponse message
    
    #---------------------------------------------------------------------------
    handleTargetEvent: (target, message) ->
        # utils.logTrace "ConnectionManager.handleTargetEvent", "message: #{utils.Jl(message)}"
    
        clients = @getConnectedClients(target)
        
        for client in clients
            client.sendEvent message
    
    #---------------------------------------------------------------------------
    connect: (client, target) ->
        for connection in @connections
            if (connection[0] == client) && (connection[1] == target)
                return
            
        oldTarget = @getConnectedTarget client
        if oldTarget
            @disconnect client, oldTarget
            
        @connections.push [client, target]
        
        PestoEvents.sendEventConnected client, target
        
    #---------------------------------------------------------------------------
    disconnect: (client, target) ->
    
        index = 0
        for connection in @connections
            if (connection[0] == client) && (connection[1] == target)
                @connections.splice(index,1)
                
                PestoEvents.sendEventDisconnected client, target
                return
                
            index++
                
    #---------------------------------------------------------------------------
    clientAttached: (client) ->
        @clientAttachments.push(client)
        
        client.id = @nextId++
        @agentMap[client.id] = client
            

    #---------------------------------------------------------------------------
    targetAttached: (target) ->
        @targetAttachments.push(target)

        target.id = @nextId++
        @agentMap[target.id] = target

        for client in @getAttachedClients()
            PestoEvents.sendEventTargetAttached client, target
        
    #---------------------------------------------------------------------------
    clientDetached: (client) ->
        target = @getConnectedTarget(client)
        return if !target
        
        @disconnect(client, target)

        @clientAttachments = _.without(@clientAttachments, client)
        delete @agentMap[client.id]

    #---------------------------------------------------------------------------
    targetDetached: (target) ->
        clients = @getConnectedClients(target)
        
        for client in clients
            @disconnect(client, target)

        @targetAttachments = _.without(@targetAttachments, target)
        delete @agentMap[target.id]

        for client in @getAttachedClients()
            PestoEvents.sendEventTargetDetached client, target

    #---------------------------------------------------------------------------
    getAttachedClients: () ->
        @clientAttachments.slice()

    #---------------------------------------------------------------------------
    getAttachedTargets: () ->
        @targetAttachments.slice()

    #---------------------------------------------------------------------------
    getConnectedClients: (target) ->
        result = []
        for connection in @connections
            if connection[1] == target
                result.push connection[0]
                
        result
        
    #---------------------------------------------------------------------------
    getConnectedTarget: (client) ->
        
        for connection in @connections
            if connection[0] == client
                return connection[1]
                
        null

    #---------------------------------------------------------------------------
    getAgentById: (id) ->
        @agentMap[id]

    #---------------------------------------------------------------------------
    toString: ->
        "#{@constructor.name}{}"


#-------------------------------------------------------------------------------
module.exports = new ConnectionManager

#-------------------------------------------------------------------------------
# moved to the bottom to avoid recursive requires
#-------------------------------------------------------------------------------
utils         = require './utils'
PestoEvents   = require './PestoEvents'
PestoRequests = require './PestoRequests'


# Licensed under the Tumbolia Public License. See footer for details.

events = require 'events'

_ = require 'underscore'

utils         = null
PestoEvents   = null
PestoRequests = null

def = require('./prettyStackTrace').def

#-------------------------------------------------------------------------------
def class ConnectionManager

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
        # utils.logTrace arguments.callee, "message: #{utils.Jl(message)}"
        
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
        # utils.logTrace arguments.callee, "message: #{utils.Jl(message)}"
    
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

#-------------------------------------------------------------------------------
# Copyright (c) 2012 Patrick Mueller
# 
# Tumbolia Public License
# 
# Copying and distribution of this file, with or without modification, are
# permitted in any medium without royalty provided the copyright notice and this
# notice are preserved.
# 
# TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
# 
#   0. opan saurce LOL
#-------------------------------------------------------------------------------
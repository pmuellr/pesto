# Licensed under the Tumbolia Public License. See footer for details.

events = require 'events'
_      = require 'underscore'

utils = require "./utils"

#-------------------------------------------------------------------------------
# emits:
#     targetAttached
#          { target: aTarget }
#     clientAttached
#          { client: aClient }
#     connected
#          { client: aClient, target: aTarget }
#     disconnected
#          { client: aClient, target: aTarget }
#     targetDetached
#          { target: aTarget }
#     clientDetached
#          { client: aClient }
#-------------------------------------------------------------------------------
class ConnectionManager extends events.EventEmitter

    #---------------------------------------------------------------------------
    constructor: () ->
        @nextId            = 1
        @connections       = []
        @clientAttachments = []
        @targetAttachments = []

    #---------------------------------------------------------------------------
    attachClient: (client) ->
        utils.logVerbose "clientAttached"

        client.id = @nextId++
        @clientAttachments.push client
        @emit "clientAttached", client
        
    #---------------------------------------------------------------------------
    detachClient: (client) ->
        utils.logVerbose "clientDetached"
        
        client.dead = true

        @clientAttachments = _.without @clientAttachments, client

        target = @getConnectedTarget client
        if target
            @disconnect(client, target)

        @emit "clientDetached", client
        
    #---------------------------------------------------------------------------
    attachTarget: (target) ->
        utils.logVerbose "targetAttached"
        
        target.id = @nextId++
        @targetAttachments.push target
        @emit "targetAttached", target

    #---------------------------------------------------------------------------
    detachTarget: (target) ->
        utils.logVerbose "targetDetached"
        
        target.dead = true
        @targetAttachments = _.without @targetAttachments, target
        
        clients = @getConnectedClients target
        for client in clients
            @disconnect(client, target)
        
        @emit "targetDetached", target

    #---------------------------------------------------------------------------
    connect: (client, target) ->
        utils.logVerbose "client/target connected"
        
        for connection in @connections
            if (connection[0] == client) && (connection[1] == target)
                return
            
        oldTarget = @getConnectedTarget client
        if oldTarget
            @disconnect client, oldTarget
            
        @connections.push [client, target]
        @emit "connected", 
            client: client
            target: target
            
    #---------------------------------------------------------------------------
    disconnect: (client, target) ->
        utils.logVerbose "client/target disconnected"

        index = 0
        for connection in @connections
            if (connection[0] == client) && (connection[1] == target)
            
                @connections.splice(index,1)
                @emit "disconnected", 
                    client: client
                    target: target
                    
                return
                
            index++
                
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

#-------------------------------------------------------------------------------
module.exports = new ConnectionManager

#-------------------------------------------------------------------------------
# moved to the bottom to avoid recursive requires
#-------------------------------------------------------------------------------
utils = require './utils'

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

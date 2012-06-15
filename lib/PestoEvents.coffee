# Licensed under the Tumbolia Public License. See footer for details.

utils  = require './utils'

#-------------------------------------------------------------------------------
module.exports = class PestoEvents

    #---------------------------------------------------------------------------
    @sendConnected: (client, target) ->
        message = 
            type:  'event'
            event: 'pesto-target-connected'
            body:
                target: target.id
                
        client.send message
    
    #---------------------------------------------------------------------------
    @sendDisconnected: (client, target) ->
        message = 
            type:  'event'
            event: 'pesto-target-disconnected'
            body:
                target: target.id
                
        client.send message

    #---------------------------------------------------------------------------
    @sendTargetAttached: (client, target) ->
        message = 
            type:  'event'
            event: 'pesto-target-attached'
            body:
                target: 
                    id:          target.id
                    description: target.description
                
        client.send message
    
    
    #---------------------------------------------------------------------------
    @sendTargetDetached: (client, target) ->
        message = 
            type:  'event'
            event: 'pesto-target-detached'
            body:
                target: 
                    id: target.id
                
        client.send message
    
    
    #---------------------------------------------------------------------------
    @sendClientConnected: (client, message) ->
        message = 
            type:  'event'
            event: 'pesto-client-connected'
                
        client.send message

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

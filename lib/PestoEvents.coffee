# Licensed under the Tumbolia Public License. See footer for details.

utils  = require './utils'

def = require('./prettyStackTrace').def

#-------------------------------------------------------------------------------
module.exports = def class PestoEvents

    #---------------------------------------------------------------------------
    @sendEventConnected: (client, target) ->
        message = 
            type:  'event'
            event: 'pesto-target-connected'
            body:
                target: target.id
                
        client.sendEvent message
    
    #---------------------------------------------------------------------------
    @sendEventDisconnected: (client, target) ->
        message = 
            type:  'event'
            event: 'pesto-target-disconnected'
            body:
                target: target.id
                
        client.sendEvent message

    #---------------------------------------------------------------------------
    @sendEventTargetAttached: (client, target) ->
        message = 
            type:  'event'
            event: 'pesto-target-attached'
            body:
                target: 
                    id:          target.id
                    description: target.description
                
        client.sendEvent message
    
    
    #---------------------------------------------------------------------------
    @sendEventTargetDetached: (client, target) ->
        message = 
            type:  'event'
            event: 'pesto-target-detached'
            body:
                target: 
                    id: target.id
                
        client.sendEvent message
    
    
    #---------------------------------------------------------------------------
    @sendEventPestoConnected: (client, message) ->
        message = 
            type:  'event'
            event: 'pesto-connected'
                
        client.sendEvent message

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
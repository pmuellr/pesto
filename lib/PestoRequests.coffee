# Licensed under the Tumbolia Public License. See footer for details.

utils             = null
connectionManager = null

#-------------------------------------------------------------------------------
module.exports = class PestoRequests

    #---------------------------------------------------------------------------
    @pesto_getInfo: (client, reqMessage) ->
        resMessage =
            type:        'response'
            request_seq: reqMessage.seq
            command:     reqMessage.command
            body:
                verbose: utils.config.verbose
                port:    utils.config.port
                v8port:  utils.config.v8port
                version: utils.VERSION
                program: utils.PROGRAM

        client.sendResponse resMessage
    
    #---------------------------------------------------------------------------
    @pesto_getTargets: (client, reqMessage) ->
        targets = []
        for target in connectionManager.getAttachedTargets()
            targets.push 
                id:          target.id 
                description: target.description
            
        resMessage =
            type:        'response'
            request_seq: reqMessage.seq
            command:     reqMessage.command
            body:
                targets: targets

        client.sendResponse resMessage
    
    #---------------------------------------------------------------------------
    @pesto_connectTarget: (client, reqMessage) ->
        targetId = reqMessage.targetId
        target = getAgentById(targetId)
    
        resMessage =
            type:        'response'
            request_seq: reqMessage.seq
            command:     reqMessage.command
            body:
                targetsFound: target?

        client.sendResponse resMessage
    
        if target
            connectionManager.connect(client,target)

#-------------------------------------------------------------------------------
# moved to the bottom to avoid issues w/recursive require()s
#-------------------------------------------------------------------------------
utils             = require './utils'
connectionManager = require './connectionManager'

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

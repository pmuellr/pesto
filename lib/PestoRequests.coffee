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

    
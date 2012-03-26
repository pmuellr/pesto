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

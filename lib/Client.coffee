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


utils             = require './utils'
connectionManager = require './connectionManager'

#-------------------------------------------------------------------------------
module.exports = class Client

    #---------------------------------------------------------------------------
    constructor: (@socket) ->
        @socket.on 'pesto-request', (message) => @_onRequest(message)

    #---------------------------------------------------------------------------
    sendEvent: (message) ->
        utils.logTrace "Client.sendEvent", utils.Jl(message)
        @socket.emit 'pesto-event', message
        
    #---------------------------------------------------------------------------
    sendResponse: (message) ->
        utils.logTrace "Client.sendResponse", utils.Jl(message)
        @socket.emit 'pesto-response', message
    
    #---------------------------------------------------------------------------
    _onRequest: (message) ->
        utils.logTrace "Client._onRequest", utils.Jl(message)
        connectionManager.handleClientRequest @, message

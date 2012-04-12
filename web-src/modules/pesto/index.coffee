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

PestoMessager         = require './PestoMessager'
templates             = require './templates'
InspectorFrontendHost = require './InspectorFrontendHost'

socket   = null
messager = null

widgetMap = {}

window.Pesto = {}

#-------------------------------------------------------------------------------
main = ->
    # installFunctionBind()
    
    options =
        reconnect: false
        
    socket = io.connect location.origin, options
    
    Pesto.messager = new PestoMessager(socket)
    
    Pesto.messager.on 'event', (message) -> _onEvent(message)
    
    window.InspectorFrontendHost = new InspectorFrontendHost
    
    getTargets (message) ->
        WebInspector.log "getTargets: #{JSON.stringify(message,null,4)}"
        
    getServerInfo (message) ->
        WebInspector.log "pesto server settings: #{JSON.stringify(message.body)}"
        

#-------------------------------------------------------------------------------
getTargets = (callback) ->
    message =
        command: 'pesto-getTargets'
        
    Pesto.messager.sendMessage(message, callback)

#-------------------------------------------------------------------------------
getServerInfo = (callback) ->
    message =
        command: 'pesto-getInfo'

    Pesto.messager.sendMessage(message, callback)

#-------------------------------------------------------------------------------
_onEvent = (message) ->
    WebInspector.log "event received: #{JSON.stringify(message,null,4)}"

#-------------------------------------------------------------------------------
$(document).ready ->
    main()

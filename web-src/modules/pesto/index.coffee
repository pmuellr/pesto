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

NodeMessager = require './NodeMessager'

socket   = null
messager = null

#-------------------------------------------------------------------------------
main = ->
    socket = io.connect location.origin
    
    messager = new NodeMessager(socket)
    
    messager.on 'event', (message) -> _onEvent(message)
    
    getScripts(=> @gotScripts())

#-------------------------------------------------------------------------------
getScripts = (callback) ->

    message =
        command: 'scripts'
        arguments:
            types: 7
            includeSource: false

    messager.sendMessage(message, callback)

#-------------------------------------------------------------------------------
gotScripts = (message) ->
    console.log "scripts: #{JSON.stringify(message,null,4)}"

#-------------------------------------------------------------------------------
_onEvent = (message) ->
    console.log "event received: #{JSON.stringify(message,null,4)}"

#-------------------------------------------------------------------------------
main()
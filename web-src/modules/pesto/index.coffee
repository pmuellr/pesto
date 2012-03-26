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
Widget                = require './Widget'
templates             = require './templates'
InspectorFrontendHost = require './InspectorFrontendHost'

socket   = null
messager = null

widgetMap = {}

#-------------------------------------------------------------------------------
main = ->

    installFunctionBind()
    
    options =
        reconnect: false
        
    socket = io.connect location.origin, options
    
    messager = new PestoMessager(socket)
    
    messager.on 'event', (message) -> _onEvent(message)
    
    window.InspectorFrontendHost = new InspectorFrontendHost
    

#-------------------------------------------------------------------------------
installFunctionBind = ->

    # from:
    # https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Function/bind
    
    Function.prototype.bind = (oThis) ->
        if typeof @ != "function"
            # closest thing possible to the ECMAScript 5 internal IsCallable function
            throw new TypeError("Function.prototype.bind - what is trying to be bound is not callable")
        
        aArgs   = Array.prototype.slice.call(arguments, 1)
        fToBind = @
        fNOP    = ->
        
        fBound = -> 
            if (@ instanceof fNOP) 
                receiver = @ 
            else
                receiver = (oThis || window)
                
            args     = aArgs.concat(Array.prototype.slice.call(arguments))
            return fToBind.apply(receiver, args)
        
        fNOP.prototype   = @prototype;
        fBound.prototype = new fNOP()
        
        return fBound

#-------------------------------------------------------------------------------
getTargets = (callback) ->
    message =
        command: 'pesto-getTargets'
        
    messager.sendMessage(message, callback)

#-------------------------------------------------------------------------------
getServerInfo = (callback) ->
    message =
        command: 'pesto-getInfo'

    messager.sendMessage(message, callback)

#-------------------------------------------------------------------------------
_onEvent = (message) ->
    console.log "event received: #{JSON.stringify(message,null,4)}"

#-------------------------------------------------------------------------------
$(document).ready ->
    main()
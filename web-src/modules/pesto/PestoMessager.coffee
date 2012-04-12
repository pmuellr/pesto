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

events = require 'events'

_ = require 'underscore'

#-------------------------------------------------------------------------------
module.exports = class PestoMessager extends events.EventEmitter

    #---------------------------------------------------------------------------
    constructor: (@socket) ->
        @callbacks = {}
        @seq       = 0
        
        @socket.on 'pesto-event', (message) =>
            @emit 'event', message
            @emit "event-#{message.event}", message

        @socket.on 'pesto-response', (message) =>
            @_onResponse(message)
    
    #---------------------------------------------------------------------------
    sendMessage: (message, callback) ->
        seq     = @seq++
        message = _.clone(message)
        
        message.seq  = seq
        message.type = 'request'
        
        if callback
            @callbacks[seq] = callback
            
        @socket.emit 'pesto-request', message

    #---------------------------------------------------------------------------
    _onResponse: (message) ->
        seq = message.request_seq
        callback = @callbacks[seq]
        if !callback
            WebInspector.log "no callback for response: #{JSON.stringify(message,null,4)}"
            return
            
        delete @callbacks[seq]
        
        callback.call(null, message)
 

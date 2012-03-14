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

def = require('./prettyStackTrace').def

#-------------------------------------------------------------------------------
module.exports = def class PestoMessager extends events.EventEmitter

    #---------------------------------------------------------------------------
    constructor: (@socket) ->
        @callbacks = {}
        @seq       = 0
        
        @socket.on 'event', (messageString) =>
            message = JSON.parse(messageString)
            @emit 'event', message

        @socket.on 'response', (messageString) =>
            message = JSON.parse(messageString)
            @_onResponse(message)
    
    #---------------------------------------------------------------------------
    sendMessage: (message, callback) ->
        seq     = @seq++
        message = _.clone(message)
        
        message.seq  = seq
        message.type = 'request'
        message = JSON.stringify(message)
        
        if callback
            @callbacks[seq] = callback
            
        @socket.emit 'request', message

    #---------------------------------------------------------------------------
    _onResponse: (message) ->
        seq = message.request_seq
        callback = @callbacks[seq]
        if !callback
            console.log "no callback for response: #{JSON.stringify(message,null,4)}"
            return
            
        callback.apply(null, message)

        

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

net    = require 'net'
events = require 'events'

utils          = require './utils'
MessageReader  = require './MessageReader'

def = require('./prettyStackTrace').def

#-------------------------------------------------------------------------------
# emits:
#   'connect'
#   'message', aString
#   'end'
#-------------------------------------------------------------------------------
module.exports = def class NodeConnection extends events.EventEmitter

    #---------------------------------------------------------------------------
    constructor: (@port) ->
        # utils.logVerbose "NodeConnection(#{@port})"
        
        @socket = net.createConnection @port, "localhost"
        @seq = 0
        
        @socket.setEncoding('utf8')
        
        @connected = false
        @socket.on 'connect', (socket)  => @_onConnect(socket)
        @socket.on 'error',   (error)   => @_onError(error)
        @socket.on 'end',               => @_onEnd()
        
        messageReader = new MessageReader(@socket)
        messageReader.on 'message', (message) => @_onMessage(message)
        
    #---------------------------------------------------------------------------
    _onConnect: () ->
        utils.logVerbose "NodeConnection.onConnect"
        
        @connected = true
        @emit 'connect'
    
    #---------------------------------------------------------------------------
    _onMessage: (message) ->
        utils.logVerbose "NodeConnection.onData:"
        utils.logVerbose "   headers:"
        for key, val of message.headers
            utils.logVerbose "       #{key}: #{val}"
        
        if message.body != ''
            body = JSON.parse(message.body)
        
            utils.logVerbose "   data: #{JSON.stringify(body,null,4)}"
            
        if message.body == ''
            @sendRequest
                command: 'scripts'
                arguments:
                    types: 7
                    includeSource: false
    
    #---------------------------------------------------------------------------
    _onError: (error) ->
        if error.code != 'ECONNREFUSED'
            utils.logVerbose "NodeConnection.onError: #{error}"
            
        @socket.end()
        @socket.destroy()
    
    #---------------------------------------------------------------------------
    _onEnd: ->
        utils.logVerbose "NodeConnection.onEnd"
        @emit 'end'

    #---------------------------------------------------------------------------
    sendRequest: (message) ->
        message.seq = @seq++
        message.type = 'request'
        
        message = JSON.stringify(message)
        
        crlf    = '\r\n'
        message = "Content-Length: #{message.length}#{crlf}#{crlf}#{message}"

        utils.logVerbose "sending message: #{message}"
        
        @socket.write message, 'utf8'
    
    #---------------------------------------------------------------------------
    sendMessage: (message) ->
        utils.logVerbose "NodeConnection.write: #{message}"

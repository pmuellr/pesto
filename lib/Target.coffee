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
#   'end'
#-------------------------------------------------------------------------------
module.exports = def class Target extends events.EventEmitter

    #---------------------------------------------------------------------------
    constructor: (@port) ->
        # utils.logVerbose "NodeConnection(#{@port})"
        @properties = {}
        
        @socket = net.createConnection @port, "localhost"
        @seq = 0
        @seqIntrospect = null
        @description = "???"
        
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
        
        @introspect()
    
    #---------------------------------------------------------------------------
    _onMessage: (message) ->
        utils.logVerbose "NodeConnection.onData:"
        utils.logVerbose "   headers:"
        for key, val of message.headers
            utils.logVerbose "       #{key}: #{val}"

        if message.body == ''
            for key, val of message.headers
                @properties[key] = val
            return
        
        message = JSON.parse(message.body)
        
        utils.logVerbose "   data: #{JSON.stringify(message,null,4)}"

        if message.type == 'event'
            connectionManager.handleTargetEvent @, message
            return

        if (message.type == 'response') && (message.request_seq == @seqIntrospect)
            if message.success
                @description = message.body.text
            return
            
        if message.type == 'response'
            connectionManager.handleTargetResponse @, message
            return

        utils.logError "unknown message received from V8: #{message.type}"
            
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
        message.seq  = @seq++
        
        message = JSON.stringify(message)
        
        crlf    = '\r\n'
        message = "Content-Length: #{message.length}#{crlf}#{crlf}#{message}"

        utils.logVerbose "sending message: #{message}"
        
        @socket.write message, 'utf8'
    
        message.seq
        
    #---------------------------------------------------------------------------
    introspect: ->
    
        message = 
            type:       'request'
            command:    'evaluate'
            arguments:
                global:      true
                expression:  "process.pid + ': ' + process.argv.join(' ')"
        
        @seqIntrospect = @sendRequest message
        
        
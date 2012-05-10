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

utils             = require './utils'
MessageReader     = require './MessageReader'
connectionManager = require './connectionManager'

#-------------------------------------------------------------------------------
# emits:
#   'connect'
#   'end'
#-------------------------------------------------------------------------------
module.exports = class Target extends events.EventEmitter

    #---------------------------------------------------------------------------
    constructor: (@port) ->
        # utils.logTrace "Target.constructor", @port
        @properties = {}
        
        @socket = net.createConnection @port, "localhost"
        @seq = 1
        @description = null
        @responseCBs = {}
        @headers = {}
        
        @socket.setEncoding('utf8')
        
        @connected = false
        @socket.on 'connect', (socket)  => @_onConnect(socket)
        @socket.on 'error',   (error)   => @_onError(error)
        @socket.on 'end',               => @_onEnd()
        
        messageReader = new MessageReader(@socket)
        messageReader.on 'message', (message) => @_onMessage(message)
        
    #---------------------------------------------------------------------------
    _onConnect: () ->
        @connected = true
        @emit 'connect'
        
        setTimeout (=> @introspect()), 1000
    
    #---------------------------------------------------------------------------
    _onMessage: (message) ->

        # first message from the target
        if message.body == ''
            for key, val of message.headers
                if key != 'Content-Length'
                    @properties[key] = val
            return
        
        message = JSON.parse(message.body)

        utils.logTrace "Target._onMessage", utils.Jl(message)
        
        if message.type == 'event'
            connectionManager.handleTargetEvent @, message
            return

        if message.type == 'response'
            if @responseCBs[message.request_seq]
                @responseCBs[message.request_seq].call null, message
                delete @responseCBs[message.request_seq]
            else
                connectionManager.handleTargetResponse @, message
                
            return

        utils.logError "unknown message received from V8: #{message.type}"
            
    #---------------------------------------------------------------------------
    _onError: (error) ->
        if error.code != 'ECONNREFUSED'
            utils.logTrace "Target._onError", error
            
        @socket.end()
        @socket.destroy()
    
    #---------------------------------------------------------------------------
    _onEnd: ->
        @emit 'end'

    #---------------------------------------------------------------------------
    sendRequest: (message, callback) ->
        message.seq  = @seq++
        
        messageString = JSON.stringify(message)
        
        crlf          = '\r\n'
        messageString = "Content-Length: #{messageString.length}#{crlf}#{crlf}#{messageString}"

        #utils.logTrace "Target.sendRequest", "sending message: #{messageString}"
        utils.logTrace "Target.sendRequest", utils.Jl(message)
        
        @socket.write messageString, 'utf8'
    
        if callback
            @responseCBs[message.seq] = callback
            
        message.seq
        
    #---------------------------------------------------------------------------
    introspect: ->
        message = 
            type:       'request'
            command:    'evaluate'
            arguments:
                global:      true
                expression:  "process.pid + ': ' + process.argv.join(' ')"
        
        @sendRequest message, (message) =>
            if message.success
                @description = message.body.text
                
            connectionManager.targetAttached @
        
        
        
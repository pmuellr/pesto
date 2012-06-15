# Licensed under the Tumbolia Public License. See footer for details.

net    = require 'net'
events = require 'events'

utils             = require './utils'
MessageReader     = require './MessageReader'
connectionManager = require './connectionManager'

def = require('./prettyStackTrace').def

#-------------------------------------------------------------------------------
# emits:
#   'connect'
#   'end'
#-------------------------------------------------------------------------------
module.exports = def class Target extends events.EventEmitter

    #---------------------------------------------------------------------------
    constructor: (@port) ->
        # utils.logTrace arguments.callee, @port
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

        utils.logTrace arguments.callee, utils.Jl(message)
        
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
            utils.logTrace arguments.callee, error
            
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

        #utils.logTrace arguments.callee, "sending message: #{messageString}"
        utils.logTrace arguments.callee, utils.Jl(message)
        
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
        
#-------------------------------------------------------------------------------
# Copyright (c) 2012 Patrick Mueller
# 
# Tumbolia Public License
# 
# Copying and distribution of this file, with or without modification, are
# permitted in any medium without royalty provided the copyright notice and this
# notice are preserved.
# 
# TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
# 
#   0. opan saurce LOL
#-------------------------------------------------------------------------------        
        
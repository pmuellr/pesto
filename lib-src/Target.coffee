# Licensed under the Tumbolia Public License. See footer for details.

net    = require 'net'
events = require 'events'

utils             = require './utils'
V8MessageReader   = require './V8MessageReader'
connectionManager = require './connectionManager'

#-------------------------------------------------------------------------------
# emits:
#   'connect'
#       {}
#   'end'
#       {}
#-------------------------------------------------------------------------------
module.exports = class Target extends events.EventEmitter

    #---------------------------------------------------------------------------
    constructor: (@port) ->
        @properties = {}
        
        @socket = net.createConnection @port, "localhost"
        
        @socket.setEncoding('utf8')
        
        @socket.on 'connect', (socket)  => @_onConnect(socket)
        @socket.on 'error',   (error)   => @_onError(error)
        @socket.on 'end',               => @_onEnd()

    #---------------------------------------------------------------------------
    toString: ->
        "aTarget"
        
    #---------------------------------------------------------------------------
    attached: ->
    
    #---------------------------------------------------------------------------
    detached: ->
    
    #---------------------------------------------------------------------------
    connected: (client) ->
    
    #---------------------------------------------------------------------------
    disconnected: (client) ->

    #---------------------------------------------------------------------------
    close: ->
        @socket.end()
        @socket.destroy()

    #---------------------------------------------------------------------------
    sendV8Request: (message, callback) ->
        message.seq  = @seq++
        
        messageString = JSON.stringify(message)
        
        crlf          = '\r\n'
        messageString = "Content-Length: #{messageString.length}#{crlf}#{crlf}#{messageString}"

        utils.logVerbose "Target.sendRequest: #{utils.Jl(message)}"
        
        @socket.write messageString, 'utf8'
    
        if callback
            @responseCBs[message.seq] = callback
            
        message.seq

    #---------------------------------------------------------------------------
    handleV8Event: (message) ->
        utils.logVerbose "V8 event received: #{utils.Jl(message)}"
        
    #---------------------------------------------------------------------------
    _onConnect: () ->
        @seq         = 1
        @description = null
        @responseCBs = {}
        @headers     = {}
        
        @emit 'connect'

        messageReader = new V8MessageReader(@socket)
        messageReader.on 'message', (message) => @_onV8Message(message)
        
        connectionManager.attachTarget @
        
        # setTimeout (=> @introspect()), 1000
    
    #---------------------------------------------------------------------------
    _onV8Message: (message) ->

        # first message from the target
        if message.body == ''
            for key, val of message.headers
                if key != 'Content-Length'
                    @properties[key] = val
            return
        
        try 
            message = JSON.parse(message.body)
        catch e
            utils.logVerbose "error parsing V8 message #{message.body}"
            return

        if message.type == 'event'
            @handleV8Event message
            return

        if message.type == 'response'
            if @responseCBs[message.request_seq]
                @responseCBs[message.request_seq].call null, message
                delete @responseCBs[message.request_seq]
            else
                utils.logVerbose "callback not registered for V8 message #{message.request_seq}"
                
            return

        utils.logError "unknown message received from V8: #{message.type}"
            
    #---------------------------------------------------------------------------
    _onError: (error) ->
        if error.code != 'ECONNREFUSED'
            utils.logVerose "Target._onError #{error}"
            
        @socket.end()
        @socket.destroy()
    
    #---------------------------------------------------------------------------
    _onEnd: ->
        connectionManager.detachTarget @

        @emit 'end'

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
        
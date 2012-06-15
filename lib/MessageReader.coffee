# Licensed under the Tumbolia Public License. See footer for details.

net    = require 'net'
events = require 'events'

utils  = require './utils'

#-------------------------------------------------------------------------------
# emits: 
#    'message', {headers, body}
#-------------------------------------------------------------------------------
module.exports = class MessageReader extends events.EventEmitter

    #---------------------------------------------------------------------------
    constructor: (socket) ->
        @_initMessage()
        
        socket.on 'data', (data) => @_onData(data)

    #---------------------------------------------------------------------------
    _initMessage: ->
        @inHeaders     = true
        @headers       = {}
        @buffer        = ""
        @contentLength = 0
    
    #---------------------------------------------------------------------------
    _emitMessage: (body) ->
        @emit 'message', {headers: @headers, body: body}
        @_initMessage()
        
    #---------------------------------------------------------------------------
    _onData: (data) ->
        @buffer += data
        
        # utils.logTrace "MessageReader._onData", "starting with '#{data}'"
        while true
            # utils.logTrace "MessageReader._onData", "top of loop"

            # reading the body
            if !@inHeaders
            
                # if we don't have enough content, return
                return if @buffer.length < @contentLength
                
                # got enough content, emit message, start over
                body    = @buffer.substr(0, @contentLength)
                @buffer = @buffer.substr(@contentLength)
                    
                @_emitMessage(body)
                 
                continue
            
            # reading headers
            delim = @buffer.indexOf('\r\n')
            
            # dangling header, return
            if -1 == delim
                return
                
            # split line
            line    = @buffer.substr(line, delim)
            @buffer = @buffer.substr(delim + 2)
        
            # empty line, now reading body so start over
            if line == ''
                @inHeaders = false
                continue

            # header line, split it            
            delim = line.indexOf(':')
            if -1 == delim
                key = line
                val = ''
            else
                key = utils.trim line.substr(0, delim)
                val = utils.trim line.substr(delim + 1)
                
            # set the header, and check for Content-Length
            @headers[key] = val
            
            if key == 'Content-Length'
                @contentLength = parseInt(val)
        
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

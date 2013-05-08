# Licensed under the Apache License. See footer for details.

net    = require "net"
events = require "events"

utils  = require "../common/utils"

#-------------------------------------------------------------------------------
# emits: 
#    "message", {headers, body}
#-------------------------------------------------------------------------------
module.exports = class V8MessageReader extends events.EventEmitter

    #---------------------------------------------------------------------------
    constructor: (socket) ->
        @_initMessage()
        
        socket.on "data", (data) => @_onData(data)

    #---------------------------------------------------------------------------
    _initMessage: ->
        @inHeaders     = true
        @headers       = {}
        @buffer        = ""
        @contentLength = 0
    
    #---------------------------------------------------------------------------
    _emitMessage: (body) ->
        @emit "message", {headers: @headers, body: body}
        @_initMessage()
        
    #---------------------------------------------------------------------------
    _onData: (data) ->
        @buffer += data
        
        # utils.logTrace "MessageReader._onData", "starting with "#{data}""
        while true
            # utils.logTrace "MessageReader._onData", "top of loop"

            # reading the body
            if !@inHeaders
            
                # if we don"t have enough content, return
                return if @buffer.length < @contentLength
                
                # got enough content, emit message, start over
                body    = @buffer.substr(0, @contentLength)
                @buffer = @buffer.substr(@contentLength)
                    
                @_emitMessage(body)
                 
                continue
            
            # reading headers
            delim = @buffer.indexOf("\r\n")
            
            # dangling header, return
            if -1 == delim
                return
                
            # split line
            line    = @buffer.substr(line, delim)
            @buffer = @buffer.substr(delim + 2)
        
            # empty line, now reading body so start over
            if line == ""
                @inHeaders = false
                continue

            # header line, split it            
            delim = line.indexOf(":")
            if -1 == delim
                key = line
                val = ""
            else
                key = utils.trim line.substr(0, delim)
                val = utils.trim line.substr(delim + 1)
                
            # set the header, and check for Content-Length
            @headers[key] = val
            
            if key == "Content-Length"
                @contentLength = parseInt(val)
        
#-------------------------------------------------------------------------------
# Copyright 2013 I.B.M.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#-------------------------------------------------------------------------------

# Licensed under the Apache License. See footer for details.

net    = require "net"
util   = require "util"
events = require "events"

utils             = require "../common/utils"
V8MessageReader   = require "./V8MessageReader"

MaxStringLength = 1000
NextTargetId    = utils.getSequencer "t"
CRLF            = "\r\n"

#-------------------------------------------------------------------------------
# emits:
#    connect {target: aTarget}
#    error   {target: aTarget, error: error}
#    end     {target: aTarget}
#    event   {target: aTarget, message: message}
#-------------------------------------------------------------------------------
module.exports = class Target # extends events.EventEmitter

    #---------------------------------------------------------------------------
    constructor: (@opts, @socket, @port) ->
        @id             = NextTargetId()
        @connManager    = @opts.connManager
        @logger         = @opts.logger
        @tracer         = @logger.tracer __filename
        @properties     = {}
        @seq            = 1
        @node           = null
        @responseCBs    = {}
        @headers        = {}
        @attached       = true
        
        @tracer.vlog "target connected: #{@port}"

        @socket.setEncoding "utf8"

        messageReader = new V8MessageReader(@socket)
        messageReader.on "message", (message) => @_onMessage message
        
        @_introspect => @connManager.targetAttached @

        # @emit "connect"

        socket.on "end", => @_onEnd()

    #---------------------------------------------------------------------------
    sendRequest: (message, callback) ->
        callback = callback || ->

        message.seq  = @seq++
        message.type = "request"

        messageString = JSON.stringify(message)
        messageString = "Content-Length: #{messageString.length}#{CRLF}#{CRLF}#{messageString}"

        @tracer.vlog "request: #{utils.Jl message}"
        
        @responseCBs[message.seq] = callback
        @socket.write messageString, "utf8"
            
        return
        
    #---------------------------------------------------------------------------
    _onMessage: (message) ->

        #-----------------------------------------------------------------------
        # first message from the target
        if message.body == ""
            for key, val of message.headers
                if key != "Content-Length"
                    @properties[key] = val

            # @tracer.vlog "_onMessage properties: #{utils.Jl @properties}"            
            return
        
        message = JSON.parse(message.body)

        #-----------------------------------------------------------------------
        if message.type == "response"
            @tracer.vlog "response: #{utils.Jl message}"

            callback = @responseCBs[message.request_seq]
            if !callback
                @logger.log "no callback registered for: #{JSON.stringify message}"
                return

            delete @responseCBs[message.request_seq]

            callback message

            return

        #-----------------------------------------------------------------------
        if message.type == "event"
            @tracer.vlog "event: #{utils.Jl message}"

            for client in @connManager.getAttachedClients()
                client.sendEvent "v8-event", 
                    targetId: @id
                    event:    message

            return

        #-----------------------------------------------------------------------
        @logger.err "unknown message received from V8: #{message.type}"

    #---------------------------------------------------------------------------
    _onEnd: ->
        @connManager.targetDetached @

        # @emit "end"

    #---------------------------------------------------------------------------
    _evalAsString: (expr, callback) ->
        message = 
            type:                "request"
            command:             "evaluate"
            arguments:
                expression:      expr
                global:          true
                disable_break:   true
                maxStringLength: MaxStringLength

        # @tracer.vlog "_evalAsString(...)"
        @sendRequest message, (message) =>
            # @tracer.vlog "_evalAsString(...): #{utils.Jl message}"

            @running = message.running

            if !message.success
                return callback Error(message.message), null

            if message.body.length > MaxStringLength
                MaxStringLength = message.body.length
                return @_evalAsString expr, callback

            callback null, message.body.value

    #---------------------------------------------------------------------------
    _introspect: (callback) ->
        expr = "(#{introspectionFunction}())"

        @_evalAsString expr, (err, value) =>
            if err
                @tracer.vlog "_introspect() failed: #{err}"
                @node = null
            else
                @node = (JSON.parse value).node

            callback()

#-------------------------------------------------------------------------------
introspectionFunction = ->
    try
        result = 
            node:
                version:   process.version
                versions:  process.versions
                config:    process.config
                env:       process.env
                argv:      process.argv
                pid:       process.pid
                title:     process.title
                arch:      process.arch
                platform:  process.platform
                uptime:    process.uptime()
                cwd:       process.cwd()
                gid:       process.getgid()
                uid:       process.getuid()
        return JSON.stringify(result)

    catch e
        throw Error "not node, I guess"
        
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
    
        
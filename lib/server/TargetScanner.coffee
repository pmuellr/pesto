# Licensed under the Apache License. See footer for details.

net    = require "net"
util   = require "util"
events = require "events"

_ = require "underscore"

utils  = require "../common/utils"
Target = require "./Target"

#-------------------------------------------------------------------------------
# emits:
#    connect {target: aTarget}
#-------------------------------------------------------------------------------
module.exports = class TargetScanner

    #---------------------------------------------------------------------------
    constructor: (@opts) ->
        @scan = @opts.scan

    #---------------------------------------------------------------------------
    start: ->
        for port in [@scan[0] .. @scan[1]]
            scanner = new SingleTargetScanner @opts, port
            scanner.checkPort()

#-------------------------------------------------------------------------------
class SingleTargetScanner

    #---------------------------------------------------------------------------
    constructor: (@opts, @port) ->
        @connManager  = @opts.connManager
        @logger       = @opts.logger
        @tracer       = @logger.tracer __filename
        @intervalSecs = 1

    #---------------------------------------------------------------------------
    checkPort: ->
        # @tracer.vlog "TargetScanner.checkPort(): checking port #{@port}"
    
        socket = net.createConnection @port, "localhost"

        socket.on "connect", =>
            @_onConnect socket

        socket.on "error", (error) => 
            @_onError socket, error

        socket.on "close", => 
            @_onClose()
            
        socket.on "end", => 
            @_onEnd socket

    #---------------------------------------------------------------------------
    _onConnect: (socket) ->
        # @tracer.vlog "_onConnect(#{@port})"

        target = new Target @opts, socket, @port

        # target takes over for itself here, no neede to pass along to anyone

    #---------------------------------------------------------------------------
    _onError: (socket, error) ->
        # @tracer.vlog "_onError(#{@port}, #{error})"

        if error.code isnt "ECONNREFUSED"
            @logger.vlog "target socket error: #{util.inspect error}"

    #---------------------------------------------------------------------------
    _onEnd: (socket) ->
        # @tracer.vlog "_onEnd(#{@port})"

        try 
            socket.end()
            socket.destroy()
        catch err
            # pass
            
    #---------------------------------------------------------------------------
    _onClose: ->
        # @tracer.vlog "_onClose(#{@port})"

        setTimeout (=> @checkPort()), @intervalSecs * 1000

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

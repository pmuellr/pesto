# Licensed under the Apache License. See footer for details.

fs    = require "fs"
URL   = require "url"
http  = require "http"
https = require "https"
path  = require "path"
util  = require "util"

_         = require "underscore"
express   = require "express"
socket_io = require "socket.io"

utils             = require "../common/utils"
Client            = require "./Client"
ConnectionManager = require "./ConnectionManager"

WebDir = path.join __dirname, "..", "..", "web"

#-------------------------------------------------------------------------------
module.exports = class Server

    #---------------------------------------------------------------------------
    constructor: (@opts) ->
        @logger      = @opts.logger
        @tracer      = @logger.tracer __filename
        @connManager = @opts.connManager

    #---------------------------------------------------------------------------
    start: ->
        return if @server?

        favIcon = "#{WebDir}/images/icon-032.png"

        app = express()

        app.on "error", (error) =>
            @logger.err "error running server: #{error}"

        app.use express.favicon         favIcon
        app.use express.json            strict: false
        app.use express.urlencoded()
        app.use express.errorHandler    dumpExceptions: true
        app.use express.static          WebDir
        app.use logErrors @logger

        @logger.log "starting server at http://localhost:#{@opts.port}"

        @server = http.createServer app
        @server.listen @opts.port

        io = socket_io.listen(@server)

        io.set "log level",     2
        io.set "transports",    ["websocket", "xhr-polling"]

        io.sockets.on "connection", (socket) => @_on_connection socket

    #---------------------------------------------------------------------------
    stop: ->
        return if !@server?

        @logger.log "stopping server at http://localhost:#{@opts.port}"
        @server.close()
        @server = null

    #---------------------------------------------------------------------------
    _on_connection: (socket) ->
        # @tracer.vlog "connection from client: #{util.inspect socket.handshake.address.address}"
        
        client = new Client @opts, socket

#-------------------------------------------------------------------------------
logErrors = (logger) ->

    return (error, request, response, next) ->
        try 
            logger.log util.inspect err
            response.send 500
        catch e 
            #pass

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

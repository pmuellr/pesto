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

http = require 'http'
path = require 'path'

connect   = require 'connect'
socket_io = require 'socket.io'

utils = require './utils'

def = require('./prettyStackTrace').def

#-------------------------------------------------------------------------------
module.exports = def class WebServer

    #---------------------------------------------------------------------------
    constructor: (@config) ->
    
    #---------------------------------------------------------------------------
    start: ->
        rootPath = utils.rootPath
        webPath  = path.join rootPath, 'web'
        
        app = connect()
          .use(connect.favicon(path.join(webPath, 'images','icon-032x032.png')))
        #  .use(connect.logger('dev'))
          .use(connect.static(webPath))

        port = @config.port
        server = http.createServer(app)
        server.listen(port)

        io = socket_io.listen(server)
        io.sockets.on 'connection', (socket) => @_onWsConnect(socket)
        
        utils.log "starting server on http://localhost:#{port}"
    
    #---------------------------------------------------------------------------
    _onWsConnect: (socket) ->
        utils.logVerbose "WebServer._onWsConnect: connection received on socket"
    
        socket.on 'request', (data) => @_onWsRequest(socket, data)
        
    #---------------------------------------------------------------------------
    _onWsRequest: (socket, data) ->
        utils.logVerbose "WebServer._onWsRequest: '#{data}'"
        
        socket.emit 'response', data
        
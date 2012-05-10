# Licensed under the Tumbolia Public License. See footer for details.

http = require 'http'
path = require 'path'

connect   = require 'connect'
socket_io = require 'socket.io'

utils             = require './utils'
Client            = require './Client'
connectionManager = require './connectionManager'

#-------------------------------------------------------------------------------
module.exports = class WebServer

    #---------------------------------------------------------------------------
    constructor: (@port) ->
    
    #---------------------------------------------------------------------------
    start: ->
        rootPath = utils.rootPath
        webPath  = path.join rootPath, 'web'
        
        app = connect()
          .use(connect.favicon(path.join(webPath, 'images','icon-032x032.png')))
          #.use(connect.logger('dev'))
          .use(connect.static(webPath))

        server = http.createServer(app)
        server.listen(@port)

        io = socket_io.listen(server)
        io.set('log level', 1)
        io.sockets.on 'connection', (socket) => @_onConnect(socket)
        
        utils.log "starting server on http://localhost:#{@port}"
    
    #---------------------------------------------------------------------------
    _onConnect: (socket) ->
        client = new Client(socket)
        
        connectionManager.clientAttached client
        
        socket.on 'disconnect', -> connectionManager.clientDetached client

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

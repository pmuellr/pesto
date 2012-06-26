# Licensed under the Tumbolia Public License. See footer for details.

http = require 'http'
path = require 'path'

connect   = require 'connect'
socket_io = require 'socket.io'

utils   = require './utils'
Client  = require './Client'

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
          .use(connect.favicon(path.join(webPath, 'pesto', 'images','pesto-032x032.png')))
          #.use(connect.logger('dev'))
          .use(connect.static(webPath))

        server = http.createServer(app)
        server.listen(@port)

        io = socket_io.listen(server)
        io.set('log level', 1)
        io.sockets.on 'connection', handleClientConnected
        
        utils.log "starting server on http://localhost:#{@port}"
        
        connectionManager.on "clientAttached", handleClientAttached
        connectionManager.on "targetAttached", handleTargetAttached
    
#-------------------------------------------------------------------------------
handleClientConnected = (socket) ->

    # Client instances hooks itself up to connectionManager
    client = new Client(socket)

#-------------------------------------------------------------------------------
handleClientAttached = (client) ->
    targets = connectionManager.getAttachedTargets()
    
    for target in targets
        connectionManager.connect client, target
        return # only connect 1st target (should only be one anyway)

#-------------------------------------------------------------------------------
handleTargetAttached = (target) ->

    clients = connectionManager.getAttachedClients()
    
    for client in clients
        connectionManager.connect client, target
        

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

# Licensed under the Tumbolia Public License. See footer for details.


utils             = require './utils'
connectionManager = require './connectionManager'

#-------------------------------------------------------------------------------
module.exports = class Client

    #---------------------------------------------------------------------------
    constructor: (@socket) ->
        @socket.on 'pesto-request', (message) => @_onRequest(message)

    #---------------------------------------------------------------------------
    sendEvent: (message) ->
        utils.logTrace "Client.sendEvent", utils.Jl(message)
        @socket.emit 'pesto-event', message
        
    #---------------------------------------------------------------------------
    sendResponse: (message) ->
        utils.logTrace "Client.sendResponse", utils.Jl(message)
        @socket.emit 'pesto-response', message
    
    #---------------------------------------------------------------------------
    _onRequest: (message) ->
        utils.logTrace "Client._onRequest", utils.Jl(message)
        connectionManager.handleClientRequest @, message

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
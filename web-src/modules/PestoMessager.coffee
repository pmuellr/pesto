# Licensed under the Tumbolia Public License. See footer for details.

events = require 'events'

_ = require 'underscore'

utils = require './utils'

#-------------------------------------------------------------------------------
module.exports = class PestoMessager extends events.EventEmitter

    #---------------------------------------------------------------------------
    constructor: (@socket) ->
        @socket.on 'pesto-message', (message) => @_receivedMessage(message)
            
        @socket.on 'connect',        => @_io_connect()
        @socket.on 'connecting',     => @_io_connecting()
        @socket.on 'connect_failed', => @_io_connect_failed()
        @socket.on 'error',          => @_io_error()
        @socket.on 'reconnect',      => @_io_reconnect()
        @socket.on 'reconnecting',   => @_io_reconnecting()
        @socket.on 'disconnect',     => @_io_disconnect()

    #---------------------------------------------------------------------------
    sendMessage: (message) ->
        @socket.emit 'pesto-message', message

    #---------------------------------------------------------------------------
    _receivedMessage: (message) ->
        ready = window?.InspectorBackend?.dispatch
        if !ready
            utils.logError "message received before InspectorBackend ready: #{message}"
            return
        
        InspectorBackend.dispatch(message)

    #---------------------------------------------------------------------------
    _reconnectRequired: ->
        message = "The server appears to have stopped.  You will need to reload this page."
        utils.logError message

    #---------------------------------------------------------------------------
    _io_connect: ->
        utils.logDebug "connected to pesto server socket"
    
    #---------------------------------------------------------------------------
    _io_disconnect: ->
        utils.logDebug "disconnected from pesto server socket"

        @_reconnectRequired()        
    
    #---------------------------------------------------------------------------
    _io_connecting: ->
        utils.logDebug "connected to pesto server socket"
    
    #---------------------------------------------------------------------------
    _io_connect_failed: ->
        utils.logDebug "connecting to pesto server failed"

        @_reconnectRequired()        
    
    #---------------------------------------------------------------------------
    _io_error: ->
        utils.logError "an error occurred communicating with the pesto server"
        
        @_reconnectRequired()        
    
    #---------------------------------------------------------------------------
    _io_reconnect: ->
        utils.logDebug "reconnected to pesto server"
    
    #---------------------------------------------------------------------------
    _io_reconnecting: ->
        utils.logDebug "reconnecting to pesto server"
    
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

# Licensed under the Tumbolia Public License. See footer for details.

PestoMessager         = require './PestoMessager'
templates             = require './templates'
connectionNotifier    = require './ConnectionNotifier'

socket   = null
messager = null

widgetMap = {}

window.Pesto = {}

#-------------------------------------------------------------------------------
main = ->
    options =
        reconnect: false
        
    socket = io.connect location.origin, options
    
    Pesto.messager = new PestoMessager(socket)
    
    Pesto.messager.on 'event', (message) -> _onEvent(message)
    
    getTargets (message) ->
        console.log "getTargets: #{JSON.stringify(message,null,4)}"
        
    getServerInfo (message) ->
        console.log "pesto server settings: #{JSON.stringify(message.body)}"
        
#-------------------------------------------------------------------------------
getTargets = (callback) ->
    message =
        command: 'pesto-getTargets'
        
    Pesto.messager.sendMessage(message, callback)

#-------------------------------------------------------------------------------
getServerInfo = (callback) ->
    message =
        command: 'pesto-getInfo'

    Pesto.messager.sendMessage(message, callback)

#-------------------------------------------------------------------------------
_onEvent = (message) ->
    WebInspector.log "event received: #{JSON.stringify(message,null,4)}"

#-------------------------------------------------------------------------------
$(document).ready ->
    main()

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

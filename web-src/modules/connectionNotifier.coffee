# Licensed under the Tumbolia Public License. See footer for details.

templates = require './templates'

#-------------------------------------------------------------------------------
$(document).ready ->
    setTimeout addWidget, 0

#-------------------------------------------------------------------------------
addWidget = ->
    connectionInfoHtml = templates["connection-info.html"]
    
    $("#toolbar").append connectionInfoHtml
    
#-------------------------------------------------------------------------------
module.exports = connectionNotifier = new class ConnectionNotifier

    #---------------------------------------------------------------------------
    constructor: ->
        @widgetElement = null
        @widgetLabel   = null
        
        # setInterval (=> @switcheroo()), 3000

    #---------------------------------------------------------------------------
    switcheroo: ->
        @setConnected()
        
        setTimeout (=> @setDisconnected()), 1000
        setTimeout (=> @setWaiting()),      2000

    #---------------------------------------------------------------------------
    setConnected: ->
        @updateText  "connected"
        @updateClass "connected"
        
        document.title = "pesto: connected"
        
    #---------------------------------------------------------------------------
    setDisconnected: ->
        @updateText  "disconnected"
        @updateClass "disconnected"

        document.title = "pesto: disconnected"
        
    #---------------------------------------------------------------------------
    setWaiting: ->
        @updateText  "waiting"
        @updateClass "waiting"

        document.title = "pesto: waiting"

    #---------------------------------------------------------------------------
    updateClass: (cls) ->
        element = @getWidgetElement()
        return if not element
        
        element.removeClass "connected"
        element.removeClass "disconnected"
        element.removeClass "waiting"

        element.addClass cls
        
    #---------------------------------------------------------------------------
    updateText: (text) ->
        element = @getWidgetLabel()
        return if not element
        
        element.text(text)
    
    #---------------------------------------------------------------------------
    getWidgetElement: ->
        @widgetElement if @widgetElement?.length

        @widgetElement = $("#pesto-connection-info")
        
    #---------------------------------------------------------------------------
    getWidgetLabel: ->
        @widgetLabel if @widgetLabel?.length
        
        @widgetLabel = $("#pesto-connection-label")

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

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


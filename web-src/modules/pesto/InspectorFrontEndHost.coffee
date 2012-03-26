#-------------------------------------------------------------------------------
# Copyright 2012 Patrick Mueller
# 
# Licensed under the Apache License, Version 2.0 (the "License")
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

TargetsPanel = require './TargetsPanel'
serviceHacks = require './serviceHacks'

#-------------------------------------------------------------------------------
module.exports = class InspectorFrontendHost

    #---------------------------------------------------------------------------
    constructor: ->
        console.log("InspectorFrontendHost.constructor()")
        @_attachedWindowHeight = 0
        @isStub                = false

    #---------------------------------------------------------------------------
    platform: ->
        console.log("InspectorFrontendHost.platform()")
#        return "windows" if navigator.userAgent.match /Windows NT/
#        return "mac"     if navigator.userAgent.match /Mac OS X/
        return "linux"

    #---------------------------------------------------------------------------
    port: ->
        console.log("InspectorFrontendHost.port()")
        return "unknown"

    #---------------------------------------------------------------------------
    bringToFront: ->
        console.log("InspectorFrontendHost.bringToFront()")
        @_windowVisible = true

    #---------------------------------------------------------------------------
    closeWindow: ->
        console.log("InspectorFrontendHost.closeWindow()")
        @_windowVisible = false

    #---------------------------------------------------------------------------
    requestAttachWindow: ->
        console.log("InspectorFrontendHost.requestAttachWindow()")

    #---------------------------------------------------------------------------
    requestDetachWindow: ->
        console.log("InspectorFrontendHost.requestDetachWindow()")

    #---------------------------------------------------------------------------
    requestSetDockSide: ->
        console.log("InspectorFrontendHost.requestSetDockSide()")

    #---------------------------------------------------------------------------
    setAttachedWindowHeight: (height) ->
        console.log("InspectorFrontendHost.setAttachedWindowHeight()")

    #---------------------------------------------------------------------------
    moveWindowBy: (x, y) ->
        console.log("InspectorFrontendHost.moveWindowBy()")

    #---------------------------------------------------------------------------
    setInjectedScriptForOrigin: (origin, script) ->
        console.log("InspectorFrontendHost.setInjectedScriptForOrigin()")

    #---------------------------------------------------------------------------
    loaded: ->
        console.log("InspectorFrontendHost.loaded()")
        Preferences.localizeUI = false
        
        setTimeout (=>@_toggleConsole()),            0
        setTimeout (=>@_setScriptsPanelAsCurrent()), 0
        setTimeout (=>@_createTargetsPanel()),       0

    #---------------------------------------------------------------------------
    _createTargetsPanel: ->    
        targetsPanel = new TargetsPanel
        
        WebInspector.toolbar.addPanel(targetsPanel)
        
    #---------------------------------------------------------------------------
    _toggleConsole: ->
        WebInspector._toggleConsoleButtonClicked()

    #---------------------------------------------------------------------------
    _setScriptsPanelAsCurrent: ->
        WebInspector.inspectorView.setCurrentPanel WebInspector.panels["scripts"]

    #---------------------------------------------------------------------------
    localizedStringsURL: ->
        console.log("InspectorFrontendHost.localizedStringsURL()")
        return undefined

    #---------------------------------------------------------------------------
    hiddenPanels: ->
        console.log("InspectorFrontendHost.hiddenPanels()")
        return [
            "elements"
            "resources"
            "network"
            "timeline"
            "profiles"
            "audits"
        ].join ','

    #---------------------------------------------------------------------------
    inspectedURLChanged: (url) ->
        console.log("InspectorFrontendHost.inspectedURLChanged()")
        document.title = WebInspector.UIString(Preferences.applicationTitle, url)

    #---------------------------------------------------------------------------
    copyText: ->
        console.log("InspectorFrontendHost.copyText()")

    #---------------------------------------------------------------------------
    openInNewTab: (url) ->
        console.log("InspectorFrontendHost.openInNewTab()")
        window.open url, "_blank"

    #---------------------------------------------------------------------------
    canSaveAs: (fileName, content) ->
        console.log("InspectorFrontendHost.canSaveAs()")
        return true

    #---------------------------------------------------------------------------
    saveAs: (fileName, content) ->
        console.log("InspectorFrontendHost.saveAs()")
        
        builder = new WebKitBlobBuilder()
        builder.append content
        
        blob = builder.getBlob("application/octet-stream")

        fr = new FileReader()
        fr.onload = (e) ->
            # Force download
            window.location = @result

        fr.readAsDataURL blob

    #---------------------------------------------------------------------------
    sendMessageToBackend: (message) ->
        console.log("InspectorFrontendHost.sendMessageToBackend()")
        
        messageObject = JSON.parse(message)
        console.log("message: " + JSON.stringify(messageObject, null, 4))
        
        if serviceHacks[messageObject.method]
            serviceHacks[messageObject.method](messageObject)

    #---------------------------------------------------------------------------
    recordActionTaken: (actionCode) ->
        console.log("InspectorFrontendHost.recordActionTaken()")

    #---------------------------------------------------------------------------
    recordPanelShown: (panelCode) ->
        console.log("InspectorFrontendHost.recordPanelShown()")

    #---------------------------------------------------------------------------
    recordSettingChanged: (settingCode) ->
        console.log("InspectorFrontendHost.recordSettingChanged()")

    #---------------------------------------------------------------------------
    loadResourceSynchronously: (url) ->
        console.log("InspectorFrontendHost.loadResourceSynchronously()")
        return ""

    #---------------------------------------------------------------------------
    setZoomFactor: (zoom) ->
        console.log("InspectorFrontendHost.setZoomFactor()")

    
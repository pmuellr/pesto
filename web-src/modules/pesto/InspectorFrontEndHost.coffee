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

serviceHacks = require './serviceHacks'

#-------------------------------------------------------------------------------
if false
    log = (message) -> WebInspector.log(message)
else
    log = (message) ->

#-------------------------------------------------------------------------------
module.exports = class InspectorFrontendHost

    #---------------------------------------------------------------------------
    constructor: ->
        log("InspectorFrontendHost.constructor()")
        @_attachedWindowHeight = 0
        @isStub                = false

    #---------------------------------------------------------------------------
    platform: ->
        log("InspectorFrontendHost.platform()")
#        return "windows" if navigator.userAgent.match /Windows NT/
#        return "mac"     if navigator.userAgent.match /Mac OS X/
        return "linux"

    #---------------------------------------------------------------------------
    port: ->
        log("InspectorFrontendHost.port()")
        return "unknown"

    #---------------------------------------------------------------------------
    bringToFront: ->
        log("InspectorFrontendHost.bringToFront()")
        @_windowVisible = true

    #---------------------------------------------------------------------------
    closeWindow: ->
        log("InspectorFrontendHost.closeWindow()")
        @_windowVisible = false

    #---------------------------------------------------------------------------
    requestAttachWindow: ->
        log("InspectorFrontendHost.requestAttachWindow()")

    #---------------------------------------------------------------------------
    requestDetachWindow: ->
        log("InspectorFrontendHost.requestDetachWindow()")

    #---------------------------------------------------------------------------
    requestSetDockSide: ->
        log("InspectorFrontendHost.requestSetDockSide()")

    #---------------------------------------------------------------------------
    setAttachedWindowHeight: (height) ->
        log("InspectorFrontendHost.setAttachedWindowHeight()")

    #---------------------------------------------------------------------------
    moveWindowBy: (x, y) ->
        log("InspectorFrontendHost.moveWindowBy()")

    #---------------------------------------------------------------------------
    setInjectedScriptForOrigin: (origin, script) ->
        log("InspectorFrontendHost.setInjectedScriptForOrigin()")

    #---------------------------------------------------------------------------
    loaded: ->
        log("InspectorFrontendHost.loaded()")
        Preferences.localizeUI = false
        
        setTimeout (=>@_toggleConsole()),            0
        setTimeout (=>@_setScriptsPanelAsCurrent()), 0
        #setTimeout (=>@_createTargetsSidebarPane()), 0
        #setTimeout (=>@_createTargetsPanel()),       0

    #---------------------------------------------------------------------------
    _createTargetsSidebarPane: ->    
        targetsSidebarPane = new TargetsSidebarPane
        
        scriptsPanel = WebInspector.panels["scripts"]
        scriptsPanel.sidebarPanes.pestoTargets = targetsSidebarPane
        
        $(scriptsPanel._debugSidebarContentsElement).prepend(targetsSidebarPane.element)
        targetsSidebarPane.expanded = true
        
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
        log("InspectorFrontendHost.localizedStringsURL()")
        return undefined

    #---------------------------------------------------------------------------
    hiddenPanels: ->
        log("InspectorFrontendHost.hiddenPanels()")
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
        log("InspectorFrontendHost.inspectedURLChanged()")
        document.title = WebInspector.UIString(Preferences.applicationTitle, url)

    #---------------------------------------------------------------------------
    copyText: ->
        log("InspectorFrontendHost.copyText()")

    #---------------------------------------------------------------------------
    openInNewTab: (url) ->
        log("InspectorFrontendHost.openInNewTab()")
        window.open url, "_blank"

    #---------------------------------------------------------------------------
    canSaveAs: (fileName, content) ->
        log("InspectorFrontendHost.canSaveAs()")
        return true

    #---------------------------------------------------------------------------
    saveAs: (fileName, content) ->
        log("InspectorFrontendHost.saveAs()")
        
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
        log("InspectorFrontendHost.sendMessageToBackend()")
        
        messageObject = JSON.parse(message)
        log("message: " + JSON.stringify(messageObject, null, 4))
        
        if serviceHacks[messageObject.method]
            serviceHacks[messageObject.method](messageObject)

    #---------------------------------------------------------------------------
    recordActionTaken: (actionCode) ->
        log("InspectorFrontendHost.recordActionTaken()")

    #---------------------------------------------------------------------------
    recordPanelShown: (panelCode) ->
        log("InspectorFrontendHost.recordPanelShown()")

    #---------------------------------------------------------------------------
    recordSettingChanged: (settingCode) ->
        log("InspectorFrontendHost.recordSettingChanged()")

    #---------------------------------------------------------------------------
    loadResourceSynchronously: (url) ->
        log("InspectorFrontendHost.loadResourceSynchronously()")
        return ""

    #---------------------------------------------------------------------------
    setZoomFactor: (zoom) ->
        log("InspectorFrontendHost.setZoomFactor()")

    #---------------------------------------------------------------------------
    showContextMenu: (event, items) ->
        log("InspectorFrontendHost.setContextMenu(#{event.toString()}, #{JSON.stringify(items)})")
    
# Licensed under the Tumbolia Public License. See footer for details.

#-------------------------------------------------------------------------------
# domain: Page
#-------------------------------------------------------------------------------
module.exports =

    #---------------------------------------------------------------------------
    enable: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Page.enable'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    disable: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Page.disable'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    addScriptToEvaluateOnLoad: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Page.addScriptToEvaluateOnLoad'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    removeScriptToEvaluateOnLoad: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Page.removeScriptToEvaluateOnLoad'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    reload: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Page.reload'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    navigate: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Page.navigate'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    getCookies: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Page.getCookies'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    deleteCookie: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Page.deleteCookie'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    getResourceTree: (client, message) ->

        result = 
            frameTree:
                childFrames: []
                resources:   []
                frame:
                    id:       "1"
                    loaderId: "1"
                    name:     "node.js script"
                    url:      "node.js"
                    mimeType: "text/plain"

        client.sendResponse
            _omsg:  'Page.getResourceTree'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    getResourceContent: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Page.getResourceContent'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    searchInResource: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Page.searchInResource'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    searchInResources: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Page.searchInResources'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    setDocumentContent: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Page.setDocumentContent'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    canOverrideDeviceMetrics: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Page.canOverrideDeviceMetrics'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    setDeviceMetricsOverride: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Page.setDeviceMetricsOverride'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    setShowPaintRects: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Page.setShowPaintRects'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    getScriptExecutionStatus: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Page.getScriptExecutionStatus'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    setScriptExecutionDisabled: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Page.setScriptExecutionDisabled'
            id:     message.id
            result: result

        return

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

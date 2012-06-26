# Licensed under the Tumbolia Public License. See footer for details.

#-------------------------------------------------------------------------------
# domain: DOM
#-------------------------------------------------------------------------------
module.exports =

    #---------------------------------------------------------------------------
    getDocument: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOM.getDocument'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    requestChildNodes: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOM.requestChildNodes'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    querySelector: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOM.querySelector'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    querySelectorAll: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOM.querySelectorAll'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    setNodeName: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOM.setNodeName'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    setNodeValue: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOM.setNodeValue'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    removeNode: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOM.removeNode'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    setAttributeValue: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOM.setAttributeValue'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    setAttributesAsText: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOM.setAttributesAsText'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    removeAttribute: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOM.removeAttribute'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    getEventListenersForNode: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOM.getEventListenersForNode'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    getOuterHTML: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOM.getOuterHTML'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    setOuterHTML: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOM.setOuterHTML'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    performSearch: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOM.performSearch'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    getSearchResults: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOM.getSearchResults'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    discardSearchResults: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOM.discardSearchResults'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    requestNode: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOM.requestNode'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    setInspectModeEnabled: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOM.setInspectModeEnabled'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    highlightRect: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOM.highlightRect'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    highlightNode: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOM.highlightNode'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    hideHighlight: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOM.hideHighlight'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    highlightFrame: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOM.highlightFrame'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    pushNodeByPathToFrontend: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOM.pushNodeByPathToFrontend'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    resolveNode: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOM.resolveNode'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    getAttributes: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOM.getAttributes'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    moveTo: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOM.moveTo'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    setTouchEmulationEnabled: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOM.setTouchEmulationEnabled'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    undo: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOM.undo'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    redo: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOM.redo'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    markUndoableState: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOM.markUndoableState'
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

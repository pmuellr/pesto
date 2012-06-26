# Licensed under the Tumbolia Public License. See footer for details.

#-------------------------------------------------------------------------------
# domain: CSS
#-------------------------------------------------------------------------------
module.exports =

    #---------------------------------------------------------------------------
    enable: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'CSS.enable'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    disable: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'CSS.disable'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    getMatchedStylesForNode: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'CSS.getMatchedStylesForNode'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    getInlineStylesForNode: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'CSS.getInlineStylesForNode'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    getComputedStyleForNode: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'CSS.getComputedStyleForNode'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    getAllStyleSheets: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'CSS.getAllStyleSheets'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    getStyleSheet: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'CSS.getStyleSheet'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    getStyleSheetText: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'CSS.getStyleSheetText'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    setStyleSheetText: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'CSS.setStyleSheetText'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    setPropertyText: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'CSS.setPropertyText'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    toggleProperty: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'CSS.toggleProperty'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    setRuleSelector: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'CSS.setRuleSelector'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    addRule: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'CSS.addRule'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    getSupportedCSSProperties: (client, message) ->

        result = 
            cssProperties: []

        client.sendResponse
            _omsg:  'CSS.getSupportedCSSProperties'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    startSelectorProfiler: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'CSS.startSelectorProfiler'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    stopSelectorProfiler: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'CSS.stopSelectorProfiler'
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

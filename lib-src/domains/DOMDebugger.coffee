# Licensed under the Tumbolia Public License. See footer for details.

#-------------------------------------------------------------------------------
# domain: DOMDebugger
#-------------------------------------------------------------------------------
module.exports =

    #---------------------------------------------------------------------------
    setDOMBreakpoint: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOMDebugger.setDOMBreakpoint'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    removeDOMBreakpoint: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOMDebugger.removeDOMBreakpoint'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    setEventListenerBreakpoint: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOMDebugger.setEventListenerBreakpoint'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    removeEventListenerBreakpoint: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOMDebugger.removeEventListenerBreakpoint'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    setInstrumentationBreakpoint: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOMDebugger.setInstrumentationBreakpoint'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    removeInstrumentationBreakpoint: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOMDebugger.removeInstrumentationBreakpoint'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    setXHRBreakpoint: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOMDebugger.setXHRBreakpoint'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    removeXHRBreakpoint: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'DOMDebugger.removeXHRBreakpoint'
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

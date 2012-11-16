# Licensed under the Tumbolia Public License. See footer for details.

#-------------------------------------------------------------------------------
# domain: Debugger
#-------------------------------------------------------------------------------
module.exports =

    #---------------------------------------------------------------------------
    causesRecompilation: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Debugger.causesRecompilation'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    supportsNativeBreakpoints: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Debugger.supportsNativeBreakpoints'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    enable: (client, message) ->

        result = null
        
        client.debuggerEnabled()

        client.sendResponse
            _omsg:  'Debugger.enable'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    disable: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Debugger.disable'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    setBreakpointsActive: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Debugger.setBreakpointsActive'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    setBreakpointByUrl: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Debugger.setBreakpointByUrl'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    setBreakpoint: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Debugger.setBreakpoint'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    removeBreakpoint: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Debugger.removeBreakpoint'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    continueToLocation: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Debugger.continueToLocation'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    stepOver: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Debugger.stepOver'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    stepInto: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Debugger.stepInto'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    stepOut: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Debugger.stepOut'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    pause: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Debugger.pause'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    resume: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Debugger.resume'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    searchInContent: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Debugger.searchInContent'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    canSetScriptSource: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Debugger.canSetScriptSource'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    setScriptSource: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Debugger.setScriptSource'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    getScriptSource: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Debugger.getScriptSource'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    getFunctionDetails: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Debugger.getFunctionDetails'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    setPauseOnExceptions: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Debugger.setPauseOnExceptions'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    evaluateOnCallFrame: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Debugger.evaluateOnCallFrame'
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

# Licensed under the Tumbolia Public License. See footer for details.

#-------------------------------------------------------------------------------
# domain: Profiler
#-------------------------------------------------------------------------------
module.exports =

    #---------------------------------------------------------------------------
    causesRecompilation: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Profiler.causesRecompilation'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    isSampling: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Profiler.isSampling'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    hasHeapProfiler: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Profiler.hasHeapProfiler'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    enable: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Profiler.enable'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    disable: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Profiler.disable'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    start: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Profiler.start'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    stop: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Profiler.stop'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    getProfileHeaders: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Profiler.getProfileHeaders'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    getProfile: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Profiler.getProfile'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    removeProfile: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Profiler.removeProfile'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    clearProfiles: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Profiler.clearProfiles'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    takeHeapSnapshot: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Profiler.takeHeapSnapshot'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    collectGarbage: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Profiler.collectGarbage'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    getObjectByHeapObjectId: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Profiler.getObjectByHeapObjectId'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    getHeapObjectId: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Profiler.getHeapObjectId'
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

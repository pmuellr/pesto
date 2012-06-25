# Licensed under the Tumbolia Public License. See footer for details.

#-------------------------------------------------------------------------------
# domain: Timeline
#-------------------------------------------------------------------------------
module.exports =

    #---------------------------------------------------------------------------
    start: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Timeline.start'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    stop: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Timeline.stop'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    setIncludeMemoryDetails: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Timeline.setIncludeMemoryDetails'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    supportsFrameInstrumentation: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Timeline.supportsFrameInstrumentation'
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

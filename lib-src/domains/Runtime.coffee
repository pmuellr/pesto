# Licensed under the Tumbolia Public License. See footer for details.

#-------------------------------------------------------------------------------
# domain: Runtime
#-------------------------------------------------------------------------------
module.exports =

    #---------------------------------------------------------------------------
    evaluate: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Runtime.evaluate'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    callFunctionOn: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Runtime.callFunctionOn'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    getProperties: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Runtime.getProperties'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    releaseObject: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Runtime.releaseObject'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    releaseObjectGroup: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Runtime.releaseObjectGroup'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    run: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Runtime.run'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    setReportExecutionContextCreation: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Runtime.setReportExecutionContextCreation'
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

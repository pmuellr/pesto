# Licensed under the Tumbolia Public License. See footer for details.

#-------------------------------------------------------------------------------
# domain: Console
#-------------------------------------------------------------------------------
module.exports =

    #---------------------------------------------------------------------------
    enable: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Console.enable'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    disable: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Console.disable'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    clearMessages: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Console.clearMessages'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    setMonitoringXHREnabled: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Console.setMonitoringXHREnabled'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    addInspectedNode: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Console.addInspectedNode'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    addInspectedHeapObject: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Console.addInspectedHeapObject'
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

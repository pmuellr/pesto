# Licensed under the Tumbolia Public License. See footer for details.

#-------------------------------------------------------------------------------
# domain: Worker
#-------------------------------------------------------------------------------
module.exports =

    #---------------------------------------------------------------------------
    setWorkerInspectionEnabled: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Worker.setWorkerInspectionEnabled'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    sendMessageToWorker: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Worker.sendMessageToWorker'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    connectToWorker: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Worker.connectToWorker'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    disconnectFromWorker: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Worker.disconnectFromWorker'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    setAutoconnectToWorkers: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Worker.setAutoconnectToWorkers'
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

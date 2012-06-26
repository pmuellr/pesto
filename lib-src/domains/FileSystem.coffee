# Licensed under the Tumbolia Public License. See footer for details.

#-------------------------------------------------------------------------------
# domain: FileSystem
#-------------------------------------------------------------------------------
module.exports =

    #---------------------------------------------------------------------------
    enable: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'FileSystem.enable'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    disable: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'FileSystem.disable'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    readDirectory: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'FileSystem.readDirectory'
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

# Licensed under the Tumbolia Public License. See footer for details.

#-------------------------------------------------------------------------------
# domain: Database
#-------------------------------------------------------------------------------
module.exports =

    #---------------------------------------------------------------------------
    enable: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Database.enable'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    disable: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Database.disable'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    getDatabaseTableNames: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Database.getDatabaseTableNames'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    executeSQL: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Database.executeSQL'
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

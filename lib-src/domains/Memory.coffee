# Licensed under the Tumbolia Public License. See footer for details.

#-------------------------------------------------------------------------------
# domain: Memory
#-------------------------------------------------------------------------------
module.exports =

    #---------------------------------------------------------------------------
    getDOMNodeCount: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Memory.getDOMNodeCount'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    getProcessMemoryDistribution: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Memory.getProcessMemoryDistribution'
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

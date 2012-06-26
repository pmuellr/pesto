# Licensed under the Tumbolia Public License. See footer for details.

#-------------------------------------------------------------------------------
# domain: ApplicationCache
#-------------------------------------------------------------------------------
module.exports =

    #---------------------------------------------------------------------------
    getFramesWithManifests: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'ApplicationCache.getFramesWithManifests'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    enable: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'ApplicationCache.enable'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    getManifestForFrame: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'ApplicationCache.getManifestForFrame'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    getApplicationCacheForFrame: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'ApplicationCache.getApplicationCacheForFrame'
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

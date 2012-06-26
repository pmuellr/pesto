# Licensed under the Tumbolia Public License. See footer for details.

#-------------------------------------------------------------------------------
# domain: Network
#-------------------------------------------------------------------------------
module.exports =

    #---------------------------------------------------------------------------
    enable: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Network.enable'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    disable: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Network.disable'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    setUserAgentOverride: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Network.setUserAgentOverride'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    setExtraHTTPHeaders: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Network.setExtraHTTPHeaders'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    getResponseBody: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Network.getResponseBody'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    canClearBrowserCache: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Network.canClearBrowserCache'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    clearBrowserCache: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Network.clearBrowserCache'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    canClearBrowserCookies: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Network.canClearBrowserCookies'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    clearBrowserCookies: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Network.clearBrowserCookies'
            id:     message.id
            result: result

        return

    #---------------------------------------------------------------------------
    setCacheDisabled: (client, message) ->

        result = null

        client.sendResponse
            _omsg:  'Network.setCacheDisabled'
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

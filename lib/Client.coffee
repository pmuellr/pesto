# Licensed under the Tumbolia Public License. See footer for details.

_ = require 'underscore'

utils             = require './utils'
connectionManager = require './connectionManager'

domains = {}

#-------------------------------------------------------------------------------
module.exports = class Client

    #---------------------------------------------------------------------------
    constructor: (@socket) ->
        connectionManager.attachClient @

        @socket.on 'pesto-message', (message) => @_handleCommand message
        @socket.on 'disconnect', => connectionManager.detachClient @

    #---------------------------------------------------------------------------
    sendEvent: (domain, method, params) ->
        @socket.emit 'pesto-message', 
            method: "#{domain}.#{method}"
            params: params
        
    #---------------------------------------------------------------------------
    sendResponse: (message) ->
        @socket.emit 'pesto-message', message
    
    #---------------------------------------------------------------------------
    _handleCommand: (message) ->
        try 
            message = JSON.parse(message)
        catch e
            utils.error "unable to parse JSON message: #{message}"
            return
        
        utils.logVerbose "Client._handleCommand #{utils.Js(message)}"
        
        method = message.method
        if typeof method != "string"
            utils.error "message's method is not a string: #{message.method}"
            return
            
        [domain, method] = method.split "."
        
        if !domains[domain] 
            utils.error "message's domain not supported: #{domain}"
            return
        
        if typeof domains[domain][method] != "function"
            utils.error "message domain's method not supported: #{domain}.#{method}"
            return

        try        
            domains[domain][method](@, message)
        catch e
            utils.error "error running #{domain}.#{method}"
            console.error e.stack
            return
            
        return

#-------------------------------------------------------------------------------
# domains
#-------------------------------------------------------------------------------

domains.Inspector        = require "./domains/Inspector"
domains.Memory           = require "./domains/Memory"
domains.Page             = require "./domains/Page"
domains.Runtime          = require "./domains/Runtime"
domains.Console          = require "./domains/Console"
domains.Network          = require "./domains/Network"
domains.Database         = require "./domains/Database"
domains.IndexedDB        = require "./domains/IndexedDB"
domains.DOMStorage       = require "./domains/DOMStorage"
domains.ApplicationCache = require "./domains/ApplicationCache"
domains.FileSystem       = require "./domains/FileSystem"
domains.DOM              = require "./domains/DOM"
domains.CSS              = require "./domains/CSS"
domains.Timeline         = require "./domains/Timeline"
domains.Debugger         = require "./domains/Debugger"
domains.DOMDebugger      = require "./domains/DOMDebugger"
domains.Profiler         = require "./domains/Profiler"
domains.Worker           = require "./domains/Worker"
domains.WebGL            = require "./domains/WebGL"

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

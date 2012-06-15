# Licensed under the Tumbolia Public License. See footer for details.

net    = require 'net'
events = require 'events'

_ = require 'underscore'

utils             = require './utils'
Target            = require './Target'
connectionManager = require './connectionManager'

def = require('./prettyStackTrace').def

#-------------------------------------------------------------------------------
# emits:
#    cb('connected', aNodeConnection)
#-------------------------------------------------------------------------------
module.exports = def class TargetScanner

    #---------------------------------------------------------------------------
    constructor: (@config) ->
        @openPorts = {}

    #---------------------------------------------------------------------------
    startScanning: ()  ->
        if @config.portStart > @config.portStop
            utils.fatalError 'starting target scan port > stopping target scan port'
            
        if @portStart <= 0
            utils.fatalError 'starting target scan port < 0'

        if @portStop >= 256*256
            utils.fatalError "stopping target scan port > #{256*256}"

        @stopped  = false
        @interval = setInterval (=> @checkPorts()), 1000
            
    #---------------------------------------------------------------------------
    stopScanning: ->
        @stopped = true
        clearInterval(@interval)
        
    #---------------------------------------------------------------------------
    checkPorts: ->
        # utils.logTrace arguments.callee, "checking node ports #{@portStart}..#{@portStop}"
        for port in [@config.portStart .. @config.portStop]
            @checkPort port            

    #---------------------------------------------------------------------------
    checkPort: (port) ->
        return if @openPorts[port]
        
        # utils.logTrace arguments.callee, "checking node port #{port}"
        
        target = new Target(port)
        
        target.on 'connect', => 
            utils.logVerbose "TargetScanner.checkPort(): connected on port #{port}"
            @openPorts[port] = target
            
            target.on 'end', => @_onTargetEnd(target, port)

            
    #---------------------------------------------------------------------------
    _onTargetEnd: (target, port) ->
        delete @openPorts[port]

        connectionManager.targetDetached target

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
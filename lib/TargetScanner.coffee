# Licensed under the Tumbolia Public License. See footer for details.

net    = require 'net'
events = require 'events'

_ = require 'underscore'

utils             = require './utils'
Target            = require './Target'
connectionManager = require './connectionManager'

#-------------------------------------------------------------------------------
# emits:
#    cb('connected', aNodeConnection)
#-------------------------------------------------------------------------------
module.exports = class TargetScanner

    #---------------------------------------------------------------------------
    constructor: (config) ->
        @port      = config.port
        @scanning  = false
        @connected = false
        @target    = null

        if @port <= 0
            utils.fatalError 'starting target scan port < 0'

        if @port >= 256*256
            utils.fatalError "stopping target scan port > #{256*256}"

    #---------------------------------------------------------------------------
    startScanning: ()  ->
        return if @scanning
        
        @scanning  = false
        @interval = setInterval (=> @checkPort()), 1000
            
    #---------------------------------------------------------------------------
    stopScanning: ->
        return if !@scanning
        
        @scanning = true
        clearInterval(@interval)
        @interval = null
        
    #---------------------------------------------------------------------------
    checkPort: ->
        return if @connected
        
#        utils.logVerbose "TargetScanner checking port #{@port}"

        @target.close() if @target
        
        @target = new Target(@port)
        
        @target.on 'connect', => 
            utils.logVerbose "Target connected on port #{@port}"
            @connected = true
            
            @target.on 'end', => 
                utils.logVerbose "Target disconnected on port #{@port}"
                @connected = false
            
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

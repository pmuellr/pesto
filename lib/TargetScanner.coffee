#-------------------------------------------------------------------------------
# Copyright 2012 Patrick Mueller
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#-------------------------------------------------------------------------------

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
        # utils.logVerbose "checking node ports #{@portStart}..#{@portStop}"
        for port in [@config.portStart .. @config.portStop]
            @checkPort port            

    #---------------------------------------------------------------------------
    checkPort: (port) ->
        return if @openPorts[port]
        
        # utils.logVerbose "checking node port #{port}"
        
        target = new Target(port)
        
        target.on 'connect', => 
            utils.logVerbose "TargetScanner: connected on port #{port}"
            @openPorts[port] = target
            
            connectionManager.targetAttached target
            
            target.on 'end', => @_onTargetEnd(target, port)

            
    #---------------------------------------------------------------------------
    _onTargetEnd: (target, port) ->
        utils.logVerbose "TargetScanner: disconnected from port #{port}"
        delete @openPorts[port]

        connectionManager.targetDetached target


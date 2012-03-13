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

utils          = require './utils'
NodeConnection = require './NodeConnection'

def = require('./prettyStackTrace').def

#-------------------------------------------------------------------------------
# emits:
#    cb('connected', aNodeConnection)
#-------------------------------------------------------------------------------
module.exports = def class NodeManager extends events.EventEmitter

    #---------------------------------------------------------------------------
    constructor: (@portStart, @portStop) ->
        utils.logVerbose "NodeManager(#{@portStart}, #{@portStop})"
        if @portStart > @portStop
            [@portStart, @portStop] = [@portStop, @portStart]
            
        if @portStart <= 0
            utils.fatalError 'starting node scan port < 0'

        if @portStop >= 256*256
            utils.fatalError "stopping node scan port > #{256*256}"
            
        @connections = {}
    
    #---------------------------------------------------------------------------
    start: ->
        @stopped  = false
        @interval = setInterval (=> @checkPorts()), 1000
        
    #---------------------------------------------------------------------------
    stop: ->
        @stopped = true
        clearInterval(@interval)
        
    #---------------------------------------------------------------------------
    checkPorts: ->
        # utils.logVerbose "checking node ports #{@portStart}..#{@portStop}"
        for port in [@portStart .. @portStop]
            @checkPort port            

    #---------------------------------------------------------------------------
    checkPort: (port) ->
        return if @connections[port]
        # utils.logVerbose "checking node port #{port}"
        
        connection = new NodeConnection(port)
        
        connection.on 'connect', => 
            utils.logVerbose "NodeManager: connected on port #{port}"
            @connections[port] = connection
            
        connection.on 'end', => 
            utils.logVerbose "NodeManager: disconnected from port #{port}"
            delete @connections[port]

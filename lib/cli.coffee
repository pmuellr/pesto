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

path = require 'path'

_ = require 'underscore'

utils       = require './utils'
NodeManager = require './NodeManager'
WebServer   = require './WebServer'

def = require('./prettyStackTrace').def

#-------------------------------------------------------------------------------
module.exports.run = ->
    nodePest = new NodePest()
    nodePest.run()

#-------------------------------------------------------------------------------
def class NodePest

    #---------------------------------------------------------------------------
    constructor: ->

    #---------------------------------------------------------------------------
    run: ->
        @checkConfig(utils.config)
        @dumpInfoAtStart(utils.config)
        
        webServer = new WebServer(utils.config)
        webServer.start()
        
        nodeManager = new NodeManager(utils.config.v8port, utils.config.v8port)
        nodeManager.start()

    #---------------------------------------------------------------------------
    startV8Connector: ->
        utils.logVerbose "starting v8 connector"
        
    #---------------------------------------------------------------------------
    dumpInfoAtStart: (config) ->
        utils.logVerbose "#{utils.PROGRAM}: #{utils.VERSION}"
        
        utils.logVerbose "configuration:"
        maxKeyLen = _.chain(config)
            .keys()
            .max((item)->item.length)
            .value().length
            
        for own key,val of config
            key = utils.alignLeft(key, maxKeyLen)
            utils.logVerbose "   #{key}: #{val}"
            
    #---------------------------------------------------------------------------
    checkConfig: (config) ->
    
        printHelp()    if config.help 
        printVersion() if config.version
        
        orig_port   = config.port
        orig_v8port = config.v8port
        
        config.verbose = (config.verbose == "true")
        config.port    = parseInt(config.port,   10)
        config.v8port  = parseInt(config.v8port, 10)
        
        if isNaN(config.port)
            utils.fatalError "specified port value is not a number: #{orig_port}"

        if isNaN(config.v8port)
            utils.fatalError "specified v8port value is not a number: #{orig_v8port}"
            
        delete config.help
        delete config.version

#---------------------------------------------------------------------------
printVersion = ->
    console.log "#{utils.VERSION}"

    process.exit 0
    
#---------------------------------------------------------------------------
printHelp = ->
    console.log "usage:   #{utils.PROGRAM} [options]"
    console.log "version: #{utils.VERSION}"
    console.log ""
    console.log "options:"
    console.log "   -v    --verbose     spew jibberish"
    console.log "   -p    --port        http port to serve on"
    console.log "   -8    --v8port      v8 port to connect to"
    console.log "   -h -? --help        print this help"
    console.log "   -V    --version     print the version #"

    process.exit 0
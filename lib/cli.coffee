# Licensed under the Tumbolia Public License. See footer for details.

require './prettyStackTrace'

path = require 'path'

_ = require 'underscore'

utils         = require './utils'
TargetScanner = require './TargetScanner'
WebServer     = require './WebServer'

#-------------------------------------------------------------------------------
module.exports.run = ->
    cli = new CLI()
    cli.run()

#-------------------------------------------------------------------------------
class CLI

    #---------------------------------------------------------------------------
    constructor: ->

    #---------------------------------------------------------------------------
    run: ->
        @checkConfig(utils.config)
        @dumpInfoAtStart(utils.config)
        
        targetScannerConfig =
            port: utils.config.v8port
            
        targetScanner = new TargetScanner(targetScannerConfig)
        targetScanner.startScanning()
        
        webServer = new WebServer(utils.config.port)
        webServer.start()

    #---------------------------------------------------------------------------
    dumpInfoAtStart: (config) ->
        utils.logVerbose "----------------------------------------------------"
        utils.logVerbose "#{utils.PROGRAM}: #{utils.VERSION}"
        
        utils.logVerbose "configuration:"
        maxKeyLen = _.chain(config)
            .keys()
            .max((item)->item.length)
            .value().length
            
        for own key,val of config
            key = utils.alignLeft(key, maxKeyLen)
            utils.logVerbose "   #{key}: #{val}"

        utils.logVerbose "----------------------------------------------------"
            
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

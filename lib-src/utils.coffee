# Licensed under the Tumbolia Public License. See footer for details.

#-------------------------------------------------------------------------------
fs   = require 'fs'
path = require 'path'

_    = require 'underscore'
nopt = require 'nopt'

#-------------------------------------------------------------------------------

configDefaults =
    verbose:  "false"
    port:     "8080"
    v8port:   "5858"

utils  = {} # value set in init()

#-------------------------------------------------------------------------------
init = ->
    utils = module.exports = new Utils
    
    packageJSON = readPackageJSON()

    utils.PROGRAM = packageJSON.name
    utils.VERSION = packageJSON.version

    configFile    = getConfigFromFile()
    configCommand = getConfigFromCommandLine()
    
    utils.config = _.defaults(configCommand, configFile, configDefaults)
    
#-------------------------------------------------------------------------------
class Utils

    #---------------------------------------------------------------------------
    constructor: ->
        @config   = {}
        @rootPath = path.resolve(path.join(__dirname, '..'))

    #---------------------------------------------------------------------------
    Jl: (object) ->
        JSON.stringify(object, null, 4)
    
    #---------------------------------------------------------------------------
    Js: (object) ->
        JSON.stringify(object)
    
    #---------------------------------------------------------------------------
    trim: (string) -> 
        string.replace(/(^\s+)|(\s+$)/g,'')

    #---------------------------------------------------------------------------
    alignLeft: (string, length) ->
        while string.length < length
            string = "#{string} "
            
        string
    
    #---------------------------------------------------------------------------
    alignRight: (string, length) ->
        while string.length < length
            string = " #{string}"
    
        string

    #---------------------------------------------------------------------------
    logVerbose: (message) -> 
        return if !utils.config.verbose
        utils.log message

    #---------------------------------------------------------------------------
    log: (message) -> 
        date = new Date()
        time = date.toISOString()    
        console.log "#{utils.PROGRAM} #{time}: #{message}"

    #---------------------------------------------------------------------------
    error: (message) -> 
        date = new Date()
        time = date.toISOString()    
        console.log "#{utils.PROGRAM} #{time}: error: #{message}"

    #---------------------------------------------------------------------------
    fatalError: (message) -> 
        utils.error message
        process.exit 1

#-------------------------------------------------------------------------------
getConfigFromCommandLine = ->

    knownOpts = 
        verbose: String
        port:    String
        v8port:  String
        help:    Boolean
        version: Boolean
        
    shortHands = 
        v:   ["--verbose"]
        p:   ["--port"]
        8:   ["--v8port"]
        h:   ["--help"]
        '?': ["--help"]
        V:   ["--version"]
        
    parsed = nopt(knownOpts, shortHands, process.argv, 2)
    
    utils.argv = parsed.remain
    
    config =
        verbose: parsed.verbose
        port:    parsed.port
        v8port:  parsed.v8port
        help:    parsed.help
        version: parsed.version
        
    config

#-------------------------------------------------------------------------------
getConfigFromFile = ->
    configFile = findConfigFile()

    config = {}
    config = readConfigFile(configFile) if configFile
    config

#-------------------------------------------------------------------------------
readConfigFile = (fileName) ->

    contents = fs.readFileSync fileName, 'utf-8'
    lines    = contents.split('\n')
    
    properties = {}

    for line in lines
        line = line.replace(/#.*/,'')
        match = line.match /\s*(\w+)\s*:\s*(.+)\s*/
        continue if !match

        key = utils.trim match[1]
        val = utils.trim match[2]

        properties[key] = val

    properties.__filename = fileName

    properties    

#-------------------------------------------------------------------------------
findConfigFile = ->
    baseName = ".#{utils.PROGRAM}.properties"
    
    dirs = [
        "."
        replaceTilde "~"
        "/etc"
    ]
    
    for dir in dirs
        fileName = path.join dir, baseName
        return fileName if path.existsSync fileName
        
    return null


#-------------------------------------------------------------------------------
readPackageJSON = () ->
    fileName = path.join utils.rootPath, 'package.json'
    
    utils.fatalError 'package.json not found' if !path.existsSync(fileName)
    
    contents = fs.readFileSync fileName
    
    try
        return JSON.parse(contents)
    catch e
        utils.fatalError 'package.json is not JSON'

#-------------------------------------------------------------------------------
replaceTilde = (fileName) ->
    fileName.replace('~', getTildeReplacement())

#-------------------------------------------------------------------------------
getTildeReplacement = () ->
    process.env["HOME"] || process.env["USERPROFILE"] || '.'

#-------------------------------------------------------------------------------
init()

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

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

#-------------------------------------------------------------------------------
fs   = require 'fs'
path = require 'path'

_    = require 'underscore'
nopt = require 'nopt'

def  = require('./prettyStackTrace').def

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
def class Utils

    #---------------------------------------------------------------------------
    rootPath: path.resolve(path.join(__dirname, '..'))

    #---------------------------------------------------------------------------
    Jl: (object) ->
        JSON.stringify(object, null, 4)
    
    #---------------------------------------------------------------------------
    Js: (object) ->
        JSON.stringify(object)
    
    #---------------------------------------------------------------------------
    config: {} # value set in init()

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
    logTrace: (func, message) -> 
        frame = func.displayName || func.name || "<anonymous function>"
            
        @logVerbose "#{frame}: #{message}"

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
        console.error "#{utils.PROGRAM} #{time}: error: #{message}"

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

# Licensed under the Apache License. See footer for details.

path = require "path"
util = require "util"

_    = require "underscore"
nopt = require "nopt"

pkg   = require "../../package.json"
utils = require "../common/utils"
main  = require "./#{pkg.name}"

require "../common/prettyStackTrace"

cli = exports

#-------------------------------------------------------------------------------
cli.run = ->
    cmdLine = process.argv[2..]

    [args, opts] = parse cmdLine

    main.start opts

#-------------------------------------------------------------------------------
# parse the command-line options
# will set the following properties on the exported object
# - argv     non-option parameters
# - config   name of the config file
# - port     port number to run the server on
# - verbose  whether to emit verbose messages
#-------------------------------------------------------------------------------
parse = (argv) ->

    optionSpecs =
        config:     path
        port:       Number
        scan:       String
        verbose:    Boolean
        help:       Boolean

    shortHands =
        c:   "--config"
        p:   "--port"
        s:   "--scan"
        v:   "--verbose"
        "?": "--help"
        h:   "--help"

    help() if argv[0] == "?"

    parsed = nopt(optionSpecs, shortHands, argv, 0)

    help() if parsed.help

    defOptions =
        port:    8080
        scan:    "5858-5858"
        verbose: false

    cmdOptions = _.pick parsed, "config port scan verbose".split(" ")

    if !cmdOptions.config
        fileName = utils.replaceTilde "~/.#{pkg.name}/config.json"
        if utils.fileExistsSync fileName
            options.config = fileName

    if !cmdOptions.config
        cfgOptions = {}
    else
        cfgOptions = readConfig cmdOptions.config

    envOptions = {}
    envOptions.port = process.env.PORT if process.env.PORT

    options = _.defaults cmdOptions, envOptions, cfgOptions, defOptions

    if typeof options.port is "string"
        options.port = parseInt(options.port,10)
        err "port is not a number: #{options.port}" if isNaN(options.port)

    match = options.scan.match /(\d+)(-(\d+))?/
    err "scan is not a valid range: #{options.scan}" if !match

    start = match[1]
    stop  = match[3] || start

    options.scan = [
        parseInt(start,10)
        parseInt(stop,10)
    ]

    [parsed.argv.remain, options]

#-------------------------------------------------------------------------------
readConfig = (fileName) ->
    try
        return require(fileName)
    catch e
        err "error reading config file: #{fileName}: #{e}"

#-------------------------------------------------------------------------------
err = (message) ->
    console.log "#{pkg.name}: #{message}"
    process.exit 1

#-------------------------------------------------------------------------------
help = ->
    text =  """
            #{pkg.name} #{pkg.version} - run a WEb INspector for NOde server

            usage:
                #{pkg.name} [options]

            options:
                -c --config <file> (default ~/.#{pkg.name}/config.json)
                -p --port <number> (default 8080)
                -v --verbose
                -h --help
            """
    console.log text
    process.exit()

#-------------------------------------------------------------------------------
# Copyright 2013 I.B.M.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#-------------------------------------------------------------------------------

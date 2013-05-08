# Licensed under the Apache License. See footer for details.

path = require "path"

utils = require "./utils"

#-------------------------------------------------------------------------------
module.exports = class Logger

    #---------------------------------------------------------------------------
    constructor: ({prefix, logObject}) ->
        @_prefix    = prefix
        @_logObject = logObject
        @_verbose   = false
        @_logObject = console if !@_logObject?

    #---------------------------------------------------------------------------
    verbose: (value) ->
        @_verbose = !!value if arguments.length isnt 0
        return @_verbose

    #---------------------------------------------------------------------------
    log: (message) ->
        @_logObject.log "#{logDate()} #{@_prefix}: #{message}"

    #---------------------------------------------------------------------------
    vlog: (message) ->
        return if !@_verbose
        @log message

    #---------------------------------------------------------------------------
    err: (message) ->
        @log "error: #{message}"
        throw Error message

    #---------------------------------------------------------------------------
    logger: (prefix) ->
        prefix    = "#{@_prefix}: #{prefix}"
        logObject = @_logObject

        logger = new Logger {prefix, logObject}

        logger.verbose @_verbose
        return logger

    #---------------------------------------------------------------------------
    tracer: (fileName) ->
        fileName = path.relative process.cwd(), fileName

        return @logger fileName

#-------------------------------------------------------------------------------
logDate = () ->
    date = new Date()

    mon = date.getMonth() + 1
    day = date.getDate()
    hr  = date.getHours()
    min = date.getMinutes()
    sec = date.getSeconds()
    ms  = date.getMilliseconds()

    mon = utils.alignRight0 "#{mon}" , 2
    day = utils.alignRight0 "#{day}" , 2
    hr  = utils.alignRight0 "#{hr }" , 2
    min = utils.alignRight0 "#{min}" , 2
    sec = utils.alignRight0 "#{sec}" , 2
    ms  = utils.alignRight0 "#{ms }" , 4

    result = "#{mon}-#{day} #{hr}:#{min}:#{sec}.#{ms}"
    return result

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

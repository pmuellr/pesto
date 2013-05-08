# Licensed under the Apache License. See footer for details.

fs   = require "fs"
path = require "path"
util = require "util"

pkg               = require "../../package.json"
Logger            = require "../common/Logger"
utils             = require "../common/utils"
Server            = require "./Server"
TargetScanner     = require "./TargetScanner"
ConnectionManager = require "./ConnectionManager"

pesto = exports

#-------------------------------------------------------------------------------
pesto.start = (opts) ->
    opts           = opts || {}
    opts.logger    = new Logger {prefix: pkg.name, logObject: opts.logObject}
    opts.webDir    = opts.webDir || path.resolve __dirname, "..", "web"

    showOpts =
        verbose: opts.verbose
        port:    opts.port
        scan:    opts.scan

    opts.logger.verbose opts.verbose

    opts.connManager = new ConnectionManager opts

    targetScanner = new TargetScanner opts
    targetScanner.start()

    server = new Server opts
    server.start()

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

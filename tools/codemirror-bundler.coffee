# Licensed under the Apache License. See footer for details.

fs   = require "fs"
path = require "path"

_ = require "underscore"

require "shelljs/global"

PROGRAM = path.basename(__filename)

#-------------------------------------------------------------------------------
log = (message) ->
    console.log "#{PROGRAM}: #{message}"

#-------------------------------------------------------------------------------
main  = (iDirName, oDirName) ->

    css = []
    js  = []

    collectCSS css, path.join(iDirName, "lib")
    collectCSS css, path.join(iDirName, "addon")
    collectJS  css, path.join(iDirName, "mode")
    collectCSS css, path.join(iDirName, "theme")

    collectJS  js,  path.join(iDirName, "lib")
    collectJS  js,  path.join(iDirName, "addon")
    collectJS  js,  path.join(iDirName, "keymap")
    collectJS  js,  path.join(iDirName, "mode")
    collectJS  js,  path.join(iDirName, "theme")

    oFile = path.join oDirName, "codemirror-bundle.css"
    fs.writeFileSync oFile, css.join "\n"
    log "generated #{oFile}"

    oFile = path.join oDirName, "codemirror-bundle.js"
    fs.writeFileSync oFile, js.join "\n"
    log "generated #{oFile}"

#-------------------------------------------------------------------------------
collectCSS = (result, iDir) ->
    collectFiles result, iDir, /.*\.css$/

#-------------------------------------------------------------------------------
collectJS = (result, iDir) ->
    collectFiles result, iDir, /.*\.js$/

#-------------------------------------------------------------------------------
collectFiles = (result, iDir, filter) ->
    files = ls "-R", iDir
    files = _.filter files, (item) -> item.match filter

    ignoreFilters = [
        /.*?\.node\..*/
        /.*?-standalone\..*/
        /.*?_test\..*/
        /.*?\/test\..*/
    ]

    for filter in ignoreFilters
        files = _.filter files, (item) ->
            res = !(item.match filter)?
            # log "skipping #{item}" if !res
            res

    for file in files
        # log "bundling #{file}"

        file = path.join(iDir, file)
        result.push """
            /*------------------------------------------------------------------------------
             * bundled from file #{file}
             *----------------------------------------------------------------------------*/
        """
        result.push fs.readFileSync file , "utf8"
        result.push ""

#-------------------------------------------------------------------------------
main process.argv[2], process.argv[3]
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

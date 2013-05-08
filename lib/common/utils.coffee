# Licensed under the Apache License. See footer for details.

fs   = null
path = require "path"

utils = exports

SequenceNumberMax = 100 * 1024 * 1024
SequenceNumber    = 0

#-------------------------------------------------------------------------------
utils.indent = 4

#-------------------------------------------------------------------------------
utils.getSequencer = (prefix) ->
    nextId = 0

    return ->
        result = "#{prefix}-#{nextId}"
        
        nextId++
        nextId = 0 if nextId >= SequenceNumberMax

        return result

#-------------------------------------------------------------------------------
utils.Jl = (object) ->
    return JSON.stringify object, null, utils.indent

#-------------------------------------------------------------------------------
utils.Js = (object) ->
    return JSON.stringify object

#-------------------------------------------------------------------------------
utils.trim = (string) ->
    string.replace(/(^\s+)|(\s+$)/g,'')

#-------------------------------------------------------------------------------
utils.alignLeft = (string, length) ->
    while string.length < length
        string = "#{string} "
    return string

#-------------------------------------------------------------------------------
utils.alignRight = (string, length) ->
    while string.length < length
        string = " #{string}"
    return string

#-------------------------------------------------------------------------------
utils.alignRight0 = (string, length) ->
    while string.length < length
        string = "0#{string}"
    return string

#-------------------------------------------------------------------------------
utils.fileExistsSync = (name) ->
    fs = require "f" + "s" if !fs
    return fs.existsSync name if fs.existsSync
    return path.existsSync(name)

#-------------------------------------------------------------------------------
utils.replaceTilde = (fileName) ->
    tilde = process.env["HOME"] || process.env["USERPROFILE"] || '.'
    return fileName.replace('~', tilde)

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

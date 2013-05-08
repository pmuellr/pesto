# Licensed under the Apache License. See footer for details.

path = require "path"

#-------------------------------------------------------------------------------
Error.prepareStackTrace = (error, structuredStackTrace) ->
    result = []
    result.push "---------------------------------------------------------"
    result.push "error: #{error}"
    result.push "---------------------------------------------------------"
    result.push "stack: "

    cwd = path.resolve(process.cwd())

    longestFile = 0
    longestLine = 0
    
    entries = []

    for callSite in structuredStackTrace
        func = callSite.getFunction()
        file = callSite.getFileName()
        line = callSite.getLineNumber()

        func = func.displayName ||
               func.name || 
               callSite.getFunctionName() ||
               callSite.getMethodName() ||
               "<anon>"

        file = path.relative(cwd, file)

        continue if !line?

        line = "#{line}"

        break if func is "Module._compile"

        entries.push {file, line, func}

        longestFile = file.length if file.length > longestFile
        longestLine = line.length if line.length > longestLine

    for entry in entries
        {file, line, func} = entry

        file = alignRight file, longestFile
        line = alignLeft  line, longestLine

        result.push "   #{file}:#{line} - #{func}()"
        
    result.join "\n"

#-------------------------------------------------------------------------------
alignLeft = (string, length) ->
    while string.length < length
        string = "#{string} "
        
    string

#-------------------------------------------------------------------------------
alignRight = (string, length) ->
    while string.length < length
        string = " #{string}"

    string

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

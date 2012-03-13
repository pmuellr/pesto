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

utils = require './utils'

#-------------------------------------------------------------------------------
exports.def = (aClass) ->
    className = aClass.name

    for own key,val of aClass
        if typeof val == 'function'
            aClass[key].displayName = "#{className}:#{key}"
    
    for own key,val of aClass.prototype
        if typeof val == 'function'
            aClass.prototype[key].displayName = "#{className}.#{key}"
            
    aClass

#-------------------------------------------------------------------------------
Error.xprepareStackTrace = (error, structuredStackTrace) ->
    result = []
    result.push "---------------------------------------------------------"
    result.push "error: #{error}"
    result.push "---------------------------------------------------------"
    result.push "stack: "

    longestFile = 0
    longestLine = 0
    
    for callSite in structuredStackTrace
        file = callSite.getFileName()
        line = callSite.getLineNumber()

        file = path.basename(file)
        line = "#{line}"
        
        if file.length > longestFile
            longestFile = file.length
    
        if line.length > longestLine
            longestLine = line.length
    
    for callSite in structuredStackTrace
        func = callSite.getFunction()
        file = callSite.getFileName()
        line = callSite.getLineNumber()

        file = path.basename(file)
        line = "#{line}"

        file = utils.alignRight(file, longestFile)
        line = utils.alignLeft( line, longestLine)

        funcName = func.displayName ||
                   func.name || 
                   callSite.getFunctionName()
                   callSite.getMethodName()
                   '???'

#        if funcName == "Module._compile"
#            result.pop()
#            result.pop()
#            break
            
        frame = "#{file}:#{line} - #{funcName}()"
        result.push "   #{frame}"
        
    result.join '\n'


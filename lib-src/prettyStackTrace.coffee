# Licensed under the Tumbolia Public License. See footer for details.

path = require 'path'

#-------------------------------------------------------------------------------
Error.prepareStackTrace = (error, structuredStackTrace) ->
    result = []
    result.push "---------------------------------------------------------"
    result.push "error: #{error}"
    result.push "---------------------------------------------------------"
    result.push "stack: "

    longestFile = 0
    longestLine = 0
    
    cwd = path.resolve(process.cwd())
    fileMax = 30
    
    for callSite in structuredStackTrace
        file = callSite.getFileName()
        line = callSite.getLineNumber()
        
#       file = path.basename(file)
        file = path.relative(cwd, file)
        line = "#{line}"
        
        if file.length > longestFile
            longestFile = file.length
    
        if line.length > longestLine
            longestLine = line.length
    
    longestFile = fileMax if longestFile > fileMax
    
    for callSite in structuredStackTrace
        func = callSite.getFunction()
        file = callSite.getFileName()
        line = callSite.getLineNumber()

#       file = path.basename(file)
        file = path.relative(cwd, file)
        
        if file.length > longestFile
            file = file.substr(-(fileMax - 3))
            file = alignRight(file, fileMax-3)
            file = "...#{file}"
        
        line = "#{line}"

        file = alignRight(file, longestFile)
        line = alignLeft( line, longestLine)

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

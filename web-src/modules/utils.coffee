# Licensed under the Tumbolia Public License. See footer for details.

utils = module.exports

#-------------------------------------------------------------------------------
utils.log = (message) ->
    WebInspector.log message, WebInspector.ConsoleMessage.MessageLevel.Log

#-------------------------------------------------------------------------------
utils.logWarn = (message) ->
    WebInspector.log message, WebInspector.ConsoleMessage.MessageLevel.Warning

#-------------------------------------------------------------------------------
utils.logDebug = (message) ->
    WebInspector.log message, WebInspector.ConsoleMessage.MessageLevel.Debug

#-------------------------------------------------------------------------------
utils.logError = (message) ->
    WebInspector.log message, WebInspector.ConsoleMessage.MessageLevel.Error

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

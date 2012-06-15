# Licensed under the Tumbolia Public License. See footer for details.

serviceHacks = module.exports

#-------------------------------------------------------------------------------
init = ->
    serviceHacks["Debugger.causesRecompilation"]       = Debugger_causesRecompilation
    serviceHacks["Debugger.supportsNativeBreakpoints"] = Debugger_supportsNativeBreakpoints
    serviceHacks["Profiler.causesRecompilation"]       = Profiler_causesRecompilation
    serviceHacks["Profiler.isSampling"]                = Profiler_isSampling
    serviceHacks["Profiler.hasHeapProfiler"]           = Profiler_hasHeapProfiler
    serviceHacks["Page.reload"]                        = Page_reload

#-------------------------------------------------------------------------------
genericServiceCall = (message) ->
    InspectorBackend.dispatch
        id: message.id

#-------------------------------------------------------------------------------
Debugger_causesRecompilation = (message) ->
    InspectorBackend.dispatch
        id:     message.id
        result:
            result: false

#-------------------------------------------------------------------------------
Debugger_supportsNativeBreakpoints = (message) ->
    InspectorBackend.dispatch
        id:     message.id
        result:
            result: false

#-------------------------------------------------------------------------------
Profiler_causesRecompilation = (message) ->
    InspectorBackend.dispatch
        id:     message.id
        result:
            result: false

#-------------------------------------------------------------------------------
Profiler_isSampling = (message) ->
    InspectorBackend.dispatch
        id:     message.id
        result:
            result: false

#-------------------------------------------------------------------------------
Profiler_hasHeapProfiler = (message) ->
    InspectorBackend.dispatch
        id:     message.id
        result:
            result: false
    
#-------------------------------------------------------------------------------
Page_reload = (message) ->
    InspectorBackend.dispatch
        id:     message.id
        result:
            result: false

#-------------------------------------------------------------------------------
init()

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

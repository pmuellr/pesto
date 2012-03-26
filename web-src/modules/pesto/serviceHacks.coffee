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

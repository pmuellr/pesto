# Licensed under the Apache License. See footer for details.

utils  = require "../common/utils"
pesto = require "./pesto"

logger = pesto.logger
tracer = logger.tracer __filename

#-------------------------------------------------------------------------------
module.exports = class Target

    #---------------------------------------------------------------------------
    constructor: (@id) ->

    #---------------------------------------------------------------------------
    refresh: (body) ->
        @running = body.running
        @node    = body.node

    #---------------------------------------------------------------------------
    description: ->
        return "javascript runtime" if !@node
        return "node #{@node.version} - #{@node.argv.slice(1).join(" ")}"

    #---------------------------------------------------------------------------
    v8_event: (event) ->
        return @v8_event_break(event)     if event.event is "break"
        return @v8_event_exception(event) if event.event is "exception"

        logger.log "unknown v8 event: #{utils.Jl event}"

    #---------------------------------------------------------------------------
    v8_event_break: (event) ->
        @getCallFrames (callFrames) => @dispatchPause callFrames, "other"

    #---------------------------------------------------------------------------
    v8_event_exception: (event) ->
        @getCallFrames (callFrames) => @dispatchPause callFrames, "exception"

    #---------------------------------------------------------------------------
    dispatchPause: (callFrames, reason) ->
        InspectorBackend.dispatch 
            method:         "Debugger.paused"
            params:
                callFrames: callFrames
                reason:     reason

    #---------------------------------------------------------------------------
    getCallFrames: (callback) ->

        v8Request = 
            targetId:                pesto.currentTarget.id
            request:            
                command:             "backtrace"
                arguments:
                    inlineRefs:      true
#                arguments:
#                    fromFrame:       0
#                    bottom:          true

        pesto.server.send_v8_request v8Request, (v8Response) =>
            if !v8Response.response.success
                return callback []

            @handleV8Backtrace v8Response.response.body.frames, v8Response.response.refs, callback

    #---------------------------------------------------------------------------
    handleV8Backtrace: (v8Frames, v8Refs, callback) ->
        refs = {}
        for v8Ref in v8Refs
            refs[v8Ref.handle] = v8Ref

        wiCallFrames = []

        for v8Frame in v8Frames
            funcRef = v8Frame.func.ref

            wiCallFrame = 
                callFrameId:        v8Frame.index
                functionName:       v8Frame.func.inferredName || v8Frame.func.name
                location:
                    scriptId:       ref[v8Frame.script.ref].id
                    lineNumber:     v8Frame.line
                    columnNumber:   v8Frame.column
                scopeChain:         [] # [Scope] - Scope chain for this call frame.
                this:               null # Runtime.RemoteObject - this object for this call frame.                

        callback wiCallFrames

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

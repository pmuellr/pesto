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

TargetList = require './TargetList'

#-------------------------------------------------------------------------------
module.exports = class TargetsPanel extends  WebInspector.Panel

    #---------------------------------------------------------------------------
    constructor: ->
        WebInspector.Panel.call this, "targets"
        
        @_toolbarItemLabel = "Targets"
        
        Object.defineProperty this, "toolbarItemLabel", 
            get: ()      => @_toolbarItemLabel  
            set: (value) => @_toolbarItemLabel = value
                          
        
        @targetList = new TargetList
        
        $(@element).append @targetList.get$Element()
    
        $(document).ready => @_installHandlers()

    #---------------------------------------------------------------------------
    _installHandlers: ->
        Pesto.messager.on "event-pesto-target-attached", =>

        Pesto.messager.on "event-pesto-target-detached", =>

        Pesto.messager.on "event-pesto-target-connected", =>

        Pesto.messager.on "event-pesto-target-disconnected", =>

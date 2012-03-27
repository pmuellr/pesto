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

events = require 'events'

#-------------------------------------------------------------------------------
# fires event 'selected' -> (target)
#-------------------------------------------------------------------------------
module.exports = class TargetsList extends events.EventEmitter

    #---------------------------------------------------------------------------
    constructor: () ->
        @$element     = $ "<ul class='target-list'>"
        @$noneItem    = $ "<li>none</li>"
        
        @$element.append @$noneItem

    #---------------------------------------------------------------------------
    get$Element: -> @$element

    #---------------------------------------------------------------------------
    addTarget: (target) ->
        desc = target.getDescription()
        
        target.$listItem = @$element.append "<li>#{desc}"

        target.$listItem.data "target", target
        
        target.$listItem.click =>
            @emit "selected", (target.$listItem.data("target"))
        
        @$noneItem.hide()
        
    #---------------------------------------------------------------------------
    removeTarget: (target) ->

        return if !target.$listItem
        
        target.$listItem.addClass "removing"
        
        target.$listItem.fadeOut 2000, =>
            target.$listItem.remove()
            
            if 0 == @$list.children().size()
                @$noneItem.show()
    

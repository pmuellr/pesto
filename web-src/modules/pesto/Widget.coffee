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

positionElement = null

$(document).ready ->
    positionElement = 
        left:   $('#body-left')
        center: $('#body-center')
        right:  $('#body-right')
 
#-------------------------------------------------------------------------------
module.exports = class Widget

    #---------------------------------------------------------------------------
    constructor: (title, body, position) ->
        parent = positionElement[position] || positionElement['left']

        @element = $ """
            <div class="widget">
                <div class="btn btn-primary">
                    <span class="title">#{title}</span>
                </div>
                <div class="body-container">
                    <div class="body">#{body}</div>
                </div>
            </div>
        """
        
        parent.append(@element)    
        
        $(".btn", @element).click =>
            $(".body-container", @element).slideToggle('fast')
            

    #---------------------------------------------------------------------------
    title: (string) ->
        selector = '.title'

        if string == undefined
            return $(selector, @element).html
            
        $(selector, @element).html(string)

    #---------------------------------------------------------------------------
    body: (string) ->
        selector = '.body'

        if string == undefined
            return $(selector, @element).html
            
        $(selector, @element).html(string)
    
    #---------------------------------------------------------------------------
    toggleBody: () ->
        $(".body-container", @element).toggle()
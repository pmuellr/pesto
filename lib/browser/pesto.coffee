# Licensed under the Apache License. See footer for details.

_ = require "underscore"

$         = require "./jquery"
utils     = require "../common/utils"
Logger    = require "../common/Logger"
templates = require "./templates"

pesto = exports

$ -> domReady()

#-------------------------------------------------------------------------------
domReady = ->

    $templates = $ "#templates"
    for own templateName, template of templates
        $templates.append "<div class='#{templateName}'>#{template}</div>"

    autoloadTemplateNames = [
        "header_html" 
        "trailer_html" 
        "navigator_html" 
        "content_html"
    ]

    for templateName in autoloadTemplateNames
        $("##{templateName}").append $("#templates .#{templateName}")

    templateNames = _.without (_.keys templates), autoloadTemplateNames

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

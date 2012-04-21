#!/usr/bin/env coffee

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

fs   = require 'fs'
path = require 'path'

iFile = process.argv[2]
if !iFile
    console.log "expecting name of Inspector.json file"
    process.exit 1
    
content = fs.readFileSync(iFile, 'utf8')
root    = JSON.parse(content)
domains = root.domains

console.log """
<style>
.indent {
    margin-left: 2em;
}

.ident {
    color: blue;
}

h4 {
    margin-top:    0em;
    margin-bottom: 0em;
}

ul {
    margin-top: 0em;
}
</style>
"""

for domain in domains

    console.log ""
    console.log "<!-- ========================================================== -->"
    console.log "<h1 class='ident'>#{domain.domain}</h1>"
    console.log "<div class='indent'>"

    if domain.types and domain.types.length
        console.log ""
        console.log "<h2>types</h2>"
        console.log "<div class='indent'>"
        
        for type in domain.types
            console.log ""
            console.log "<h3 class='ident'>#{type.id}</h3>"
            console.log "<div class='indent'>"

            if type.description
                console.log "<p>#{type.description}</h3>"
                
            if type.properties
                console.log "<h4>properties</h4>"
                console.log "<ul>"
                for property in type.properties
                    console.log "<li class='ident'>#{property.name}"
                    
                console.log "</ul>"
            

            console.log "</div>"
        console.log "</div>"
        
    
    if domain.commands and domain.commands.length
        console.log ""
        console.log "<h2>commands</h2>"
        console.log "<div class='indent'>"
        
        for command in domain.commands
            console.log ""
            console.log "<h3 class='ident'>#{command.name}</h3>"
            console.log "<div class='indent'>"
            
            if command.description
                console.log "<p>#{command.description}</h3>"
                
            if command.parameters
                console.log "<h4>parameters</h4>"
                console.log "<ul>"
                for parameter in command.parameters
                    console.log "<li class='ident'>#{parameter.name}"
                    
                console.log "</ul>"
                
            if command.returns
                console.log "<h4>returns</h4>"
                console.log "<ul>"
                for ret in command.returns
                    console.log "<li class='ident'>#{ret.name}"
                    
                console.log "</ul>"
                
            console.log "</div>"
        console.log "</div>"

                
    if domain.events and domain.events.length
        console.log ""
        console.log "<h2>events</h2>"
        console.log "<div class='indent'>"
    
        for event in domain.events
            console.log ""
            console.log "<h3 class='ident'>#{event.name}</h3>"
            console.log "<div class='indent'>"
            
            if event.description
                console.log "<p>#{event.description}</h3>"

            if event.parameters
                console.log "<h4>parameters</h4>"
                console.log "<ul>"
                for parameter in event.parameters
                    console.log "<li class='ident'>#{parameter.name}"
                    
                console.log "</ul>"
                
            console.log "</div>"

        console.log "</div>"
                
    console.log "</div>"



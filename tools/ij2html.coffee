#!/usr/bin/env coffee

# Licensed under the Tumbolia Public License. See footer for details.

fs   = require 'fs'
path = require 'path'

_ = require 'underscore'

#-------------------------------------------------------------------------------
main = ->
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
        font-weight: bold;
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
    
    skipDomains = "Memory Page Network Database IndexedDB DOMStorage ApplicationCache FileSystem DOM CSS DOMDebugger Worker"
    skipDomains = skipDomains.split(" ")
    
    for domain in domains
        continue if domain.domain in skipDomains
        processDomain(domain)

#-------------------------------------------------------------------------------
processDomain = (domain) ->

    console.log ""
    console.log "<!-- ========================================================== -->"
    console.log "<h1 class='ident'>#{domain.domain}</h1>"
    console.log "<div class='indent'>"
    console.log "<table frame=border rules=all cellpadding=5 cellspacing=0 width=100%>"


    if domain.types?.length
        console.log ""
        console.log "<tr>"
        console.log "<td valign='top'>types"
        console.log "<td width=100%>"
        
        for type in domain.types
            console.log ""
            console.log "<h3 class='ident'>#{type.id}</h3>"
            console.log "<div class='indent'>"

            if type.type != "object"
                type.description = "#{type.type}: #{type.description}"
                
            if type.description
                console.log "<p>#{type.description}</h3>"
                
            if type.properties
                console.log "<h4>properties</h4>"
                
                console.log "<div class='indent'>"
                console.log "<table cellpadding=5>"
                for property in type.properties
                    console.log "<tr><td valign=top><b>#{property.name}<b>&nbsp;:"
                    console.log "<td>#{getTypeDescription(property)}"
                console.log "</table>"
                console.log "</div>"

            console.log "</div>"
        
    
    if domain.commands?.length
        console.log ""
        console.log "<tr>"
        console.log "<td valign='top'>commands"
        console.log "<td width=100%>"
        
        for command in domain.commands
            sig = getSignature(command)

            console.log ""
            console.log "<h3 class='ident'>#{sig}</h3>"
            console.log "<div class='indent'>"
            
            if command.description
                console.log "<p>#{command.description}</h3>"
                
            if command.parameters
                console.log "<h4>parameters</h4>"

                console.log "<div class='indent'>"
                console.log "<table cellpadding=5>"
                for parameter in command.parameters
                    console.log "<tr><td valign=top><b>#{parameter.name}<b>&nbsp;:"
                    console.log "<td>#{getTypeDescription(parameter)}"
                console.log "</table>"
                console.log "</div>"
                
            if command.returns
                console.log "<h4>returns</h4>"

                console.log "<div class='indent'>"
                console.log "<table cellpadding=5>"
                for ret in command.returns
                    console.log "<tr><td valign=top><b>#{ret.name}<b>&nbsp;:"
                    console.log "<td>#{getTypeDescription(ret)}"
                console.log "</table>"
                console.log "</div>"
                
            console.log "</div>"

                
    if domain.events?.length
        console.log ""
        console.log "<tr>"
        console.log "<td valign='top'>events"
        console.log "<td width=100%>"
    
        for event in domain.events
            sig = getSignature(event)
        
            console.log ""
            console.log "<h3 class='ident'>#{sig}</h3>"
            console.log "<div class='indent'>"
            
            if event.description
                console.log "<p>#{event.description}</h3>"

            if event.parameters
                console.log "<h4>parameters</h4>"

                console.log "<div class='indent'>"
                console.log "<table cellpadding=5>"
                for parameter in event.parameters
                    console.log "<tr><td valign=top><b>#{parameter.name}<b>&nbsp;:"
                    console.log "<td>#{getTypeDescription(parameter)}"
                console.log "</table>"
                console.log "</div>"
                
            console.log "</div>"

                
    console.log "</table>"
    console.log "</div>"
    
#-------------------------------------------------------------------------------
getSignature = (thang) ->

    args = []
    if thang.parameters
        args = _.pluck(thang.parameters, "name")
    
    "#{thang.name}(#{args.join(', ')})"

#-------------------------------------------------------------------------------
getTypeDescription = (parm) ->

    if parm.type == "array"
        desc = parm.items.type || parm.items.$ref
        desc = "#{desc}[]"
    else
        desc = parm.type || parm.$ref
        
    if parm.optional
        desc = "#{desc} <i>optional</i>"
        
    if parm.description
        desc = "#{desc}<br>#{parm.description}"
    
    if parm.enum
        desc = "#{desc}<br>Must be one of: #{JSON.stringify(parm.enum)}" 
        
    desc
    
#-------------------------------------------------------------------------------
main()

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

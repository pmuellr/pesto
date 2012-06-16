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
    
    for domain in domains
        processDomain(domain)

#-------------------------------------------------------------------------------
processDomain = (domain) ->

    console.log "#-------------------------------------------------------------------------------"
    console.log "class #{domain.domain}"
    console.log ""
    console.log "    #---------------------------------------------------------------------------"
    console.log "    constructor: ->"
    console.log ""
    
    if domain.commands?.length
        for command in domain.commands
            if !command.parameters
                command.parameters = []
            command.parameters.unshift name: "request"
            sig = getSignature(command)
                
            console.log "    #---------------------------------------------------------------------------"
            if command.description
                console.log "    # #{command.description}"
                console.log "    #---------------------------------------------------------------------------"
            console.log "    #{sig} ->"
            console.log "       request.response null"
            console.log ""
                
    if domain.events?.length
        for event in domain.events
            event.name = "sendEvent_#{event.name}"
            sig = getSignature(event)
        
            console.log "    #---------------------------------------------------------------------------"
            if event.description
                console.log "    # #{event.description}"
                console.log "    #---------------------------------------------------------------------------"
            console.log "    #{sig} ->"
            console.log ""
            
    console.log ""
    
#-------------------------------------------------------------------------------
getSignature = (thang) ->

    args = []
    if thang.parameters
        args = _.pluck(thang.parameters, "name")
    
    "#{thang.name}: (#{args.join(', ')})"

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

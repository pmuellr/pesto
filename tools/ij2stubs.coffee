#!/usr/bin/env coffee

# Licensed under the Tumbolia Public License. See footer for details.

fs   = require 'fs'
path = require 'path'

_ = require 'underscore'

oDir = "#{__dirname}/../lib/domains"

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

    lines = []

    lines.push "# Licensed under the Tumbolia Public License. See footer for details."
    lines.push ""
    lines.push "#-------------------------------------------------------------------------------"
    lines.push "# domain: #{domain.domain}"
    lines.push "#-------------------------------------------------------------------------------"
    lines.push "module.exports ="
    lines.push ""
    
    if domain.commands?.length
        for command in domain.commands
            if !command.parameters
                command.parameters = []
            command.parameters.unshift name: "request"
            sig = getSignature(command)
                
            lines.push "    #---------------------------------------------------------------------------"
            lines.push "    #{command.name}: (client, message) ->"
            lines.push ""
            lines.push "        result = null"
            lines.push ""
            lines.push "        client.sendResponse"
            lines.push "            _omsg:  '#{domain.domain}.#{command.name}'"
            lines.push "            id:     message.id"
            lines.push "            result: result"
            lines.push ""
            lines.push "        return"
            lines.push ""

    lines.push "#-------------------------------------------------------------------------------"
    lines.push "# Copyright (c) 2012 Patrick Mueller"
    lines.push "#"
    lines.push "# Tumbolia Public License"
    lines.push "#"
    lines.push "# Copying and distribution of this file, with or without modification, are"
    lines.push "# permitted in any medium without royalty provided the copyright notice and this"
    lines.push "# notice are preserved."
    lines.push "#"
    lines.push "# TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION"
    lines.push "#"
    lines.push "#   0. opan saurce LOL"
    lines.push "#-------------------------------------------------------------------------------"
    lines.push ""
    
    oFile = "#{oDir}/#{domain.domain}.coffee"
    
    fs.writeFileSync oFile, lines.join("\n"), "utf8"
    
    console.log "generated: #{oFile}"
    
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

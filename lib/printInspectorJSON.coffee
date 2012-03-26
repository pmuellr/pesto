fs   = require 'fs'
path = require 'path'

#-------------------------------------------------------------------------------
main = ->

    iFile    = path.join __dirname, '..', 'web', 'Inspector.json'
    contents = fs.readFileSync iFile, 'utf8'
    
    json = JSON.parse contents
    
    console.log JSON.stringify json, null, 4
    return
    
    version = "#{json.version.major}.#{json.version.minor}"
    console.log "version: #{version}"
    
    domains = json.domains
    
    for domain in domains
        printDomain domain

#-------------------------------------------------------------------------------
printDomain = (domain) ->
    console.log domain.domain
    
    domain.commands ||= []
    domain.events   ||= []
    domain.types    ||= []
    
    console.log "    commands:"
    for command in domain.commands
        printCommand command

    console.log "    events:"
    for event in domain.events
        printEvent event

    console.log "    types:"
    for type in domain.types
        printType type

#-------------------------------------------------------------------------------
printCommand = (command) ->
    console.log "        #{sig(command)}"

#-------------------------------------------------------------------------------
printEvent = (event) ->
    console.log "        #{sig(event)}"

#-------------------------------------------------------------------------------
printType = (type) ->
#    console.log "        #{JSON.stringify(type)}"

#-------------------------------------------------------------------------------
sig = (object) ->
    "#{object.name}()"

#-------------------------------------------------------------------------------
main()
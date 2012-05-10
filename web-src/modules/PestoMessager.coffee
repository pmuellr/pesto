# Licensed under the Tumbolia Public License. See footer for details.

events = require 'events'

_ = require 'underscore'

#-------------------------------------------------------------------------------
module.exports = class PestoMessager extends events.EventEmitter

    #---------------------------------------------------------------------------
    constructor: (@socket) ->
        @callbacks = {}
        @seq       = 0
        
        @socket.on 'pesto-event', (message) =>
            @emit 'event', message
            @emit "event-#{message.event}", message

        @socket.on 'pesto-response', (message) =>
            @_onResponse(message)
    
    #---------------------------------------------------------------------------
    sendMessage: (message, callback) ->
        seq     = @seq++
        message = _.clone(message)
        
        message.seq  = seq
        message.type = 'request'
        
        if callback
            @callbacks[seq] = callback
            
        @socket.emit 'pesto-request', message

    #---------------------------------------------------------------------------
    _onResponse: (message) ->
        seq = message.request_seq
        callback = @callbacks[seq]
        if !callback
            WebInspector.log "no callback for response: #{JSON.stringify(message,null,4)}"
            return
            
        delete @callbacks[seq]
        
        callback.call(null, message)
 
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

# Licensed under the Tumbolia Public License. See footer for details.

PestoMessager         = require './PestoMessager'
InspectorFrontendHost = require './InspectorFrontendHost'
utils                 = require './utils'

window.Pesto = {}

#-------------------------------------------------------------------------------
main = ->
    # installFunctionBind()
    
    options =
        reconnect: false
        
    socket = io.connect location.origin, options
    
    Pesto.messager = new PestoMessager(socket)
    
    window.InspectorFrontendHost = new InspectorFrontendHost
    
#-------------------------------------------------------------------------------
jQuery(document).ready ->
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

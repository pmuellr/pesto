#!/usr/bin/env coffee

# Licensed under the Tumbolia Public License. See footer for details.

fs   = require 'fs'
path = require 'path'

indexHtml     = process.argv[2]
additionsFile = process.argv[3]

indexHtml = fs.readFileSync(indexHtml, 'utf8')

additionsFile = fs.readFileSync(additionsFile, 'utf8')

indexHtml = indexHtml.replace "</head>", "#{additionsFile}</head>"

console.log indexHtml

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
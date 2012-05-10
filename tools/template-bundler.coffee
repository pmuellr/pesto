# Licensed under the Tumbolia Public License. See footer for details.

fs   = require 'fs'
path = require 'path'

dir = process.argv[2]
files = fs.readdirSync(dir)

console.log 'templates = module.exports'
console.log ''

for file in files
    contents = fs.readFileSync path.join(dir,file), 'utf8'
    contents = JSON.stringify(contents)
    
    console.log "templates['#{file}'] = #{contents}"

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

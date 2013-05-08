# Licensed under the Apache License. See footer for details.

fs   = require 'fs'
path = require 'path'

dir = process.argv[2]
files = fs.readdirSync(dir)

console.log 'templates = module.exports'
console.log ''

for file in files
    contents = fs.readFileSync path.join(dir,file), 'utf8'
    contents = contents.replace /<!--(.|[\r\n])*?-->/g, ""
    contents = contents.trim()
    contents = JSON.stringify(contents)

    file = file.replace /\./g, "_"
    
    console.log "templates['#{file}'] = #{contents}"

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

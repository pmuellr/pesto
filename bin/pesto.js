#!/usr/bin/env node

// Licensed under the Apache License. See footer for details.

var path = require("path")
var fs   = require("fs")

var rootPath = path.dirname(fs.realpathSync(__filename))
var coffee   = path.join(rootPath, "..", "node_modules", "coffee-script")
var cli      = path.join(rootPath, "..", "lib", "server", "cli")

require(coffee)
require(cli).run()

/*
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
*/
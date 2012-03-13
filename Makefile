#-------------------------------------------------------------------------------
# Copyright 2012 Patrick Mueller
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#	  http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#-------------------------------------------------------------------------------

.PHONY: build test vendor

build:
	@echo copying web files
	
	@chmod -R +w web
	@rm -rf web
	
	@mkdir web
	@cp -R web-src/* web
	
	@mkdir web/scripts
	@cp node_modules/socket.io/node_modules/socket.io-client/dist/socket.io.js web/scripts
	
	@chmod -R -w web

test: build
#	@echo

vendor:
	@npm install
	@rm -rf vendor
	@mkdir vendor
	curl --output vendor/jquery.js --progress-bar http://code.jquery.com/jquery-1.7.1.js


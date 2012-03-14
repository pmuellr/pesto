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
	@echo building web directory
	
	@chmod -R +w web
	@rm -rf web
	
	@mkdir web
	@cp -R web-src/* web
	@rm -rf          web/modules
	
	@mkdir web/scripts
	
	@rm -rf tmp
	@mkdir tmp
	
	@cp -R web-src/modules/*        tmp
	@cp lib/prettyStackTrace.coffee tmp/pesto
	
	@cp node_modules/backbone/backbone.js     tmp
	@cp node_modules/underscore/underscore.js tmp
	
	@echo "   running browserify"
	@node_modules/.bin/browserify tmp/index.coffee \
	    --outfile web/scripts/modules.js \
	    --debug --verbose
	
	@cp    vendor/coffee-script.js                                                web/scripts
	@cp    vendor/jquery.js                                                       web/scripts
	@cp -R vendor/bootstrap                                                       web/bootstrap
	@cp node_modules/socket.io/node_modules/socket.io-client/dist/socket.io.js    web/scripts
	
	@chmod -R -w web
	
	@touch tmp/build-done.txt

test: build
#	@echo

vendor:
	@npm install
	@rm -rf vendor
	@mkdir vendor
	curl --output vendor/jquery.js        --progress-bar http://code.jquery.com/jquery-1.7.1.js
	curl --output vendor/coffee-script.js --progress-bar https://raw.github.com/jashkenas/coffee-script/1.2.0/extras/coffee-script.js
	curl --output vendor/bootstrap.zip    --progress-bar http://twitter.github.com/bootstrap/assets/bootstrap.zip
	
	mkdir vendor/bootstrap
	unzip vendor/bootstrap.zip  -d vendor
	rm    vendor/bootstrap.zip
    

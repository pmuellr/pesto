#-------------------------------------------------------------------------------
# Copyright 2012 Patrick Mueller
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

.PHONY: build test vendor

SOCKET_IO_DIR = node_modules/socket.io/node_modules/socket.io-client/dist

build:
	@echo building web directory
	
	@chmod -R +w web
	@rm -rf web
	
	@mkdir web
	@cp -R vendor/WebInspector/front-end/*    web
	@cp    vendor/WebInspector/Inspector.json web

	@mkdir web/pesto
	@cp -R web-src/* web/pesto
	@rm -rf          web/pesto/modules
	@rm -rf          web/pesto/templates
	@rm -rf          web/pesto/images/*.acorn
	
	@mv     web/pesto/client/*.js web
	@rm -rf web/pesto/client
	
	@node_modules/.bin/coffee tools/create-index-html.coffee \
	   vendor/WebInspector/front-end/inspector.html \
	   web-src/client/index-additions.html \
	   > web/index.html
	
	@mkdir web/pesto/scripts

	@rm -rf tmp
	@mkdir tmp

    # pre-compile just to get syntax errors
	@node_modules/.bin/coffee -c -o tmp \
	    web-src/modules/*.coffee web-src/modules/pesto/*.coffee

	@rm -rf tmp
	@mkdir tmp

	@cp -R web-src/modules/*        tmp
	
	@node_modules/.bin/coffee tools/template-bundler.coffee \
	    web-src/templates > tmp/pesto/templates.js
	
	@cp node_modules/backbone/backbone.js     tmp
	@cp node_modules/underscore/underscore.js tmp
	
	@echo "   running browserify"
	@node_modules/.bin/browserify tmp/index.coffee \
	    --outfile web/pesto/scripts/modules.js \
	    --debug --verbose
	
	@cp    vendor/mustache.js            web/pesto/scripts
#	@cp    vendor/coffee-script.js       web/pesto/scripts
	@cp    vendor/jquery.js              web/pesto/scripts
#	@cp -R vendor/bootstrap              web/bootstrap
#	@cp -R vendor/CodeMirror2            web/CodeMirror2
	@cp $(SOCKET_IO_DIR)/socket.io.js    web/pesto/scripts
	
	@chmod -R -w web
	
	@touch tmp/build-done.txt

test: build
#	@echo

vendor:
	@npm install
	@rm -rf vendor
	@mkdir vendor
	curl --output vendor/jquery.js        --progress-bar http://code.jquery.com/jquery-1.7.1.min.js
#	curl --output vendor/coffee-script.js --progress-bar https://raw.github.com/jashkenas/coffee-script/1.2.0/extras/coffee-script.js
	curl --output vendor/mustache.js      --progress-bar https://raw.github.com/janl/mustache.js/0.4.2/mustache.js
#	curl --output vendor/bootstrap.zip    --progress-bar http://twitter.github.com/bootstrap/assets/bootstrap.zip

#	mkdir    vendor/bootstrap
#	unzip -q vendor/bootstrap.zip  -d vendor
#	rm       vendor/bootstrap.zip
    
#	mkdir vendor/CodeMirror2
#	curl --output vendor/CodeMirror2/codemirror.css --progress-bar https://raw.github.com/marijnh/CodeMirror2/master/lib/codemirror.css
#	curl --output vendor/CodeMirror2/codemirror.js  --progress-bar https://raw.github.com/marijnh/CodeMirror2/master/lib/codemirror.js
#	curl --output vendor/CodeMirror2/javascript.js  --progress-bar https://raw.github.com/marijnh/CodeMirror2/master/mode/javascript/javascript.js
	
	svn --non-interactive --trust-server-cert export -r 111354 https://svn.webkit.org/repository/webkit/trunk/Source/WebCore/inspector vendor/WebInspector
	rm vendor/WebInspector/*.cpp
	rm vendor/WebInspector/*.h

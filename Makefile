# Licensed under the Tumbolia Public License. See footer for details.

.PHONY: build test vendor

SOCKET_IO_DIR = node_modules/socket.io/node_modules/socket.io-client/dist

#-------------------------------------------------------------------------------
build: web tmp
	@echo building web directory
	
	# erase the ./web directory
	@-chmod -R +w web
	@-rm -rf web/*
	
	# copy in Web Inspector files
	@cp -R vendor/WebInspector/front-end/*    web
	@cp    vendor/WebInspector/Inspector.json web

	# copy in pesto files
	@node_modules/.bin/coffee tools/ij2html.coffee  web/Inspector.json > web/Inspector-API.html
	@node_modules/.bin/coffee tools/ij2stubs.coffee web/Inspector.json > web/Inspector-stubs.coffee.txt
	@mkdir web/pesto
	@cp -R web-src/* web/pesto
	
	# modules / templates added later
	@rm -rf          web/pesto/modules
	@rm -rf          web/pesto/templates
	@rm -rf          web/pesto/images/*.acorn
	
    # move custom Web Inspector files over	
	@mv     web/pesto/client/*.js web
	@rm -rf web/pesto/client
	
    # create a new index.html file
	@node_modules/.bin/coffee tools/create-index-html.coffee \
	   vendor/WebInspector/front-end/inspector.html \
	   web-src/client/index-additions.html \
	   > web/index.html
	
	# create place for new pesto scripts
	@mkdir web/pesto/scripts

    # pre-compile just to get syntax errors, browserify doesn't
	@-rm -rf tmp/*
	@node_modules/.bin/coffee -c -o tmp \
	    web-src/modules/*.coffee web-src/modules/*.coffee

    # copy our pesto modules over for browserify
	@-rm -rf tmp/*
	@mkdir tmp/pesto

	@cp -R web-src/modules/*        tmp/pesto
	@echo "require('./pesto')" >      tmp/index.js
	
#	@node_modules/.bin/coffee tools/template-bundler.coffee \
#	    web-src/templates > tmp/pesto/templates.js
#	
#	@cp node_modules/backbone/backbone.js     tmp
	@cp node_modules/underscore/underscore.js tmp
	
    # run browserify
	@echo "   running browserify"
	@node_modules/.bin/browserify tmp/index.js \
	    --outfile web/pesto/scripts/modules.js \
	    --debug --verbose
	
#	@cp    vendor/mustache.js            web/pesto/scripts
#	@cp    vendor/coffee-script.js       web/pesto/scripts
	@cp    vendor/jquery.js              web/pesto/scripts
#	@cp -R vendor/bootstrap              web/bootstrap
#	@cp -R vendor/CodeMirror2            web/CodeMirror2
	@cp $(SOCKET_IO_DIR)/socket.io.js    web/pesto/scripts
	
	@chmod -R -w web
	
	@touch tmp/build-done.txt

#-------------------------------------------------------------------------------
web:
	mkdir web
    
#-------------------------------------------------------------------------------
tmp:
	mkdir tmp
    
#-------------------------------------------------------------------------------
test: build
#	@echo

#-------------------------------------------------------------------------------
#WEBKIT_VERSION = 111354
#WEBKIT_VERSION = 120350
WEBKIT_VERSION = 120456

#-------------------------------------------------------------------------------
vendor:
	@npm install
	@rm -rf vendor
	@mkdir vendor
	curl --output vendor/jquery.js        --progress-bar http://code.jquery.com/jquery-1.7.1.min.js
#	curl --output vendor/coffee-script.js --progress-bar https://raw.github.com/jashkenas/coffee-script/1.2.0/extras/coffee-script.js
#	curl --output vendor/mustache.js      --progress-bar https://raw.github.com/janl/mustache.js/0.4.2/mustache.js
#	curl --output vendor/bootstrap.zip    --progress-bar http://twitter.github.com/bootstrap/assets/bootstrap.zip

#	mkdir    vendor/bootstrap
#	unzip -q vendor/bootstrap.zip  -d vendor
#	rm       vendor/bootstrap.zip
    
#	mkdir vendor/CodeMirror2
#	curl --output vendor/CodeMirror2/codemirror.css --progress-bar https://raw.github.com/marijnh/CodeMirror2/master/lib/codemirror.css
#	curl --output vendor/CodeMirror2/codemirror.js  --progress-bar https://raw.github.com/marijnh/CodeMirror2/master/lib/codemirror.js
#	curl --output vendor/CodeMirror2/javascript.js  --progress-bar https://raw.github.com/marijnh/CodeMirror2/master/mode/javascript/javascript.js
	
	svn --non-interactive --trust-server-cert export -r $(WEBKIT_VERSION) https://svn.webkit.org/repository/webkit/trunk/Source/WebCore/inspector vendor/WebInspector
	rm vendor/WebInspector/*.cpp
	rm vendor/WebInspector/*.h

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

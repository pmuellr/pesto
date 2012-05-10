# Licensed under the Tumbolia Public License. See footer for details.

.PHONY: build test vendor

#-------------------------------------------------------------------------------
all: build

#-------------------------------------------------------------------------------
clean:

	# erase the ./web directory
	@chmod -R +w web
	@rm -rf web
	
	@rm -rf tmp

#-------------------------------------------------------------------------------
build:
	@echo building web directory
	
	# erase the ./web directory
	@-chmod -R +w web
	@rm -rf web
	
	# create the ./web directory
	@mkdir web
	
	# copy in pesto files
	@cp -R web-src/* web
	
	# modules / templates added later
	@rm -rf  web/modules
	@rm -rf  web/templates
	@rm -rf  web/images/*.acorn
	
    # pre-compile just to get syntax errors, browserify doesn't
	@rm -rf tmp
	@mkdir tmp

	@node_modules/.bin/coffee -c -o tmp \
	    web-src/modules/*.coffee web-src/modules/*.coffee

    # copy our pesto modules over for browserify
	@rm -rf tmp
	@mkdir tmp
	@mkdir tmp/pesto

	@cp -R web-src/modules/*         tmp/pesto
	@echo "require('./pesto')" >     tmp/index.js
	
    # create our templates module
	@node_modules/.bin/coffee tools/template-bundler.coffee \
	    web-src/templates > tmp/pesto/templates.js
	
    # copy over 3rd party modules
	@cp node_modules/backbone/backbone.js     tmp
	@cp node_modules/underscore/underscore.js tmp
	
    # run browserify
	@echo "   running browserify"
	@node_modules/.bin/browserify tmp/index.js \
	    --outfile web/modules.js \
	    --debug --verbose
	
	@mkdir web/vendor
	@mkdir web/vendor/bootstrap
	@mkdir web/vendor/codemirror
	@mkdir web/vendor/jquery-ui
	
	@cp    vendor/mustache.js            web/vendor
	@cp    vendor/coffee-script.js       web/vendor
	@cp    vendor/jquery.js              web/vendor
	@cp -R vendor/jquery-ui/*            web/vendor/jquery-ui
	@cp -R vendor/bootstrap/*            web/vendor/bootstrap
	@cp -R vendor/codemirror/*           web/vendor/codemirror
	@cp $(SOCKET_IO_DIR)/socket.io.js    web/vendor
	
	@chmod -R -w web
	
	@touch tmp/build-done.txt

#-------------------------------------------------------------------------------
test: build
	@echo TBD

#-------------------------------------------------------------------------------
vendor:
	@echo Downloading third party goop

    # installing npm modules

	@npm install

    # installing stuff for the browser
	
	@rm -rf vendor
	@mkdir vendor
	
    # installing jquery, coffee-script, mustache

	@curl --output vendor/jquery.js        --progress-bar http://code.jquery.com/jquery-$(VERSION_JQUERY).min.js
	@curl --output vendor/coffee-script.js --progress-bar https://raw.github.com/jashkenas/coffee-script/$(VERSION_COFFEESCRIPT)/extras/coffee-script.js
	@curl --output vendor/mustache.js      --progress-bar https://raw.github.com/janl/mustache.js/$(VERSION_MUSTACHE)/mustache.js
	
    # installing bootstrap

	@rm -rf tmp
	@mkdir  tmp

	@curl --output tmp/bootstrap.zip    --progress-bar http://twitter.github.com/bootstrap/assets/bootstrap.zip

	@mkdir    vendor/bootstrap
	@unzip -q tmp/bootstrap.zip  -d vendor
    
    # installing codemirror

	@mkdir vendor/codemirror
	@curl --output vendor/codeMirror/codemirror.css --progress-bar https://raw.github.com/marijnh/CodeMirror2/$(VERSION_CODEMIRROR)/lib/codemirror.css
	@curl --output vendor/codeMirror/codemirror.js  --progress-bar https://raw.github.com/marijnh/CodeMirror2/$(VERSION_CODEMIRROR)/lib/codemirror.js
	@curl --output vendor/codeMirror/javascript.js  --progress-bar https://raw.github.com/marijnh/CodeMirror2/$(VERSION_CODEMIRROR)/mode/javascript/javascript.js

    # installing jquery ui

	@rm -rf tmp
	@mkdir  tmp

	@mkdir vendor/jquery-ui
	@mkdir vendor/jquery-ui/themes
	@mkdir vendor/jquery-ui/themes/images
	
	@curl --progress --out tmp/jquery-ui.zip http://jqueryui.com/download/jquery-ui-$(VERSION_JQUERY_UI).custom.zip
	@unzip -q tmp/jquery-ui.zip -d tmp
	@cp tmp/development-bundle/ui/jquery-ui-$(VERSION_JQUERY_UI).custom.js   vendor/jquery-ui/jquery-ui.js
	@cp tmp/development-bundle/themes/base/images/*                          vendor/jquery-ui/themes/images
	@cp tmp/development-bundle/themes/smoothness/jquery-ui-1.8.20.custom.css vendor/jquery-ui/themes/smoothness.css
	

#-------------------------------------------------------------------------------

SOCKET_IO_DIR = node_modules/socket.io/node_modules/socket.io-client/dist

VERSION_JQUERY        = 1.7.1
VERSION_JQUERY_UI     = 1.8.20
VERSION_COFFEESCRIPT  = 1.3.1
VERSION_MUSTACHE      = 0.4.2
VERSION_CODEMIRROR    = v2.24

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

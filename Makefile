# Licensed under the Apache License. See footer for details.

.PHONY: build test vendor


VERSION_JQUERY    = 2.0.0
VERSION_JQUERY_UI = 1.10.3
VERSION_D3        = v3.1.5
VERSION_RIVETS    = v0.5.0

SOCKET_IO_DIR = node_modules/socket.io/node_modules/socket.io-browser

BROWSERIFY       = @node_modules/.bin/browserify
COFFEE           = @node_modules/.bin/coffee
COFFEEC          = $(COFFEE) --compile
TEMPLATE_BUNDLER = $(COFFEE) tools/template-bundler.coffee
SPLIT_SOURCEMAP  = $(COFFEE) tools/split-sourcemap.coffee


#-------------------------------------------------------------------------------
help:
	@echo "targets:"
	@echo "   build  - build it"
	@echo "   run    - run it"
	@echo "   watch  - watch for source change, build it, run it"
	@echo "   vendor - get 3rd party files"

#-------------------------------------------------------------------------------
watch:
	@node_modules/.bin/node-supervisor \
		--extensions 	"coffee|js|css|html|png" \
		--watch 	 	"bin,lib,tools,web-src" \
		--exec       	"make" \
		--no-restart-on error \
		-- build-n-serve

#-------------------------------------------------------------------------------
build-n-serve: build serve

#-------------------------------------------------------------------------------
serve:
	@echo ""
	@echo "--------------------------------------------------------------------"
	@echo "running serve"
	@echo "--------------------------------------------------------------------"

	@# use --debug-brk to stop at load time
	node bin/pesto.js --verbose --scan 5858-5860

#-------------------------------------------------------------------------------
build:
	@echo ""
	@echo "--------------------------------------------------------------------"
	@echo "running build"
	@echo "--------------------------------------------------------------------"
	
# 	clean the web directory
	@-chmod -R +w web
	@-rm    -rf   web
	@-mkdir       web
	
# 	pre-compile just to get syntax errors, browserify doesn't
	@-rm -rf tmp
	@-mkdir  tmp

# 	copy our base files
	@mkdir -p web/css
	@mkdir -p web/images
	@mkdir -p web/scripts
	@mkdir -p web/vendor

	@cp web-src/*.html   web
	@cp web-src/css/*    web/css
	@cp web-src/images/* web/images

	@cp -R vendor/*      web/vendor



#   compile CoffeeScript
	@mkdir -p tmp/pesto/common tmp/pesto/browser 
	@echo "   compiling CoffeeScript"
	@$(COFFEEC) --output tmp               lib/server/*.coffee
	@$(COFFEEC) --output tmp/pesto/common  lib/common/*.coffee
	@$(COFFEEC) --output tmp/pesto/browser lib/browser/*.coffee

# 	create our templates module
	@$(TEMPLATE_BUNDLER) web-src/templates > tmp/pesto/browser/templates.js
	
#   run browserify
	@echo "   running browserify"
	@$(BROWSERIFY) tmp/pesto/browser/pesto.js \
	    --outfile web/scripts/modules.js \
	    --debug --verbose

	@$(SPLIT_SOURCEMAP)	web/scripts/modules.js
	
	@chmod -R -w web
	
	@touch tmp/build-done.txt


#-------------------------------------------------------------------------------
vendor: vendor-dl

#-------------------------------------------------------------------------------
vendor-npm:
	@-chmod -R +w node_modules/* 
	@rm -rf       node_modules
	@npm install
	@chmod -R -w  node_modules/* 

#-------------------------------------------------------------------------------
vendor-dl: vendor-dl-init vendor-dl-jquery vendor-dl-d3 vendor-dl-rivets vendor-dl-bootstrap
	@chmod -R -w  vendor/* 

#-------------------------------------------------------------------------------
vendor-dl-init:
	@-chmod -R +w vendor/* 
	@rm -rf       vendor
	@mkdir        vendor

#-------------------------------------------------------------------------------
vendor-dl-jquery:
	@curl --progress --out vendor/jquery.js http://code.jquery.com/jquery-$(VERSION_JQUERY).js
	
#-------------------------------------------------------------------------------
vendor-dl-jquery-ui:

	@rm -rf tmp
	@mkdir  tmp

	@mkdir -p vendor/jquery-ui/images
	
	@curl --progress --out tmp/jquery-ui.zip http://jqueryui.com/resources/download/jquery-ui-$(VERSION_JQUERY_UI).zip
	@unzip -q tmp/jquery-ui.zip -d tmp
	cp tmp/jquery-ui-$(VERSION_JQUERY_UI)/ui/jquery-ui.js           vendor/jquery-ui/jquery-ui.js
	cp tmp/jquery-ui-$(VERSION_JQUERY_UI)/themes/base/jquery-ui.css vendor/jquery-ui/jquery-ui.css
	cp tmp/jquery-ui-$(VERSION_JQUERY_UI)/themes/base/images/*      vendor/jquery-ui/images

#-------------------------------------------------------------------------------
vendor-dl-d3:
	@curl --progress-bar -o vendor/d3.js     https://raw.github.com/mbostock/d3/$(VERSION_D3)/d3.js

#-------------------------------------------------------------------------------
vendor-dl-rivets:
	@curl --progress-bar -o vendor/rivets.js https://raw.github.com/mikeric/rivets/$(VERSION_RIVETS)/dist/rivets.js

#-------------------------------------------------------------------------------
vendor-dl-bootstrap:
	@mkdir -p               vendor/bootstrap
	@rm   -rf               vendor/bootstrap/*
	@curl --progress-bar -o vendor/bootstrap/bootstrap.zip http://twitter.github.io/bootstrap/assets/bootstrap.zip
	@unzip -q               vendor/bootstrap/bootstrap.zip -d vendor/bootstrap
	@mv                     vendor/bootstrap/bootstrap/*      vendor/bootstrap
	@rm                     vendor/bootstrap/bootstrap.zip
	@rm -rf                 vendor/bootstrap/bootstrap
	@rm                     vendor/bootstrap/css/*.min.css
	@rm                     vendor/bootstrap/js/*.min.js

#-------------------------------------------------------------------------------
icons:
	@echo converting icons with ImageMagick

	@convert -resize 057x057 web-src/images/icon-1024.png      web-src/images/icon-057.png
	@convert -resize 072x072 web-src/images/icon-1024.png      web-src/images/icon-072.png
	@convert -resize 114x114 web-src/images/icon-1024.png      web-src/images/icon-114.png
	@convert -resize 144x144 web-src/images/icon-1024.png      web-src/images/icon-144.png
	@convert -resize 032x032 web-src/images/icon-1024.png      web-src/images/icon-032.png
	@convert -resize 064x064 web-src/images/icon-1024.png      web-src/images/icon-064.png
	@convert -resize 096x096 web-src/images/icon-1024.png      web-src/images/icon-096.png
	@convert -resize 128x128 web-src/images/icon-1024.png      web-src/images/icon-128.png
	@convert -resize 512x512 web-src/images/icon-1024.png      web-src/images/icon-512.png

	@convert -resize 512x210 web-src/images/icon-1024x420.png  web-src/images/icon-512x210.png
	@convert -resize 256x105 web-src/images/icon-1024x420.png  web-src/images/icon-256x105.png

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

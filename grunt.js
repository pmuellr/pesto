// Licensed under the Tumbolia Public License. See footer for details.

// open "http://search.npmjs.org/#/grunt" ; sudo npm -g install grunt

var child_process = require("child_process")

//------------------------------------------------------------------------------
// list of source files to watch
//------------------------------------------------------------------------------
var sourceFiles = [
    "grunt.js",
    "lib/**/*.coffee", 
    "Makefile",
    "tools/**/*.coffee",
    "web-src/**/*.coffee",
    "web-src/**/*.html",
    "web-src/**/*.css"
]

//------------------------------------------------------------------------------
var gruntConfig = {
    watch: {
        make: {
            files: sourceFiles,
            tasks: ["make"]
        }
    }
}

//------------------------------------------------------------------------------
// run "jake"
//------------------------------------------------------------------------------
function makeTask(task, grunt) {
    var done = task.async()
    var make = child_process.spawn('make')
    
    make.stdout.on("data", function(data) {
        grunt.log.write("" + data)
    })
    
    make.stderr.on("data", function(data) {
        grunt.log.error("" + data)
    })
    
    make.on("exit", function(code) {
        if (code === 0) return done(true)
        
        grunt.log.writeln("error running make", code)
        return done(false)
    })
}

//------------------------------------------------------------------------------
module.exports = function(grunt) {
    grunt.initConfig(gruntConfig)
    
    grunt.registerTask("default", "watch")
    grunt.registerTask("make", "run make", function(){makeTask(this, grunt)}
    )
}

//-------------------------------------------------------------------------------
// Copyright (c) 2012 Patrick Mueller
// 
// Tumbolia Public License
// 
// Copying and distribution of this file, with or without modification, are
// permitted in any medium without royalty provided the copyright notice and this
// notice are preserved.
// 
// TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
// 
//   0. opan saurce LOL
//-------------------------------------------------------------------------------
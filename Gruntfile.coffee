module.exports = (grunt)->

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    coffee:
      compile:
        files:
          "build/<%= pkg.name %>.js": js_files.map (e)-> "lib/js/#{e}.coffee"
          "build/.spec/<%= pkg.name %>Spec.js": spec_files.map (e)-> "spec/#{e}.coffee"

      ###glob_to_multiple:
        expand: true
        cwd: 'spec'
        src: ['*.coffee']
        dest: 'build/.spec'
        ext: '.js' ###

    stylus:
      compile:
        files:
          "build/<%= pkg.name %>.css": "lib/css/jumly.styl"

    uglify:
      options:
        banner: """/* <%= pkg.name %>-<%= pkg.version %> <%=grunt.template.today('yyyy-mm-dd')%> */\n"""
        mangle: false  ## if true, jumly.min.js is corrupted
      build:
        src: 'build/<%= pkg.name %>.js'
        dest: 'build/<%= pkg.name %>.min.js'

    cssmin:
      compress:
        files:
          'build/<%= pkg.name %>.min.css': [ "build/<%= pkg.name %>.css" ]

    "jasmine-node":
      run:
        spec: 'spec',
      options:
        coffee: true,
      env:
        NODE_PATH: "lib/js"

    watch:
      coffee:
        files: ['spec/*.coffee']
        tasks: ['coffee:compile', 'jasmine:pivotal']

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-contrib-jasmine-node'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'default', ['build']
  grunt.registerTask 'minify', ['uglify', 'cssmin']
  grunt.registerTask 'compile', ['coffee', 'stylus']
  grunt.registerTask 'build', ['compile', 'minify']
  grunt.registerTask 'spec', ['jasmine-node']
  grunt.registerTask 'release:prepare', "", ->
    grunt.task.requires ["build"]
    fs = require "fs"
    exec = require("child_process").exec
    version = (fs.readFileSync("lib/version").toString()).split("\n")[0]
    dir = "views/static/release/#{version}"
    fs.mkdirSync dir unless fs.existsSync dir
    done = @async()
    exec "cp build/jumly.min.js build/jumly.min.css #{dir}; git add #{dir}", (err,stdout,stderr)->
      process.stdout.write stdout if stdout
      process.stderr.write stderr if stderr
      process.stderr.write err if err
      done(true)

js_files = [
  "core", "jquery.g2d", "jquery.ext", "icon"
  "HTMLElement"
  "Diagram", "DiagramBuilder", "DiagramLayout"
  "HTMLElementLayout", "NoteElement", "Position", "Relationship",
  "SequenceLifeline", "SequenceMessage", "SequenceInteraction", "SequenceOccurrence", "SequenceParticipant"
  "SequenceDiagram", "SequenceDiagramBuilder", "SequenceDiagramLayout", "SequenceFragment", "SequenceRef", "UsecaseDiagram",
  #"Class", "ClassDiagram", "ClassDiagramBuilder"
]

spec_files = [
  "jasmine-utils"
  "coreSpec"
  "DiagramSpec"
  "HTMLElementSpec"
  "SequenceDiagramBuilderSpec", "SequenceDiagramLayoutSpec", "SequenceDiagramSpec"
  #"ClassDiagramSpec"
]

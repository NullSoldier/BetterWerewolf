'use strict'

LIVERELOAD_PORT=31337
lrsnippet = require('connect-livereload')
  port: LIVERELOAD_PORT

module.exports = (grunt) ->
  require('load-grunt-tasks') grunt

  grunt.initConfig
    watch:
      options:
        spawn: false

      coffee:
        files: 'public/{**/,}*.coffee'
        tasks: 'coffee'

      gruntfile:
        files: 'Gruntfile.coffee'

      livereload:
        options:
          livereload: LIVERELOAD_PORT

        files: [
          'public/{**/,}*.html'
          'public/{**/,}*.js'
          'compiled/{**/,}*.js'
        ]

    coffee:
      scripts:
        expand: true
        cwd: 'public'
        src: ['*.coffee', '**/*.coffee']
        dest: 'compiled'
        ext: '.js'

    bgShell:
      server:
        cmd: 'npm start'
        bg: true
        fail: true

    connect:
      options:
        port: 3001

      proxies: [{
        context: '/'
        host: '127.0.0.1'
        port: 3000
      }]

      livereload:
        options:
          middleware: (connect) ->
            return [
              lrsnippet
              require('grunt-connect-proxy/lib/utils').proxyRequest
            ]

  grunt.registerTask 'server', [
    'coffee',
    'configureProxies',
    'connect:livereload',
    'watch'
  ]

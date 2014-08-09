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

      gruntfile:
        files: 'Gruntfile.coffee'

      livereload:
        options:
          livereload: LIVERELOAD_PORT

        files: [
          'public/{**/,}*.html'
          'public/{**/,}*.css'
          'public/{**/,}*.less'
          'public/{**/,}*.js'
          'public/{**/,}*.coffee'
        ]

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
    'configureProxies',
    'connect:livereload',
    'watch'
  ]

if process.env.NODE_ENV is 'production'
  # require 'newrelic'
  1

debug = require('debug') 'BetterWerewolf'
app = require './app'

app.set 'port', process.env.PORT or 3000

server = app.listen app.get('port'), ->
  debug "Express server listening on port #{ server.address().port }"

io = require('socket.io').listen server

if process.env.REDISCLOUD_URL
  redis = require 'socket.io-redis'
  pubClient = require('redis-url').connect process.env.REDISCLOUD_URL
  subClient = require('redis-url').connect process.env.REDISCLOUD_URL
  io.adapter redis(pubClient: pubClient, subClient: subClient)

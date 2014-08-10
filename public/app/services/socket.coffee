angular.module('WolvesApp')
  .service 'Socket', ->
    console.log 'socket init called'
    return socket.io()

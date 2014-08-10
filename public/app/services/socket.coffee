angular.module('WolvesApp').service 'Socket', ($log) ->
  $log.info 'socket init called'
  return socket.io()

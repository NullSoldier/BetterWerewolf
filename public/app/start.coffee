socket = io()

console.log 'socket', socket
socket.on 'connect', ->
  console.log 'connected'

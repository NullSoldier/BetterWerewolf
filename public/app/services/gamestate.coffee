angular.module('WolvesApp').service 'GameState', ($log) ->
  socket = io()
  state = {}

  socket.on 'game', (game) ->
    state.roles = game.roles
    state.duration = game.duration
    console.log game
    return

  socket.on 'players', (players) ->
    state.players = players
    console.log players
    return

  state.join = (player) ->
    socket.emit 'join', player
    return

  $log.info 'gamestate service'
  return state


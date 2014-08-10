angular.module('WolvesApp').service 'GameState', ($log) ->
  socket = io()
  state = {}

  socket.on 'game', (game) ->
    state.roles = game.roles
    state.duration = game.duration
    return

  socket.on 'players', (players) ->
    state.players = players
    return

  $log.info 'gamestate service'
  return state


angular.module('WolvesApp').service 'GameState', ($log, Socket) ->

  state = {}

  Socket.on 'game', (game) ->
    state.roles = game.roles
    state.duration = game.duration
    return

  Socket.on 'players', (players) ->
    state.players = players
    return

  $log.info 'gamestate service'
  return state


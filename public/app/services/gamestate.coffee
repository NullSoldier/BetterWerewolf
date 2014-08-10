angular.module('WolvesApp').service 'GameState', ($log, $timeout) ->
  socket = io()
  state = {}

  socket.on 'game', (game) -> $timeout ->
    state.roles = game.roles
    state.duration = game.durationSeconds
    return

  socket.on 'players', (players) -> $timeout ->
    state.players = players
    return

  state.join = (player) ->
    socket.emit 'join', player
    return

  state.updateDuration = (seconds) ->
    socket.emit 'updateDuration', seconds
    return

  state.updateRole = (role, quantity) ->
    socket.emit 'updateRole',
      role: role
      quantity: quantity
    return

  $log.info 'gamestate service'
  return state


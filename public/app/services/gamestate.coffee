angular.module('WolvesApp').service 'GameState', ($timeout) ->
  socket = io()

  socket.on 'disconnect', ->
    document.write 'Realoading ...'
    setTimeout ->
      document.location.reload()
    , 1000

  state =
    state: 'loading'
    durationSeconds: null
    roles: {}
    players: {}

  socket.on 'game', (game) -> $timeout ->
    state.state = game.state
    state.roles = game.roles
    state.duration = game.durationSeconds
    return

  socket.on 'players', (players) -> $timeout ->
    state.players = players
    return

  socket.on 'gameNightStart', ({players, unclaimed}) -> $timeout ->
    state.state = 'night'
    state.players = players
    state.unclaimed = unclaimed
    return

  socket.on 'gameDayStart', ({players, unclaimed}) -> $timeout ->
    state.state = 'day'
    state.players = players
    state.unclaimed = unclaimed
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

  state.swap = (from, to) ->
    socket.emit 'nightAction', swap: [from, to]
    return

  state.startGame = ->
    socket.emit 'startGame'
    return

  return state

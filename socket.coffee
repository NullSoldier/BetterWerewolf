io          = require('socket.io')()
_           = require 'lodash'
app         = require './app'

createNewGameState = ->
  app.gameState = {
    state: 'lobby'
    durationSeconds: 600
    dayEnd: null
    votingEnd: null
    voteDurationSeconds: 5
    nightEnd: null
    players: {}
    unclaimed: []
    actions: []
    nightResponseCount: 0
    roles: {
      werewolf    : 1
      minion      : 0
      villager    : 1
      seer        : 1
      robber      : 1
      troublemaker: 1
      tanner      : 0
    }
  }
  return

setState = (state) ->
  app.gameState.state = state
  return

addPlayer = (player) ->
  if player.id of app.gameState.players
    return

  app.gameState.players[player.id] = player
  return

removePlayer = (id) ->
  delete app.gameState.players[id]
  return

assignRoles = ->
  # build list of roles
  roles = []
  for role, quantity of app.gameState.roles
    for i in [0...quantity]
      roles.push role

  shuffled = _.shuffle roles

  for id, player of app.gameState.players
    player.startRole = shuffled.pop()
    player.currentRole = player.startRole

    console.log "Assigned #{ player.name } to #{ player.startRole }"

  while shuffled.length > 0
    app.gameState.unclaimed.push shuffled.pop()
  return

updateRole = (role, quantity, callback) ->
  app.gameState.roles[role] = quantity
  return

updateDuration = (seconds) ->
  app.gameState.durationSeconds = seconds

sendGameState = (to) ->
  state = _.clone app.gameState
  delete state.players
  to.emit 'game', state
  return

sendPlayerState = (to) ->
  to.emit 'players', app.gameState.players
  return

resolveActions = ->
  actionOrder = [
    'robber'
    'troublemaker'
  ]

  sortedActions = _.sortBy app.gameState.actions, (a) -> actionOrder.indexOf a.type

  for action in sortedActions
    from = app.gameState.players[action.from]
    to   = app.gameState.players[action.to]

    console.log "#{ from.name } swapped their #{ from.currentRole } for #{ to.name }'s #{ to.currentRole }"

    # swap roles
    toCurrent = to.currentRole
    to.currentRole = from.currentRole
    from.currentRole = to.toCurrent
  return

startVoting = ->
  setState 'voting'
  app.gameState.votingEnd = Date.now() + (app.gameState.voteDurationSeconds * 1000)

  io.emit 'gameVoting',
    votingEnd: app.gameState.votingEnd

  setTimeout startGameEnded, app.gameState.voteDurationSeconds * 1000
  return

startGameEnded = ->
  setState 'ended'
  io.emit 'gameEnded',
    players  : app.gameState.players
    unclaimed: app.gameState.unclaimed
  return

io.on 'connection', (socket) ->

  socket.on 'startGame', ->
    console.log 'Night starting'

    setState 'night'
    assignRoles()
    io.emit 'gameNightStart',
      players  : app.gameState.players
      unclaimed: app.gameState.unclaimed
    return

  socket.on 'disconnect', ->
    if io.sockets.sockets.length is 0
      # last person disconnected, reset the game data.
      createNewGameState()
      return

    if socket.playerId and app.gameState.state is 'lobby'
      console.log "Player #{ socket.playerId } is leaving"
      removePlayer socket.playerId
      sendPlayerState io
    return

  socket.on 'updateRole', ({role, quantity}) ->
    console.log "Updating #{ role } to #{ quantity }"
    updateRole role, quantity
    sendGameState io
    return

  socket.on 'updateDuration', (seconds) ->
    console.log "Updating duration to #{seconds} seconds"
    updateDuration Number seconds
    sendGameState io
    return

  socket.on 'join', (player) ->
    if not app.gameState
      console.log 'Creating initial game state'
      createNewGameState()

    if app.gameState.state isnt 'lobby' and not (player.id of app.gameState.players)
      socket.emit 'showError', 'Game in progress. please come back later. :)'
      socket.disconnect()
      return

    console.log "Player #{ player.id } joined as #{ player.name }"

    player.socketId = socket.id
    socket.playerId = player.id
    addPlayer player

    sendGameState socket
    sendPlayerState io
    return

  socket.on 'nightAction', ({swap}) ->
    player = app.gameState.players[socket.playerId]

    if player.hasDoneAction
      return

    player.hasDoneAction = true

    console.log "#{ player.name } took a night action as a #{ player.startRole }
     ( #{app.gameState.nightResponseCount + 1 } / #{ _.keys(app.gameState.players).length } )"

    canUseAction = player.startRole is 'robber' or player.startRole is 'troublemaker'

    if canUseAction
      # queue up player action
      app.gameState.actions.push
        type: player.startRole
        from: swap[0]
        to  : swap[1]

    app.gameState.nightResponseCount += 1

    # once all players have gone, start day round
    if app.gameState.nightResponseCount is _.keys(app.gameState.players).length
      resolveActions()
      setState 'day'
      app.gameState.dayEnd = Date.now() + (app.gameState.durationSeconds * 1000)

      console.log 'Day starting'
      io.emit 'gameDayStart',
        dayEnd   : app.gameState.dayEnd
        players  : app.gameState.players
        unclaimed: app.gameState.unclaimed

      setTimeout startVoting, app.gameState.durationSeconds * 1000
    return


module.exports = io

io          = require('socket.io')()
persistence = require './persistence'
_           = require 'lodash'

createInitialGameState = ->
  return {
    state: 'lobby'
    durationSeconds: 600
    dayEnd: null
    nightEnd: null
    players: {}
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

createGameState = ->
  persistence.set 'gameState', createInitialGameState()
  return

addPlayer = (player, callback) ->
  persistence.get 'gameState', (err, gameState) ->
    gameState.players[player.id] = player
    persistence.set 'gameState', gameState
    callback null, gameState.players
    return

removePlayer = (id, callback) ->
  persistence.get 'gameState', (err, gameState) ->
    delete gameState.players[id]
    persistence.set 'gameState', gameState, callback
    return

assignRoles = ->
  persistence.get 'gameState', (err, gameState) ->
    roles    = _.keys gameState.roles
    shuffled = _.shuffle roles

    for player in gameState.players
      player.startRole = shuffled.pop()
      player.currentRole = player.startRole

    persistence.set 'gameState', gameState
    return

updateRole = (role, quantity, callback) ->
  persistence.get 'gameState', (err, gameState) ->
    gameState.roles[role] = quantity
    persistence.set 'gameState', gameState, callback
  return

sendGameState = (to) ->
  persistence.get 'gameState', (err, gameState) ->
    to.emit 'game',
      roles          : gameState.roles
      durationSeconds: gameState.durationSeconds
    return
  return

sendPlayerState = (to) ->
  persistence.get 'gameState', (err, gameState) ->
    to.emit 'players', gameState.players
    return
  return

io.on 'connection', (socket) ->

  socket.on 'startGame', ->
    console.log 'Game Started'
    return

  socket.on 'disconnect', ->
    console.log "Player #{ socket.playerId } is leaving"
    removePlayer socket.playerId, -> sendPlayerState io
    return

  socket.on 'updateRole', ({role, quantity}) ->
    console.log "Updating #{ role } to #{ quantity }"
    updateRole role, quantity, -> sendGameState io
    return

  socket.on 'join', (player) ->
    console.log "Player #{ player.id } joined as #{ player.name }"

    persistence.get 'gameState', (err, gameState) ->
      if not gameState
        gameState = createInitialGameState()
        persistence.set 'gameState', gameState

      player.socketId = socket.id
      socket.playerId = player.id
      addPlayer player,  -> sendPlayerState io

      sendGameState io
      return
    return

module.exports = io

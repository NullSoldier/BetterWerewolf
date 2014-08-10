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

addPlayer = (id, callback) ->
  persistence.get 'gameState', (err, gameState) ->
    gameState.players[id] = null
    persistence.set 'gameState', gameState
    callback null, gameState.players
    return

removePlayer = (id) ->
  persistence.get 'gameState', (err, gameState) ->
    delete gameState.players[id]
    persistence.set 'gameState', gameState
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

updateRoleQuantity = (role, quantity, callback) ->
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

  socket.on 'updateRoleQuantity', ({row, quantity}) ->
    console.log "Updating #{ role } to #{ quantity }"
    updateRoleQuantity role, quantity, sendGameState
    return

  socket.on 'join', (player) ->
    console.log "Player joined for #{ player.id }"

    persistence.get 'gameState', (err, gameState) ->
      if not gameState
        gameState = createInitialGameState()
        persistence.set 'gameState', gameState

      addPlayer player.id, -> sendPlayerState io

      sendGameState io
      return
    return

module.exports = io

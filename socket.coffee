io          = require('socket.io')()
persistence = require('./persistence')
_           = require('lodash')

createInitialGameState = ->
  return {
    gameState: {
      state: 'waiting'
      nightDurationSeconds: '600'
      nightEndDate: null
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
  }

createGameState = ->
  persistence.set 'gameState', createInitialGameState()
  return

addPlayer = (id, callback) ->
  persistence.get 'gameState', (err, gameState) ->
    gameState.players.id = null
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

io.on 'connection', (socket) ->
  socket.join('bw')

  socket.on 'updateRoleQuantity', (role, quantity) ->
    console.log "Updating #{ role } to #{ quantity }"
    return

  socket.on 'startGame', ->
    console.log 'Game Started'
    return

  socket.on 'join', (player) ->
    addPlayer player.id, (err, players) ->
      socket.emit 'players', players
      return
    return

module.exports = io

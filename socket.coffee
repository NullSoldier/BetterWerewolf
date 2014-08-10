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

addPlayer = (id) ->
  persistence.get 'gameState', (gameState) ->
    gameState.players.id = null
    persistence.set 'gameState', gameState
    return

removePlayer = (id) ->
  persistence.get 'gameState', (gameState) ->
    delete gameState.players[id]
    persistence.set 'gameState', gameState
    return

assignRoles = () ->
  persistence.get 'gameState', (gameState) ->
    roles    = _.keys gameState.roles
    shuffled = _.shuffle roles

    for player in gameState.players
      player.startRole = shuffled.pop()
      player.currentRole = player.startRole

    persistence.set 'gameState', gameState
    return

io.on 'connection', (socket) ->
  socket.join('bw')

  socket.on 'playerInfo', (id, name) ->
    console.log "Player Info for #{ id } (#{ name })"
    return

  socket.on 'updateRoleQuantity', (role, quantity) ->
    console.log "Updating #{ role } to #{ quantity }"
    return

  socket.on 'startGame', ->
    console.log 'Game Started'
    return

module.exports = io

angular.module('WolvesApp').directive 'gameNight', ->
  templateUrl: '/app/views/gamenight.html'

  controller: ($scope, GameState) ->
    currentRole = GameState.players[$scope.player.id].startRole

  link: ->

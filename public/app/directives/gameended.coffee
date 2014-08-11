angular.module('WolvesApp').directive 'gameEnded', ->
  templateUrl: '/app/views/gameended.html'

  controller: ($scope, GameState) ->
    $scope.players = GameState.players

  link: ->

angular.module('WolvesApp').directive 'gameNight', ->
  templateUrl: '/app/views/gamenight.html'

  controller: ($scope, GameState) ->

  link: ->

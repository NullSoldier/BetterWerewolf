
angular.module('WolvesApp').directive 'gameState', ->
  controller: ($scope, GameState) ->
    console.log 'state controller'

  link: (scope, element, attrs) ->
    console.log 'state link', element


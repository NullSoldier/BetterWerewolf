angular.module('WolvesApp').directive 'gameWaiting', (GameState) ->
  templateUrl: '/app/views/gamewaiting.html'

  link: (scope, element, attr) ->
    scope.showResults = ->
      GameState.showResults()
      return

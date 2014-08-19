angular.module('WolvesApp').directive 'gameEnded', ->
  templateUrl: '/app/views/gameended.html'

  controller: ($scope) ->
    window.navigator.vibrate [1000]

    $scope.joinGame = ->
      document.location.reload()
      return

    return

  link: ->

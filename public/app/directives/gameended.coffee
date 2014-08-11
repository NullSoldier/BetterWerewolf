angular.module('WolvesApp').directive 'gameEnded', ->
  templateUrl: '/app/views/gameended.html'

  controller: ->
    window.navigator.vibrate [1000]
    return

  link: ->

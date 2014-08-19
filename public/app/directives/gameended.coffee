angular.module('WolvesApp').directive 'gameEnded', ->
  templateUrl: '/app/views/gameended.html'

  controller: ($scope, GameState) ->

    niceActions = []
    for action in GameState.actions
      niceActions.push
        who : GameState.players[action.who]
        type: action.type
        from: GameState.players[action.from]
        to  : GameState.players[action.to]

    $scope.actions = niceActions

    window.navigator.vibrate [1000]

    $scope.joinGame = ->
      document.location.reload()
      return

    return

  link: ->

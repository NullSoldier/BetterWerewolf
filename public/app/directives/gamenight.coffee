angular.module('WolvesApp').directive 'gameNight', ->
  templateUrl: '/app/views/gamenight.html'

  controller: ($scope, GameState) ->
    $scope.others = _.filter GameState.players, (p) ->
      p.id != $scope.player.id

    $scope.werewolves = _.chain $scope.others
      .filter (p) -> p.role == 'werewolves'
      .keys()
      .values()

    $scope.stealPlayer = ([player]) ->
      console.log 'stelaing', player.name

    $scope.swapPlayers = ([player1, player2]) ->
      console.log 'swapping', player1.name, player2.name

  link: ->

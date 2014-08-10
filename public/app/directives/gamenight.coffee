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
      robbed = _.find GameState.players, (p) -> p.id == player.id

      alert "Stole #{robbed.startRole} from #{robbed.name}"

      GameState.swap $scope.player.id, player.id
      $scope.player.hasDoneAction = true

    $scope.swapPlayers = ([player1, player2]) ->
      GameState.swap player1.id, player2.id
      $scope.player.hasDoneAction = true

    $scope.markDone = ->
      GameState.nightAction()
      $scope.player.hasDoneAction = true

  link: ->

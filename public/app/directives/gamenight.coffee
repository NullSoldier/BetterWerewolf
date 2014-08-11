angular.module('WolvesApp').directive 'gameNight', ->
  templateUrl: '/app/views/gamenight.html'

  controller: ($scope, GameState) ->
    $scope.others = _.filter GameState.players, (p) ->
      return p.id != $scope.player.id

    $scope.werewolves = _.filter $scope.others, (p) ->
      return p.startRole == 'werewolf'

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

    $scope.lookAt = (player) ->
      if player is 'middle'
        $scope.actionResult = """
          Two middle cards are:
          1. #{GameState.unclaimed[0]}
          2. #{GameState.unclaimed[1]}
        """
      else
        $scope.actionResult = "#{player.name} is a #{player.startRole}"

      alert $scope.actionResult
      $scope.markDone()

  link: ->

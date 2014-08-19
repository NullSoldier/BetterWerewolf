angular.module('WolvesApp').directive 'gameLobby', ->
  templateUrl: '/app/views/gamelobby.html'

  controller: ($scope, GameState) ->
    maxes =
      werewolf: 2
      villager: 3

    setTimerValues = (currentSeconds) ->
      $scope.timerValues = []
      for minutes in [1..10]
        $scope.timerValues.push
          value: minutes * 60
          display: "#{minutes} Minutes"
          selected: currentSeconds == (minutes * 60)

    setRoles = (gameRoles) ->
      if not gameRoles
        return

      $scope.roleCount = 0
      $scope.roles = []

      for name, num of gameRoles
        $scope.roleCount += num
        $scope.roles.push
          name: name
          max:  maxes[name] or 1
          num: num

    $scope.addRole = (role) ->
      GameState.updateRole role.name, (role.num+1)

    $scope.removeRole = (role) ->
      GameState.updateRole role.name, (role.num-1)

    $scope.$watch 'currentGame.roles', setRoles, true
    $scope.$watch 'currentGame.durationSeconds', setTimerValues

    $scope.$watch 'timerSelect', (value) ->
      if value
        GameState.updateDuration value

    $scope.timerSelect = $scope.currentGame.durationSeconds


    $scope.start = ->
      GameState.startGame()
      return

    $scope.canStart = ->
      playerCount   = _.keys($scope.currentGame.players).length
      requiredCount = $scope.roleCount - 3
      return playerCount == requiredCount

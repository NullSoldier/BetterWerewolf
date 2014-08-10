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
        index = 0
        selected = Array(maxes[name] or 1)
        for value in selected
          if num <= index
            break
          selected[index] = true
          index++

        $scope.roleCount += num
        $scope.roles.push
          name: name
          max:  maxes[name] or 1
          num: num
          selected: selected

    $scope.$watch 'currentGame.roles', setRoles, true
    $scope.$watch 'currentGame.duration', setTimerValues

    $scope.$watch 'timerSelect', (value) ->
      if value
        GameState.updateDuration value

    $scope.toggleRole = (role, index) ->
      role.selected[index] = not role.selected[index]
      role.num = _.filter(role.selected).length

      GameState.updateRole role.name, role.num

    $scope.start = ->
      GameState.startGame()
      return

    $scope.canStart = ->
      playerCount    = _.keys($scope.currentGame.players).length
      minPlayerCount = $scope.roleCount - 3
      return playerCount >= minPlayerCount

  link: (scope, element, attrs) ->


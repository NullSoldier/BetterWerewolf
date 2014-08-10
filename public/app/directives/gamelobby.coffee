angular.module('WolvesApp').directive 'gameLobby', ->
  templateUrl: '/app/views/gamelobby.html'

  controller: ($scope, GameState) ->
    maxes =
      werewolf: 2
      villager: 3

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
        $scope.roles.push {
          name: name
          max:  maxes[name] or 1
          num: num
          selected: selected
        }

    $scope.$watch 'currentGame.roles', setRoles, true

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


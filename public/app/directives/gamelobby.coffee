angular.module('WolvesApp').directive 'gameLobby', ->
  templateUrl: '/app/views/gamelobby.html'

  controller: ($scope, GameState) ->
    maxes =
      werewolf: 2
      villager: 3

    setRoles = (gameRoles) ->
      if not gameRoles
        return

      $scope.roles = []
      for name, num of $scope.currentGame.roles
        index = 0
        selected = Array(maxes[name] or 1)
        for value in selected
          if num <= index
            break
          selected[index] = true
          index++

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

  link: (scope, element, attrs) ->


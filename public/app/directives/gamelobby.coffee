angular.module('WolvesApp').directive 'gameLobby', ->
  templateUrl: '/app/views/gamelobby.html'

  controller: ($scope, GameState) ->

    $scope.roles = [
      { name: 'robber' }
      { name: 'seer' }
      { name: 'werewolf', max: 2 }
      { name: 'troublemaker' }
      { name: 'tanner' }
      { name: 'villager', max: 3 }
    ]

    for role in $scope.roles
      role.max = role.max or 1
      role.num = 0
      role.selected = Array(role.max)

    $scope.toggleRole = (role, index) ->
      role.selected[index] = not role.selected[index]
      role.num = _.filter(role.selected).length

    $scope.start = ->
      console.log 'clicked start'

  link: (scope, element, attrs) ->


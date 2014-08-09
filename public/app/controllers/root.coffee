angular.module('WolvesApp').controller 'RootController', ($scope, localStorageService) ->
  $scope.player = localStorageService.get 'player'
  $scope.player ?= {}

  until $scope.player.id and $scope.player.name
    id = UUID()
    name = prompt 'Please enter a player name'

    if name
      $scope.player =
        id  : id
        name: name

      localStorageService.set 'player', $scope.player

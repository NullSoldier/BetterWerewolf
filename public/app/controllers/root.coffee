angular.module('WolvesApp')
  .controller 'RootController', ($scope, localStorageService) ->

    $scope.playerName = localStorageService.get('player name')

    until $scope.playerName
      $scope.playerName = prompt('Please enter a player name')

      if $scope.playerName
        localStorageService.set('player name', $scope.playerName)


angular.module('WolvesApp').controller 'RootController',
  ($scope, localStorageService, GameState) ->
    $scope.player = localStorageService.get 'player'

    until $scope.player?.id and $scope.player?.name
      id = UUID()
      name = prompt 'Please enter a player name'

      if name
        $scope.player =
          id  : id
          name: name

        localStorageService.set 'player', $scope.player

    GameState.join $scope.player
    $scope.currentGame = GameState

    # keep $scope.player in sync with $scope.currentGame.players
    $scope.$watch 'currentGame.players', (players) ->
      if players and $scope.player.id of players
        $scope.player = players[$scope.player.id]

    $scope.rename = ->
      localStorageService.set 'player', id: $scope.player.id
      document.location.reload()

    return

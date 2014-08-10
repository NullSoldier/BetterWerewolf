angular.module('WolvesApp').directive 'selectPlayers', ->
  templateUrl: '/app/views/selectplayers.html'

  scope:
    # count
    # actionText
    source: '&'
    done: '='

  link: (scope, element, attrs) ->
    scope.actionText = attrs.actiontext
    scope.count = Number attrs.count

    scope.players = []

    source = scope.source()

    for player in source
      scope.players.push
        name: player.name
        id: player.id,
        selected: false

    selected = []
    watcher = (players) ->
      selected = _.filter players, 'selected'
      scope.actionDisabled = selected.length != scope.count

    scope.$watch 'players', watcher, true

    scope.actionDisabled = true

    scope.actionClick = ->
      scope.done(selected)


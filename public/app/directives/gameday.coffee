angular.module('WolvesApp').directive 'gameDay', ->
  template: '''
    <timer end-time="currentGame.dayEnd">
      {{minutes}} minutes, {{seconds}} seconds
    </timer>
  '''
  controller: ($scope) ->

  link: ->

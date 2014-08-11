angular.module('WolvesApp').directive 'gameVoting', ->
  template: '''Time to vote... <timer end-time="currentGame.votingEnd">{{seconds}} seconds</timer>'''
  controller: ($scope) ->
    window.navigator.vibrate [250, 750, 250, 750, 250, 750, 250, 750, 250]
    return

  link: ->

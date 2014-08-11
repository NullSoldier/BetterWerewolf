angular.module('WolvesApp').directive 'gameVoting', ->
  template: '''VOTING ROUND... <timer end-time="currentGame.votingEnd">{{minutes}} minutes, {{seconds}} seconds</timer>'''
  controller: ($scope) ->
    console.log 'Voting!', $scope.currentGame

  link: ->

module = angular.module('WolvesApp', ['LocalStorageModule'])

module.config (localStorageServiceProvider) ->
  localStorageServiceProvider.setPrefix('better-werewolves')

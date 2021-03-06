app = angular.module('WolvesApp', ['LocalStorageModule', 'timer'])

app.config (localStorageServiceProvider) ->
  localStorageServiceProvider.setPrefix('better-werewolves')
  return

navigator.vibrate = navigator.vibrate || navigator.webkitVibrate || navigator.mozVibrate || navigator.msVibrate;

app.run ($window) ->
  $window.UUID = ->
    gen = (s) ->
      p = (Math.random().toString(16)+'000000000').substr 2, 8
      if s then '-' + p.substr(0, 4) + '-' + p.substr(4, 4) else p
    return gen() + gen(true) + gen(true) + gen()
  return

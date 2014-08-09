cluster = require 'cluster'

if cluster.isMaster
  workerCount = require('os').cpus().length
  while workerCount--
    cluster.fork()

  cluster.on 'exit', (deadWorker) ->
    worker = cluster.fork()
    console.log "Worker #{ deadWorker.process.pid } replaced by #{ worker.process.pid }"
    return

else
  console.log "Starting worker #{ process.pid }"
  require './server'

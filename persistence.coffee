class LocalPersistence

  constructor: ->
    @storage = {}
    return

  set: (key, value, callback) ->
    @storage[key] = JSON.stringify value
    callback? null, true
    return

  get: (key, callback) ->
    if key of @storage
      value = JSON.parse @storage[key]
    else
      value = undefined
    callback null, value
    return

class RedisPersistence

  constructor: ->
    @client = require('redis-url').connect process.env.REDISTOGO_URL
    return

  set: (key, value, callback) ->
    @client.set key, JSON.stringify(value), callback
    return

  get: (key, callback) ->
    @client.get key, (err, value) ->
      if value
        value = JSON.parse value
      callback err, value
      return
    return


if process.env.REDISTOGO_URL
  client = new RedisPersistence
else
  client = new LocalPersistence

module.exports = client

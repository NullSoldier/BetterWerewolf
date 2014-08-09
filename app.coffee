bodyParser   = require 'body-parser'
compression  = require 'compression'
cookieParser = require 'cookie-parser'
express      = require 'express'
favicon      = require 'static-favicon'
logger       = require 'morgan'
path         = require 'path'
routes       = require './routes/index'
users        = require './routes/users'

app = express()

# view engine setup
app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'

app.use favicon()
app.use logger('dev')
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: true)
app.use cookieParser()
app.use compression()
app.use express.static(path.join(__dirname, 'public'))

# set the routes
app.use '/', routes
app.use '/users', users

# catch 404 and forward to error handler
app.use (req, res, next) ->
  err = new Error 'Not Found'
  err.status = 404
  next err
  return

# error handler
app.use (err, req, res, next) ->
  res.status err.status or 500
  if app.get('env') is 'development'
    # give stack trace
    error = err
  else
    # omit stack trace
    error = {}

  res.render 'error',
    message: err.message
    error: error
  return

module.exports = app

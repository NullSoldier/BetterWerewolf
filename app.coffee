bodyParser   = require 'body-parser'
coffee       = require 'coffee-middleware'
compression  = require 'compression'
cookieParser = require 'cookie-parser'
express      = require 'express'
less         = require 'express-less'
logger       = require 'morgan'
path         = require 'path'
swig         = require 'swig'

app = express()

# view engine setup
app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'html'
app.engine 'html', swig.renderFile
swig.setDefaults cache: false

app.use logger('dev')
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: true)
app.use cookieParser()
app.use compression()

# compile coffeescript files on the fly
app.use coffee(src: "#{ __dirname }/public")

# compile less files on the fly
app.use less("#{ __dirname }/public")

app.use express.static "#{ __dirname }/public"

# set the routes
app.use '/', require('./routes/index')

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

makePromise = require "make-promise"
module.exports = faithful = {}
    
faithful.log = (promise) ->
  promise
    .then (value) -> 
      console.log value
    .then null, (err) -> 
      console.error err

faithful.dir = (promise) ->
  promise
    .then (value) ->
      console.log value
    .then null, (err) -> 
      console.error err

faithful.return = faithful.fulfill = (value) ->
  makePromise (cb) -> cb null, value

faithful.throw = faithful.fail = faithful.reject = (error) ->
  makePromise (cb) -> cb error, null, true

faithful.ensurePromise = (value) ->
  return value if faithful.isPromise value
  return faithful.return value
  
faithful.isPromise = (value) ->
  value and typeof value.then is "function"

faithful.forceTimeout = (time, promise) ->
  makePromise (cb) ->
    timerId = delay time, -> cb new Error "Timeout after #{time} ms."
    promise
      .then (result) ->
        clearTimeout timerId
        cb null, result
      .then null, (err) ->
        clearTimeout timerId
        cb err

delay = (time, fn) -> setTimeout fn, time
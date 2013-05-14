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

faithful.throw = faithful.fail = (error) ->
  makePromise (cb) -> cb error, null, true

faithful.ensurePromise = (value) ->
  return value if faithful.isPromise value
  return faithful.return value
  
faithful.isPromise = (value) ->
  value and typeof value.then is "function"
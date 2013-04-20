makePromise = require "./makePromise"
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
  makePromise (resolve) -> resolve value

faithful.throw = faithful.fail = (error) ->
  makePromise (resolve, reject) -> reject error

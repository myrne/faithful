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

faithful.return = (value) -> # returns a promise which resolves to value
  makePromise (resolve) -> resolve value

faithful.throw = (error) -> # returns a promise which rejects with error
  makePromise (resolve, reject) -> reject error

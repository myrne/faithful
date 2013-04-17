RSVP = require "rsvp"

module.exports = makePromise = (func) ->
  promise = new RSVP.Promise
  resolve = (value) -> promise.resolve value
  reject = (error) -> promise.reject error
  func resolve, reject
  promise
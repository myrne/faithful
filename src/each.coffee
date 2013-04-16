RSVP = require "rsvp"

module.exports = each = (values, iterator, options = {}) ->
  bigPromise = new RSVP.Promise
  unless values.length
    bigPromise.resolve []
    return bigPromise
  try
    promises = (iterator value for value in values)
  catch error
    bigPromise.reject error
    return bigPromise
  stopped = false
  numRemaining = promises.length
  resolver = (index) ->
    return (value) ->
      return if stopped
      try
        options.handleResult? value, index
      catch error
        stopped = true
        return bigPromise.reject error
      numRemaining--
      if numRemaining is 0 or options.stopEarly?()
        stopped = true
        bigPromise.resolve options.getFinalValue?()
  for promise, i in promises
    try
      promise.then resolver(i), (error) -> bigPromise.reject error
    catch error # there is no then method
      bigPromise.reject error
      stopped = true
      return bigPromise
  bigPromise
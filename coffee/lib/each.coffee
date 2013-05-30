makePromise = require "make-promise"
throttle = require "f-throttle"

module.exports = each = (values, iterator, options = {}) ->
  makePromise (cb) ->
    return cb null, options.getFinalValue?() unless values.length
    options.concurrency ?= 1024
    throttledIterator = throttle options.concurrency, iterator
    return cb null, options.getFinalValue?() unless values.length
    try promises = (throttledIterator value for value in values)
    catch error then return cb error
    stopped = false
    numRemaining = promises.length
    resolver = (index) ->
      return (value) ->
        return if stopped
        try options.handleResult? value, index
        catch error
          stopped = true
          return cb error
        numRemaining--
        if numRemaining is 0 or options.stopEarly?()
          stopped = true
          cb null, options.getFinalValue?()
    for promise, i in promises
      try promise.then resolver(i), (error) -> cb error
      catch error # there is no then method
        cb error
        stopped = true
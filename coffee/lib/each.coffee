makePromise = require "make-promise"
throttle = require "f-throttle"

module.exports = each = (values, iterator, {concurrency,handleResult,stopEarly,getFinalValue} = {}) ->
  makePromise (cb) ->
    return cb null, getFinalValue?() unless values.length
    concurrency ?= 1024
    throttledIterator = throttle concurrency, iterator
    return cb null, getFinalValue?() unless values.length
    try promises = (throttledIterator value for value in values)
    catch error then return cb error
    stopped = false
    numRemaining = promises.length
    resolver = (index) ->
      return (value) ->
        return if stopped
        try handleResult? value, index
        catch error
          stopped = true
          return cb error
        numRemaining--
        if numRemaining is 0 or stopEarly?()
          stopped = true
          cb null, getFinalValue?()
    for promise, i in promises
      try promise.then resolver(i), (error) -> cb error
      catch error # there is no then method
        cb error
        stopped = true
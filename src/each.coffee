makePromise = require "make-promise"

module.exports = each = (values, iterator, options = {}) ->
  makePromise (resolve, reject) ->
    return resolve options.getFinalValue?() unless values.length
    try
      promises = (iterator value for value in values)
    catch error
      return reject error
    stopped = false
    numRemaining = promises.length
    resolver = (index) ->
      return (value) ->
        return if stopped
        try
          options.handleResult? value, index
        catch error
          stopped = true
          return reject error
        numRemaining--
        if numRemaining is 0 or options.stopEarly?()
          stopped = true
          resolve options.getFinalValue?()
    for promise, i in promises
      try
        promise.then resolver(i), (error) -> reject error
      catch error # there is no then method
        reject error
        stopped = true
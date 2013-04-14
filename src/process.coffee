RSVP = require "rsvp"

module.exports = process = (values, options) ->
  i = 0
  promise = new RSVP.Promise
  iterate = ->
    if i >= values.length
      promise.resolve options.getFinalOutput?()
    else
      try 
        localPromise = options.callNext i
      catch err
        return promise.reject err
      try
        localPromise
          .then (output) ->
            options.handleOutput? output
            iterate()
          .then null, (err) -> promise.reject err
      catch error
        promise.reject error
      i++
  iterate()
  promise  
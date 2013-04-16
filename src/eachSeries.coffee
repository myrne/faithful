RSVP = require "rsvp"

module.exports = process = (values, iterator, options ={}) ->
  i = 0
  promise = new RSVP.Promise
  iterate = ->
    if (i >= values.length) or options.stopEarly?()
      promise.resolve options.getFinalValue?()
    else
      try 
        localPromise = iterator values[i]
      catch err
        return promise.reject err
      try
        localPromise
          .then (result) ->
            options.handleResult? result
            iterate()
          .then null, (err) -> promise.reject err
      catch error
        promise.reject error
      i++
  iterate()
  promise
  
  # Algorithm from
  # http://blog.jcoglan.com/2013/03/30/ ...
  # callbacks-are-imperative-promises-are-funcional-nodes-biggest-missed-opportunity/
  # iterator = (currentPromise, value) -> currentPromise.then -> iterator value
  # return values.reduce iterator, faithful.return() # I don't understand this code yet
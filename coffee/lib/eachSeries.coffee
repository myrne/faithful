makePromise = require "make-promise"

module.exports = process = (values, iterator, options ={}) ->
  i = 0
  makePromise (cb) ->
    resolver = (i) ->
      (result) -> 
        options.handleResult? result, i
        iterate()
    iterate = ->
      if (i >= values.length) or options.stopEarly?()
        cb null, options.getFinalValue?()
      else
        try promise = iterator values[i]
        catch err then return cb err
        try promise.then(resolver(i)).then null, (err) -> cb err
        catch error then cb error
        i++
    iterate()
  
  # Algorithm from
  # http://blog.jcoglan.com/2013/03/30/ ...
  # callbacks-are-imperative-promises-are-funcional-nodes-biggest-missed-opportunity/
  # iterator = (currentPromise, value) -> currentPromise.then -> iterator value
  # return values.reduce iterator, faithful.return() # I don't understand this code yet
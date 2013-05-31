makePromise = require "make-promise"

module.exports = eachSeries = (values, iterator, options ={}) ->
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
makePromise = require "./makePromise"

module.exports = process = (values, iterator, options ={}) ->
  i = 0
  makePromise (resolve, reject) ->
    resolver = (i) ->
      (result) -> 
        options.handleResult? result, i
        iterate()
    iterate = ->
      if (i >= values.length) or options.stopEarly?()
        resolve options.getFinalValue?()
      else
        try 
          localPromise = iterator values[i]
        catch err
          return reject err
        try
          localPromise
            .then(resolver(i))
            .then null, (err) -> reject err
        catch error
          reject error
        i++
    iterate()
  
  # Algorithm from
  # http://blog.jcoglan.com/2013/03/30/ ...
  # callbacks-are-imperative-promises-are-funcional-nodes-biggest-missed-opportunity/
  # iterator = (currentPromise, value) -> currentPromise.then -> iterator value
  # return values.reduce iterator, faithful.return() # I don't understand this code yet
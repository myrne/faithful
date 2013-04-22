makePromise = require "make-promise"

module.exports = adapt = (fn, receiver) ->
  (args...) ->
    makePromise (resolve, reject) ->
      args.push (args...) ->
        return reject error if error = args.shift()
        return resolve.apply null, args
      fn.apply receiver, args
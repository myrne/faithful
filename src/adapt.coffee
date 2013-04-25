makePromise = require "make-promise"

module.exports = adapt = (fn, receiver) ->
  (args...) ->
    makePromise (resolve, reject) ->
      args.push (err, result) ->
        return reject err if err
        return resolve result
      fn.apply receiver, args
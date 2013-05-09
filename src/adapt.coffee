makePromise = require "make-promise"

module.exports = adapt = (fn, receiver) ->
  (args...) ->
    makePromise (cb) ->
      args.push cb
      fn.apply receiver, args
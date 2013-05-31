{isPromise} = require "./utilities"
makePromise = require "make-promise"

module.exports = collect = (inputs) ->
  return inputs if isPromise inputs
  return makePromise (cb) ->
    switch getTypeOf inputs
      when "object" then outputs = {}
      when "array" then outputs = new Array inputs.length
      else return cb new Error "You can only collect arrays or objects."
    promises = []
    indexes = []
    for key, value of inputs
      if isPromise value
        promises.push value
        indexes.push key
      else
        outputs[key] = value
    return cb null, outputs unless promises.length > 0
    numRemaining = promises.length
    resolver = (i) ->
      (result) -> 
        outputs[indexes[i]] = result
        numRemaining--
        cb null, outputs unless numRemaining > 0
    for promise, i in promises
      try promise.then resolver(i), (err) -> cb err
      catch err then return cb err

getTypeOf = do ->
  classToType = {}
  for name in "Boolean Number String Function Array Date RegExp Undefined Null".split(" ")
    classToType["[object " + name + "]"] = name.toLowerCase()
  (obj) ->
    strType = Object::toString.call(obj)
    classToType[strType] or "object"
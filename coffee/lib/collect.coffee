{fulfill,fail,ensurePromise,isPromise} = require "./utilities"
each = require "./each"

module.exports = collect = (value) ->
  switch getTypeOf value
    when "object"
      return value if typeof value.then is "function"
      return collectProperties value
    when "array"
      return collectValues value
    else
      return fail new Error "You can only collect arrays or objects."
      
collectValues = (array) ->
  results = []
  each array, ensurePromise,
    handleResult: (value, i) -> results[i] = value
    getFinalValue: -> results

collectProperties = (object) ->
  promisesIndex = {}
  newProperties = {}
  for name, value of object
    if isPromise value
      promisesIndex[name] = value
    else
      newProperties[name] = value
  promises = (value for name, value of promisesIndex)
  promiseNames = Object.keys promisesIndex
  each promises, ((p) -> p),
    handleResult: (value, i) -> newProperties[promiseNames[i]] = value
    getFinalValue: -> newProperties

getTypeOf = do ->
  classToType = {}
  for name in "Boolean Number String Function Array Date RegExp Undefined Null".split(" ")
    classToType["[object " + name + "]"] = name.toLowerCase()
  (obj) ->
    strType = Object::toString.call(obj)
    classToType[strType] or "object"
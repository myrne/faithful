{fulfill,fail,ensurePromise} = require "./utilities"
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
  names = Object.keys object
  values = (value for name, value of object)
  newProperties = {}
  each values, ensurePromise,
    handleResult: (value, i) -> newProperties[names[i]] = value
    getFinalValue: -> newProperties

getTypeOf = do ->
  classToType = {}
  for name in "Boolean Number String Function Array Date RegExp Undefined Null".split(" ")
    classToType["[object " + name + "]"] = name.toLowerCase()
  (obj) ->
    strType = Object::toString.call(obj)
    classToType[strType] or "object"
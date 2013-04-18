faithful =
  each: require "./each"
  return: require("./utilities").return
  throw: require("./utilities").throw

module.exports = collect = (value) ->
  switch getTypeOf value
    when "object"
      return value if typeof value.then is "function"
      return collectProperties value
    when "array"
      return collectValues value
    else
      return faithful.throw new Error "You can only collect arrays or objects."
      
collectValues = (array) ->
  results = []
  faithful.each array, ensurePromise,
    handleResult: (value, i) -> results[i] = value
    getFinalValue: -> results

collectProperties = (object) ->
  names = Object.keys object
  values = (value for name, value of object)
  newProperties = {}
  faithful.each values, ensurePromise,
    handleResult: (value, i) -> newProperties[names[i]] = value
    getFinalValue: -> newProperties

ensurePromise = (value) ->
  return value if value and typeof value.then is "function"
  return faithful.return value

getTypeOf = do ->
  classToType = {}
  for name in "Boolean Number String Function Array Date RegExp Undefined Null".split(" ")
    classToType["[object " + name + "]"] = name.toLowerCase()
  (obj) ->
    strType = Object::toString.call(obj)
    classToType[strType] or "object"
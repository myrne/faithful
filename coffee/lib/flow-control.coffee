{map,mapSeries,mapLimit} = require('./collections')

module.exports =
  series: (functions) ->
    doBatch mapSeries, functions

  parallel: (functions) ->
    doBatch map, functions
  
  parallelLimit: (functions, concurrency) ->
    makeMapFn = (concurrency) ->
      (functions, iterator) -> mapLimit functions, concurrency, iterator
    doBatch makeMapFn(concurrency), functions
  
  applyToEach: (functions, args...) ->
    map functions, (fn) -> fn.apply {}, args

  applyToEachSeries: (functions, args...) ->
    mapSeries functions, (fn) -> fn.apply {}, args

doBatch = (map, functions) ->
  if Array.isArray functions then doBatchArray map, functions else doBatchObject map, functions

doBatchArray = (map, functions) ->
  map functions, (fn) -> fn()

doBatchObject = (map, obj) ->
  keys = Object.keys obj
  functions = (value for key, value of obj)
  map(functions, (fn) -> fn()).then (results) ->
    outputs = {}
    outputs[keys[i]] = result for result, i in results
    outputs
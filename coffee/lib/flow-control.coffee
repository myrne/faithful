{map,mapSeries,mapLimit} = require('./collections')

module.exports =
  series: (functions) ->
    mapSeries functions, (fn) -> fn()

  parallel: (functions) ->
    map functions, (fn) -> fn()
  
  parallelLimit: (functions, concurrency) ->
    mapLimit functions, concurrency, (fn) -> fn()
  
  applyToEach: (functions, args...) ->
    map functions, (fn) -> fn.apply {}, args

  applyToEachSeries: (functions, args...) ->
    mapSeries functions, (fn) -> fn.apply {}, args
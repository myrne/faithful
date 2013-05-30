makePromise = require "make-promise"
each = require "./each"
eachSeries = require "./eachSeries"
eachLimit = require "./eachLimit"

module.exports = faithful =
  map: (values, iterator) ->
    results = []
    each values, iterator,
      handleResult: (value, i) -> results[i] = value
      getFinalValue: -> results

  mapSeries: (inputs, iterator) ->
    results = []
    eachSeries inputs, iterator,
      handleResult: (result) -> results.push result
      getFinalValue: -> results

  mapLimit: (inputs, concurrency, iterator) ->
    results = []
    eachLimit inputs, concurrency, iterator,
      handleResult: (result) -> results.push result
      getFinalValue: -> results

  reduce: (values, reduction, iterator) ->
    eachSeries values, ((value) -> iterator reduction, value),
      handleResult: (result) -> reduction = result
      getFinalValue: -> reduction

  detectSeries: (values, iterator) ->
    found = false
    foundValue = undefined
    eachSeries values, iterator,
      handleResult: (result, i) -> 
        return unless result
        foundValue = values[i]
        found = true
      getFinalValue: -> foundValue
      stopEarly: -> found
    
  detect: (values, iterator) ->
    found = false
    foundValue = undefined
    each values, iterator,
      handleResult: (result, i) -> 
        return unless result
        foundValue = values[i]
        found = true 
      getFinalValue: -> foundValue
      stopEarly: -> found
    
  filter: (values, iterator) ->
    matchingValues = []
    each values, iterator,
      handleResult: (result, i) -> 
        matchingValues.push values[i] if result
      getFinalValue: -> matchingValues
    
  filterSeries: (values, iterator) ->
    matchingValues = []
    eachSeries values, iterator,
      handleResult: (result, i) -> 
        matchingValues.push values[i] if result
      getFinalValue: -> matchingValues

  applyEach: (pairs, iterator) ->
    faithful.map pairs, (pair) -> iterator.apply {}, pair

  applyEachSeries: (pairs, iterator) ->
    faithful.mapSeries pairs, (pair) -> iterator.apply {}, pair
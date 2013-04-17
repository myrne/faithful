module.exports = faithful = {}
faithful.eachSeries = require "./eachSeries"
faithful.each = require "./each"
faithful.makePromise = require "./makePromise"

faithful.map = (values, iterator) ->
  results = []
  faithful.each values, iterator,
    handleResult: (value, i) -> results[i] = value
    getFinalValue: -> results

faithful.mapSeries = (inputs, iterator) ->
  results = []
  faithful.eachSeries inputs, iterator,
    handleResult: (result) -> results.push result
    getFinalValue: -> results
  
faithful.return = (value) -> # returns a promise which resolves to value
  faithful.makePromise (resolve) -> resolve value

faithful.throw = (error) -> # returns a promise which rejects with error
  faithful.makePromise (resolve, reject) -> reject value

faithful.reduce = (values, reduction, iterator) ->
  faithful.eachSeries values, ((value) -> iterator reduction, value),
    handleResult: (result) -> reduction = result
    getFinalValue: -> reduction

faithful.detectSeries = (values, iterator) ->
  found = false
  foundValue = undefined
  faithful.eachSeries values, iterator,
    handleResult: (result, i) -> 
      return unless result
      foundValue = values[i]
      found = true
    getFinalValue: -> foundValue
    stopEarly: -> found
    
faithful.detect = (values, iterator) ->
  found = false
  foundValue = undefined
  faithful.each values, iterator,
    handleResult: (result, i) -> 
      return unless result
      foundValue = values[i]
      found = true 
    getFinalValue: -> foundValue
    stopEarly: -> found
    
faithful.filter = (values, iterator) ->
  matchingValues = []
  faithful.each values, iterator,
    handleResult: (result, i) -> 
      return unless result
      matchingValues.push values[i]
    getFinalValue: -> matchingValues
    
faithful.filterSeries = (values, iterator) ->
  matchingValues = []
  faithful.eachSeries values, iterator,
    handleResult: (result, i) -> 
      return unless result
      matchingValues.push values[i]
    getFinalValue: -> matchingValues
    
faithful.log = (promise) ->
  promise
    .then (value) -> 
      console.log value
    .then null, (err) -> 
      console.error err

faithful.dir = (promise) ->
  promise
    .then (value) -> 
      console.log value
    .then null, (err) -> 
      console.error err
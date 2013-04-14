RSVP = require "rsvp"
process = require "./process"
  
module.exports = faithful = {}

faithful.each = faithful.forEach = (values, iterator) -> 
  # this effectively works like "map", but it will do for now
  try
    eachPromise = RSVP.all (iterator value for value in values)
  catch error
    faithful.throw error
  
faithful.eachSeries = faithful.forEachSeries = (values, iterator) ->
  # Algorithm from
  # http://blog.jcoglan.com/2013/03/30/ ...
  # callbacks-are-imperative-promises-are-iteratortional-nodes-biggest-missed-opportunity/
  # iterator = (currentPromise, value) -> currentPromise.then -> iterator value
  # return values.reduce iterator, faithful.return() # I don't understand this code yet
  process values,
    iterator: iterator

faithful.map = (values, iterator) ->
  try
    mapPromise = RSVP.all (iterator value for value in values)
  catch error
    faithful.throw error

faithful.mapSeries = (inputs, iterator) ->
  results = []
  process inputs,
    handleResult: (result) -> results.push result
    getFinalValue: -> results
    iterator: iterator
  
faithful.return = (value) -> # returns a promise which resolves to value
  promise = new RSVP.Promise
  promise.resolve value
  promise

faithful.throw = (error) -> # returns a promise which rejects with error
  promise = new RSVP.Promise
  promise.reject error
  promise

faithful.reduce = (values, reduction, iterator) ->
  process values,
    handleResult: (result) -> reduction = result
    getFinalValue: -> reduction
    iterator: (value) -> iterator reduction, value

faithful.detectSeries = (values, iterator) ->
  found = false
  process values,
    handleResult: (result) -> found = true if result
    getFinalValue: -> found
    iterator: iterator
    stopEarly: -> found
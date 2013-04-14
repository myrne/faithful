RSVP = require "rsvp"
process = require "./process"
  
module.exports = faithful = {}

faithful.each = faithful.forEach = (values, func) -> 
  # this effectively works like "map", but it will do for now
  try
    eachPromise = RSVP.all (func value for value in values)
  catch error
    faithful.throw error
  
faithful.eachSeries = faithful.forEachSeries = (values, func) ->
  # Algorithm from
  # http://blog.jcoglan.com/2013/03/30/ ...
  # callbacks-are-imperative-promises-are-functional-nodes-biggest-missed-opportunity/
  # iterator = (currentPromise, value) -> currentPromise.then -> func value
  # return values.reduce iterator, faithful.return() # I don't understand this code yet
  process values,
    handleOutput: (output) ->
    getFinalOutput: -> undefined
    callNext: (i) -> func values[i]

faithful.map = (values, func) ->
  try
    mapPromise = RSVP.all (func value for value in values)
  catch error
    faithful.throw error

faithful.mapSeries = (inputs, func) ->
  outputs = []
  process inputs,
    handleOutput: (output) -> outputs.push output
    getFinalOutput: -> outputs
    callNext: (i) -> func inputs[i]
  
faithful.return = (value) -> # returns a promise which resolves to value
  promise = new RSVP.Promise
  promise.resolve value
  promise

faithful.throw = (error) -> # returns a promise which rejects with error
  promise = new RSVP.Promise
  promise.reject error
  promise

faithful.reduce = (values, reduction, func) ->
  process values,
    handleOutput: (output) -> reduction = output
    getFinalOutput: -> reduction
    callNext: (i) -> func reduction, values[i]
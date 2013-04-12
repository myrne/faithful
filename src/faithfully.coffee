RSVP = require "rsvp"
  
module.exports = ffl = {}

ffl.each = ffl.forEach = (values, func) -> 
  # this effectively works like "map", but it will do for now
  RSVP.all (func value for value in values)
  
ffl.eachSeries = ffl.forEachSeries = (values, func) ->
  # Algorithm from
  # http://blog.jcoglan.com/2013/03/30/ ...
  # callbacks-are-imperative-promises-are-functional-nodes-biggest-missed-opportunity/
  # iterator = (currentPromise, value) -> currentPromise.then -> func value
  # return values.reduce iterator, ffl.return() # I don't understand this code yet
  i = 0
  promise = new RSVP.Promise
  iterate = ->
    if i >= values.length
      promise.resolve() 
    else
      try 
        localPromise = func(values[i])
      catch err
        return promise.reject err
      localPromise.then (-> iterate()), ((err) -> promise.reject err)
      i++
  iterate()
  promise

ffl.map = (values, func) ->
  RSVP.all (func value for value in values)

ffl.mapSeries = (values, func) ->
  RSVP.all (func value for value in values)
  
ffl.return = (value) -> # returns a promise which resolves to value
  promise = new RSVP.Promise
  promise.resolve value
  promise
  
ffl.reduce = (values, func) ->
  
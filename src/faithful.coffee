RSVP = require "rsvp"
  
module.exports = ffl = {}

ffl.each = ffl.forEach = (values, func) -> 
  # this effectively works like "map", but it will do for now
  try
    eachPromise = RSVP.all (func value for value in values)
  catch error
    ffl.throw error
  
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
  try
    mapPromise = RSVP.all (func value for value in values)
  catch error
    ffl.throw error

ffl.mapSeries = (inputs, func) ->
  i = 0
  promise = new RSVP.Promise
  outputs = []
  iterate = ->
    if i >= inputs.length
      promise.resolve outputs 
    else
      try 
        localPromise = func(inputs[i])
      catch err
        return promise.reject err
      localPromise
        .then (output) ->
          outputs.push output # this works because individual promises resolve in order
          iterate()
        .then null, (err) -> promise.reject err
      i++
  iterate()
  promise
  
ffl.return = (value) -> # returns a promise which resolves to value
  promise = new RSVP.Promise
  promise.resolve value
  promise

ffl.throw = (error) -> # returns a promise which rejects with error
  promise = new RSVP.Promise
  promise.reject error
  promise
  
ffl.reduce = (values, func) ->
  
assert = require "assert"
RSVP = require "rsvp"

timeout = 100
length = 20
argumentsUsed = (false for i in [0...10])


module.exports = testMap = (subjectFn, it) ->
  inputs = (i for i in [0...10])
  expectedOutputs = (i*2 for i in inputs)
  it "returns promise that resolves to correct array", (next) ->
    fn = (value) ->
      promise = new RSVP.Promise
      setImmediate ->
        argumentsUsed[value] = true
        promise.resolve value * 2
      promise
    subjectFn(inputs, fn).then (outputs) ->
      assert.equal outputs[i], expectedOutputs[i] for i in [0..10]
      next null
        
delayRandomly = (maxTimeout, fn) ->
  delay (Math.round(Math.random() * maxTimeout)), fn
delay = (timeout, fn) -> setTimeout fn, timeout
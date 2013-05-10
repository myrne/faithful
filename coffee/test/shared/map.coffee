assert = require "assert"

timeout = 100
length = 20
faithful = require "../../../"

module.exports = testMap = (subjectFn, it) ->
  inputs = (i for i in [0...10])
  expectedOutputs = (i*2 for i in inputs)
  it "returns promise that resolves to correct array", (next) ->
    fn = (value) ->
      faithful.makePromise (cb) ->
        setImmediate -> cb null, value * 2
    subjectFn(inputs, fn).then (outputs) ->
      assert.equal outputs[i], expectedOutputs[i] for i in [0..10]
      next null
        
delayRandomly = (maxTimeout, fn) ->
  delay (Math.round(Math.random() * maxTimeout)), fn
delay = (timeout, fn) -> setTimeout fn, timeout
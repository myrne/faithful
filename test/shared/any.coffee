assert = require "assert"
RSVP = require "rsvp"

timeout = 100
length = 20

module.exports = testAny = (subjectFn, it) ->
  it "fails gracefully when fn throws an error", (next) ->
    fn = (arg) -> throw new Error "Random exception"
    inputs = (i for i in [0...length].reverse())
    subjectFn(inputs, fn)
      .then ->
        next new Error "function should not have succeeded."
      .then null, (err) ->
        assert.equal err.toString(), "Error: Random exception"
        next null
      .then null, (err) ->
        next err
        
  it "calls fn with every value in the array", (next) ->
    argumentsUsed = (false for i in [0...10])
    inputs = (i for i in [0...10])
    fn = (value) ->
      promise = new RSVP.Promise
      setImmediate ->
        argumentsUsed[value] = true
        promise.resolve()
      promise
    subjectFn(inputs, fn).then ->
      assert.ok argumentsUsed[input], "Argument #{input} was used." for input in inputs
      next null

  it "calls fn with arguments in original order", (next) ->
    argsUsed = (false for i in [0...length])
    inputs = (i for i in [0...length])
    callOrder = []
    fn = (arg) ->
      promise = new RSVP.Promise
      assert.ok !argsUsed[i], "Arg #{i} has been used before arg #{arg}." for i in [arg...length]
      argsUsed[arg] = true
      callOrder.push arg
      delayRandomly timeout, -> promise.resolve()
      promise
    subjectFn(inputs, fn)
      .then ->
        next null
      .then null, (err) ->
        console.log err
        next new Error "Function should not have failed."
        
delayRandomly = (maxTimeout, fn) ->
  delay (Math.round(Math.random() * maxTimeout)), fn
delay = (timeout, fn) -> setTimeout fn, timeout
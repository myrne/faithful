assert = require "assert"
RSVP = require "rsvp"

timeout = 100
length = 20

module.exports = testSeries = (subjectFn, it) ->
  it "stops calling fn when a call of fn fails", (next) ->
    argsUsed = (false for i in [0...length])
    inputs = (i for i in [0...length])
    callOrder = []
    expectedOutputs = (i*2 for i in inputs)
    fn = (value) ->
      promise = new RSVP.Promise
      argsUsed[value] = true
      callOrder.push value
      if value is 5
        delayRandomly timeout, -> promise.reject new Error "Random Error."
      else
        delayRandomly timeout, -> promise.resolve()
      promise
    subjectFn(inputs, fn)
      .then ->
        next new Error "eachSeries should have failed, but hasn't."
      .then null, (err) ->
        assert.equal err.toString(), "Error: Random Error."
        assert.ok argsUsed[arg], "Argument #{arg} was not used, while it should." for arg in [1...6]
        assert.ok !argsUsed[arg], "Argument #{arg} was used, while it should not." for arg in [6...length]
        next null
      .then null, (err) ->
        next err
        
delayRandomly = (maxTimeout, fn) ->
  delay (Math.round(Math.random() * maxTimeout)), fn
delay = (timeout, fn) -> setTimeout fn, timeout
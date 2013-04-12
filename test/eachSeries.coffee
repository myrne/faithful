assert = require "assert"
RSVP = require "rsvp"

faithfully = require "../"

length = 20
timeout = 50

describe "faithfully.eachSeries", ->
  fn = (value) ->
    promise = new RSVP.Promise
    setImmediate ->
      argsUsed[value] = true
      callOrder.push value
      promise.resolve()
    promise
  it "calls fn with every value in the array", (next) ->
    argsUsed = (false for i in [0...length])
    inputs = (i for i in [0...length])
    callOrder = []
    fn = (value) ->
      promise = new RSVP.Promise
      argsUsed[value] = true
      callOrder.push value
      setImmediate -> promise.resolve()
      promise

    faithfully.eachSeries(inputs, fn).then ->
      assert.ok argsUsed[input], "Argument #{input} was used." for input in inputs
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
    faithfully.eachSeries(inputs, fn)
      .then ->
        next null
      .then null, (err) ->
        console.log err
        next new Error "The eachSeries should not have failed."

  it "fails gracefully when fn throws an error", (next) ->
    fn = (arg) -> throw new Error "Random exception"
    inputs = (i for i in [0...length].reverse())
    faithfully.eachSeries(inputs, fn)
      .then ->
        next new Error "eachSeries should not have succeeded."
      .then null, (err) ->
        assert.equal err.toString(), "Error: Random exception"
        next null
      .then null, (err) ->
        next err

  it "stops calling fn when previous call of fn fails", (next) ->
    argsUsed = (false for i in [0...length])
    inputs = (i for i in [0...length])
    callOrder = []
    fn = (value) ->
      promise = new RSVP.Promise
      argsUsed[value] = true
      callOrder.push value
      if value is 5
        delayRandomly timeout, -> promise.reject new Error "Random Error."
      else
        delayRandomly timeout, -> promise.resolve()
      promise
      
    faithfully.eachSeries(inputs, fn)
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
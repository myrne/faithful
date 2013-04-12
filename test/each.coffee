require "setimmediate"

assert = require "assert"
RSVP = require "rsvp"

argumentsUsed = (false for i in [0...10])
inputs = (i for i in [0...10])

faithfully = require "../"

describe "faithfully.each", ->
  it "calls fn with every value in the array", (next) ->
    fn = (value) ->
      promise = new RSVP.Promise
      setImmediate ->
        argumentsUsed[value] = true
        promise.resolve()
      promise
    faithfully.each(inputs, fn).then ->
      assert.ok argumentsUsed[input], "Argument #{input} was used." for input in inputs
      next null
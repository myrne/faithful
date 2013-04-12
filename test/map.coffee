assert = require "assert"
RSVP = require "rsvp"

argumentsUsed = (false for i in [0...10])
inputs = (i for i in [0...10])
expectedOutputs = (i*2 for i in inputs)

faithfully = require "../"

describe "faithfully.map", ->
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
  it "returns promise that resolves to correct array", (next) ->
    fn = (value) ->
      promise = new RSVP.Promise
      setImmediate ->
        argumentsUsed[value] = true
        promise.resolve value * 2
      promise
    faithfully.each(inputs, fn).then (outputs) ->
      assert.equal outputs[i], expectedOutputs[i] for i in [0..10]
      next null      
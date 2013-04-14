require "setimmediate"

assert = require "assert"
RSVP = require "rsvp"

faithful = require "../"

testAny = require "./shared/any"
testSeries = require "./shared/series"

factorial = (n) ->
  return 1 if n is 0 or n is 1
  return factorial(n-1)*n

describe "faithful.reduce", ->
  inputs = (i for i in [1...10])
  expectedOutput = factorial 9
  it "works for pseudo-factorial", (next) ->
    fn = (memo, value) ->
      promise = new RSVP.Promise
      setImmediate ->
        promise.resolve(memo * value)
      promise
    faithful.reduce(inputs, 1, fn)
      .then (output) ->
        assert.equal output, expectedOutput
        next null
      .then null, (err) ->
        next err
  it "works for building string (checks serial execution)", (next) ->
    testString = "testString"
    fn = (memo, value) ->
      promise = new RSVP.Promise
      delayRandomly 50, ->
        promise.resolve memo + value
      promise
    faithful.reduce(testString, "", fn)
      .then (output) ->
        assert.equal output, testString
        next null
      .then null, (err) ->
        next err
        
        
delayRandomly = (maxTimeout, fn) ->
  delay (Math.round(Math.random() * maxTimeout)), fn
delay = (timeout, fn) -> setTimeout fn, timeout
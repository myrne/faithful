require "setimmediate"

assert = require "assert"

faithful = require "../"

testAny = require "./shared/any"
testSeries = require "./shared/series"

makePromise = require "make-promise"

factorial = (n) ->
  return 1 if n is 0 or n is 1
  return factorial(n-1)*n

describe "faithful.reduce", ->
  inputs = (i for i in [1...10])
  expectedOutput = factorial 9
  it "works for pseudo-factorial", (next) ->
    fn = (memo, value) ->
      makePromise (resolve) ->
        setImmediate -> resolve(memo * value)
    faithful.reduce(inputs, 1, fn)
      .then (output) ->
        assert.equal output, expectedOutput
        next null
      .then null, (err) ->
        next err
  it "works for building string (checks serial execution)", (next) ->
    testString = "testString"
    fn = (memo, value) ->
      makePromise (resolve) ->
        delayRandomly 50, -> resolve memo + value
    faithful.reduce(testString, "", fn)
      .then (output) ->
        assert.equal output, testString
        next null
      .then null, (err) ->
        next err
        
        
delayRandomly = (maxTimeout, fn) ->
  delay (Math.round(Math.random() * maxTimeout)), fn
delay = (timeout, fn) -> setTimeout fn, timeout
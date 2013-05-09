assert = require "assert"
faithful = require "../../"

timeout = 100
length = 20

module.exports = testFilter = (subjectFn, it) ->
  inputs = (i for i in [0...10])
  expectedOutputs = (i*2 for i in inputs)
  it "finds the prime numbers", (next) ->
    numbers = [4,6,7,8,9,10,12,14,15,16,17,18,19,20]
    primes = (number for number in numbers when isPrime number)
    detectPrime = (number) ->
      faithful.makePromise (cb) ->
        setImmediate -> cb null, isPrime number
    subjectFn(numbers, detectPrime)
      .then (primes) ->
        assert.ok -1 is primes.indexOf 12
        assert.ok -1 is primes.indexOf 14
        assert.ok ~primes.indexOf 7
        assert.ok ~primes.indexOf 17
        assert.ok ~primes.indexOf 19
        assert.ok primes.length is 3
        next null
      .then null, (err) ->
        next err
  it "gives empty array when no inputs match", (next) ->
    detectPrime = (number) ->
      faithful.makePromise (cb) ->
        setImmediate -> cb null, null
    subjectFn([1,2,3], detectPrime)
      .then (results) ->
        assert.equal results.length, 0
        next null
      .then null, (err) ->
        next err
  it "gives array with single value if one input matches", (next) ->
    detectPrime = (number) ->
      faithful.makePromise (cb) ->
        setImmediate -> cb null, true
    subjectFn([2], detectPrime)
      .then (results) ->
        assert.equal results.length, 1
        assert.deepEqual results, [2]
        next null
      .then null, (err) ->
        next err
        
delayRandomly = (maxTimeout, fn) ->
  delay (Math.round(Math.random() * maxTimeout)), fn
delay = (timeout, fn) -> setTimeout fn, timeout

isPrime = (number) ->
  return false for i in [2...number] when number % i is 0
  return true
faithful = require "../../"
assert = require "assert"

pairs = [
  ["abc","123"]
  ["def","456"]
  ["ghi","789"]
]

describe "faithful.applyEach", ->
  it "calls iterator with values inside the given arrays", (next) ->
    pairsReceived = []
    printArgs = (arg1, arg2)->
      faithful.makePromise (cb) ->
        pairsReceived.push [arg1,arg2]
        cb null, null
    faithful.applyEach(pairs, printArgs)
      .then ->
        assert.deepEqual pairs, pairsReceived
        next null
      .then null, (err) ->
        next err
      
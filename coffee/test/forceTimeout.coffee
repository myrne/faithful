require "setimmediate"

assert = require "assert"

faithful = require "../../"

describe "faithful.forceTimeout", ->
  it "does time out", (next) ->
    pr = faithful.makePromise (cb) ->
    faithful.forceTimeout(500, pr)
      .then(
        (result) -> throw new Error "Promise should not have succeeded", 
        (err) -> 
          assert.equal err.toString(), "Error: Timeout after 500 ms."
          next null
      ).then null, (err) -> next err
  it "fails when input promise fails", (next) ->
    pr = faithful.makePromise (cb) -> cb new Error "The original error."
    faithful.forceTimeout(500, pr)
      .then(
        (result) -> throw new Error "Promise should not have succeeded", 
        (err) -> 
          assert.equal err.toString(), "Error: The original error."
          next null
      ).then null, (err) -> next err
      
  it "succeeds when input promise succeeds", (next) ->
    pr = faithful.makePromise (cb) -> setImmediate -> cb null, 12345
    faithful.forceTimeout(500, pr)
      .then (result) -> 
        assert.equal result, 12345
        next null
      .then null, (err) -> 
        next err
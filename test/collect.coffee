assert = require "assert"
faithful = require "../"

console.log faithful

mixedProperties =
  abc: "12"
  def: faithful.return "34"
  ghi: "56"
  jkl: faithful.return "78"

mixedValues = [
  "abc"
  faithful.return "def"
  "ghi"
  faithful.return "jkl"
]

describe "faithful.collec", ->
  describe "w", ->
    it "collects object properties", (next) -> 
      faithful.collect(mixedProperties)
        .then (properties) ->
          assert.equal properties.abc, "12"
          assert.equal properties.def, "34"
          assert.equal properties.ghi, "56"
          assert.equal properties.jkl, "78"
          next null
        .then null, (err) ->
          next err
    it "collects array values", (next) -> 
      faithful.collect(mixedValues)
        .then (values) ->
          assert.deepEqual values, ["abc","def","ghi","jkl"]
          next null
        .then null, (err) ->
          next err
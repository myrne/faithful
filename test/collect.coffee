assert = require "assert"
faithful = require "../"

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

describe "faithful.collect", ->
  it "gives an empty object for an empty object", (next) -> 
    faithful.collect({})
      .then (properties) ->
        assert.deepEqual properties, {}
        next null
      .then null, (err) ->
        next err
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

  it "gives an empty array for an empty array", (next) -> 
    faithful.collect([])
      .then (values) ->
        assert.deepEqual values, []
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
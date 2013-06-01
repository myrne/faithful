assert = require "assert"
faithful = require "../../../"

mixedProperties =
  abc: -> faithful.return "12"
  def: -> faithful.return "34"
  ghi: -> faithful.return "56"
  jkl: -> faithful.return "78"

mixedValues = [
  -> faithful.return "abc"
  -> faithful.return "def"
  -> faithful.return "ghi"
  -> faithful.return "jkl"
]

module.exports = testBatch = (subjectFn, it) ->
  describe "when input is an array", ->
    it "gives an empty array for an empty array", (next) -> 
      subjectFn([])
        .then (values) ->
          assert.deepEqual values, []
          next null
        .then null, (err) ->
          next err  
    it "results in good output for array", (next) ->
      subjectFn(mixedValues)
        .then (values) ->
          assert.deepEqual values, ["abc","def","ghi","jkl"]
          next null
        .then null, (err) ->
          next err

  describe "when input is an object", ->
    it "gives an empty object for an empty object", (next) -> 
      subjectFn({})
        .then (properties) ->
          assert.deepEqual properties, {}
          next null
        .then null, (err) ->
          next err
          
    it "results in good output for hash", (next) ->
      subjectFn(mixedProperties)
        .then (properties) ->
          assert.equal properties.abc, "12"
          assert.equal properties.def, "34"
          assert.equal properties.ghi, "56"
          assert.equal properties.jkl, "78"
          next null
        .then null, (err) ->
          next err
    
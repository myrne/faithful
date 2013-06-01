assert = require "assert"

faithful = require "../../"

testBatch = require "./shared/batch"

describe "faithful.parallelLimit", ->
  fn = (functions) -> faithful.parallelLimit functions, 2
  testBatch fn, it
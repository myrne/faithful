assert = require "assert"

faithful = require "../../"

testBatch = require "./shared/batch"

describe "faithful.parallel", ->
  testBatch faithful.parallel, it
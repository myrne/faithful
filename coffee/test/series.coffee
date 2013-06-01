assert = require "assert"

faithful = require "../../"

testBatch = require "./shared/batch"

describe "faithful.series", ->
  testBatch faithful.series, it
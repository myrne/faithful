require "setimmediate"

assert = require "assert"

testSeries = require "./shared/series"
testAny = require "./shared/any"

faithful = require "../"

describe "faithful.eachSeries", ->
  testSeries faithful.eachSeries, it
  testAny faithful.eachSeries, it
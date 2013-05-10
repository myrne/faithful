require "setimmediate"

assert = require "assert"

faithful = require "../../"

testSeries = require "./shared/series"
testAny = require "./shared/any"
testMap = require "./shared/map"

describe "faithful.mapSeries", ->
  testAny faithful.mapSeries, it  
  testSeries faithful.mapSeries, it
  testMap faithful.mapSeries, it
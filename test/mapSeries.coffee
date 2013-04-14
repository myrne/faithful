require "setimmediate"

assert = require "assert"
RSVP = require "rsvp"

faithfully = require "../"

testSeries = require "./shared/series"
testAny = require "./shared/any"
testMap = require "./shared/map"

describe "faithfully.mapSeries", ->
  testAny faithfully.mapSeries, it  
  testSeries faithfully.mapSeries, it
  testMap faithfully.mapSeries, it
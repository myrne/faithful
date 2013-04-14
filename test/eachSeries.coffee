require "setimmediate"

assert = require "assert"
RSVP = require "rsvp"

testSeries = require "./shared/series"
testAny = require "./shared/any"

faithfully = require "../"

describe "faithfully.eachSeries", ->
  testSeries faithfully.eachSeries, it
  testAny faithfully.eachSeries, it
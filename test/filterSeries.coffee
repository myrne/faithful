require "setimmediate"

assert = require "assert"
RSVP = require "rsvp"

faithful = require "../"

testAny = require "./shared/any"
testFilter = require "./shared/filter"

describe "faithful.filterSeries", ->
  testAny faithful.filterSeries, it
  testFilter faithful.filterSeries, it
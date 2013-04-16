require "setimmediate"

assert = require "assert"
RSVP = require "rsvp"

faithful = require "../"

testAny = require "./shared/any"
testDetect = require "./shared/detect"
testSeries = require "./shared/series"

describe "faithful.detectSeries", ->
  testAny faithful.detectSeries, it
  testSeries faithful.detectSeries, it
  testDetect faithful.detectSeries, it
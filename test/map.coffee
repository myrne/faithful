require "setimmediate"

assert = require "assert"
RSVP = require "rsvp"

faithfully = require "../"

testAny = require "./shared/any"
testMap = require "./shared/map"

describe "faithfully.map", ->
  testAny faithfully.map, it
  testMap faithfully.map, it
require "setimmediate"

assert = require "assert"
RSVP = require "rsvp"

faithful = require "../"

testAny = require "./shared/any"
testMap = require "./shared/map"

describe "faithful.map", ->
  testAny faithful.map, it
  testMap faithful.map, it
require "setimmediate"

assert = require "assert"
RSVP = require "rsvp"

faithfully = require "../"

testAny = require "./shared/any"

describe "faithfully.each", ->
  testAny faithfully.each, it

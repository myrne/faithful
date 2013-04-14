require "setimmediate"

assert = require "assert"
RSVP = require "rsvp"

faithful = require "../"

testAny = require "./shared/any"

describe "faithful.each", ->
  testAny faithful.each, it

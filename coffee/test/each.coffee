require "setimmediate"

assert = require "assert"

faithful = require "../../"

testAny = require "./shared/any"

describe "faithful.each", ->
  testAny faithful.each, it

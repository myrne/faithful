require "setimmediate"

assert = require "assert"

faithful = require "../"

testAny = require "./shared/any"
testMap = require "./shared/map"

describe "faithful.map", ->
  testAny faithful.map, it
  testMap faithful.map, it
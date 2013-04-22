require "setimmediate"

assert = require "assert"

faithful = require "../"

testAny = require "./shared/any"
testFilter = require "./shared/filter"

describe "faithful.filter", ->
  testAny faithful.filter, it
  testFilter faithful.filter, it
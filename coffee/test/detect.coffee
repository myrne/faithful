require "setimmediate"

assert = require "assert"

faithful = require "../../"

testAny = require "./shared/any"
testDetect= require "./shared/detect"

describe "faithful.detect", ->
  testAny faithful.detect, it
  testDetect faithful.detect, it
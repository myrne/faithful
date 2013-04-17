assert = require "assert"
faithful = require "../"

describe "faithful.adapt", ->
  timesTwo = faithful.adapt (number, next) ->
    return next new Error "You must supply a number." unless typeof number is "number"
    return next null, number * 2
  describe "when adapting a function with one argument", ->
    it "works when succeeds", (next) -> 
      timesTwo(5)
        .then (result) ->
          assert.equal result, 10
          next null
        .then null, (err) ->
          next err
    it "works when it fails", (next) -> 
      timesTwo("abc")
        .then (result) ->
          next new Error "Promise should not have succeeded."
        .then null, (err) ->
          assert.equal err.toString(), "Error: You must supply a number."
          next null
        .then null, (err) ->
          next err
          
  describe "when adapting a function with two arguments", ->
    multiply = faithful.adapt (number1, number2, next) ->
      return next new Error "You must supply a number 1." unless typeof number1 is "number"
      return next new Error "You must supply a number 2." unless typeof number2 is "number"
      return next null, number1 * number2

    it "works when succeeds", (next) -> 
      multiply(5,3)
        .then (result) ->
          assert.equal result, 15
          next null
        .then null, (err) ->
          next err
    it "works when it fails", (next) -> 
      multiply("abc",3)
        .then (result) ->
          next new Error "Promise should not have succeeded."
        .then null, (err) ->
          assert.equal err.toString(), "Error: You must supply a number 1."
          next null
        .then null, (err) ->
          next err
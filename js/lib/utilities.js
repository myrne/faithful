// Generated by CoffeeScript 1.6.2
(function() {
  var faithful, makePromise;

  makePromise = require("make-promise");

  module.exports = faithful = {};

  faithful.log = function(promise) {
    return promise.then(function(value) {
      return console.log(value);
    }).then(null, function(err) {
      return console.error(err);
    });
  };

  faithful.dir = function(promise) {
    return promise.then(function(value) {
      return console.log(value);
    }).then(null, function(err) {
      return console.error(err);
    });
  };

  faithful["return"] = faithful.fulfill = function(value) {
    return makePromise(function(cb) {
      return cb(null, value);
    });
  };

  faithful["throw"] = faithful.fail = faithful.reject = function(error) {
    return makePromise(function(cb) {
      return cb(error, null, true);
    });
  };

  faithful.ensurePromise = function(value) {
    if (faithful.isPromise(value)) {
      return value;
    }
    return faithful["return"](value);
  };

  faithful.isPromise = function(value) {
    return value && typeof value.then === "function";
  };

}).call(this);

/*
//@ sourceMappingURL=utilities.map
*/

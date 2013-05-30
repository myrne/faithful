// Generated by CoffeeScript 1.6.2
(function() {
  var each, makePromise, throttle;

  makePromise = require("make-promise");

  throttle = require("f-throttle");

  module.exports = each = function(values, iterator, _arg) {
    var concurrency, getFinalValue, handleResult, stopEarly, _ref;

    _ref = _arg != null ? _arg : {}, concurrency = _ref.concurrency, handleResult = _ref.handleResult, stopEarly = _ref.stopEarly, getFinalValue = _ref.getFinalValue;
    return makePromise(function(cb) {
      var error, i, numRemaining, promise, promises, resolver, stopped, throttledIterator, value, _i, _len, _results;

      if (!values.length) {
        return cb(null, typeof getFinalValue === "function" ? getFinalValue() : void 0);
      }
      if (concurrency == null) {
        concurrency = 1024;
      }
      throttledIterator = throttle(concurrency, iterator);
      if (!values.length) {
        return cb(null, typeof getFinalValue === "function" ? getFinalValue() : void 0);
      }
      try {
        promises = (function() {
          var _i, _len, _results;

          _results = [];
          for (_i = 0, _len = values.length; _i < _len; _i++) {
            value = values[_i];
            _results.push(throttledIterator(value));
          }
          return _results;
        })();
      } catch (_error) {
        error = _error;
        return cb(error);
      }
      stopped = false;
      numRemaining = promises.length;
      resolver = function(index) {
        return function(value) {
          if (stopped) {
            return;
          }
          try {
            if (typeof handleResult === "function") {
              handleResult(value, index);
            }
          } catch (_error) {
            error = _error;
            stopped = true;
            return cb(error);
          }
          numRemaining--;
          if (numRemaining === 0 || (typeof stopEarly === "function" ? stopEarly() : void 0)) {
            stopped = true;
            return cb(null, typeof getFinalValue === "function" ? getFinalValue() : void 0);
          }
        };
      };
      _results = [];
      for (i = _i = 0, _len = promises.length; _i < _len; i = ++_i) {
        promise = promises[i];
        try {
          _results.push(promise.then(resolver(i), function(error) {
            return cb(error);
          }));
        } catch (_error) {
          error = _error;
          cb(error);
          _results.push(stopped = true);
        }
      }
      return _results;
    });
  };

}).call(this);

/*
//@ sourceMappingURL=each.map
*/

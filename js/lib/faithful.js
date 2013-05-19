// Generated by CoffeeScript 1.6.2
(function() {
  var faithful, fn, mod, name, _i, _len, _ref;

  module.exports = faithful = {
    adapt: require("./adapt"),
    each: require("./each"),
    forEach: require("./each"),
    eachSeries: require("./eachSeries"),
    forEachSeries: require("./eachSeries"),
    adapt: require("./adapt"),
    makePromise: require("make-promise"),
    collect: require("./collect"),
    throwHard: require("./throwHard")
  };

  _ref = [require("./utilities"), require("./collections"), require("./flow-control")];
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    mod = _ref[_i];
    for (name in mod) {
      fn = mod[name];
      faithful[name] = fn;
    }
  }

}).call(this);

/*
//@ sourceMappingURL=faithful.map
*/

// Generated by CoffeeScript 1.12.2
(function() {
  module.exports = function(err) {
    var error;
    if (typeof err === "string" || err instanceof String) {
      err = new Error(err);
    }
    if (!(err instanceof Error)) {
      err = new Error("Non-string, non-Error error.");
    }
    try {
      throw new Error(err);
    } catch (error1) {
      error = error1;
      setImmediate(function() {
        console.error("");
        console.error(error.stack);
        process.exit(1);
        throw error;
      });
    }
    throw err;
  };

}).call(this);

//# sourceMappingURL=throwHard.js.map

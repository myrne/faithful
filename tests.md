# TOC
   - [faithful.each](#faithfuleach)
   - [faithful.eachSeries](#faithfuleachseries)
   - [faithful.map](#faithfulmap)
   - [faithful.mapSeries](#faithfulmapseries)
<a name=""></a>
 
<a name="faithfuleach"></a>
# faithful.each
fails gracefully when fn throws an error.

```js
var fn, i, inputs;

fn = function(arg) {
  throw new Error("Random exception");
};
inputs = (function() {
  var _i, _j, _len, _ref, _results, _results1;

  _ref = (function() {
    _results1 = [];
    for (var _j = 0; 0 <= length ? _j < length : _j > length; 0 <= length ? _j++ : _j--){ _results1.push(_j); }
    return _results1;
  }).apply(this).reverse();
  _results = [];
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    i = _ref[_i];
    _results.push(i);
  }
  return _results;
})();
return subjectFn(inputs, fn).then(function() {
  return next(new Error("function should not have succeeded."));
}).then(null, function(err) {
  assert.equal(err.toString(), "Error: Random exception");
  return next(null);
}).then(null, function(err) {
  return next(err);
});
```

fails gracefully when fn does not return an object with 'then' method.

```js
var fn, i, inputs;

fn = function(arg) {
  return {
    someMethodNotBeingThen: function() {
      return true;
    }
  };
};
inputs = (function() {
  var _i, _j, _len, _ref, _results, _results1;

  _ref = (function() {
    _results1 = [];
    for (var _j = 0; 0 <= length ? _j < length : _j > length; 0 <= length ? _j++ : _j--){ _results1.push(_j); }
    return _results1;
  }).apply(this).reverse();
  _results = [];
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    i = _ref[_i];
    _results.push(i);
  }
  return _results;
})();
return subjectFn(inputs, fn).then(function() {
  return next(new Error("function should not have succeeded."));
}).then(null, function(err) {
  assert.equal(err.toString(), "TypeError: Object #<Object> has no method 'then'");
  return next(null);
}).then(null, function(err) {
  return next(err);
});
```

calls fn with every value in the array.

```js
var argumentsUsed, fn, i, inputs;

argumentsUsed = (function() {
  var _i, _results;

  _results = [];
  for (i = _i = 0; _i < 10; i = ++_i) {
    _results.push(false);
  }
  return _results;
})();
inputs = (function() {
  var _i, _results;

  _results = [];
  for (i = _i = 0; _i < 10; i = ++_i) {
    _results.push(i);
  }
  return _results;
})();
fn = function(value) {
  var promise;

  promise = new RSVP.Promise;
  setImmediate(function() {
    argumentsUsed[value] = true;
    return promise.resolve();
  });
  return promise;
};
return subjectFn(inputs, fn).then(function() {
  var input, _i, _len;

  for (_i = 0, _len = inputs.length; _i < _len; _i++) {
    input = inputs[_i];
    assert.ok(argumentsUsed[input], "Argument " + input + " was used.");
  }
  return next(null);
});
```

calls fn with arguments in original order.

```js
var argsUsed, callOrder, fn, i, inputs;

argsUsed = (function() {
  var _i, _results;

  _results = [];
  for (i = _i = 0; 0 <= length ? _i < length : _i > length; i = 0 <= length ? ++_i : --_i) {
    _results.push(false);
  }
  return _results;
})();
inputs = (function() {
  var _i, _results;

  _results = [];
  for (i = _i = 0; 0 <= length ? _i < length : _i > length; i = 0 <= length ? ++_i : --_i) {
    _results.push(i);
  }
  return _results;
})();
callOrder = [];
fn = function(arg) {
  var promise, _i;

  promise = new RSVP.Promise;
  for (i = _i = arg; arg <= length ? _i < length : _i > length; i = arg <= length ? ++_i : --_i) {
    assert.ok(!argsUsed[i], "Arg " + i + " has been used before arg " + arg + ".");
  }
  argsUsed[arg] = true;
  callOrder.push(arg);
  delayRandomly(timeout, function() {
    return promise.resolve();
  });
  return promise;
};
return subjectFn(inputs, fn).then(function() {
  return next(null);
}).then(null, function(err) {
  console.log(err);
  return next(new Error("Function should not have failed."));
});
```

<a name="faithfuleachseries"></a>
# faithful.eachSeries
stops calling fn when previous call of fn fails.

```js
var argsUsed, callOrder, expectedOutputs, fn, i, inputs;

argsUsed = (function() {
  var _i, _results;

  _results = [];
  for (i = _i = 0; 0 <= length ? _i < length : _i > length; i = 0 <= length ? ++_i : --_i) {
    _results.push(false);
  }
  return _results;
})();
inputs = (function() {
  var _i, _results;

  _results = [];
  for (i = _i = 0; 0 <= length ? _i < length : _i > length; i = 0 <= length ? ++_i : --_i) {
    _results.push(i);
  }
  return _results;
})();
callOrder = [];
expectedOutputs = (function() {
  var _i, _len, _results;

  _results = [];
  for (_i = 0, _len = inputs.length; _i < _len; _i++) {
    i = inputs[_i];
    _results.push(i * 2);
  }
  return _results;
})();
fn = function(value) {
  var promise;

  promise = new RSVP.Promise;
  argsUsed[value] = true;
  callOrder.push(value);
  if (value === 5) {
    delayRandomly(timeout, function() {
      return promise.reject(new Error("Random Error."));
    });
  } else {
    delayRandomly(timeout, function() {
      return promise.resolve();
    });
  }
  return promise;
};
return subjectFn(inputs, fn).then(function() {
  return next(new Error("eachSeries should have failed, but hasn't."));
}).then(null, function(err) {
  var arg, _i, _j;

  assert.equal(err.toString(), "Error: Random Error.");
  for (arg = _i = 1; _i < 6; arg = ++_i) {
    assert.ok(argsUsed[arg], "Argument " + arg + " was not used, while it should.");
  }
  for (arg = _j = 6; 6 <= length ? _j < length : _j > length; arg = 6 <= length ? ++_j : --_j) {
    assert.ok(!argsUsed[arg], "Argument " + arg + " was used, while it should not.");
  }
  return next(null);
}).then(null, function(err) {
  return next(err);
});
```

fails gracefully when fn throws an error.

```js
var fn, i, inputs;

fn = function(arg) {
  throw new Error("Random exception");
};
inputs = (function() {
  var _i, _j, _len, _ref, _results, _results1;

  _ref = (function() {
    _results1 = [];
    for (var _j = 0; 0 <= length ? _j < length : _j > length; 0 <= length ? _j++ : _j--){ _results1.push(_j); }
    return _results1;
  }).apply(this).reverse();
  _results = [];
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    i = _ref[_i];
    _results.push(i);
  }
  return _results;
})();
return subjectFn(inputs, fn).then(function() {
  return next(new Error("function should not have succeeded."));
}).then(null, function(err) {
  assert.equal(err.toString(), "Error: Random exception");
  return next(null);
}).then(null, function(err) {
  return next(err);
});
```

fails gracefully when fn does not return an object with 'then' method.

```js
var fn, i, inputs;

fn = function(arg) {
  return {
    someMethodNotBeingThen: function() {
      return true;
    }
  };
};
inputs = (function() {
  var _i, _j, _len, _ref, _results, _results1;

  _ref = (function() {
    _results1 = [];
    for (var _j = 0; 0 <= length ? _j < length : _j > length; 0 <= length ? _j++ : _j--){ _results1.push(_j); }
    return _results1;
  }).apply(this).reverse();
  _results = [];
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    i = _ref[_i];
    _results.push(i);
  }
  return _results;
})();
return subjectFn(inputs, fn).then(function() {
  return next(new Error("function should not have succeeded."));
}).then(null, function(err) {
  assert.equal(err.toString(), "TypeError: Object #<Object> has no method 'then'");
  return next(null);
}).then(null, function(err) {
  return next(err);
});
```

calls fn with every value in the array.

```js
var argumentsUsed, fn, i, inputs;

argumentsUsed = (function() {
  var _i, _results;

  _results = [];
  for (i = _i = 0; _i < 10; i = ++_i) {
    _results.push(false);
  }
  return _results;
})();
inputs = (function() {
  var _i, _results;

  _results = [];
  for (i = _i = 0; _i < 10; i = ++_i) {
    _results.push(i);
  }
  return _results;
})();
fn = function(value) {
  var promise;

  promise = new RSVP.Promise;
  setImmediate(function() {
    argumentsUsed[value] = true;
    return promise.resolve();
  });
  return promise;
};
return subjectFn(inputs, fn).then(function() {
  var input, _i, _len;

  for (_i = 0, _len = inputs.length; _i < _len; _i++) {
    input = inputs[_i];
    assert.ok(argumentsUsed[input], "Argument " + input + " was used.");
  }
  return next(null);
});
```

calls fn with arguments in original order.

```js
var argsUsed, callOrder, fn, i, inputs;

argsUsed = (function() {
  var _i, _results;

  _results = [];
  for (i = _i = 0; 0 <= length ? _i < length : _i > length; i = 0 <= length ? ++_i : --_i) {
    _results.push(false);
  }
  return _results;
})();
inputs = (function() {
  var _i, _results;

  _results = [];
  for (i = _i = 0; 0 <= length ? _i < length : _i > length; i = 0 <= length ? ++_i : --_i) {
    _results.push(i);
  }
  return _results;
})();
callOrder = [];
fn = function(arg) {
  var promise, _i;

  promise = new RSVP.Promise;
  for (i = _i = arg; arg <= length ? _i < length : _i > length; i = arg <= length ? ++_i : --_i) {
    assert.ok(!argsUsed[i], "Arg " + i + " has been used before arg " + arg + ".");
  }
  argsUsed[arg] = true;
  callOrder.push(arg);
  delayRandomly(timeout, function() {
    return promise.resolve();
  });
  return promise;
};
return subjectFn(inputs, fn).then(function() {
  return next(null);
}).then(null, function(err) {
  console.log(err);
  return next(new Error("Function should not have failed."));
});
```

<a name="faithfulmap"></a>
# faithful.map
fails gracefully when fn throws an error.

```js
var fn, i, inputs;

fn = function(arg) {
  throw new Error("Random exception");
};
inputs = (function() {
  var _i, _j, _len, _ref, _results, _results1;

  _ref = (function() {
    _results1 = [];
    for (var _j = 0; 0 <= length ? _j < length : _j > length; 0 <= length ? _j++ : _j--){ _results1.push(_j); }
    return _results1;
  }).apply(this).reverse();
  _results = [];
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    i = _ref[_i];
    _results.push(i);
  }
  return _results;
})();
return subjectFn(inputs, fn).then(function() {
  return next(new Error("function should not have succeeded."));
}).then(null, function(err) {
  assert.equal(err.toString(), "Error: Random exception");
  return next(null);
}).then(null, function(err) {
  return next(err);
});
```

fails gracefully when fn does not return an object with 'then' method.

```js
var fn, i, inputs;

fn = function(arg) {
  return {
    someMethodNotBeingThen: function() {
      return true;
    }
  };
};
inputs = (function() {
  var _i, _j, _len, _ref, _results, _results1;

  _ref = (function() {
    _results1 = [];
    for (var _j = 0; 0 <= length ? _j < length : _j > length; 0 <= length ? _j++ : _j--){ _results1.push(_j); }
    return _results1;
  }).apply(this).reverse();
  _results = [];
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    i = _ref[_i];
    _results.push(i);
  }
  return _results;
})();
return subjectFn(inputs, fn).then(function() {
  return next(new Error("function should not have succeeded."));
}).then(null, function(err) {
  assert.equal(err.toString(), "TypeError: Object #<Object> has no method 'then'");
  return next(null);
}).then(null, function(err) {
  return next(err);
});
```

calls fn with every value in the array.

```js
var argumentsUsed, fn, i, inputs;

argumentsUsed = (function() {
  var _i, _results;

  _results = [];
  for (i = _i = 0; _i < 10; i = ++_i) {
    _results.push(false);
  }
  return _results;
})();
inputs = (function() {
  var _i, _results;

  _results = [];
  for (i = _i = 0; _i < 10; i = ++_i) {
    _results.push(i);
  }
  return _results;
})();
fn = function(value) {
  var promise;

  promise = new RSVP.Promise;
  setImmediate(function() {
    argumentsUsed[value] = true;
    return promise.resolve();
  });
  return promise;
};
return subjectFn(inputs, fn).then(function() {
  var input, _i, _len;

  for (_i = 0, _len = inputs.length; _i < _len; _i++) {
    input = inputs[_i];
    assert.ok(argumentsUsed[input], "Argument " + input + " was used.");
  }
  return next(null);
});
```

calls fn with arguments in original order.

```js
var argsUsed, callOrder, fn, i, inputs;

argsUsed = (function() {
  var _i, _results;

  _results = [];
  for (i = _i = 0; 0 <= length ? _i < length : _i > length; i = 0 <= length ? ++_i : --_i) {
    _results.push(false);
  }
  return _results;
})();
inputs = (function() {
  var _i, _results;

  _results = [];
  for (i = _i = 0; 0 <= length ? _i < length : _i > length; i = 0 <= length ? ++_i : --_i) {
    _results.push(i);
  }
  return _results;
})();
callOrder = [];
fn = function(arg) {
  var promise, _i;

  promise = new RSVP.Promise;
  for (i = _i = arg; arg <= length ? _i < length : _i > length; i = arg <= length ? ++_i : --_i) {
    assert.ok(!argsUsed[i], "Arg " + i + " has been used before arg " + arg + ".");
  }
  argsUsed[arg] = true;
  callOrder.push(arg);
  delayRandomly(timeout, function() {
    return promise.resolve();
  });
  return promise;
};
return subjectFn(inputs, fn).then(function() {
  return next(null);
}).then(null, function(err) {
  console.log(err);
  return next(new Error("Function should not have failed."));
});
```

returns promise that resolves to correct array.

```js
var fn;

fn = function(value) {
  var promise;

  promise = new RSVP.Promise;
  setImmediate(function() {
    argumentsUsed[value] = true;
    return promise.resolve(value * 2);
  });
  return promise;
};
return subjectFn(inputs, fn).then(function(outputs) {
  var _i;

  for (i = _i = 0; _i <= 10; i = ++_i) {
    assert.equal(outputs[i], expectedOutputs[i]);
  }
  return next(null);
});
```

<a name="faithfulmapseries"></a>
# faithful.mapSeries
fails gracefully when fn throws an error.

```js
var fn, i, inputs;

fn = function(arg) {
  throw new Error("Random exception");
};
inputs = (function() {
  var _i, _j, _len, _ref, _results, _results1;

  _ref = (function() {
    _results1 = [];
    for (var _j = 0; 0 <= length ? _j < length : _j > length; 0 <= length ? _j++ : _j--){ _results1.push(_j); }
    return _results1;
  }).apply(this).reverse();
  _results = [];
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    i = _ref[_i];
    _results.push(i);
  }
  return _results;
})();
return subjectFn(inputs, fn).then(function() {
  return next(new Error("function should not have succeeded."));
}).then(null, function(err) {
  assert.equal(err.toString(), "Error: Random exception");
  return next(null);
}).then(null, function(err) {
  return next(err);
});
```

fails gracefully when fn does not return an object with 'then' method.

```js
var fn, i, inputs;

fn = function(arg) {
  return {
    someMethodNotBeingThen: function() {
      return true;
    }
  };
};
inputs = (function() {
  var _i, _j, _len, _ref, _results, _results1;

  _ref = (function() {
    _results1 = [];
    for (var _j = 0; 0 <= length ? _j < length : _j > length; 0 <= length ? _j++ : _j--){ _results1.push(_j); }
    return _results1;
  }).apply(this).reverse();
  _results = [];
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    i = _ref[_i];
    _results.push(i);
  }
  return _results;
})();
return subjectFn(inputs, fn).then(function() {
  return next(new Error("function should not have succeeded."));
}).then(null, function(err) {
  assert.equal(err.toString(), "TypeError: Object #<Object> has no method 'then'");
  return next(null);
}).then(null, function(err) {
  return next(err);
});
```

calls fn with every value in the array.

```js
var argumentsUsed, fn, i, inputs;

argumentsUsed = (function() {
  var _i, _results;

  _results = [];
  for (i = _i = 0; _i < 10; i = ++_i) {
    _results.push(false);
  }
  return _results;
})();
inputs = (function() {
  var _i, _results;

  _results = [];
  for (i = _i = 0; _i < 10; i = ++_i) {
    _results.push(i);
  }
  return _results;
})();
fn = function(value) {
  var promise;

  promise = new RSVP.Promise;
  setImmediate(function() {
    argumentsUsed[value] = true;
    return promise.resolve();
  });
  return promise;
};
return subjectFn(inputs, fn).then(function() {
  var input, _i, _len;

  for (_i = 0, _len = inputs.length; _i < _len; _i++) {
    input = inputs[_i];
    assert.ok(argumentsUsed[input], "Argument " + input + " was used.");
  }
  return next(null);
});
```

calls fn with arguments in original order.

```js
var argsUsed, callOrder, fn, i, inputs;

argsUsed = (function() {
  var _i, _results;

  _results = [];
  for (i = _i = 0; 0 <= length ? _i < length : _i > length; i = 0 <= length ? ++_i : --_i) {
    _results.push(false);
  }
  return _results;
})();
inputs = (function() {
  var _i, _results;

  _results = [];
  for (i = _i = 0; 0 <= length ? _i < length : _i > length; i = 0 <= length ? ++_i : --_i) {
    _results.push(i);
  }
  return _results;
})();
callOrder = [];
fn = function(arg) {
  var promise, _i;

  promise = new RSVP.Promise;
  for (i = _i = arg; arg <= length ? _i < length : _i > length; i = arg <= length ? ++_i : --_i) {
    assert.ok(!argsUsed[i], "Arg " + i + " has been used before arg " + arg + ".");
  }
  argsUsed[arg] = true;
  callOrder.push(arg);
  delayRandomly(timeout, function() {
    return promise.resolve();
  });
  return promise;
};
return subjectFn(inputs, fn).then(function() {
  return next(null);
}).then(null, function(err) {
  console.log(err);
  return next(new Error("Function should not have failed."));
});
```

stops calling fn when previous call of fn fails.

```js
var argsUsed, callOrder, expectedOutputs, fn, i, inputs;

argsUsed = (function() {
  var _i, _results;

  _results = [];
  for (i = _i = 0; 0 <= length ? _i < length : _i > length; i = 0 <= length ? ++_i : --_i) {
    _results.push(false);
  }
  return _results;
})();
inputs = (function() {
  var _i, _results;

  _results = [];
  for (i = _i = 0; 0 <= length ? _i < length : _i > length; i = 0 <= length ? ++_i : --_i) {
    _results.push(i);
  }
  return _results;
})();
callOrder = [];
expectedOutputs = (function() {
  var _i, _len, _results;

  _results = [];
  for (_i = 0, _len = inputs.length; _i < _len; _i++) {
    i = inputs[_i];
    _results.push(i * 2);
  }
  return _results;
})();
fn = function(value) {
  var promise;

  promise = new RSVP.Promise;
  argsUsed[value] = true;
  callOrder.push(value);
  if (value === 5) {
    delayRandomly(timeout, function() {
      return promise.reject(new Error("Random Error."));
    });
  } else {
    delayRandomly(timeout, function() {
      return promise.resolve();
    });
  }
  return promise;
};
return subjectFn(inputs, fn).then(function() {
  return next(new Error("eachSeries should have failed, but hasn't."));
}).then(null, function(err) {
  var arg, _i, _j;

  assert.equal(err.toString(), "Error: Random Error.");
  for (arg = _i = 1; _i < 6; arg = ++_i) {
    assert.ok(argsUsed[arg], "Argument " + arg + " was not used, while it should.");
  }
  for (arg = _j = 6; 6 <= length ? _j < length : _j > length; arg = 6 <= length ? ++_j : --_j) {
    assert.ok(!argsUsed[arg], "Argument " + arg + " was used, while it should not.");
  }
  return next(null);
}).then(null, function(err) {
  return next(err);
});
```

returns promise that resolves to correct array.

```js
var fn;

fn = function(value) {
  var promise;

  promise = new RSVP.Promise;
  setImmediate(function() {
    argumentsUsed[value] = true;
    return promise.resolve(value * 2);
  });
  return promise;
};
return subjectFn(inputs, fn).then(function(outputs) {
  var _i;

  for (i = _i = 0; _i <= 10; i = ++_i) {
    assert.equal(outputs[i], expectedOutputs[i]);
  }
  return next(null);
});
```


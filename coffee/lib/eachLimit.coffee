each = require "./each"

module.exports = eachLimit = (values, concurrency, iterator, options ={}) ->
  options.concurrency = concurrency
  each values, iterator, options
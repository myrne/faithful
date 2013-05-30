each = require "./each"

module.exports = eachSeries = (values, iterator, options ={}) ->
  options.concurrency = 1
  each values, iterator, options
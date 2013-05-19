module.exports = faithful =
  adapt: require "./adapt"
  each: require "./each"
  forEach: require "./each"
  eachSeries: require "./eachSeries"
  forEachSeries: require "./eachSeries"
  adapt: require "./adapt"
  makePromise: require "make-promise"
  collect: require "./collect"
  throwHard: require "./throwHard"

faithful[name] = fn for name, fn of mod for mod in [
  require "./utilities"
  require "./collections"
  require "./flow-control"
]
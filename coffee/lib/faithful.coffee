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

for moduleName in ['utilities','collections','flow-control']
  faithful[name] = fn for name, fn of require "./#{moduleName}"
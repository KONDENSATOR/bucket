_ = require('lodash')
util = require('util')
f    = require('./functions')

class Query
  constructor: (@branch) ->
    @subset = _(@branch.state.dirty).chain()

  exec : (name, args...) ->
    @subset = @subset[name](args...)
    this

  reduce      : (fn, memo) -> @exec('reduce', fn, memo)
  reduceRight : (fn, memo) -> @exec('reduceRight', fn, memo)

  map     : (fn) -> @exec('map', fn)
  find    : (fn) -> @exec('find', fn)
  filter  : (fn) -> @exec('filter', fn)
  reject  : (fn) -> @exec('reject', fn)
  every   : (fn) -> @exec('every', fn)
  some    : (fn) -> @exec('some', fn)
  max     : (fn) -> @exec('max', fn)
  min     : (fn) -> @exec('min', fn)

  sortBy  : (fn) -> @exec('sortBy', fn)
  groupBy : (fn) -> @exec('groupBy', fn)
  indexBy : (fn) -> @exec('indexBy', fn)
  countBy : (fn) -> @exec('countBy', fn)

  size    : () -> @exec('size')
  first   : (n) -> @exec('first', n)
  initial : (n) -> @exec('initial', n)
  last    : (n) -> @exec('last', n)
  rest    : (n) -> @exec('rest', n)

  compact : () -> @exec('compact', fn)
  flatten : (shallow) -> @exec('flatten', shallow)

  uniq    : (isSorted, fn) -> @exec('uniq', isSorted, fn)

  value   : () -> @subset.value()
  set     : () -> @branch.set(@subset.values().value()); @branch
  inspect : () -> f.inspect(@, @subset.value())
  lift    : (fn) ->
    @subset = _(fn(@subset.value())).chain()
    this

module.exports = Query

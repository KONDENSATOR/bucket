_ = require('underscore')
util = require('util')

class Query
  constructor: (@branch) ->
    @subset = _(@branch.state.dirty).chain()

  filter : (fn) -> @subset = @subset.filter(fn); this
  map    : (fn) -> @subset = @subset.map(fn); this

  value: () -> @subset.value()

  set : () ->
    @branch.set(@subset.values().value())
    @branch

  log : () ->
    console.log(util.inspect(@subset.value(), {color:true, depth:null}))
    this

module.exports = Query

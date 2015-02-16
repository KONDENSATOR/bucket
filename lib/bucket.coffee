_      = require('lodash')
Branch = require('./branch')
f      = require("./functions")

instanceid = 0

class Bucket
  constructor: (path) ->
    instanceid += 1
    @state =
      id       : "bucket:#{instanceid}"
      path     : path
      children : {}
      err      : () -> this
      read     : () -> this
      stored   : () -> this

  # Accessors
  path     : () -> @state.path
  parent   : () -> @state.parent

  onerr    : (fn) -> f.onerr(@, fn); this
  onread   : (fn) -> f.onread(@, fn); this
  onstored : (fn) -> f.onstored(@, fn); this
  onoblited: (fn) -> f.onoblited(@, fn); this
  onlisted : (fn) -> f.onlisted(@, fn); this
  onclosed : (fn) -> f.onclosed(@, fn); this

  oblit    : () -> f.oblit(@)
  list     : () -> f.list(@)
  close    : () -> f.close(@)

  use : (name, fn) ->
    if _.isFunction(name)
      fn = name
      name = 'master'
    name ?= 'master'
    branch = new Branch(@, name)

    @state.children[name] = branch

    f.ensure(@state.path, (err) =>
      if err?
        @state.err(err)
      else
        branch.load(fn))

    branch

module.exports = Bucket


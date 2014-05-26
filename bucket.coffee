Branch = require('./branch')

f = require("./functions")

class Bucket
  constructor: (path) ->
    @state =
      path     : path
      children : {}
      err      : () -> this
      data     : () -> this
      stored   : () -> this

  # Accessors
  path     : () -> @state.path
  parent   : () -> @state.parent

  onerr    : (fn) -> f.onerr(@, fn); this
  ondata   : (fn) -> f.ondata(@, fn); this
  onstored : (fn) -> f.onstored(@, fn); this
  onoblited: (fn) -> f.onoblited(@, fn); this
  onlisted : (fn) -> f.onlisted(@, fn); this
  onclosed : (fn) -> f.onclosed(@, fn); this

  oblit    : () -> f.oblit(@)
  list     : () -> f.list(@)
  close    : () -> f.close(@)

  use : (name) ->
    name ?= 'master'
    branch = new Branch(@state)
    branch.init(name, this)

    @state.children[name] = branch

    f.ensure(@state.path, (err) =>
      if err?
        @state.err(err)
      else
        branch.load())
    branch

module.exports = Bucket

_ = require("underscore")

Query = require("./query")

f = require("./functions")


class Branch
  constructor: (state) ->
    @state = _(state).clone()

  init : (name, parent) ->
    @state.branch   = name
    @state.parent   = parent

    @state.children = {}
    @state.commited = {}  # Keeps commited state
    @state.dirty    = {}  # Keeps whole data in dirty state
    @state.changes  = {}  # Keeps only changed datagrams
    this

  branch : () -> @state.branch
  onerr  : (fn) -> f.onerr(@, fn); this
  ondata : (fn) -> f.ondata(@, fn); this
  onstored : (fn) -> f.onstored(@, fn); this

  filename : () -> f.filename(@)
  load : () -> f.load(@)

  # Obliterate me
  oblit : () -> f.oblit(@)

  # Close me and my children
  close : () -> f.close(@)

  # Fork me
  fork  : (name) -> f.fork(@, name)

  # Merge with parent unless parent is type Bucket
  merge   : () -> f.merge(@)
  changed : () -> f.changed(@)
  discard : () -> f.discard(@)
  commit  : () -> f.commit(@)
  query   : () -> new Query(@)
  set     : (itms) -> f.set(@, itms)
  remove  : (keys) -> f.remove(@, keys)
  store   : () -> f.store(new Branch(@state))

module.exports = Branch

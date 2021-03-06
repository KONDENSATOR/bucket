_ = require("lodash")

Query = require("./query")

f = require("./functions")

instanceid = 0

class Branch
  constructor: (parent, name) ->
    instanceid += 1
    @state = _(parent.state).clone()
    @state.id = "branch:#{instanceid}"
    @state.branch   = name
    @state.parent   = parent
    @state.children = {}
    @state.commited = {}  # Keeps commited state
    @state.dirty    = {}  # Keeps whole data in dirty state
    @state.changes  = {}  # Keeps only changed datagrams

  branch   : () -> @state.branch
  onerr    : (fn) -> f.onerr(@, fn); this
  onread   : (fn) -> f.onread(@, fn); this
  onstored : (fn) -> f.onstored(@, fn); this

  filename : () -> f.filename(@)
  load : (fn) -> f.load(@, fn)

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
  query   : () -> new Query(@)
  set     : (itms) -> f.set(@, itms)
  remove  : (keys) -> f.remove(@, keys)
  store   : () -> f.store(@)

  inspect : () -> f.inspect(@, @state.dirty)

module.exports = Branch

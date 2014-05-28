path     = require("path")
fs       = require("fs")
readline = require("readline")
_        = require("underscore")
util     = require("util")

inspect = (obj, value) ->
  console.log(util.inspect(value, colors:true, depth:null))
  obj

set     = (obj, items) ->
  if items?
    state = obj.state
    items = [items] if not _(items).isArray()

    _(items).each((item) ->
      if not item.id?
        discard(obj)
        state.err("Bucket(#{state.branch}) Transaction rollbacked - Error: Item contains no id: #{util.inspect(item)}")
        return
      present = state.dirty[item.id]
      if not _(item).isEqual(present)
        state.dirty[item.id] = item
        state.changes[item.id] = item)
  obj

remove = (obj, ids) ->
  if ids?
    ids = [ids] if not _(ids).isArray()
    state = obj.state
    _(ids).each((id) ->
      delete state.dirty[id]
      state.changes[id] = {id:id, deleted:true})
  obj

filename = (obj) ->
  state = obj.state
  path.join(state.path, state.branch)

load = (obj, fn) ->
  state = obj.state

  # Create file if not existing
  fs.closeSync(fs.openSync(filename(obj), 'a'))

  # Set up line reader
  rl = readline.createInterface(
    input    : fs.createReadStream(filename(obj))
    output   : process.stdout
    terminal : false)

  # On each line
  rl.on("line", (line) =>
    chunk   = JSON.parse(line)
    set(obj, chunk))

  # Callback on EOF passing the bucket with data
  rl.on("close", () =>
    commit(obj)
    fn(obj) if fn?)

  # Return the bucket configuration
  obj

# Obliterate me
oblit = (obj) ->
  state = obj.state
  obj

# Close me and my children
close = (obj) ->
  state = obj.state
  obj

# Fork me
fork  = (obj, name) ->
  state = obj.state
  obj

# Merge with parent unless parent is type Bucket
merge = (obj) ->
  state = obj.state
  obj

changed = (obj) -> _(obj.state.changes).keys().length > 0

discard = (obj) ->
  state = obj.state
  state.dirty = _(state.commited).clone()
  state.changes = {}
  obj

commit  = (obj) ->
  state = obj.state
  changes = state.changes
  state.commited = _(state.dirty).clone()
  state.changes = {}
  obj.state.data(obj, changes)
  obj

store   = (obj) ->
  state = obj.state
  if changed(obj)
    transaction = JSON.stringify(_(state.changes).values()) + "\n"

    fs.appendFile(filename(obj), transaction, {encoding:'utf8'}, (err) ->
      if err?
        discard(obj)
        state.err("Bucket(#{@state.branch}) Transaction rollbacked - " + err)
      else
        state.commited = state.dirty
        state.changes = {}
        state.stored(obj))
  obj

ensure = (filepath, fn) ->
  real = path.resolve(filepath)
  fs.exists(real, (exists) ->
    if exists
      fn()
    else
      fn("Path '#{real}' does not exist"))

onerr  = (obj, fn) ->
  obj.state.err = fn
  this
ondata = (obj, fn) ->
  obj.state.data = fn
  this
onstored = (obj, fn) ->
  obj.state.stored = fn
  this
onoblited = (obj, fn) ->
  obj.state.oblited = fn
  this
onlisted = (obj, fn) ->
  obj.state.listed = fn
  this
onclosed = (obj, fn) ->
  obj.state.closed = fn
  this

module.exports =
  inspect  : inspect
  set      : set
  remove   : remove
  filename : filename
  load     : load
  oblit    : oblit
  close    : close
  fork     : fork
  merge    : merge
  changed  : changed
  discard  : discard
  commit   : commit
  store    : store
  ensure   : ensure

  onerr    : onerr
  ondata   : ondata
  onstored : onstored

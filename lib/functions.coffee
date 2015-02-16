path     = require("path")
fs       = require("fs")
readline = require("readline")
_        = require("lodash")
util     = require("util")

dlog = (obj, fname) ->
  # console.log(obj.state.id, fname)

ilog = (obj, fname, info) ->
  console.log(obj.state.id, fname, info)



inspect = (obj, value) ->
  dlog(obj, "inspect")
  console.log(util.inspect(value, colors:true, depth:null))
  obj

set = (obj, items) ->
  dlog(obj, "set")
  if items?
    state = obj.state
    items = [items] if not _.isArray(items)
    ilog(obj, "set", "Set argument contains #{items.length} items")

    _.each(items, (item) ->
      if not item.id?
        discard(obj)
        state.err("Bucket(#{state.branch}) Transaction rollbacked - Error: Item contains no id: #{util.inspect(item)}")
        return
      present = JSON.stringify(state.dirty[item.id])
      comparable = JSON.stringify(item)

      if present != comparable
        state.dirty[item.id] = item
        state.changes[item.id] = item
    )
  obj

remove = (obj, ids) ->
  dlog(obj, "remove")
  if ids?
    ids = [ids] if not _.isArray(ids)
    state = obj.state
    _.each(ids, (id) ->
      delete state.dirty[id]
      state.changes[id] = {id:id, deleted:true})
  obj

filename = (obj) ->
  dlog(obj, "filename")
  state = obj.state
  path.join(state.path, state.branch)

load = (obj, fn) ->
  dlog(obj, "load")
  do (obj, fn) ->
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
      changes = obj.state.changes
      commit(obj)
      obj.state.read(obj, changes)
      changes = null
      fn(obj) if fn?)

    # Return the bucket configuration
    obj

# Obliterate me
oblit = (obj) ->
  dlog(obj, "oblit")
  state = obj.state
  obj

# Close me and my children
close = (obj) ->
  dlog(obj, "close")
  state = obj.state
  obj

# Fork me
fork  = (obj, name) ->
  dlog(obj, "fork")
  state = obj.state
  obj

# Merge with parent unless parent is type Bucket
merge = (obj) ->
  dlog(obj, "merge")
  state = obj.state
  obj

changed = (obj) ->
  dlog(obj, "changed")
  _.keys(obj.state.changes).length > 0

discard = (obj) ->
  dlog(obj, "discard")
  state = obj.state
  state.dirty = _.clone(state.commited)
  state.changes = {}
  obj

commit  = (obj) ->
  dlog(obj, "commit")
  state = obj.state
  changes = state.changes
  state.commited = _.clone(state.dirty)
  state.changes = {}
  obj

store   = (obj) ->
  dlog(obj, "store")
  do (obj) ->
    state = obj.state
    if not changed(obj)
      ilog(obj, "store", "Nothing changed")
    else
      transaction = JSON.stringify(_(state.changes).values()) + "\n"

      ilog(obj, "store", "Appending to #{filename(obj)}")

      fs.appendFile(filename(obj), transaction, {encoding:'utf8'}, (err) ->
        if err?
          discard(obj)
          ilog(obj, "store", "Error storing")
          state.err("Bucket(#{@state.branch}) Transaction rollbacked - " + err)
        else
          ilog(obj, "store", "Done storing #{state.changes.length} changes")
          stored_changes = state.changes
          commit(obj)
          state.stored(obj, stored_changes)
          stored_changes = null)
    obj

ensure = (filepath, fn) ->
  do (filepath, fn) ->
    real = path.resolve(filepath)
    fs.exists(real, (exists) ->
      if exists
        fn()
      else
        fn("Path '#{real}' does not exist"))

onerr  = (obj, fn) ->
  dlog(obj, "onerr")
  obj.state.err = fn
  this
onread = (obj, fn) ->
  dlog(obj, "onread")
  obj.state.read = fn
  this
onstored = (obj, fn) ->
  dlog(obj, "onstored")
  obj.state.stored = fn
  this
onoblited = (obj, fn) ->
  dlog(obj, "onoblited")
  obj.state.oblited = fn
  this
onlisted = (obj, fn) ->
  dlog(obj, "onlisted")
  obj.state.listed = fn
  this
onclosed = (obj, fn) ->
  dlog(obj, "onclosed")
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
  store    : store
  ensure   : ensure

  onerr    : onerr
  onread   : onread
  onstored : onstored


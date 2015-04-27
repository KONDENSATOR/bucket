_      = require('underscore')
bucket = require("../index")

# Initialize test-data bucket and master branch
master_test_data = () ->
  bucket("test-data")
    .onerr((err) -> console.log("ERROR: #{err}"))
    .use()

# Test insert, store, query, filter, map and store again
insert_and_query = () ->
  master_test_data()
    .ondata((data) ->
      data.set([{id:'frasse', hej:"då"}, {id:'staffan', gurka:'groen'}])
        .store()
        .onstored((branch) ->
          console.log("First store for branch #{branch.branch()}"))
        .query()
          .filter((i) -> i.id == "frasse")
          .map((i) -> _(i).extend(name : "gurkan"))
          .log()
          .set()
        .store()
        .onstored((branch) ->
          console.log("Second store for branch #{branch.branch()}")))

# Test remove
test_remove = () ->
  master_test_data()
    .ondata((data) ->
      data.remove('frasse')
        .store()
        .onstored((branch) ->
          console.log("Stored removing object for branch #{branch.branch()}")))


# Only run if run as entry point
if not module.parent?
  insert_and_query()
  test_remove()

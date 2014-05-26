Bucket = require("./bucket")
Branch = require("./branch")
Query  = require("./query")

# Entry point
#
# path - The directory to store the bucket and it's branches
module.exports = (path) -> new Bucket(path)


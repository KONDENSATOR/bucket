# This file is used when compiled to JS, hence the strange path to
# bucket module.
Bucket = require('./js/bucket')

module.exports = (path) -> new Bucket(path)


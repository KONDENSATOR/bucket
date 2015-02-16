// Generated by CoffeeScript 1.9.0
(function() {
  var Branch, Bucket, f, instanceid, _;

  _ = require('lodash');

  Branch = require('./branch');

  f = require("./functions");

  instanceid = 0;

  Bucket = (function() {
    function Bucket(path) {
      instanceid += 1;
      this.state = {
        id: "bucket:" + instanceid,
        path: path,
        children: {},
        err: function() {
          return this;
        },
        read: function() {
          return this;
        },
        stored: function() {
          return this;
        }
      };
    }

    Bucket.prototype.path = function() {
      return this.state.path;
    };

    Bucket.prototype.parent = function() {
      return this.state.parent;
    };

    Bucket.prototype.onerr = function(fn) {
      f.onerr(this, fn);
      return this;
    };

    Bucket.prototype.onread = function(fn) {
      f.onread(this, fn);
      return this;
    };

    Bucket.prototype.onstored = function(fn) {
      f.onstored(this, fn);
      return this;
    };

    Bucket.prototype.onoblited = function(fn) {
      f.onoblited(this, fn);
      return this;
    };

    Bucket.prototype.onlisted = function(fn) {
      f.onlisted(this, fn);
      return this;
    };

    Bucket.prototype.onclosed = function(fn) {
      f.onclosed(this, fn);
      return this;
    };

    Bucket.prototype.oblit = function() {
      return f.oblit(this);
    };

    Bucket.prototype.list = function() {
      return f.list(this);
    };

    Bucket.prototype.close = function() {
      return f.close(this);
    };

    Bucket.prototype.use = function(name, fn) {
      var branch;
      if (_.isFunction(name)) {
        fn = name;
        name = 'master';
      }
      if (name == null) {
        name = 'master';
      }
      branch = new Branch(this, name);
      this.state.children[name] = branch;
      f.ensure(this.state.path, (function(_this) {
        return function(err) {
          if (err != null) {
            return _this.state.err(err);
          } else {
            return branch.load(fn);
          }
        };
      })(this));
      return branch;
    };

    return Bucket;

  })();

  module.exports = Bucket;

}).call(this);

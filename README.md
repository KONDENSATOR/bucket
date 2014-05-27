bucket
------

### What is it

It is a simple in memory data-storage that persists to simple json-files, featuring Underscore.js. This makes it fast and easy. The file format is incremental using append only to write.

### Why?

*My database works just fine!* - Yes, and it's probably safer, better, faster and so forth (at least for now).

However there's always the hassle setting up databases in new environments, be it on a new developer machine, test server or production. With bucket you don't need to worry because all there is, is a folder of files. Heck, you can even keep data in the repository if you like.

### Warning

This library is NOT ready for production use!

### Features

* In memory
* Underscore queries
* Incremental persistance
* Transactional
* Chainable
* Easy
  * To install
  * Use
  * Distribute

### Future features

* Branches for persistant transactions
  * Fork
  * Merge
* Data partitioning
* Reactive (yeah there's a buzz word for you)

### Quick start

#### Installation

```
npm install bucket-node --save
```

```coffeescript
bucket = require("bucket-node")
```

#### Querying

```coffeescript
bucket('myfolder')
  .onerror((err) -> console.log(err))
  .use()
  .ondata((data) ->
    result = data.query()
      .filter((item) -> item.name == "nodejs")
      .log()
      .value()
    dosomething(result))
```

* log() is a simple inspector that logs the current value to the console
* value() returns the unwrapped current value

#### Setting and storing

```coffeescript
bucket('myfolder')
  .onerror((err) -> console.log(err))
  .use('master') # master is always default
  .ondata((data) ->
    data.set({id:'myuniqueid', name:'myname', data:'mydata'})
      .store()
      .onstore((branch) -> console.log("Stored data on branch #{branch.branch()}")))
```

#### Querying, manipulating and storing

```coffeescript
bucket('myfolder')
  .onerror((err) -> console.log(err))
  .use()
  .ondata((data) ->
    data.query()
      .filter((item) -> item.name == "nodejs")
      .map((item) -> item.other = "coffee")
      .set()
      .store()
      .onstore((branch) -> console.log("Stored data on branch #{branch.branch()}")))
```

### Licence

The MIT License (MIT)

Copyright (c) 2014 Fredrik Andersson, KONDENSATOR

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

bucket-node
-----------

### What is it

It is a simple in memory data-storage that persists to simple json-files, featuring Underscore.js. This makes it fast and easy. The file format is incremental using append only to write.

### Warning

This library is still under heavy development and should not be used in production as is.

### Features

* In memory
* Underscore queries
* Incremental persistance
* Transactional
* Easy
  * To install
  * Use
  * Distribute

### Future features

* Branches for persistant transactions
  * Fork
  * Merge
* Data partitioning

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
    console.dir(result))
```

#### Setting and storing

```coffeescript
bucket('myfolder')
  .onerror((err) -> console.log(err))
  .use('master') # master is always default
  .ondata((data) ->
    data.set({id:'myuniqueid', name:'myname', data:'mydata'})
    data.store()
    data.onstore((branch) -> "Stored data on branch #{branch.branch()}"))
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

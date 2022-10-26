### v0.6.2 (2021-01-13)
* get rid of paren warnings
* configure elixir formatter
* upgrade all packages to most recent versions
* migrate CI from Travis-CI to Github Actions

### v0.6.1 (2016-01-22)

Elixir 1.2 goodies:

* get rid of paren warnings [thx mindreframer]
* ex_doc compatible with 1.2

### v0.6.0 (2015-10-14)

* `build(expr)` as a simpler counterpart to `build do..`
* update to Elixir 1.1 and OTP 18

### v0.5.1

* impl: in-Core renames, docs etc
* fix Core typespecs (was invalid since bc5d06e - 0.4.0)

### v0.5.0 (2015-02-24)

* DSL: `value/1`
* `builder/1` macro moved to separate module
* impl: DSL revamp

### v0.4.0 (2015-02-24)

* impl: Core revamp
* allow for "partials"

### v0.3.4 (2015-02-23)

* upgrade to Elixir 1.0
* use iolist_to_binary in `flush/1` to reflect how it works with sockets
* text() macro turns arg into a string instead of just passing value

### v0.3.3

* add empty `p` element as it is so often

### v0.3.2

* bugfix: add missing `script` element
* more docs & tests

### v0.3.1

* internal APIs cleanup
* more docs

### v0.3.0

* API simplified: `elements`/`pick` not needed anymore
* better docs
* readme describes features based on an embedded example

### v0.2.0

* API rename: loops & closures unrolling now via `elements`/`pick` macros
* defensive measure against improper nesting without do: block
* small doc & tests improvements

### v0.1.2

* More refactorings & typespec fixes
* Preliminary documentation

### v0.1.1

* Refactoring
* Typespec fixes
* 100% test coverage

### v0.1.0

* Version extracted from my [Rockside] project
* Allows for nesting, nonvoid & void tags,
  loops & closures unrolling via `gather`/`pick` macros.

[rockside]: https://github.com/herenowcoder/rockside

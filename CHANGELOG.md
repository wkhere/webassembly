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

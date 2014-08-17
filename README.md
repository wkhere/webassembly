WebAssembly
===========
[![beauty inside!](http://img.shields.io/badge/beauty-inside-80b0ff.svg)](http://en.wikipedia.org/wiki/Beauty)
[![Build Status](https://travis-ci.org/herenowcoder/webassembly.svg?branch=master)](https://travis-ci.org/herenowcoder/webassembly)
[![Coverage Status](https://img.shields.io/coveralls/herenowcoder/webassembly.svg)](https://coveralls.io/r/herenowcoder/webassembly)
[![hex.pm version](https://img.shields.io/hexpm/v/webassembly.svg)](https://hex.pm/packages/webassembly)
[![hex.pm downloads](https://img.shields.io/hexpm/dt/webassembly.svg)](https://hex.pm/packages/webassembly)

DSL for creating html structure straight with Elixir blocks:

```Elixir
    use WebAssembly
    builder do
      html do
        head do
          meta http_equiv: "Content-Type", content: "text/html"
          title "example"
        end
        body do
          div class: "container", id: :content do
            ul do
              for index<-1..5, do:
                li "item #{index}"
            end
            random = :random.uniform(10)
            if random == 5 do
              text "Lucky! You got five"
            end
          end
          span [style: "smiling"], "that was nice"
        end
      end
    end
```

This results in a deeply nested list (aka [iolist])
which you can flatten or better send to the socket as it is
(via [Plug] & [Cowboy] for example).

Now what can be concluded from an example above:

* you have access to HTML macros inside `builder` block
* HTML macro can be used with flat content or with a `do`-block
* element with a `do`-block means nesting
* inside such a `do`-block you have access to **full Elixir syntax**
* if element has attributes they go first (but are optional), then the content
* attributes are Elixir keywords
* underscores in attribute keys are translated to dash signs
* you can omit brackets around attributes when using `do`-block,
  but not when using flat form
* if you want to emit just text without any html tag, just use `text`.

Isn't it beautiful? For me it is..

## Usage

WebAssembly is on [Hex], so just add `{:webassembly, "~> 0.2"}` to your deps
and `:webassembly` to your apps in the `mix.exs`.

More examples to come - like, how to blend it with [Plug] & stuff..

## Thanks

Loosely inspired by [Markaby].

## License

The code is released under the BSD 2-Clause License.

[markaby]: http://markaby.github.io/
[plug]:    http://hex.pm/packages/plug
[cowboy]:  http://hex.pm/packages/cowboy
[iolist]:  http://www.erlang.org/doc/reference_manual/typespec.html
[hex]:     http://hex.pm

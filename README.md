WebAssembly
===========
[![Build Status](https://travis-ci.org/herenowcoder/webassembly.svg?branch=master)](https://travis-ci.org/herenowcoder/webassembly)
[![Coverage Status](https://img.shields.io/coveralls/herenowcoder/webassembly.svg)](https://coveralls.io/r/herenowcoder/webassembly)

DSL for creating html structure straight with Elixir blocks:

```Elixir
    
    use WebAssembly
    builder do
      html do
        head do
          ctype = "text/html"
          meta http_equiv: "Content-Type", content: ctype
          title "foo"
        end
        body do
          div class: "mydiv" do
            ul do
              li 1
              if all_goes_well, do:
                li "second"
            end
          end
          text "that was nice"
        end
      end
    end
```

This results in a deeply nested list (aka [iolist])
which you can flatten or send directly to the socket
(via [Plug] & [Cowboy] for example).
 
Loosely inspired by [Markaby].

[markaby]: http://markaby.github.io/
[plug]:    http://hex.pm/packages/plug
[cowboy]:  http://hex.pm/packages/cowboy
[iolist]:  http://www.erlang.org/doc/reference_manual/typespec.html

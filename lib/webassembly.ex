defmodule WebAssembly do
  @moduledoc ~S"""
  Wrapper module for assembling html elements from blocks into iolist.

  The moving parts are: elements DSL (`WebAssembly.DSL`),
  HTML macros (`WebAssembly.HTML`) and a context in which
  they should be used, provided by Builder (`WebAssembly.Builder`).

  These modules are automatically imported, so you just use:

      use WebAssembly
      builder do
        div class: "container" do
          n = get_the_size
          if n > 1 do
            ul do
              for index <- 1..n, do:
                li "item #{index}"
            end
          else
            span "got only one item"
          end
        end
      end
  """

  # ^todo: mode docs on nesting, loops, partials ..etc

  defmacro __using__(_opts) do
    quote do
      import WebAssembly.DSL
      import WebAssembly.Builder
      use WebAssembly.HTML
      :ok
    end
  end
end

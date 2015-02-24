defmodule WebAssembly.Builder do
  @moduledoc """
  Provide context for using the elements DSL (`WebAssembly.DSL`)
  and possibly HTML macros (`WebAssembly.HTML` module).
  """

  @doc ~S"""
  Generate iolist from HTML elements given in a block with the DSL.
  """
  # ^ todo: link to examples, eg. in `WebAssembly` doc
  defmacro builder(do_block)

  defmacro builder(do: body) do
    quote do
      import  WebAssembly.DSL.Internal
      WebAssembly.Core.Builder.start
      with_scope do: unquote(body)
      WebAssembly.Core.Builder.finish
    end
  end
end

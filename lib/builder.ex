defmodule WebAssembly.Builder do
  @moduledoc """
  Provide context for using the elements DSL (`WebAssembly.DSL`)
  and possibly HTML macros (`WebAssembly.HTML` module).
  """

  @doc ~S"""
  Generate iolist from HTML elements given in a block with the DSL.

  Code being run in the block can be split into different fuctions
  (this is an equivalent of partial templates).
  Builder is guaranteed to work as long as calls happen in the same
  Erlang process, which is typical for the intended use (webapp
  controllers/handlers).
  """
  # ^ todo: link to examples, eg. in `WebAssembly` doc
  defmacro builder(do_block_or_expr)

  defmacro builder(do: body) do
    quote do
      import  WebAssembly.DSL.Internal
      WebAssembly.Core.Engine.fire
      with_scope do: unquote(body)
      WebAssembly.Core.Engine.return
    end
  end

  defmacro build(expr) do
    quote do: (builder do: unquote(expr))
  end
end

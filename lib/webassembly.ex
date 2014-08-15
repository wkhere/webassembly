defmodule WebAssembly do
  defmacro __using__(_opts) do
    quote do
      import WebAssembly.DSL
      use    WebAssembly.HTML
    end
  end
end

defmodule WebAssembly do
  defmacro __using__(_opts) do
    quote do
      use WebAssembly.DSL
    end
  end
end

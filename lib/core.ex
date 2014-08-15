alias WebAssembly.Core

defmodule Core do

  defmodule St do
    require WebAssembly.Types, as: T

    defstruct stack: []
    @type t :: %St{stack: [T.content]}

    @spec new() :: t
    def new, do: %__MODULE__{}

    @spec push(t, T.content) :: t
    def push(%{stack: s} = state, elem) do
      %{state | stack: [elem|s]}
    end

    @spec release(t) :: [T.content]
    def release(%{stack: s} = _state), do: Enum.reverse(s)
  end

end

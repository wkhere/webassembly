alias WebAssembly.Core

defmodule Core do
  @moduledoc """
  Module encapsulating assembly state `WebAssembly.Core.St` and tools around it.
  """

  defmodule St do
    @moduledoc """
    State of markup assembly in the current scope.
    """
    require WebAssembly.Types, as: T

    defstruct stack: []
    @opaque t :: %St{stack: [T.content]}

    @doc """
    Creates new empty state.
    """
    @spec new() :: t
    def new, do: %__MODULE__{}

    @doc """
    Pushes `value` into the `state`.
    """
    @spec push(t, T.content) :: t
    def push(_, %__MODULE__{} = value) do
      raise ArgumentError, "cant push state as a value: #{inspect value}"
    end
    def push(%{stack: s} = state, value) do
      %{state | stack: [value|s]}
    end

    @doc """
    Releases the `state`, returning values in the order of pushing.
    """
    @spec release(t) :: [T.content]
    def release(%{stack: s} = _state), do: Enum.reverse(s)
  end

end

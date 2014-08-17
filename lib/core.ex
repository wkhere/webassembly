alias WebAssembly.Core

defmodule Core do
  @moduledoc """
  Core of the markup assembly.

  Consists of two parts:

  * `WebAssembly.Core.St` - a functional state of markup in the current block
  * `WebAssembly.Core.Scope` - a wrapper around functional state, allowing for
    mutable operations on it
  """
  require WebAssembly.Types, as: T


  defmodule St do
    @moduledoc """
    Pure-functional state of markup assembly in the current block.
    """

    defstruct stack: []
    @opaque t :: %St{stack: [T.content]}

    @doc """
    Creates new empty state.
    """
    @spec new() :: t
    def new, do: %__MODULE__{}

    @doc """
    Pushes `value` into the `state`, returning a new one.
    """
    @spec push(t, T.content) :: t
    def push(%{stack: s} = state, value) do
      %{state | stack: [value|s]}
    end

    @doc """
    Releases the `state`, returning values in the order of pushing.
    """
    @spec release(t) :: [T.content]
    def release(%{stack: s} = _state), do: Enum.reverse(s)
  end


  defmodule Scope do
    @moduledoc """
      Mutability wrapper around `WebAssembly.Core.St`.

      Corresponds to the inner content of currently assembled
      element.

      Internally uses `Agent`s.
    """

    @doc """
    Creates new mutable scope to hold the state of elements assembly.

    Returns `pid` of the underlying Agent one can operate on.
    """
    @spec new!() :: pid
    def new! do
      {:ok, pid} = Agent.start_link(fn -> St.new end)
      pid
    end

    @doc """
    Pushes a `value` into the assembly scope given by `pid`.

    Returns changed internal state.
    """
    @spec push!(pid, T.content) :: St.t
    def push!(pid, value)

    def push!(_, %St{} = value) do
      raise ArgumentError, "cant push state as a value: #{inspect value}"
      # todo: try to detect pathological situation by other means
    end
    def push!(pid, value) do
      Agent.get_and_update(pid, fn st0 ->
        st = St.push(st0, value)
        {st, st}
      end)
    end

    @doc """
    Releases the assembly scope given by `pid`, returning
    values in the order of pushing.

    Stops underlying Agent.
    """
    @spec release!(pid) :: [T.content]
    def release!(pid) do
      result = Agent.get(pid, fn st -> St.release(st) end)
      :ok = Agent.stop(pid)
      result
    end
  end
end

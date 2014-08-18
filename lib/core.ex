alias WebAssembly.Core

defmodule Core do
  @moduledoc """
  Core of the elements assembly.

  Consists of two parts:

  * `WebAssembly.Core.St` - state of assembly in the current block
  * `WebAssembly.Core.Scope` - wrapper around state, allowing for
     mutable operations on it
  """
  require WebAssembly.Types, as: T


  defmodule St do
    @moduledoc """
    Pure-functional state of elements assembly in the current block.
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

      Internally uses Agents.
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
    """
    @spec push!(pid, T.content) :: :ok
    def push!(pid, value) do
      Agent.update(pid, fn st0 -> St.push(st0, value) end)
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

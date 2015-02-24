defmodule WebAssembly.Core do
  @moduledoc false

  defmodule Engine do
    @moduledoc """
    Elements-assembling engine used internally by `WebAssembly.Builder` and `WebAssembly.DSL`.
    """

    @s __MODULE__
    @pid_key :webassembly_engine_pid

    defstruct scopes: [], result: nil

    require WebAssembly.Types, as: T

    defp pid(), do: Process.get(@pid_key)


    @doc """
    Fire up the engine accessible within the current Erlang process.
    """
    @spec fire() :: :ok
    def fire() do
      {:ok, pid} = Agent.start_link(fn -> %@s{} end)
      Process.put(@pid_key, pid)
      :ok
    end

    @doc """
    Open new scope.
    """
    @spec new_scope() :: :ok
    def new_scope() do
      Agent.update(pid, fn %{scopes: scopes} = state -> 
        %{ state | scopes: [[]|scopes] }
      end)
    end

    @doc """
    Push `val` into the current scope.
    """
    @spec push(T.content) :: :ok
    def push(val) do
      Agent.update(pid, fn %{scopes: [scope|prevs]} = state ->
        %{ state | scopes: [[val|scope] | prevs] }
      end)
    end

    @doc """
    Release the current scope, merging it with the uplevel one.

    If this was last scope, prepare the engine for `return/0`.
    """
    @spec release_scope() :: :ok
    def release_scope() do
      import Enum, only: [reverse: 1]

      Agent.update(pid, fn
        %{scopes: [scope1,scope0|prevs]} = state ->
          scope_merged = [reverse(scope1) | scope0]
          %{ state | scopes: [scope_merged | prevs] }

        %{scopes: [scope]} ->
          %@s{ result: reverse(scope), scopes: :released }
      end)
    end

    @doc """
    Shutdown the engine and return the assembled structure.
    """
    @spec return() :: [T.content]
    def return() do
      result = Agent.get(pid, fn
        %{scopes: :released, result: res} ->
        res
      end)
      :ok = Agent.stop(pid)
      result
    end
  end
end

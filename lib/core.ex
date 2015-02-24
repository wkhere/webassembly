alias WebAssembly.Core

defmodule Core do
  #@moduledoc "Core of the elements assembly."
  @moduledoc false #todo

  defmodule Builder do
    @s __MODULE__
    @pid_key :builder_pid

    defstruct scopes: [], result: nil

    require WebAssembly.Types, as: T

    defp pid(), do: Process.get(@pid_key)

    @spec fire() :: :ok
    def fire() do
      {:ok, pid} = Agent.start_link(fn -> %@s{} end)
      Process.put(@pid_key, pid)
      :ok
    end

    @spec new_scope() :: :ok
    def new_scope() do
      Agent.update(pid, fn %{scopes: scopes} = state -> 
        %{ state | scopes: [[]|scopes] }
      end)
    end

    @spec push(T.content) :: :ok
    def push(val) do
      Agent.update(pid, fn %{scopes: [scope|prevs]} = state ->
        %{ state | scopes: [[val|scope] | prevs] }
      end)
    end

    @spec release_scope() :: :ok
    def release_scope() do
      import Enum, only: [reverse: 1]

      Agent.update(pid, fn
        %{scopes: [scope1,scope0|prevs]} = state ->
          scope_merged = [reverse(scope1) | scope0]
          %{ state | scopes: [scope_merged | prevs] }

        %{scopes: [scope|[]]} ->
          %@s{ result: reverse(scope), scopes: :finished }
      end)
    end

    @spec return() :: [T.content]
    def return() do
      result = Agent.get(pid, fn
        %{scopes: :finished, result: res} ->
        res
      end)
      :ok = Agent.stop(pid)
      result
    end
  end
end

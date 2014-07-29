alias Rockside.HTML

defmodule HTML.Assembly do

  defmodule St do
    defstruct stack: []
    @type t :: %St{stack: list}

    @spec new() :: t
    def new, do: %__MODULE__{}

    @spec push(t, any) :: t
    def push(st = %{stack: s}, elem) do
      %{st | stack: [elem|s]}
    end

    @spec release(t) :: list
    def release(%{stack: s}), do: Enum.reverse(s)
  end

end

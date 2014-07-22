alias Rockside.HTML

defmodule HTML.Assembly do

  defmodule St do
    defstruct stack: []

    def new, do: %__MODULE__{}

    def push(st = %{stack: s}, elem) do
      %{st | stack: [elem|s]}
    end

    def release(%{stack: s}), do: Enum.reverse(s)
  end

end

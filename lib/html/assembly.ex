alias Rockside.HTML

defmodule HTML.Assembly do

  defmodule St do
    require HTML.Assembly.Types, as: T

    defstruct stack: []
    @type t :: %St{stack: [T.content]}

    @spec new() :: t
    def new, do: %__MODULE__{}

    @spec push(t, T.content) :: t
    def push(st = %{stack: s}, elem) do
      %{st | stack: [elem|s]}
    end

    @spec release(t) :: [T.content]
    def release(%{stack: s}), do: Enum.reverse(s)
  end

end

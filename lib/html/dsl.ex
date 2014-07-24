alias Rockside.HTML

defmodule HTML.DSL do
  alias   Rockside.HTML.Assembly.St
  require St

  defmodule Helpers do
    defmacro tag_start(tag) do
      quote do: "<#{unquote(tag)}>"
    end
    defmacro tag_end(tag) do
      quote do: "</#{unquote(tag)}>"
    end
  end


  # basic api

  defmacro builder(do: body) do
    quote do
      alias Rockside.HTML.Assembly.St
      var!(st) = St.new
      unquote(body)
      St.release(var!(st))
    end
  end

  defmacro add_tag(tagname, content) do
    quote do
      import Helpers
      alias Rockside.HTML.Assembly.St
      var!(st) = var!(st) |> St.push(tag_start(unquote(tagname)))
      var!(st) = var!(st) |> St.push(unquote(content))
      var!(st) = var!(st) |> St.push(tag_end(unquote(tagname)))
    end
  end

  defmacro tag(tagname, do: body) do
    quote do
      add_tag(unquote(tagname), fn ->
        builder do: unquote(body)
      end.())
    end
  end

  defmacro tag(tagname, content) do
    quote do: add_tag(unquote(tagname), unquote(content))
  end

  ~w[div]
    |> Enum.each fn name ->
      sym = :"#{name}"
      defmacro unquote(sym)(whatever) do
        t = unquote(sym)
        quote do: tag(unquote(t), unquote(whatever))
      end
    end

  defmacro text(content) do
    quote do
      var!(st) = var!(st) |> St.push(unquote(content))
    end
  end

end

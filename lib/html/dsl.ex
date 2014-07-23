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

  defmacro div(do: body) do
    quote do
      add_tag(:div, fn ->
        builder do: unquote(body)
      end.())
    end
  end

  defmacro div(content) do
    quote do: add_tag(:div, unquote(content))
  end

end

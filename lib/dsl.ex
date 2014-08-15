defmodule WebAssembly.DSL do
  alias   WebAssembly.Core.St
  require St


  defmodule TagChunks do
    import WebAssembly.Tools, only: [htmlize_attrs: 1]

    defmacro tag_start(tag, []) do
      quote do: "\n<#{unquote(tag)}>"
    end
    defmacro tag_start(tag, attrs) do
      quote do: ["\n<#{unquote(tag)} ", htmlize_attrs(unquote(attrs)), ">"]
    end

    defmacro tag_end(tag) do
      quote do: "</#{unquote(tag)}>"
    end

    defmacro tag_only(tag, []), do:
      quote do: "<#{unquote(tag)} />"
    defmacro tag_only(tag, attrs) do
      quote do: ["\n<#{unquote(tag)} ", htmlize_attrs(unquote(attrs)), " />"]
    end
  end


  # basic api

  defmacro builder(do: body) do
    quote do
      alias WebAssembly.Core.St
      var!(st) = St.new
      unquote(body)
      St.release(var!(st))
    end
  end

  defmacro add_val!(v) do
    quote do
      var!(st) = var!(st) |> St.push(unquote(v))
    end
  end

  defmacro add_tag!(tagname, attrs, content) do
    quote do
      import TagChunks
      add_val! tag_start(unquote(tagname), unquote(attrs))
      add_val! unquote(content)
      add_val! tag_end(unquote(tagname))
    end
  end

  defmacro add_tag_void!(tagname, attrs) do
    quote do
      import TagChunks
      add_val! tag_only(unquote(tagname), unquote(attrs))
    end
  end

  defmacro tag(tagname, attrs\\[], rest)

  defmacro tag(tagname, attrs, do: body) do
    quote do
      add_tag!(unquote(tagname), unquote(attrs), fn ->
        builder do: unquote(body)
      end.())
    end
  end

  defmacro tag(tagname, attrs, content) do
    quote do: add_tag!(unquote(tagname), unquote(attrs), unquote(content))
  end

  defmacro tag_void(tagname, attrs\\[]) do
    quote do: add_tag_void!(unquote(tagname), unquote(attrs))
  end

  # pick / gather for loops & closures

  defmacro pick(expr) do
    quote do
      unquote(expr)
      var!(st)
    end
  end

  defmacro gather(new_scope_expr) do
    quote do
      inner_content = case unquote(new_scope_expr) do
        states when is_list(states) ->
          states |> Enum.map fn st=%St{} -> St.release(st) end
        st=%St{} ->
          St.release(st)
      end
      add_val! inner_content
    end
  end

  # todo: somehow prevent from span(span("a"))

end

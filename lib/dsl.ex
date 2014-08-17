defmodule WebAssembly.DSL do
  @moduledoc """
  DSL for assembling tag blocks into iolist.

  Tag blocks can be intermixed with regular Elixir syntax.
  """

  alias   WebAssembly.Core.Scope
  require Scope


  defmodule TagChunks do
    @moduledoc """
    Macros producing iolist with tag starts & ends plus tag attributes.
    """
    import WebAssembly.Tools.Input, only: [htmlize_attrs: 1]

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


  # internal api

  defmacro add_val!(v) do
    quote do
      var!(scope!) |> Scope.push!(unquote(v))
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


  # basic api

  defmacro builder(do_block)

  defmacro builder(do: body) do
    quote do
      fn ->
        alias WebAssembly.Core.Scope
        var!(scope!) = Scope.new!
        unquote(body)
        Scope.release!(var!(scope!))
      end.()
    end
      # the fn above is crucial -> it introduces new lexical
      # scope, so our `scope!` var doesn't gets overwritten
  end

  defmacro tag(tagname, attrs\\[], rest)

  defmacro tag(tagname, attrs, do: body) do
    quote do
      add_tag!(unquote(tagname), unquote(attrs),
        builder do: unquote(body))
    end
  end

  defmacro tag(tagname, attrs, content) do
    quote do: add_tag!(unquote(tagname), unquote(attrs), unquote(content))
  end

  defmacro tag_void(tagname, attrs\\[]) do
    quote do: add_tag_void!(unquote(tagname), unquote(attrs))
  end

  # unrolling loops & closures

  #defmacro pick(expr) do
  #  quote do
  #    unquote(expr)
  #    var!(st)
  #  end
  #end

  #  defmacro elements(new_scope_expr) do
  #    quote do
  #      inner_content = case unquote(new_scope_expr) do
  #        states when is_list(states) ->
  #          for st=%St{} <- states, do: St.release(st)
  #        st=%St{} ->
  #          St.release(st)
  #      end
  #      add_val! inner_content
  #    end
  #  end

end

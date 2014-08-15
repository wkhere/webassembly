defmodule WebAssembly.DSL do
  alias   WebAssembly.Core.St
  require St

  defmacro __using__(_opts) do
    quote do
      import Kernel, except: [div: 2]
      import WebAssembly.DSL
    end
  end


  defmodule Helpers do
    import WebAssembly.Tools, only: [htmlize_attrs: 1]

    defmacro tag_start(tag, []) do
      quote do: "<#{unquote(tag)}>"
    end
    defmacro tag_start(tag, attrs) do
      quote do: ["<#{unquote(tag)} ", htmlize_attrs(unquote(attrs)), ">"]
    end

    defmacro tag_end(tag) do
      quote do: "</#{unquote(tag)}>"
    end

    defmacro tag_only(tag, []), do:
      quote do: "<#{unquote(tag)} />"
    defmacro tag_only(tag, attrs) do
      quote do: ["<#{unquote(tag)} ", htmlize_attrs(unquote(attrs)), " />"]
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
      import Helpers
      add_val! tag_start(unquote(tagname), unquote(attrs))
      add_val! unquote(content)
      add_val! tag_end(unquote(tagname))
    end
  end

  defmacro add_tag_void!(tagname, attrs) do
    quote do
      import Helpers
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


  @html_nonvoid_tags ~w[
    head title style
    noscript template
    body section nav article aside h1 h2 h3 h4 h5 h6
    header footer address main
    p pre blockquote ol ul li dl dt dd figure figcaption div
    a em strong small s cite q dfn abbr data time code var samp kbd
    sub sup i b u mark ruby rt rp bdi bdo span
    ins del
    iframe object video audio canvas
    map svg math
    table caption colgroup tbody thead tfoot tr td th
    form fieldset legend label button select datalist optgroup
    option textarea ceygen output progress meter
    details summary menuitem menu
    ]a

  # http://www.w3.org/TR/html5/syntax.html#void-elements
  @html_void_tags ~w[
    meta link base
    area br col embed hr img input keygen param source track wbr
    ]a

  @html_nonvoid_tags |> Enum.each fn tag ->
      defmacro unquote(tag)(attrs\\[], whatever) do
        t = unquote(tag)
        quote do: tag(unquote(t), unquote(attrs), unquote(whatever))
      end
    end

  @html_void_tags |> Enum.each fn tag ->
      defmacro unquote(tag)(attrs\\[]) do
        t = unquote(tag)
        quote do: tag_void(unquote(t), unquote(attrs))
      end
    end

  defmacro html(attrs\\[], whatever) do
    quote do
      add_val! "<!DOCTYPE html>"
      tag(:html, unquote(attrs), unquote(whatever))
    end
  end

  defmacro text(content) do
    quote do: add_val! unquote(content)
  end

  def html_nonvoid_tags, do: @html_nonvoid_tags
  def html_void_tags, do: @html_void_tags
end

alias Rockside.HTML

defmodule HTML.DSL do
  alias   Rockside.HTML.Assembly.St
  require St

  defmodule Helpers do
    import Rockside.HTML.Assembly.Tools, only: [htmlize_attrs: 1]

    defmacro tag_start(tag, []) do
      quote do: "<#{unquote(tag)}>"
    end
    defmacro tag_start(tag, attrs) do
      quote do: ["<#{unquote(tag)} ", htmlize_attrs(unquote(attrs)), ">"]
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
          states |> Enum.map fn st=%St{stack: _} -> St.release(st) end
        st=%St{stack: _} ->
          St.release(st)
      end
      add_val! inner_content
    end
  end

  # todo: somehow prevent from span(span("a"))

  ~w[
    html head title base link meta style
    script noscript template
    body section nav article aside h1 h2 h3 h4 h5 h6
    header footer address main
    p hr pre blockquote ol ul li dl dt dd figure figcaption div
    a em strong small s cite q dfn abbr data time code var samp kbd
    sub sup i b u mark ruby rt rp bdi bdo span br wbr
    ins del
    img iframe embed object param video audio source track canvas
    map area svg math
    table caption colgroup col tbody thead tfoot tr td th
    form fieldset legend label input button select datalist optgroup
    option textarea keygen output progress meter
    details summary menuitem menu
    ] |> Enum.each fn name ->
      sym = :"#{name}"
      defmacro unquote(sym)(attrs\\[], whatever) do
        t = unquote(sym)
        quote do: tag(unquote(t), unquote(attrs), unquote(whatever))
      end
    end

  defmacro text(content) do
    quote do: add_val! unquote(content)
  end

end

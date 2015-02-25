defmodule WebAssembly.DSL do
  @moduledoc """
  Basic DSL for assembling HTML elements from blocks.
  """


  @doc ~S"""
  Create HTML element in the assembly scope,
  possibly nesting a new scope.

  New scope for inner elements is created when
  this macro is called with a `do`-block.

  Should be called inside the `WebAssembly.Builder` context.

  Expects `attributes` to be Elixir keywords.
  They will get converted into HTML format.
  Underscores in keys will be converted to dash signs. 

  This macro is to be used by `WebAssembly.HTML` module,
  unless you want to invent your own elements.

  ## Examples

      iex> build element :div, do: (element :span, "foo")
      ["\n<div>", ["\n<span>", "foo", "</span>"], "</div>"]

      iex> build(element :a,
      iex>    [href: "#foo", data_toggle: "modal"], "bar")
      iex> |> WebAssembly.Tools.Output.flush
      "\n<a href=\"#foo\" data-toggle=\"modal\">bar</a>"

  """
  defmacro element(name, attributes\\[], content)

  defmacro element(name, attributes, do: body) do
    quote do
      import WebAssembly.DSL.Internal
      add_scoped_element!(unquote(name), unquote(attributes),
        with_scope do: unquote(body))
    end
  end

  defmacro element(name, attributes, flat_content) do
    quote do
      import WebAssembly.DSL.Internal
      add_element!(unquote(name),
        unquote(attributes), unquote(flat_content))
    end
  end


  @doc ~S"""
  Create HTML void element (ie. element without content)
  in the assembly scope.

  Should be called inside the `WebAssembly.Builder` context.

  See `element/3` for explanation on the format of `attributes`.

  This macro is to be used by `WebAssembly.HTML` module,
  unless you want to invent your own elements.

  ## Examples

      iex> build(void_element :meta,
      iex>    http_equiv: "Content-Type", content: "text/html")
      iex> |> WebAssembly.Tools.Output.flush
      "\n<meta http-equiv=\"Content-Type\" content=\"text/html\" />"

  """
  defmacro void_element(name, attributes\\[]) do
    quote do
      import WebAssembly.DSL.Internal
      add_void_element!(unquote(name), unquote(attributes))
    end
  end


  @doc ~S"""
  Create any value in the assembly scope.

  Should be called inside the `WebAssembly.Builder` context.

  Please note there's no typechecking here and the final result
  will be treated as an iolist.
  Means: if unsure, put only strings here.

  ## Examples

      iex> build value "what are your values?"
      ["what are your values?"]
      iex> build(element :foo, do: value "bar")
      iex> |> WebAssembly.Tools.Output.flush
      "\n<foo>bar</foo>"
  """
  defmacro value(val) do
    quote do: add_value!(unquote(val))
  end
end


defmodule WebAssembly.DSL.Internal do
  @moduledoc false #todo

  defmodule Tags do
    @moduledoc false

    import WebAssembly.Tools.Input, only: [htmlize_attributes: 1]

    defmacro tag_start(tag, []) do
      quote do: "\n<#{unquote(tag)}>"
    end
    defmacro tag_start(tag, attributes) do
      quote do: ["\n<#{unquote(tag)} ",
                  htmlize_attributes(unquote(attributes)), ">"]
    end

    defmacro tag_end(tag) do
      quote do: "</#{unquote(tag)}>"
    end

    defmacro tag_only(tag, []), do:
      quote do: "<#{unquote(tag)} />"
    defmacro tag_only(tag, attributes) do
      quote do: ["\n<#{unquote(tag)} ",
                  htmlize_attributes(unquote(attributes)), " />"]
    end
  end


  @doc """
  Manage assembly scopes.
  """
  defmacro with_scope(do_block)

  defmacro with_scope(do: body) do
    quote do
      WebAssembly.Core.Engine.new_scope
      unquote(body)
      WebAssembly.Core.Engine.release_scope
    end
  end

  defmacro add_value!(value) do
    quote do
      WebAssembly.Core.Engine.push(unquote(value))
    end
  end

  defmacro add_scoped_element!(name, attributes, content) do
    quote do
      import Tags
      add_value! tag_start(unquote(name), unquote(attributes))
      unquote(content)
      add_value! tag_end(unquote(name))
    end
  end

  defmacro add_element!(name, attributes, content) do
    quote do
      import Tags
      add_value! tag_start(unquote(name), unquote(attributes))
      add_value! unquote(content)
      add_value! tag_end(unquote(name))
    end
  end

  defmacro add_void_element!(name, attributes) do
    quote do
      import Tags
      add_value! tag_only(unquote(name), unquote(attributes))
    end
  end
end

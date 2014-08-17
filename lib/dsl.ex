defmodule WebAssembly.DSL do
  @moduledoc """
  Basic DSL for assembling HTML elements from blocks into iolist.

  You shouldn't be using this module directly except of `builder/1` macro.
  """

  alias   WebAssembly.Core.Scope
  require Scope


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


  defmodule Internal do
    @moduledoc false
      
    defmacro add_value!(value) do
      quote do
        var!(scope!) |> Scope.push!(unquote(value))
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

  # basic api

  @doc """
  Manage assembly scopes.

  All HTML macros must be called within the provided block. 
  """
  defmacro builder(do_block)

  defmacro builder(do: body) do
    quote do
      alias WebAssembly.Core.Scope
      import Internal
      fn ->
        var!(scope!) = Scope.new!
        unquote(body)
        Scope.release!(var!(scope!))
      end.()
    end
      # the fn above is crucial -> it introduces new lexical
      # scope, so our `scope!` var doesn't gets overwritten
  end


  @doc ~S"""
  Create HTML element in the assembly scope,
  possibly creating new scope.

  If called with a block, introduces a new scope for nested elements.

  Must be called inside `builder/1` block.

  Expects `attributes` to be Elixir keywords.
  They will get converted into HTML format.
  Underscores in keys will be converted to dash signs. 

  This macro is to be used by `WebAssembly.HTML` module.

  ## Examples

      iex> builder do: (element :div, do: (element :span, "foo"))
      ["\n<div>", ["\n<span>", "foo", "</span>"], "</div>"]

      iex> (builder do: element(:a,
      iex>    [href: "#foo", data_toggle: "modal"], "bar"))
      iex> |> WebAssembly.Tools.Output.flush
      "\n<a href=\"#foo\" data-toggle=\"modal\">bar</a>"

  """
  defmacro element(name, attributes\\[], content)

  defmacro element(name, attributes, do: body) do
    quote do
      add_element!(unquote(name), unquote(attributes),
        builder do: unquote(body))
    end
  end

  defmacro element(name, attributes, flat_content) do
    quote do: add_element!(unquote(name),
      unquote(attributes), unquote(flat_content))
  end


  @doc ~S"""
  Create HTML void element (ie. element without content)
  in the assembly scope.

  Must be called inside `builder/1` block.

  See `element/3` for explanation on the format of `attributes`.

  This macro is to be used by `WebAssembly.HTML` module.

  ## Examples

      iex> (builder do: void_element(:meta,
      iex>    http_equiv: "Content-Type", content: "text/html"))
      iex> |> WebAssembly.Tools.Output.flush
      "\n<meta http-equiv=\"Content-Type\" content=\"text/html\" />"

  """
  defmacro void_element(name, attributes\\[]) do
    quote do: add_void_element!(unquote(name), unquote(attributes))
  end

end

defmodule WebAssembly.HTML do
  @moduledoc """
  HTML5 wrapper macros to be used inside `WebAssembly.DSL.builder/1`.
  """

  defmacro __using__(_opts) do
    quote do
      import Kernel, except: [div: 2]
      import WebAssembly.HTML
    end
  end

  import WebAssembly.DSL

  @nonvoid_tags ~w[
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
    option textarea output progress meter
    details summary menuitem menu
    ]a

  # http://www.w3.org/TR/html5/syntax.html#void-elements
  @void_tags ~w[
    meta link base
    area br col embed hr img input keygen param source track wbr
    ]a

  # macros generation

  @nonvoid_tags |> Enum.each fn tag ->
      defmacro unquote(tag)(attrs\\[], content) do
        t = unquote(tag)
        quote do: tag(unquote(t), unquote(attrs), unquote(content))
      end
    end

  @void_tags |> Enum.each fn tag ->
      defmacro unquote(tag)(attrs\\[]) do
        t = unquote(tag)
        quote do: tag_void(unquote(t), unquote(attrs))
      end
    end

  # special cases

  defmacro html(attrs\\[], content) do
    quote do
      add_val! "<!DOCTYPE html>"
      tag(:html, unquote(attrs), unquote(content))
    end
  end

  defmacro text(content) do
    quote do: add_val! unquote(content)
  end

  # meta helpers

  def nonvoid_tags, do: @nonvoid_tags
  def void_tags, do: @void_tags
end

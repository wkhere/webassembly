defmodule WebAssembly.Tools do
  @moduledoc """
  Tools manipulating assembly input & output.

  See `WebAssembly.Tools.Input` & `WebAssembly.Tools.Output`.
  """

  alias WebAssembly.Types, as: T


  defmodule Input do

    @doc ~S"""
    Turn a keyword list of attributes to an list of attribute framgents
    in a format used by html.

    Underscores in key names are turned into dash signs.

    ## Examples
        iex> WebAssembly.Tools.Input.htmlize_attributes(class: "light", id: :myid)
        ["class=\"light\"", " ", "id=\"myid\""]

        iex> WebAssembly.Tools.Input.htmlize_attributes(http_equiv: "Content-Type")
        ["http-equiv=\"Content-Type\""]
    """

    @spec htmlize_attributes(T.attributes) :: T.assembled_attributes

    def htmlize_attributes(attrs) do
      Enum.map(attrs, fn {k,v} ->
      k = k |> to_string |> String.replace("_", "-")
        ~s/#{k}="#{v}"/
      end)
      |> Enum.intersperse(" ")
    end
  end


  defmodule Output do

    @doc ~S"""
    Flush nested list of HTML elements into a flat string.

    Flushing is not needed when you pass deep list of elements
    directly to Plug. Still it may come handy when testing,
    prototyping or using WebAssembly output together with
    template-based views.

    ## Examples
        iex(1)> use WebAssembly
        :ok
        iex(2)> doc = builder do: div do: (span "hey!")
        ["\n<div>", ["\n<span>", "hey!", "</span>"], "</div>"]
        iex(3)> WebAssembly.Tools.Output.flush doc
        "\n<div>\n<span>hey!</span></div>"
    """

    @spec flush(T.assembled_elements) :: binary

    def flush(chunks) when is_list(chunks) do
      chunks |> List.flatten |> Enum.join
    end
  end
end

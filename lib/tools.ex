defmodule WebAssembly.Tools do
  alias WebAssembly.Core.Types, as: T

  @spec htmlize_attrs(T.attrs) :: [String.t]

  def htmlize_attrs(attrs) do
    Enum.map(attrs, fn {k,v} ->
    k = k |> to_string |> String.replace("_", "-")
      ~s/#{k}="#{v}"/
    end)
    |> Enum.intersperse(" ")
  end


  @spec flush(T.out_tag) :: String.t

  def flush(chunks) when is_list(chunks) do
    chunks |> List.flatten |> Enum.join
  end
  # flush/1 needed only for plug-free tests, because patched Plug
  # accepts iolist as a resp body

end

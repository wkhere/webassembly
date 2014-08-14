ExUnit.start

defmodule WebAssembly.TestHelper do
  def flush(doc) do
    doc |> WebAssembly.Tools.flush |> no_lf
  end

  def no_lf(s), do: String.replace(s, "\n", "")
  def no_indent(s), do: Regex.replace(~r/^\s+/m, s, "")
end

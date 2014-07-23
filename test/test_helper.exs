ExUnit.start

defmodule Rockside.HTML.TestHelper do
  def flush(doc) do
    doc |> Rockside.HTML.Assembly.Tools.flush |> no_lf
  end

  def no_lf(s), do: String.replace(s, "\n", "")
  def no_indent(s), do: Regex.replace(~r/^\s+/m, s, "")
end

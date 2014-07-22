ExUnit.start

defmodule Rockside.HTML.TestHelper do
  def flush(doc) do
    doc |> Rockside.HTML.TagBase.Tools.flush |> no_lf
  end

  def no_lf(s), do: String.replace(s, "\n", "")
  def no_ws(s), do: Regex.replace(~r/\s/, s, "")
end

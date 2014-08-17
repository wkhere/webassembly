defmodule WebAssembly.HexDescExample.Test do
  use ExUnit.Case
  import WebAssembly.TestHelper

  defp get_the_size, do: 2

  test "example" do
    use WebAssembly
    doc = builder do
        div class: "container" do
          n = get_the_size
          if n > 1 do
            ul do
              for index <- 1..n, do:
                li "item #{index}"
            end
          else
            span "got only one item"
          end
        end
    end
    assert doc |> flush == """
      <div class="container">
        <ul>
          <li>item 1</li>
          <li>item 2</li>
        </ul>
      </div>
      """
      |> no_indent |> no_lf
  end
end

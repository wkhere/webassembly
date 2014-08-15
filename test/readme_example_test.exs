defmodule WebAssembly.ReadmeExample.Test do
  use ExUnit.Case
  import WebAssembly.TestHelper
  import WebAssembly.Examples

  test "example" do
    assert readme_ex |> flush == """
    <!DOCTYPE html><html>
      <head>
        <meta http-equiv="Content-Type" content="text/html" />
        <title>foo</title>
      </head>
      <body>
        <div class="mydiv">
          <ul>
            <li>1</li>
            <li>second</li>
          </ul>
        </div>
        that was nice
      </body>
    </html>
    """
    |> no_indent |> no_lf
  end
end

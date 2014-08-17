defmodule WebAssembly.ReadmeExample.Test do
  use ExUnit.Case
  import WebAssembly.TestHelper
  import WebAssembly.Examples

  test "example" do
    assert readme_ex |> flush == """
    <!DOCTYPE html><html>
      <head>
        <meta http-equiv="Content-Type" content="text/html" />
        <title>example</title>
      </head>
      <body>
        <div class="container" id="content">
          <ul>
            <li>item 1</li>
            <li>item 2</li>
            <li>item 3</li>
            <li>item 4</li>
            <li>item 5</li>
          </ul>
          Lucky! You got five
        </div>
        that was nice
      </body>
    </html>
    """
    |> no_indent |> no_lf
  end
end

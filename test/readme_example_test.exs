defmodule WebAssembly.ReadmeExample.Test do
  use ExUnit.Case
  import WebAssembly.TestHelper

  def all_goes_well, do: true

  test "example" do
    use WebAssembly
    doc = builder do
      html do
        head do
          ctype = "text/html"
          meta http_equiv: "Content-Type", content: ctype
          title "foo"
        end
        body do
          div class: "mydiv" do
            if all_goes_well do
              text "ok"
            else
              text "bad"
            end
          end
        end
      end
    end
    assert doc |> flush == """
    <!DOCTYPE html><html>
      <head>
        <meta http-equiv="Content-Type" content="text/html" />
        <title>foo</title>
      </head>
      <body>
        <div class="mydiv">
          ok
        </div>
      </body>
    </html>
    """
    |> no_indent |> no_lf
  end
end

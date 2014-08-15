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
            ul do
              li 1
              if all_goes_well, do:
                li "second"
            end
          end
          text "that was nice"
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

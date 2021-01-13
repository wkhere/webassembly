defmodule WebAssembly.RealWorldTest do
  use    ExUnit.Case
  import WebAssembly.TestHelper
  use    WebAssembly

  test "empty p" do
    assert (builder do: p()) |> flush == "<p></p>"
    assert (builder do
      div do
          p(); p()
      end; p()
    end) |> flush == "<div><p></p><p></p></div><p></p>"
  end

  test "empty p's and filled p's" do
    doc = builder do
      p "par1"
      p()
      p class: "c1" do
        text "foo"
        p()
      end
    end
    assert doc |> flush == """
      <p>par1</p>
      <p></p>
      <p class="c1">
        foo
        <p></p>
      </p>
      """ |> no_indent |> no_lf
  end

  test "script src" do
    doc = builder do
      script [src: "/foo.js", type: "text/javascript"], []
    end
    assert doc |> flush === """
      <script src="/foo.js" type="text/javascript"></script>
    """
    |> no_indent |> no_lf
  end

  test "script embedded" do
    doc = builder do
      script type: "text/javascript" do
        text ~s[$("body").css("background-color", "#000")]
      end
    end
    assert doc |> flush === """
      <script type="text/javascript">
        $("body").css("background-color", "#000")
      </script>
      """
      |> no_indent |> no_lf
  end

end

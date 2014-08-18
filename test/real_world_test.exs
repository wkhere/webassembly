defmodule WebAssembly.RealWorldTest do
  use    ExUnit.Case
  import WebAssembly.TestHelper
  use    WebAssembly

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

alias WebAssembly.DSL

defmodule DSL.Test do
  use    ExUnit.Case
  import WebAssembly.TestHelper
  use    DSL

  # testing only primitives here

  test "basic builder" do
    buf = builder do
      add_val! :x
      _foo = "anything in between"
      add_val! :y
    end
    assert buf == [:x, :y]
  end

  test "builder with one content tag" do
    buf = builder do
      tag :foo, "content"
    end
    assert buf == ["<foo>", "content", "</foo>"]
  end

  test "builder with void tags" do
    buf = builder do
      tag_void :foo
      tag_void :bar, class: "high"
    end
    assert buf |> flush == """
      <foo />
      <bar class="high" />
    """
    |> no_indent |> no_lf
  end

end

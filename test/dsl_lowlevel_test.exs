alias WebAssembly.DSL

defmodule DSL.LowLevelTest do
  use    ExUnit.Case
  import WebAssembly.TestHelper
  import DSL

  # testing only primitives here

  test "basic builder" do
    buf = builder do
      add_val! :x
      _foo = "anything in between"
      add_val! :y
    end
    assert buf == [:x, :y]
  end

  test "one content tag" do
    buf = builder do
      tag :foo, "content"
    end
    assert buf == ["<foo>", "content", "</foo>"]
  end

  test "nested content tags" do
    buf = builder do
      tag :foo do
        tag :bar, "content"
      end
    end
    assert buf == ["<foo>", ["<bar>", "content", "</bar>"], "</foo>"]
  end

  test "nested content tags and some siblings" do
    buf = builder do
      add_val! "simple text 1"
      tag :foo do
        tag :bar, "inner tag"
        add_val! "inner text"
      end
      add_val! "simple text 2"
    end
    assert buf ==
      ["simple text 1", "<foo>",
        ["<bar>", "inner tag", "</bar>", "inner text"],
       "</foo>", "simple text 2"]
  end

  test "attributes" do
    buf = builder do
      tag :foo, class: "highclass", id: 42 do
        tag :span, [style: "dotted"], "good morning"
      end
    end
    assert buf ==
      [["<foo ", [~s/class="highclass"/, " ", ~s/id="42"/], ">"],
       [["<span ", [~s/style="dotted"/], ">"], "good morning", "</span>"],
       "</foo>"]
  end

  test "void tags" do
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

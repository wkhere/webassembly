defmodule WebAssembly.DSL.LowLevelTest do
  use    ExUnit.Case
  import WebAssembly.TestHelper
  import WebAssembly.DSL
  import WebAssembly.Builder

  test "basic builder" do
    buf = builder do
      value :x
      _foo = "anything in between"
      value :y
    end
    assert buf == [:x, :y]
  end

  test "one flat element" do
    buf = builder do
      element :foo, "content"
    end
    assert buf == ["\n<foo>", "content", "</foo>"]
  end

  test "element with a block containing flat element" do
    buf = builder do
      element :foo do
        element :bar, "content"
      end
    end
    assert buf == ["\n<foo>", ["\n<bar>", "content", "</bar>"], "</foo>"]
  end

  test "nested elements with siblings" do
    buf = builder do
      value "outer text 1"
      element :foo do
        element :bar, "deep"
        value "inner text"
      end
      value "outer text 2"
    end
    assert buf ==
      ["outer text 1",
       "\n<foo>",
          ["\n<bar>", "deep", "</bar>", "inner text"],
       "</foo>", 
       "outer text 2"]
  end

  test "attributes" do
    buf = builder do
      element :foo, class: "highclass", id: 42 do
        element :span, [style: "dotted"], "good morning"
      end
    end
    assert buf ==
      [["\n<foo ", [~s/class="highclass"/, " ", ~s/id="42"/], ">"],
       [["\n<span ", [~s/style="dotted"/], ">"], "good morning", "</span>"],
       "</foo>"]
  end

  test "void elements" do
    buf = builder do
      void_element :foo
      void_element :bar, class: "high"
    end
    assert buf |> flush == """
      <foo />
      <bar class="high" />
    """
    |> no_indent |> no_lf
  end

end

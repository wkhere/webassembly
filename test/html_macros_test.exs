defmodule WebAssembly.HTMLMacrosTest do
  use    ExUnit.Case
  #import WebAssembly.TestHelper
  use    WebAssembly

  WebAssembly.HTML.void_elements
  |> Enum.each fn element ->
    test "#{element} test" do
      doc = builder do: unquote(element)(class: "foo")
      doc_no_attrs = builder do: unquote(element)()
      e = unquote(element)
      assert doc == [["\n<#{e} ", [~s/class="foo"/], " />"]]
      assert doc_no_attrs == ["<#{e} />"]
    end
  end

  WebAssembly.HTML.nonvoid_elements
  |> Enum.each fn element ->
    test "#{element} test" do
      doc = builder do: unquote(element)([class: "foo"], "content")
      doc_no_attrs = builder do: unquote(element)("content")
      e = unquote(element)
      assert doc ==
        [["\n<#{e} ", [~s/class="foo"/], ">"], "content", "</#{e}>"]
      assert doc_no_attrs ==
        ["\n<#{e}>", "content", "</#{e}>"]
    end
  end 
end

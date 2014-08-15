defmodule WebAssembly.HTMLMacrosTest do
  use    ExUnit.Case
  #import WebAssembly.TestHelper
  use    WebAssembly

  WebAssembly.HTML.html_void_tags
  |> Enum.each fn tag ->
    test "#{tag} test" do
      doc = builder do: unquote(tag)(class: "foo")
      doc_no_attrs = builder do: unquote(tag)()
      tag = unquote(tag)
      assert doc == [["<#{tag} ", [~s/class="foo"/], " />"]]
      assert doc_no_attrs == ["<#{tag} />"]
    end
  end

  WebAssembly.HTML.html_nonvoid_tags
  |> Enum.each fn tag ->
    test "#{tag} test" do
      doc = builder do: unquote(tag)([class: "foo"], "content")
      doc_no_attrs = builder do: unquote(tag)("content")
      tag = unquote(tag)
      assert doc ==
        [["<#{tag} ", [~s/class="foo"/], ">"], "content", "</#{tag}>"]
      assert doc_no_attrs ==
        ["<#{tag}>", "content", "</#{tag}>"]
    end
  end 
end

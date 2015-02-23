defmodule WebAssembly.Partial.Test do
  use    ExUnit.Case
  import WebAssembly.TestHelper
  import WebAssembly.DSL
  import WebAssembly.HTML, only: [text: 1]

  def partial1 do
    void_element :bar
  end

  def partial2 do
    element :bar2 do
      text "Hey!"
    end
  end

  test "use some partial funs" do
    buf = builder do
      element :foo, "content"
      partial1
      element :quux do
        partial2
      end
    end
    assert buf |> flush == """
      <foo>content</foo>
      <bar />
      <quux>
        <bar2>
          Hey!
        </bar2>
      </quux>
    """
    |> no_indent |> no_lf
  end  

end

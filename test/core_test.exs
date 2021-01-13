defmodule WebAssembly.Core.Test.Helpers do
  import WebAssembly.DSL.Internal.Tags

  def el(name, content), do: [tag_start(name, []), content, tag_end(name)]
  def el_start(name), do: tag_start(name, [])
  def el_end(name), do: tag_end(name)
end

defmodule WebAssembly.Core.Test do
  use ExUnit.Case
  import WebAssembly.TestHelper
  import WebAssembly.Core.Engine

  import __MODULE__.Helpers

  test "empty scope" do
    fire()
    new_scope()
    release_scope()
    assert return() == []
  end

  test "push 1 value" do
    fire()
    new_scope()
    push(1)
    release_scope()
    assert return() == [1]
  end

  test "push 2 values" do
    fire()
    new_scope()
    push(1)
    push(2)
    release_scope()
    assert return() == [1, 2]
  end

  test "push 1 element" do
    fire()
    new_scope()
    push(el(:foo, "bar"))
    release_scope()
    assert return() |> flush == "<foo>bar</foo>"
  end

  test "push 2 elements" do
    fire()
    new_scope()
    push(el(:foo, "1"))
    push(el(:bar, "2"))
    release_scope()

    assert return() |> flush ==
             """
                <foo>1</foo>
                <bar>2</bar>
             """
             |> no_indent
             |> no_lf
  end

  test "push 2 elements nested and 3rd sister to 1st" do
    fire()
    new_scope()
    push(el_start(:foo))
    new_scope()
    push(el(:bar, "inner"))
    release_scope()
    push(el_end(:foo))
    push(el(:quux, "sister"))
    release_scope()

    assert return() |> flush ==
             """
               <foo>
                 <bar>inner</bar>
               </foo>
               <quux>sister</quux>
             """
             |> no_indent
             |> no_lf
  end

  test "push 2 sister elements & then 2 nested inside 2nd sister" do
    fire()
    new_scope()
    push(el(:foo, "sister1"))
    push(el_start(:bar))
    new_scope()
    push("sister2")
    push(el(:quux, "inner"))
    push(el(:cosmic, "inner as well"))
    release_scope()
    push(el_end(:bar))
    release_scope()

    assert return() |> flush ==
             """
               <foo>sister1</foo>
               <bar>
                 sister2
                 <quux>inner</quux>
                 <cosmic>inner as well</cosmic>
               </bar>
             """
             |> no_indent
             |> no_lf
  end
end

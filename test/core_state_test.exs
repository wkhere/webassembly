alias WebAssembly.Core.St

defmodule St.Test do
  use    ExUnit.Case
  import WebAssembly.TestHelper
  import St

  def element(name, content) do
    import WebAssembly.DSL.Tags
    [tag_start(name,[]), content, tag_end(name)]
  end

  test "new state releases empty list" do
    assert ( new |> release ) == []
  end

  test "push 1 value releases list with this value only" do
    assert ( new |> push(1) |> release ) == [1]
  end

  test "push 2 values releases list of these values in the order of pushes" do
    assert ( new |> push(1) |> push(2) |> release ) == [1,2]
  end

  test "push one element" do
    assert new |> push(element(:foo, "bar")) |> release |> flush
      == "<foo>bar</foo>"
  end

  test "push two elements" do
    assert new
      |> push(element(:foo, "1"))
      |> push(element(:bar, "2"))
      |> release
      |> flush
      == """
      <foo>1</foo>
      <bar>2</bar>
      """ |> no_indent |> no_lf
  end

  test "push two elements nested and a third sister to first" do
    assert new
      |> push(element(:foo,
          new
          |> push(element(:bar, "inner"))
          |> release
        ))
      |> push(element(:quux, "sister"))
      |> release
      |> flush
      == """
      <foo>
        <bar>inner</bar>
      </foo>
      <quux>sister</quux>
      """ |> no_indent |> no_lf
  end

  test "mix nesting and a list content" do
    assert new
      |> push(element(:foo, [
          "inner",
          new
          |> push(element(:bar, "child"))
          |> release
        ]))
      |> push(element(:quux, "sister"))
      |> release
      |> flush
      === """
      <foo>
        inner
        <bar>child</bar>
      </foo>
      <quux>sister</quux>
      """ |> no_indent |> no_lf
  end

  test "push two sister elements and then two nested in 2nd sis" do
    assert new
      |> push(element(:foo, "sister"))
      |> push(element(:bar,
          new
          |> push(element(:quux, "inner"))
          |> push(element(:cosmic, "inner as well"))
          |> release
        ))
      |> release
      |> flush
      == """
      <foo>sister</foo>
        <bar>
        <quux>inner</quux>
        <cosmic>inner as well</cosmic>
      </bar>
      """ |> no_indent |> no_lf
  end

  test "use nonstrict state" do
    nonstrict_st = %{stack: []}
    assert ( nonstrict_st |> push(1) |> release ) == [1]
    # a possible hack: use of non-Core.St.t map like above will work,
    # but will be detected by the dialyzer when in compiled modules
  end
end

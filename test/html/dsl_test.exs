alias Rockside.HTML

defmodule DSL.Test do
  use    ExUnit.Case
  import HTML.TestHelper
  import HTML.DSL
  import Kernel, except: [div: 2]

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

  test "builder with mixed level tags/text, no single enclosing element" do
    buf = builder do
      div "foo"
      div do
        span "bar"
      end
    end
    assert buf |> flush == """
      <div>foo</div>
      <div>
        <span>bar</span>
      </div>
      """
      |> no_indent |> no_lf
  end

  test "more variations of tags w/ enclosing html element" do
    buf = builder do
      html do
        text "foo"
        div do
          text "inner"
        end
        text ["bar", "quux"]
      end
    end
    assert buf  |> flush == """
      <!DOCTYPE html><html>
        foo
        <div>
          inner
        </div>
        barquux
      </html>
      """
      |> no_indent |> no_lf
  end

  test "gather/pick with a list comprehension" do
    buf = builder do
      ul do
        gather for x <- 1..2, do: pick li "#{x}"
      end
    end
    assert buf |> flush == """
      <ul>
        <li>1</li>
        <li>2</li>
      </ul>
      """
      |> no_indent |> no_lf
  end

  test "gather/pick with Enum.map" do
    buf = builder do
      ul do
        gather Enum.map 1..2, &(pick li "#{&1}")
      end
    end
    assert buf |> flush == """
      <ul>
        <li>1</li>
        <li>2</li>
      </ul>
      """
      |> no_indent |> no_lf
  end

  test "gather/pick with a closure" do
    buf = builder do
      gather (fn -> pick span "foo" end).()
    end
    assert buf |> flush == "<span>foo</span>"
  end

  test "attrs" do
    buf = builder do
      span [class: "hilight"], "foo"
      div [id: :matrix, class: "shiny"] do
        text "heyy!"
        span [style: "outline: 1px"], "are you in matrix?"
      end
    end
    assert buf |> flush == """
      <span class="hilight">foo</span>
      <div id="matrix" class="shiny">
        heyy!
        <span style="outline: 1px">
          are you in matrix?
        </span>
      </div>
      """
      |> no_indent |> no_lf
  end
end

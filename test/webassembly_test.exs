defmodule WebAssembly.Test do
  use    ExUnit.Case
  import WebAssembly.TestHelper
  use    WebAssembly

  doctest WebAssembly.DSL
  doctest WebAssembly.Tools.Input
  doctest WebAssembly.Tools.Output

  test "mixed level elements/text, no single enclosing element" do
    doc = builder do
      div "foo"
      div do
        span "bar"
      end
    end
    assert doc |> flush == """
      <div>foo</div>
      <div>
        <span>bar</span>
      </div>
      """
      |> no_indent |> no_lf
  end

  test "more variations of elements w/ enclosing html element" do
    doc = builder do
      html do
        head do
          meta http_equiv: "Content-Type", content: "text/html"
          title "hey!"
        end
        body do
          text "foo"; br
          div do
            text "inner"
          end
          text ["bar", "quux"]
        end
      end
    end
    assert doc  |> flush == """
      <!DOCTYPE html><html>
        <head>
          <meta http-equiv="Content-Type" content="text/html" />
          <title>hey!</title>
        </head>
        <body>
          foo<br />
          <div>
            inner
          </div>
          barquux
        </body>
      </html>
      """
      |> no_indent |> no_lf
  end

  test "loop" do
    doc = builder do
      ul do
        for x <- 1..2, do: li "#{x}"
      end
    end
    assert doc |> flush == """
      <ul>
        <li>1</li>
        <li>2</li>
      </ul>
      """
      |> no_indent |> no_lf
  end

  test "loop with do-blocks inside" do
    doc = builder do
      div class: "outer" do
        for x <- 1..2 do
          div class: "inner" do
            span x
          end
        end
      end
    end
    assert doc |> flush == """
      <div class="outer">
        <div class="inner">
          <span>1</span>
        </div>
        <div class="inner">
          <span>2</span>
        </div>
      </div>
    """
    |> no_indent |> no_lf
  end

  test "loop via Enum" do
    doc = builder do
      ul do
        Enum.map 1..2, &(li &1)
      end
    end
    assert doc |> flush == """
      <ul>
        <li>1</li>
        <li>2</li>
      </ul>
      """
      |> no_indent |> no_lf
  end

  test "closure" do
    doc = builder do
      fn -> span "foo" end.()
    end
    assert doc |> flush == "<span>foo</span>"
  end

  test "attrs" do
    doc = builder do
      span [class: "hilight"], "foo"
      div id: :matrix, class: "shiny" do
        text "heyy!"
        span [style: "outline: 1px"], "are you in matrix?"
      end
    end
    assert doc |> flush == """
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

  test "case of span(span :foo)" do
    # this is a pathological case when one should open new block but didn't
    assert_raise ArgumentError, fn -> builder do: span(span :foo) end
   end
end

defmodule WebAssembly.Test do
  use    ExUnit.Case
  import WebAssembly.TestHelper
  use    WebAssembly

  doctest WebAssembly.Tools.Input
  doctest WebAssembly.Tools.Output

  test "mixed level tags/text, no single enclosing element" do
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
    assert buf  |> flush == """
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

  test "unrolling list comprehension" do
    buf = builder do
      ul do
        elements for x <- 1..2, do: pick li "#{x}"
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

  test "unrolling list with do-blocks inside" do
    buf = builder do
      div class: "outer" do
        for x <- 1..2 do
          div class: "inner" do
            span x
          end |> pick
        end |> elements
        #   ^^ugly..
      end
    end
    assert buf |> flush == """
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

  test "unrolling Enum.map" do
    buf = builder do
      ul do
        elements Enum.map 1..2, &(pick li "#{&1}")
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

  test "unrolling a closure" do
    buf = builder do
      elements (fn -> pick span "foo" end).()
    end
    assert buf |> flush == "<span>foo</span>"
  end

  test "attrs" do
    buf = builder do
      span [class: "hilight"], "foo"
      div id: :matrix, class: "shiny" do
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

  test "case of span(span :foo)" do
    assert_raise ArgumentError, fn -> builder do: span(pick span :foo) end
    # here `pick` is only to prevent from compilation warning on unused st var
    # the pathological case stays the same as if there was no `pick`
  end
end

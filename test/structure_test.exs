defmodule WebAssembly.StructureTest do
  use    ExUnit.Case
  import WebAssembly.TestHelper
  use    WebAssembly

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
          text "foo"; br()
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

  test "mixed blocks where inner one ends with non-assembly expr" do
    doc = builder do
      div do
        text "foo"
        _var = :whatever
      end
    end
    assert doc |> flush == "<div>foo</div>"
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

  test "loop with inner block ending with non-assembly expr" do
    doc = builder do
      for x <- 1..1 do
        li "#{x}"
        _var = :whatever
      end
    end
    assert doc |> flush == """
      <li>1</li>
    """ |> no_indent |> no_lf
  end

  test "loop with do-blocks inside" do
    doc = builder do
      div class: "outer" do
        for x <- 1..2 do
          div class: "inner" do
            span "#{x}"
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
        Enum.map 1..2, &(li "#{&1}")
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

  test "Enum loop with fn ending with non-assembly expr" do
    doc = builder do
      Enum.map 1..1, fn x ->
        li "#{x}"
        _var = :whatever
      end
    end
    assert doc |> flush == """
      <li>1</li>
    """ |> no_indent |> no_lf
  end

  test "closure" do
    doc = builder do
      fn -> span "foo" end.()
    end
    assert doc |> flush == "<span>foo</span>"
  end

  test "closure ending with non-assembly expr" do
    doc = builder do
      fn ->
        li "1"
        _var = :whatever
      end.()
    end
    assert doc |> flush == """
      <li>1</li>
    """ |> no_indent |> no_lf
  end

  test "text() should really turn into string" do
    doc = builder do: (text :atom; text 1)
    assert doc |> :erlang.iolist_to_binary |> no_lf == "atom1"
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

  # 'bad-nesting' detection switched off - it worked only for some cases
  #
  #  test "nesting without do-block" do
  #    # these are cases when one should open new block but didn't
  #    assert_raise ArgumentError, fn -> builder do: span(span :foo) end
  #    # above would raise in 0.2.0-0.3.1, but the ones below not:
  #    assert_raise ArgumentError, fn -> builder do: span([1, span(:foo)]) end
  #    assert_raise ArgumentError, fn -> builder do: span([span(:foo), 1]) end
  #   end
end

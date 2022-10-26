defmodule WebAssembly.BadExamplesTest do
  use ExUnit.Case
  import WebAssembly.TestHelper
  import WebAssembly.BadExamples

  test "bad examples" do
    assert_raise ArgumentError, fn -> bad1() |> flush end
  end
end

alias WebAssembly.Core.St

defmodule St.Test do
  use    ExUnit.Case
  import St

  test "new state has empty stack" do
    assert new.stack == []
  end

  test "push anything" do
    assert ( new |> push(1) ).stack == [1]
  end

  test "2x push anything" do
    assert ( new |> push(1) |> push(2) ).stack == [2,1]
  end

  test "2x push anything + release" do
    assert new |> push(1) |> push(2) |> release == [1,2]
  end
end

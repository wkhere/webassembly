defmodule WebAssembly.BadExamples do
  # these should make dialyzer crying

  @moduledoc false

  # alias WebAssembly.Types, as: T
  @dialyzer {:nowarn_function, bad1: 0}
  use WebAssembly

  def bad1 do
    builder do
      span(1)
      span(:not_text)
    end
  end
end

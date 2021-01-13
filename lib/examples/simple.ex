defmodule WebAssembly.Examples do
  # needed to have examples as a separate module
  # to trigger dialyzer analysis of core & dsl

  @moduledoc false

  alias WebAssembly.Types, as: T

  @spec readme_ex :: T.assembled_elements
  def readme_ex do
    use WebAssembly
    builder do
      html do
        head do
          meta http_equiv: "Content-Type", content: "text/html"
          title "example"
        end
        body do
          div class: "container", id: :content do
            ul do
              for index <- 1..3, do:
                li "item #{index}"
            end
            random = :random.uniform(10)
            if random == 5 do
              text "Lucky! You got five"
            end
          end
          span [style: "smiling"], "that was nice"
        end
      end
    end
  end


  import WebAssembly.Tools.Output

  @spec readme_ex_flushed :: binary
  def readme_ex_flushed do
    readme_ex() |> flush()
  end
end

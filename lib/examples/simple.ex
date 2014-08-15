defmodule WebAssembly.Examples do
  # needed to have examples as a separate module
  # to trigger dialyzer analysis of core & dsl

  defp all_goes_well, do: true

  def readme_ex do
    use WebAssembly
    builder do
      html do
        head do
          ctype = "text/html"
          meta http_equiv: "Content-Type", content: ctype
          title "foo"
        end
        body do
          div class: "mydiv", id: :myid do
            ul do
              li 1
              if all_goes_well, do:
                li "second"
            end
          end
          text "that was nice"
        end
      end
    end
  end

end

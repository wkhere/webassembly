defmodule WebAssembly.Examples do
  # needed to have examples as a separate module
  # to trigger dialyzer analysis of core & dsl

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
              elements for index<-1..5, do:
                pick li ["item ", index]
            end
            random = :random.uniform(10)
            if random == 5 do
              text "Lucky! You got five"
            end
          end
          text "that was nice"
        end
      end
    end
  end

end

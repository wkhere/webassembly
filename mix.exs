defmodule Webassembly.Mixfile do
  use Mix.Project

  def project do
    [app: :webassembly,
     version: "0.0.1-dev",
     elixir: "~> 0.15.0",
     deps: deps,
     description: description,
     package: package,
     test_coverage: [tool: ExCoveralls]]
  end

  def application do
    [applications: [],
      description: 'Web DSL']
  end

  defp deps do
    [{:excoveralls, "~> 0.3.2", only: :test}]
  end

  defp description do
    """
    WebAssembly is a web DSL for Elixir.

    You create html structure straight using Elixir blocks.
    """
  end

  defp package do
    [ contributors: ["Wojciech Kaczmarek"],
      licenses: ["BSD"],
      description: description,
      links: %{"GitHub" => "https://github.com/herenowcoder/webassembly"}
    ]
  end
end

defmodule Webassembly.Mixfile do
  use Mix.Project

  def project do
    [app: :webassembly,
     version: "0.0.1-dev",
     elixir: "~> 0.15.1",
     deps: deps,
     test_coverage: [tool: ExCoveralls]]
  end

  def application do
    [applications: [],
      description: 'Web DSL']
  end

 defp deps do
    [{:excoveralls, "~> 0.3.2", only: :test}]
  end
end

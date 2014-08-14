defmodule Webassembly.Mixfile do
  use Mix.Project

  def project do
    [app: :webassembly,
     version: "0.0.1-dev",
     elixir: "~> 0.15.1",
     deps: deps]
  end

  def application do
    [applications: []]
  end

 defp deps do
    []
  end
end

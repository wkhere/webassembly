defmodule WebAssembly.Mixfile do
  use Mix.Project

  def project do
    [
      app: :webassembly,
      docs: [main: WebAssembly],
      version: "0.6.2-dev",
      elixir: "~> 1.0",
      deps: deps(),
      description: description(),
      package: package(),
      test_coverage: [tool: ExCoveralls]
    ]
  end

  def application do
    [applications: [], description: 'Web DSL']
  end

  defp deps,
    do: [
      {:excoveralls, "~> 0.10", only: :test},
      {:ex_doc, "~> 0.23", only: :dev},
      {:dialyxir, "~> 1.0", only: :dev}
    ]

  defp description do
    ~S"""
    WebAssembly is a web DSL for Elixir.

    You create html structure straight using do blocks.
    Means, you can intermix html-building blocks with full Elixir syntax.

    DSL output is an iolist, which you can flatten to string, but
    better use is to just feed it to the socket (via Plug & Cowboy).

    WebAssembly aims to have 100% test coverage.
    """
  end

  defp package do
    [
      maintainers: ["Wojciech Kaczmarek", "Roman Heinrich"],
      licenses: ["BSD"],
      description: description(),
      links: %{
        "GitHub" => "https://github.com/herenowcoder/webassembly",
        "HexDocs" => "http://hexdocs.pm/webassembly"
      }
    ]
  end
end

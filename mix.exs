defmodule BinanceApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :binance_api,
      version: "0.2.11",
      description: "Binance API access for elixir, doesn't use structs, includes spot and futures",

      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,

      deps: deps(),
      package: package(),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {BinanceApi.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:finch, "~> 0.8"},
      {:jason, "~> 1.2"},
      {:proper_case, "~> 1.3"},
      {:nimble_options, "~> 0.3.0"},

      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
    ]
  end

  defp package do
    [
      maintainers: ["Mika Kalathil"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/LearnElixirDev/binance-api-elixir"},
      files: ~w(mix.exs README.md CHANGELOG.md lib config)
    ]
  end

  defp docs do
    [
      main: "BinanceApi",
      source_url: "https://github.com/LearnElixirDev/binance-api-elixir",
      groups_for_modules: [
        "HTTP Modules": [BinanceApi.HTTP, BinanceApi.HTTP.UrlGenerator],
        "Request Modules": [
          BinanceApi.Account,
          BinanceApi.Order,
          BinanceApi.Order.Spot,
          BinanceApi.Order.USDMFutures,
          BinanceApi.System,
          BinanceApi.Symbol
        ]
      ]
    ]
  end
end

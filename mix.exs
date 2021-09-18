defmodule BinanceApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :binance_api,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:nimble_options, "~> 0.3.0"}
    ]
  end
end

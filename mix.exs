defmodule Binance.MixProject do
  use Mix.Project

  def project do
    [
      app: :binance_api,
      version: "0.1.5",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Binance.Supervisor, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.0"},
      {:poison, "~> 3.1"},
      {:exconstructor, "~> 1.1.0"},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:mix_test_watch, "~> 0.5", only: :dev, runtime: false},
      {:exvcr, "~> 0.10.1", only: :test}
    ]
  end

  defp description do
    """
    Elixir wrapper for Binance API
    """
  end

  defp package do
    [
      name: :binance_api,
      files: ["lib", "config", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Mika Kalathil"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/Lure-Consulting/binance-api-elixir"}
    ]
  end
end

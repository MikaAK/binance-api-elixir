# BinanceApi

[![Hex pm](http://img.shields.io/hexpm/v/binance_api.svg?style=flat)](https://hex.pm/packages/binance_api)

Binance api for elixir, includes the ability to utilize futures

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `binance_api` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:binance_api, "~> 0.2"}
  ]
end
```

### Config
```elixir
config :binance_api,
  api_key: "<BINANCE_API_KEY>",
  secret_key: "<BINANCE_SECRET_KEY>",
  base_url: "https://api.binance.com" # default,
  base_futures_url: "https://api.binance.com" # default,
  secure_receive_window: 5_000 # default,

  request: [
    pool_timeout: 5_000 # default,
    receive_timeout: 15_000 # default
  ]
```

### Goals

- [x] To allow for multiple accounts to be used
- [x] Access to trading on the futures API
- [x] Access to trading on the spot API
- [x] Access to accounts

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/binance_api](https://hexdocs.pm/binance_api).


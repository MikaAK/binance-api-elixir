defmodule BinanceApi do
  @moduledoc """
  This library interacts with binance in a very simple way and doesn't make
  attempts to deserialize the results of the api into a struct.

  To utilize this library we need to first set up some configuration

  ### Config
  ```elixir
  config :binance_api,
    api_key: "<BINANCE_API_KEY>", # required
    secret_key: "<BINANCE_SECRET_KEY>", # required
    base_url: "https://api.binance.com" # default,
    secure_receive_window: 5_000 # default,

    request: [
      pool_timeout: 5_000 # default,
      receive_timeout: 15_000 # default
    ]
  ```

  ### Options
  For all requests we can provide the same options to override any
  of the default config, however it's not required to pass them at all as long as
  the config is set

  #{NimbleOptions.docs(BinanceApi.HTTP.opts_definitions())}
  """

  alias BinanceApi.HTTP

  def fetch_account(opts \\ []) do
    HTTP.get("/api/v3/account", nil, Keyword.merge(opts, [secured?: true]))
  end
end

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

  # Symbol API

  @spec ticker_price(symbol :: String.t) :: HTTP.res_single
  @spec ticker_price(symbol :: String.t, HTTP.opts) :: HTTP.res_single
  @doc "Get the last price for a ticker"
  defdelegate ticker_price(symbol, opts \\ []), to: BinanceApi.Symbol

  # System API

  @spec ping() :: :pong | HTTP.error
  @spec ping(HTTP.opts) :: :pong | HTTP.error
  @doc "Ping Binance servers to get pong"
  defdelegate ping(opts \\ []), to: BinanceApi.System

  @spec server_time() :: HTTP.res_single
  @spec server_time(HTTP.opts) :: HTTP.res_single
  @doc "Server time from Binance"
  defdelegate server_time(opts \\ []), to: BinanceApi.System

  @spec exchange_info :: HTTP.res_single
  @spec exchange_info(HTTP.opts) :: HTTP.res_single
  @doc "Exchange info"
  defdelegate exchange_info(opts \\ []), to: BinanceApi.System

  @spec system_status() :: HTTP.res_single
  @spec system_status(HTTP.opts) :: HTTP.res_single
  @doc "System status"
  defdelegate system_status(opts \\ []), to: BinanceApi.System

  # Order API

  @spec open_orders() :: HTTP.res_multi
  @spec open_orders(HTTP.opts) :: HTTP.res_multi
  @doc "Get all active open orders"
  defdelegate open_orders(opts \\ []), to: BinanceApi.Order

  @spec open_orders_by_symbol(symbol :: String.t) :: HTTP.res_multi
  @spec open_orders_by_symbol(symbol :: String.t, HTTP.opts) :: HTTP.res_multi
  @doc "Get all active open orders for a specific symbol"
  defdelegate open_orders_by_symbol(symbol, opts \\ []), to: BinanceApi.Order

  # Account Api

  @spec account() :: HTTP.res_single
  @spec account(HTTP.opts) :: HTTP.res_single
  @doc "Get account details"
  defdelegate account(opts \\ []), to: BinanceApi.Account
end

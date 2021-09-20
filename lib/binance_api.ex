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

  @spec futures_ticker_price(symbol :: String.t) :: HTTP.res_single
  @spec futures_ticker_price(symbol :: String.t, HTTP.opts) :: HTTP.res_single
  @doc "Get the last price for a ticker"
  defdelegate futures_ticker_price(symbol, opts \\ []), to: BinanceApi.Symbol

  @spec spot_ticker_price(symbol :: String.t) :: HTTP.res_single
  @spec spot_ticker_price(symbol :: String.t, HTTP.opts) :: HTTP.res_single
  @doc "Get the last price for a ticker"
  defdelegate spot_ticker_price(symbol, opts \\ []), to: BinanceApi.Symbol

  # System API

  @spec spot_ping() :: :pong | HTTP.error
  @spec spot_ping(HTTP.opts) :: :pong | HTTP.error
  @doc "Ping Binance servers to get pong"
  defdelegate spot_ping(opts \\ []), to: BinanceApi.System

  @spec futures_ping() :: :pong | HTTP.error
  @spec futures_ping(HTTP.opts) :: :pong | HTTP.error
  @doc "Ping Binance servers to get pong"
  defdelegate futures_ping(opts \\ []), to: BinanceApi.System

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

  # Spot Order API

  @spec spot_all_orders() :: HTTP.res_multi
  @spec spot_all_orders(HTTP.opts) :: HTTP.res_multi
  @doc "Get all active all orders"
  defdelegate spot_all_orders(opts \\ []), to: BinanceApi.Order

  @spec spot_open_orders() :: HTTP.res_multi
  @spec spot_open_orders(HTTP.opts) :: HTTP.res_multi
  @doc "Get all active open orders"
  defdelegate spot_open_orders(opts \\ []), to: BinanceApi.Order

  @spec spot_open_orders_by_symbol(symbol :: String.t) :: HTTP.res_multi
  @spec spot_open_orders_by_symbol(symbol :: String.t, HTTP.opts) :: HTTP.res_multi
  @doc "Get all active open orders for a specific symbol"
  defdelegate spot_open_orders_by_symbol(symbol, opts \\ []), to: BinanceApi.Order

  @spec spot_cancel_order(symbol :: String.t, order_id :: String.t) :: HTTP.res_single
  @spec spot_cancel_order(symbol :: String.t, order_id :: String.t, HTTP.opts) :: HTTP.res_single
  @doc "Cancels an order for a specific symbol by the `order_id`"
  defdelegate spot_cancel_order(symbol, order_id, opts \\ []), to: BinanceApi.Order

  @spec spot_cancel_orders(order_ids :: list(String.t)) :: HTTP.res_single
  @spec spot_cancel_orders(order_ids :: list(String.t), HTTP.opts) :: HTTP.res_single
  @doc "Cancels an order for a specific symbol by the `order_id`"
  defdelegate spot_cancel_orders(order_id, opts \\ []), to: BinanceApi.Order

  @spec spot_place_order(params :: map) :: HTTP.res_single
  @spec spot_place_order(params :: map, HTTP.opts) :: HTTP.res_single
  @doc "Opens and order in binance, see: https://github.com/binance/binance-spot-api-docs/blob/master/rest-api.md#new-order--trade"
  defdelegate spot_place_order(symbol, opts \\ []), to: BinanceApi.Order

  @spec spot_place_orders(params_list :: list(map)) :: HTTP.res_single
  @spec spot_place_orders(params_list :: list(map), HTTP.opts) :: HTTP.res_single
  @doc "Opens batch orders in binance, see: https://github.com/binance/binance-spot-api-docs/blob/master/rest-api.md#new-order--trade"
  defdelegate spot_place_orders(symbol, opts \\ []), to: BinanceApi.Order

  # Futures Order API

  @spec futures_all_orders() :: HTTP.res_multi
  @spec futures_all_orders(HTTP.opts) :: HTTP.res_multi
  @doc "Get all active all orders"
  defdelegate futures_all_orders(opts \\ []), to: BinanceApi.Order

  @spec futures_open_orders() :: HTTP.res_multi
  @spec futures_open_orders(HTTP.opts) :: HTTP.res_multi
  @doc "Get all active open orders"
  defdelegate futures_open_orders(opts \\ []), to: BinanceApi.Order

  @spec futures_open_orders_by_symbol(symbol :: String.t) :: HTTP.res_multi
  @spec futures_open_orders_by_symbol(symbol :: String.t, HTTP.opts) :: HTTP.res_multi
  @doc "Get all active open orders for a specific symbol"
  defdelegate futures_open_orders_by_symbol(symbol, opts \\ []), to: BinanceApi.Order

  @spec futures_cancel_order(symbol :: String.t, order_id :: String.t) :: HTTP.res_single
  @spec futures_cancel_order(symbol :: String.t, order_id :: String.t, HTTP.opts) :: HTTP.res_single
  @doc "Cancels an order for a specific symbol by the `order_id`"
  defdelegate futures_cancel_order(symbol, order_id, opts \\ []), to: BinanceApi.Order

  @spec futures_cancel_orders(order_ids :: list(String.t)) :: HTTP.res_single
  @spec futures_cancel_orders(order_ids :: list(String.t), HTTP.opts) :: HTTP.res_single
  @doc "Cancels an order for a specific symbol by the `order_id`"
  defdelegate futures_cancel_orders(order_id, opts \\ []), to: BinanceApi.Order

  @spec futures_place_order(params :: map) :: HTTP.res_single
  @spec futures_place_order(params :: map, HTTP.opts) :: HTTP.res_single
  @doc "Opens and order in binance futures"
  defdelegate futures_place_order(symbol, opts \\ []), to: BinanceApi.Order

  @spec futures_place_orders(params_list :: list(map)) :: HTTP.res_single
  @spec futures_place_orders(params_list :: list(map), HTTP.opts) :: HTTP.res_single
  @doc "Opens batch orders in binance"
  defdelegate futures_place_orders(symbol, opts \\ []), to: BinanceApi.Order

  # Account Api

  @spec account() :: HTTP.res_single
  @spec account(HTTP.opts) :: HTTP.res_single
  @doc "Get account details"
  defdelegate account(opts \\ []), to: BinanceApi.Account
end

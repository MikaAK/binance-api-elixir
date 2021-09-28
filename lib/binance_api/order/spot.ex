defmodule BinanceApi.Order.Spot do
  alias BinanceApi.HTTP

  @batch_create_order_limit 5

  @spec all_orders(HTTP.opts) :: HTTP.res_multi
  def all_orders(opts) do
    "/allOrders"
      |> HTTP.build_v3_url
      |> HTTP.get(Keyword.put(opts, :secured?, true))
  end

  @spec open_orders(HTTP.opts) :: HTTP.res_multi
  def open_orders(opts) do
    "/openOrders"
      |> HTTP.build_v3_url
      |> HTTP.get(Keyword.put(opts, :secured?, true))
  end

  @spec open_orders_by_symbol(symbol :: String.t, HTTP.opts) :: HTTP.res_multi
  def open_orders_by_symbol(symbol, opts) do
    "/openOrders"
      |> HTTP.build_v3_url
      |> HTTP.get(%{symbol: symbol}, Keyword.put(opts, :secured?, true))
  end

  @spec cancel_order(symbol :: String.t, order_id :: String.t, HTTP.opts) :: HTTP.res_multi
  def cancel_order(symbol, order_id, opts) do
    "/order"
      |> HTTP.build_v3_url
      |> HTTP.delete(%{symbol: symbol, order_id: order_id}, Keyword.put(opts, :secured?, true))
  end

  @spec cancel_open_orders(symbol :: String.t, HTTP.opts) :: HTTP.res_multi
  def cancel_open_orders(symbol, opts) do
    "/openOrders"
      |> HTTP.build_v3_url
      |> HTTP.delete(%{symbol: symbol}, Keyword.put(opts, :secured?, true))
  end

  @spec place_order(params :: map, HTTP.opts) :: HTTP.res_multi
  def place_order(params, opts) do
    "/order"
      |> HTTP.build_v3_url
      |> HTTP.post(params, Keyword.put(opts, :secured?, true))
  end

  @spec place_orders(params_list :: list(map), HTTP.opts) :: HTTP.res_multi
  def place_orders(params_list, opts) when length(params_list) <= @batch_create_order_limit do
    "/batchOrders"
      |> HTTP.build_v3_url
      |> HTTP.post(%{batch_orders: params_list}, Keyword.put(opts, :secured?, true))
  end
end


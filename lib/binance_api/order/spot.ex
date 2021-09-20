defmodule BinanceApi.Order.Spot do
  alias BinanceApi.HTTP

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

  @spec open_order(params :: map, HTTP.opts) :: HTTP.res_multi
  def open_order(params, opts) do
    "/order"
      |> HTTP.build_v3_url
      |> HTTP.post(params, Keyword.put(opts, :secured?, true))
  end
end


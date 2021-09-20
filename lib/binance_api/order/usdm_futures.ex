defmodule BinanceApi.Order.USDMFutures do
  alias BinanceApi.HTTP

  @spec all_orders(HTTP.opts) :: HTTP.res_multi
  def all_orders(opts) do
    HTTP.futures_get("/allOrders", Keyword.put(opts, :secured?, true))
  end

  @spec open_orders(HTTP.opts) :: HTTP.res_multi
  def open_orders(opts) do
    HTTP.futures_get("/openOrders", Keyword.put(opts, :secured?, true))
  end

  @spec open_orders_by_symbol(symbol :: String.t, HTTP.opts) :: HTTP.res_multi
  def open_orders_by_symbol(symbol, opts) do
    HTTP.futures_get("/openOrders", %{symbol: symbol}, Keyword.put(opts, :secured?, true))
  end

  @spec cancel_order(symbol :: String.t, order_id :: String.t, HTTP.opts) :: HTTP.res_multi
  def cancel_order(symbol, order_id, opts) do
    HTTP.futures_delete("/order", %{symbol: symbol, order_id: order_id}, Keyword.put(opts, :secured?, true))
  end

  @spec open_order(params :: map, HTTP.opts) :: HTTP.res_multi
  def open_order(params, opts) do
    HTTP.futures_post("/order", params, Keyword.put(opts, :secured?, true))
  end
end


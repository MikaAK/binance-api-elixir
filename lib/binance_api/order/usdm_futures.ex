defmodule BinanceApi.Order.USDMFutures do
  alias BinanceApi.HTTP

  @batch_create_order_limit 5
  @batch_delete_order_limit 5

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

  @spec cancel_orders(order_ids :: list(non_neg_integer), HTTP.opts) :: HTTP.res_multi
  def cancel_orders(order_ids, opts) when length(order_ids) <= @batch_delete_order_limit do
    HTTP.futures_post(
      "/batchOrders",
      %{order_id_list: order_ids},
      Keyword.put(opts, :secured?, true)
    )
  end

  @spec place_order(params :: map, HTTP.opts) :: HTTP.res_multi
  def place_order(params, opts) do
    HTTP.futures_post("/order", params, Keyword.put(opts, :secured?, true))
  end

  @spec place_orders(params_list :: list(map), HTTP.opts) :: HTTP.res_multi
  def place_orders(params_list, opts) when length(params_list) <= @batch_create_order_limit do
    HTTP.futures_post(
      "/batchOrders",
      %{batch_orders: params_list},
      Keyword.put(opts, :secured?, true)
    )
  end
end


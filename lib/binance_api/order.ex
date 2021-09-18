defmodule BinanceApi.Order do
  alias BinanceApi.HTTP

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
end

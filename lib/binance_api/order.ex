defmodule BinanceApi.Order do
  alias BinanceApi.Order

  defdelegate spot_open_orders(opts),
    to: Order.Spot,
    as: :open_orders

  defdelegate spot_open_orders_by_symbol(symbol, opts),
    to: Order.Spot,
    as: :open_orders_by_symbol

  defdelegate spot_cancel_order(symbol, order_id, opts),
    to: Order.Spot,
    as: :cancel_order

  defdelegate spot_open_order(params, opts),
    to: Order.Spot,
    as: :open_order
end

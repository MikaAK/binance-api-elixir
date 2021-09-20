defmodule BinanceApi.Order do
  alias BinanceApi.Order

  defdelegate spot_all_orders(opts),
    to: Order.Spot,
    as: :all_orders

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

  defdelegate futures_all_orders(opts),
    to: Order.USDMFutures,
    as: :all_orders

  defdelegate futures_open_orders(opts),
    to: Order.USDMFutures,
    as: :open_orders

  defdelegate futures_open_orders_by_symbol(symbol, opts),
    to: Order.USDMFutures,
    as: :open_orders_by_symbol

  defdelegate futures_cancel_order(symbol, order_id, opts),
    to: Order.USDMFutures,
    as: :cancel_order

  defdelegate futures_open_order(params, opts),
    to: Order.USDMFutures,
    as: :open_order
end

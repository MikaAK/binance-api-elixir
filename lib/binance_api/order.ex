defmodule BinanceApi.Order do
  alias BinanceApi.Order

  defdelegate spot_all_orders(opts),
    to: Order.Spot,
    as: :all_orders

  defdelegate spot_find_order(symbol, order_id, opts),
    to: Order.Spot,
    as: :find_order

  defdelegate spot_open_orders(opts),
    to: Order.Spot,
    as: :open_orders

  defdelegate spot_open_orders_by_symbol(symbol, opts),
    to: Order.Spot,
    as: :open_orders_by_symbol

  defdelegate spot_cancel_order(symbol, order_id, opts),
    to: Order.Spot,
    as: :cancel_order

  defdelegate spot_cancel_open_orders(symbol, opts),
    to: Order.Spot,
    as: :cancel_open_orders

  defdelegate spot_place_order(params, opts),
    to: Order.Spot,
    as: :place_order

  defdelegate spot_place_orders(params_list, opts),
    to: Order.Spot,
    as: :place_orders

  defdelegate spot_trade_list(symbol, params, opts),
    to: Order.Spot,
    as: :trade_list


  defdelegate futures_all_orders(opts),
    to: Order.USDMFutures,
    as: :all_orders

  defdelegate futures_find_order(symbol, order_id, opts),
    to: Order.USDMFutures,
    as: :find_order

  defdelegate futures_open_orders(opts),
    to: Order.USDMFutures,
    as: :open_orders

  defdelegate futures_open_orders_by_symbol(symbol, opts),
    to: Order.USDMFutures,
    as: :open_orders_by_symbol

  defdelegate futures_cancel_order(symbol, order_id, opts),
    to: Order.USDMFutures,
    as: :cancel_order

  defdelegate futures_cancel_orders(symbol, order_ids, opts),
    to: Order.USDMFutures,
    as: :cancel_orders

  defdelegate futures_cancel_open_orders(symbol, opts),
    to: Order.USDMFutures,
    as: :cancel_open_orders

  defdelegate futures_place_order(params, opts),
    to: Order.USDMFutures,
    as: :place_order

  defdelegate futures_place_orders(params_list, opts),
    to: Order.USDMFutures,
    as: :place_orders

  defdelegate futures_trade_list(symbol, params, opts),
    to: Order.USDMFutures,
    as: :trade_list

  defdelegate futures_account_balance(opts),
    to: Order.USDMFutures,
    as: :account_balance
end

defmodule Binance.OrderConfig do
  @enforce_keys [:symbol, :side, :type, :quantity, :price]
  defstruct [
    symbol: nil,
    side: nil,
    type: nil,
    quantity: nil,
    price: nil,
    time_in_force: "GTC",
    new_client_order_id: nil,
    stop_price: nil,
    iceberg_quantity: nil,
    receiving_window: 1000
  ]
end

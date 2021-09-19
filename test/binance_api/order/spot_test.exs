defmodule BinanceApi.Order.SpotTest do
  use ExUnit.Case, async: true

  alias BinanceApi.Order.Spot

  @moduletag :spot_orders
  @moduletag capture_log: true

  @symbol "BTCUSDT"

  describe "Opening, Viewing and Canceling Orders" do
    test "orders can be open and canceled" do
      order_id = open_order()

      cancel_and_assert_order(order_id)
    end

    test "orders can be open and then viewed with open orders before being canceled" do
      order_id = open_order()

      assert {:ok, [%{"order_id" => ^order_id}]} = Spot.open_orders([])
      assert {:ok, [%{"order_id" => ^order_id}]} = Spot.open_orders_by_symbol(@symbol, [])

      cancel_and_assert_order(order_id)
    end
  end

  defp open_order do
    assert {:ok, %{"price" => price}} = BinanceApi.Symbol.ticker_price(@symbol, [])

    assert {:ok, %{
      "order_id" => order_id,
      "side" => "BUY",
      "type" => "LIMIT"
    }} = Spot.open_order(%{
      symbol: @symbol,
      side: "BUY",
      type: "LIMIT",
      time_in_force: "GTC",
      price: round(String.to_float(price) * 0.50), # 50% of price
      quantity: "0.00061" # ~ $20
    }, [])

    order_id
  end

  def cancel_and_assert_order(order_id) do
    assert {:ok, %{
      "status" => "CANCELED",
      "side" => "BUY"
    }} = Spot.cancel_order(@symbol, order_id, [])
  end
end

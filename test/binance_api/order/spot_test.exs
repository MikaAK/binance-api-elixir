defmodule BinanceApi.Order.SpotTest do
  use ExUnit.Case, async: true

  alias BinanceApi.Order.Spot

  @moduletag :config_needed
  @symbol "BTCUSDTPERP"

  describe "Opening, Viewing and Canceling Orders" do
    test "orders can be open and canceled" do
      assert {:ok, order} = Spot.open_order(%{
        symbol: @symbol,
        side: "BUY",
        type: "MARKET",
        quantity: "0.011"
      }, [])

      assert {:ok, a} = Spot.cancel_order(@symbol, order.order_id, [])

      IO.inspect(order)
      IO.inspect(a)
    end

    test "orders can be open and then viewed with open orders before being canceled" do
    end
  end
end

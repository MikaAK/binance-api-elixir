defmodule BinanceApi.Order.Builder do
  @moduledoc """
  This module helps to build orders for use with `BinanceApi.place/2` and
  similar APIs
  """

  def limit(price, quantity, symbol, side, time_in_force \\ "GTC") do
    %{
      symbol: symbol,
      price: price,
      side: side,
      quantity: quantity,
      type: "LIMIT",
      time_in_force: time_in_force
    }
  end

  def market(quantity, symbol, side) do
    %{
      symbol: symbol,
      side: side,
      type: "MARKET",
      quantity: quantity
    }
  end

  def stop(price, quantity, symbol, side, stop_price \\ nil) do
    %{
      symbol: symbol,
      side: side,
      type: "STOP",
      quantity: quantity,
      price: price,
      stop_price: stop_price || price,
      reduce_only: true
    }
  end

  def stop_market(price, quantity, symbol, side, stop_price \\ nil) do
    %{
      symbol: symbol,
      side: side,
      type: "TAKE_PROFIT",
      quantity: quantity,
      price: price,
      stop_price: stop_price || price,
      reduce_only: true
    }
  end

  def take_profit(price, quantity, symbol, side) do
    %{
      symbol: symbol,
      side: side,
      type: "TAKE_PROFIT_MARKET",
      quantity: quantity,
      stop_price: price,
      reduce_only: true
    }
  end

  def take_profit_market(price, symbol, side) do
    %{
      symbol: symbol,
      side: side,
      type: "TAKE_PROFIT_MARKET",
      stop_price: price,
      reduce_only: true
    }
  end

  def trailing_stop_market(side, symbol, callback_rate) do
    %{
      symbol: symbol,
      side: side,
      type: "TAKE_PROFIT_MARKET",
      callback_rate: callback_rate,
      reduce_only: true
    }
  end

  def reduce_only(params), do: Map.put(params, :reduce_only, true)
end

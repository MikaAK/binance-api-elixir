defmodule BinanceApi.Symbol do
  alias BinanceApi.HTTP

  @spec spot_ticker_price(symbol :: String.t, HTTP.opts) :: HTTP.res_single
  def spot_ticker_price(symbol, opts) when is_binary(symbol) do
    "/ticker/price"
      |> HTTP.build_v3_url
      |> HTTP.get(%{symbol: symbol}, opts)
  end

  @spec futures_ticker_price(symbol :: String.t, HTTP.opts) :: HTTP.res_single
  def futures_ticker_price(symbol, opts) do
    HTTP.futures_get("/ticker/price", %{symbol: symbol}, opts)
  end
end

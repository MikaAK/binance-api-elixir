defmodule BinanceApi.Symbol do
  alias BinanceApi.HTTP

  @spec ticker_price(symbol :: String.t, HTTP.opts) :: HTTP.res_single
  def ticker_price(symbol, opts) when is_binary(symbol) do
    "/ticker/price"
      |> HTTP.build_v3_url
      |> HTTP.get(%{symbol: symbol}, opts)
  end
end

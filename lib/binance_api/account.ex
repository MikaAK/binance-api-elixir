defmodule BinanceApi.Account do
  alias BinanceApi.HTTP

  @spec account(HTTP.opts) :: HTTP.res_single
  def account(opts) do
    "/account"
      |> HTTP.build_v3_url
      |> HTTP.get(Keyword.put(opts, :secured?, true))
  end
end


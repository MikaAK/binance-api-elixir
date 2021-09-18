defmodule BinanceApi do
  alias BinanceApi.HTTP

  def fetch_account(opts \\ []) do
    HTTP.get("/api/v3/account", nil, Keyword.merge(opts, [secured?: true]))
  end
end

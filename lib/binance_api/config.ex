defmodule BinanceApi.Config do
  @moduledoc false

  @app :binance_api

  def api_key, do: get_key(:api_key, "<BINANCE_API_KEY>")
  def secret_key, do: get_key(:secret_key, "<BINANCE_SECRET_KEY>")
  def base_url, do: get_key(:base_url, "https://api.binance.com")
  def base_futures_url, do: get_key(:base_futures_url, "https://fapi.binance.com")
  def secure_receive_window, do: get_key(:secure_receive_window, 5_000)

  def request_pool_timeout, do: get_sub_key(:request, :pool_timeout, 5_000)
  def request_receive_timeout, do: get_sub_key(:request, :receive_timeout, 15_000)

  def get_key(key, default), do: Application.get_env(@app, key, default)

  def get_sub_key(key, sub_key, default) do
    case get_key(key, default) do
      nil -> default
      key_list when is_list(key_list) -> key_list[sub_key]
      _ -> default
    end
  end
end

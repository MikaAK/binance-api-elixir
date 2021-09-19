defmodule BinanceApi.Config do
  @moduledoc false

  @app :binance_api

  def api_key, do: get_key(:api_key)
  def secret_key, do: get_key(:secret_key)
  def base_url, do: get_key(:base_url)
  def base_futures_url, do: get_key(:base_futures_url)
  def secure_receive_window, do: get_key(:secure_receive_window)

  def request_pool_timeout, do: get_sub_key(:request, :pool_timeout)
  def request_receive_timeout, do: get_sub_key(:request, :receive_timeout)

  def get_key(key), do: Application.get_env(@app, key)

  def get_sub_key(key, sub_key) do
    case get_key(key) do
      nil -> raise "Cannot find config for #{key} in :binance_api, this is required"
      key_list when is_list(key_list) -> key_list[sub_key]
      _ -> raise "Config for #{key} in :binance_api is not a keyword list"
    end
  end
end

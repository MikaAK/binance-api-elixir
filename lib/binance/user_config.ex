defmodule Binance.UserConfig do
  @moduledoc """
  Module for fetching `secret_key` and `api_key` from either a singular config or a
  multi-user configuration
  """

  defmodule KeyValidationError do
    defexception [:message]
  end

  def get_secret_key do
    validate_key(Application.get_env(:binance, :secret_key))
  end

  def get_secret_key(user) do
    get_and_validate_key(Application.get_env(:binance, user), :secret_key)
  end

  def get_api_key do
    validate_key(Application.get_env(:binance, :secret_key))
  end

  def get_api_key(user) do
    get_and_validate_key(Application.get_env(:binance, user), :secret_key)
  end

  defp get_and_validate_key(config, key) when is_map(config) do
    validate_key(config[key])
  end

  defp get_and_validate_key(config, key) do
    raise KeyValidationError, message: "config is not a map, Key: #{key} Config: #{inspect config}"
  end

  defp validate_key(key) when is_bitstring(key), do: key
  defp validate_key(key) when is_map(key), do: raise KeyValidationError, message: "Must use a user name when user config is used, given: #{inspect key}"
  defp validate_key(key) when is_nil(key), do: raise KeyValidationError, message: "Config cannot be nil"
end

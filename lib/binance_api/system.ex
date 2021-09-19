defmodule BinanceApi.System do
  alias BinanceApi.HTTP

  @spec spot_ping(HTTP.opts) :: :pong | HTTP.error
  def spot_ping(opts) do
    with {:ok, %{}} <- HTTP.get(HTTP.build_v3_url("/ping"), opts), do: :pong
  end

  @spec futures_ping(HTTP.opts) :: :pong | HTTP.error
  def futures_ping(opts) do
    with {:ok, %{}} <- HTTP.futures_get("/ping", opts), do: :pong
  end

  @spec server_time(HTTP.opts) :: HTTP.res_single
  def server_time(opts) do
    HTTP.get(HTTP.build_v3_url("/time"), opts)
  end

  @spec exchange_info(HTTP.opts) :: HTTP.res_single
  def exchange_info(opts) do
    HTTP.get(HTTP.build_v3_url("/exchangeInfo"), opts)
  end

  @spec system_status(HTTP.opts) :: HTTP.res_single
  def system_status(opts) do
    HTTP.get(HTTP.build_v1_url("/system/status"), opts)
  end
end

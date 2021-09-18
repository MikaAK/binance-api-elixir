defmodule BinanceApi.HTTP do
  alias BinanceApi.{Config, HTTP.UrlGenerator}

  @opts_definition [
    secured?: [type: :boolean, default: false],
    secret_key: [type: :string, default: Config.secret_key()],
    api_key: [type: :string, default: Config.api_key()],
    base_url: [type: :string, default: Config.base_url()],
    secure_receive_window: [type: :non_neg_integer, default: Config.secure_receive_window()],
    pool_timeout: [type: :non_neg_integer, default: Config.request_pool_timeout()],
    receive_timeout: [type: :non_neg_integer, default: Config.request_receive_timeout()]
  ]

  @moduledoc """
  This module constructs a request for binance using authentication information
  that is set in by the `opts` param

  By default the opts will use the `api_key` and `secret_key` set in the config

  ### Options

  #{NimbleOptions.docs(@opts_definition)}
  """

  @type opts :: [
    secured?: boolean,
    secret_key: String.t,
    api_key: String.t,
    base_url: String.t,
    secure_receive_window: non_neg_integer,
    pool_timeout: non_neg_integer,
    receive_timeout: non_neg_integer
  ]

  @type http_res :: {:ok, map | list} | {:error, %{code: atom, message: String.t}}

  @authorization_failure_error_codes [403]
  @not_found_failure_error_codes [404]

  @spec get(String.t, Keyword.t) :: http_res
  @spec get(String.t, nil | map, Keyword.t) :: http_res
  def get(url, params \\ nil, opts) do
    request(:get, url, params, opts)
  end

  @spec post(String.t, nil | map, Keyword.t) :: http_res
  def post(url, body, opts) do
    request(:post, url, body, opts)
  end

  defp request(method, url, body, opts) do
    opts = NimbleOptions.validate!(opts, @opts_definition)
    url = UrlGenerator.build(method, url, body, opts)

    res = method
      |> Finch.build(url, build_headers(opts[:api_key]), body)
      |> Finch.request(BinanceApi.Finch, Keyword.take(opts, [:pool_timeout, :receive_timeout]))

    with {:ok, res} <- res do
      handle_response(res)
    end
  end

  defp build_headers(api_key) do
    [
      {"X-MBX-APIKEY", api_key}
    ]
  end

  defp handle_response(%Finch.Response{status: 200, body: body}) do
    with {:ok, body} <- Jason.decode(body) do
      {:ok, ProperCase.to_snake_case(body)}
    end
  end

  defp handle_response(%Finch.Response{
    status: status_code,
    body: body
  } = request) when status_code in @not_found_failure_error_codes do
    {:error, %{code: :not_found, message: body, details: request}}
  end

  defp handle_response(%Finch.Response{
    status: status_code,
    body: body
  } = request) when status_code in @authorization_failure_error_codes do
    {:error, %{code: :unauthorized, message: body, details: request}}
  end

  defp handle_response(%Finch.Response{} = request) do
    {:error, %{code: :internal_server_error, message: "unhandled error code", details: request}}
  end
end

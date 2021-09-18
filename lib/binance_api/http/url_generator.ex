defmodule BinanceApi.HTTP.UrlGenerator do
  @moduledoc """
  This module constructs urls for requests, it includes adding signatures to
  the url and encoding params onto get requests
  """

  @spec build(:get | :post | :delete, String.t, map | nil, Keyword.t) :: String.t
  def build(method, url, body, opts) do
    opts[:base_url]
      |> Path.join(url)
      |> maybe_add_signature(method, body, opts)
  end

  # NOTE: Signature must be at the end of the query params or the request will fails
  defp maybe_add_signature(url, method, body, opts) do
    cond do
      opts[:secured?] ->
        args_str = %{
          "timestamp" => DateTime.to_unix(DateTime.utc_now(), :millisecond),
          "recvWindow" => opts[:secure_receive_window]
        }
          |> Map.merge(ProperCase.to_camel_case(body || %{}))
          |> URI.encode_query

        signature = generate_signature(args_str, opts[:secret_key])


        if method in [:get, :delete] do
          "#{url}?#{args_str}&signature=#{signature}"
        else
          "#{url}?signature=#{signature}"
        end

      is_map(body) and method in [:get, :delete] ->
        "#{url}?#{URI.encode_query(ProperCase.to_camel_case(body))}"

      true -> url
    end
  end

  defp generate_signature(args_string, secret_key) do
    :hmac
      |> :crypto.mac(
        :sha256,
        secret_key,
        args_string
      )
      |> Base.encode16()
  end
end

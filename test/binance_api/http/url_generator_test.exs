defmodule BinanceApi.HTTP.UrlGeneratorTest do
  use ExUnit.Case, async: true

  alias BinanceApi.HTTP.UrlGenerator

  @base_url "http://base_url.com"

  @params %{"item" => 1}

  @default_opts [base_url: @base_url]

  @secret_key "secret_key"
  @secure_opts [
    secured?: true,
    secure_receive_window: :timer.seconds(5),
    secret_key: @secret_key,
    base_url: @base_url
  ]

  describe "&build/4" do
    test "encodes url params with camelCase" do
      actual = UrlGenerator.build(:get, "/url", %{my_snake_case_item: 1}, @default_opts)

      assert actual === "#{@base_url}/url?mySnakeCaseItem=1"
    end

    test "returns url for GET without signature if non secured?: true" do
      actual = UrlGenerator.build(:get, "/url", %{item: 1}, @default_opts)

      assert actual === "#{@base_url}/url?item=1"
    end

    test "returns url for POST without signature if non secured?: true" do
      actual = UrlGenerator.build(:post, "/url", @params, @default_opts)

      assert actual === "#{@base_url}/url"
    end

    test "returns url for DELETE without signature if non secured?: true" do
      actual = UrlGenerator.build(:delete, "/url", @params, @default_opts)

      assert actual === "#{@base_url}/url?item=1"
    end

    test "returns url for GET without signature if non secured?: true and no params" do
      actual = UrlGenerator.build(:get, "/url", nil, @default_opts)

      assert actual === "#{@base_url}/url"
    end

    test "returns url for GET with signature if secured?: true in opts" do
      params = %{
        "item" => 1,
        "timestamp" => System.os_time(:millisecond),
        "recvWindow" => @secure_opts[:secure_receive_window]
      }

      actual = UrlGenerator.build(:get, "/url", params, @secure_opts)

      expected_params = "item=1&recvWindow=#{params["recvWindow"]}&timestamp=#{params["timestamp"]}&signature=#{generate_signature(params, @secret_key)}"

      assert actual === "#{@base_url}/url?#{expected_params}"
    end

    test "returns url for POST with signature if secured?: true in opts" do
      params = %{
        "item" => 1,
        "timestamp" => System.os_time(:millisecond),
        "recvWindow" => @secure_opts[:secure_receive_window]
      }

      actual = UrlGenerator.build(:post, "/url", params, @secure_opts)

      assert actual === "#{@base_url}/url?signature=#{generate_signature(params, @secret_key)}"
    end

    test "returns url for DELETE with signature if secured?: true in opts" do
      params = %{
        "item" => 1,
        "timestamp" => System.os_time(:millisecond),
        "recvWindow" => @secure_opts[:secure_receive_window]
      }

      actual = UrlGenerator.build(:delete, "/url", params, @secure_opts)

      expected_params = "item=1&recvWindow=#{params["recvWindow"]}&timestamp=#{params["timestamp"]}&signature=#{generate_signature(params, @secret_key)}"

      assert actual === "#{@base_url}/url?#{expected_params}"
    end
  end

  defp generate_signature(params, secret_key) do
    :hmac
      |> :crypto.mac(
        :sha256,
        secret_key,
        URI.encode_query(params)
      )
      |> Base.encode16()
  end
end

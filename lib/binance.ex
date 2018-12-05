defmodule Binance do
  @moduledoc """
  Main module that interacts with Binance
  """

  import Binance.UserConfig, only: [
    get_secret_key: 1,
    get_secret_key: 0,
    get_api_key: 1,
    get_api_key: 0
  ]

  import Binance.Request, only: [
    get_binance: 1,
    get_binance: 3,
    get_binance: 4,
    post_binance: 4,
    delete_binance: 4
  ]

  alias Binance.{TradePair, OrderConfig}

  defguardp is_user(val) when is_atom(val) or is_bitstring(val)
  defguardp is_config(val) when is_list(val) or is_atom(val)

  @doc """
  Pings binance API. Returns `{:ok, %{}}` if successful, `{:error, reason}` otherwise
  """
  def ping do
    get_binance("/api/v1/ping")
  end

  @doc """
  Get binance server time in unix epoch.

  Returns `{:ok, time}` if successful, `{:error, reason}` otherwise

  ## Example
  ```
  {:ok, 1515390701097}
  ```

  """
  def get_server_time do
    case get_binance("/api/v1/time") do
      {:ok, %{"serverTime" => time}} -> {:ok, time}
      err -> err
    end
  end

  def get_exchange_info do
    case get_binance("/api/v1/exchangeInfo") do
      {:ok, data} -> {:ok, Binance.ExchangeInfo.new(data)}
      err -> err
    end
  end

  # Ticker

  @doc """
  Get all symbols and current prices listed in binance

  Returns `{:ok, [%Binance.SymbolPrice{}]}` or `{:error, reason}`.

  ## Example
  ```
  {:ok,
    [%Binance.SymbolPrice{price: "0.07579300", symbol: "ETHBTC"},
     %Binance.SymbolPrice{price: "0.01670200", symbol: "LTCBTC"},
     %Binance.SymbolPrice{price: "0.00114550", symbol: "BNBBTC"},
     %Binance.SymbolPrice{price: "0.00640000", symbol: "NEOBTC"},
     %Binance.SymbolPrice{price: "0.00030000", symbol: "123456"},
     %Binance.SymbolPrice{price: "0.04895000", symbol: "QTUMETH"},
     ...]}
  ```
  """
  def get_all_prices do
    case get_binance("/api/v1/ticker/allPrices") do
      {:ok, data} ->
        {:ok, Enum.map(data, &Binance.SymbolPrice.new(&1))}

      err ->
        err
    end
  end

  @doc """
  Retrieves the current ticker information for the given trade pair.

  Symbol can be a binance symbol in the form of `"ETHBTC"` or `%TradePair{}`.

  Returns `{:ok, %Binance.Ticker{}}` or `{:error, reason}`

  ## Example
  ```
  {:ok,
    %Binance.Ticker{ask_price: "0.07548800", bid_price: "0.07542100",
      close_time: 1515391124878, count: 661676, first_id: 16797673,
      high_price: "0.07948000", last_id: 17459348, last_price: "0.07542000",
      low_price: "0.06330000", open_price: "0.06593800", open_time: 1515304724878,
      prev_close_price: "0.06593800", price_change: "0.00948200",
      price_change_percent: "14.380", volume: "507770.18500000",
      weighted_avg_price: "0.06946930"}}
  ```
  """
  def get_ticker(%TradePair{} = symbol) do
    case TradePair.find_symbol(symbol) do
      {:ok, binance_symbol} -> get_ticker(binance_symbol)
      e -> e
    end
  end

  def get_ticker(symbol) when is_binary(symbol) do
    case get_binance("/api/v1/ticker/24hr?symbol=#{symbol}") do
      {:ok, data} -> {:ok, Binance.Ticker.new(data)}
      err -> err
    end
  end

  @doc """
  Retrieves the bids & asks of the order book up to the depth for the given symbol

  Returns `{:ok, %{bids: [...], asks: [...], lastUpdateId: 12345}}` or `{:error, reason}`

  ## Example
  ```
  {:ok,
    %Binance.OrderBook{
      asks: [
        ["8400.00000000", "2.04078100", []],
        ["8405.35000000", "0.50354700", []],
        ["8406.00000000", "0.32769800", []],
        ["8406.33000000", "0.00239000", []],
        ["8406.51000000", "0.03241000", []]
      ],
      bids: [
        ["8393.00000000", "0.20453200", []],
        ["8392.57000000", "0.02639000", []],
        ["8392.00000000", "1.40893300", []],
        ["8390.09000000", "0.07047100", []],
        ["8388.72000000", "0.04577400", []]
      ],
      last_update_id: 113634395
    }
  }
  ```
  """
  def get_depth(symbol, limit) do
    case get_binance("/api/v1/depth?symbol=#{symbol}&limit=#{limit}") do
      {:ok, data} -> {:ok, Binance.OrderBook.new(data)}
      err -> err
    end
  end

  # Account

  @doc """
  Fetches user account from binance

  Returns `{:ok, %Binance.Account{}}` or `{:error, reason}`.

  In the case of a error on binance, for example with invalid parameters, `{:error, {:binance_error, %{code: code, msg: msg}}}` will be returned.

  Please read https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#account-information-user_data to understand API
  """
  def get_account do
    get_account(get_secret_key(), get_api_key())
  end

  def get_account(user) when is_user(user) do
    get_account(get_secret_key(user), get_api_key(user))
  end

  def get_account(secret_key, api_key) do
    case get_binance("/api/v3/account", secret_key, api_key) do
      {:ok, data} -> {:ok, Binance.Account.new(data)}
      error -> error
    end
  end

  # Order

  @doc """
    Check an order's status.

    Returns `{:ok, %Binance.OrderResponse{}}` or `{:error, reason}`

    ## Examples

        iex> Binance.get_order "ADABTC", 44730730
        {:ok,
        %Binance.OrderResponse{
          client_order_id: "web_0019daab853b4e129edfea4345cbda17",
          executed_qty: "0.00000000",
          iceberg_qty: "0.00000000",
          is_working: true,
          order_id: 44730730,
          orig_qty: "3893.00000000",
          price: "0.00003249",
          side: "SELL",
          status: "NEW",
          stop_price: "0.00000000",
          symbol: "ADABTC",
          time: 1531958591439,
          time_in_force: "GTC",
          transact_time: nil,
          type: "LIMIT"
        }}
  """
  def get_order(symbol, order_id, user) when is_binary(symbol) and is_user(user) do
    get_order(symbol, order_id, get_secret_key(user), get_api_key(user))
  end

  def get_order(symbol, order_id) when is_binary(symbol) do
    get_order(symbol, order_id, get_secret_key(), get_api_key())
  end

  def get_order(symbol, orderId, secret_key, api_key) when is_binary(symbol) do
    case get_binance("/api/v3/order", %{symbol: symbol, orderId: orderId}, secret_key, api_key) do
      {:ok, data} -> {:ok, Binance.OrderResponse.new(data)}
      err -> err
    end
  end

  @doc"""

  Cancel an active order.

  Returns `{:ok, %Binance.OrderResponse{}}` or `{:error, reason}`

  ## Examples

      iex> Binance.cancel_order "ADABTC", 18845701
      {:ok,
       %Binance.OrderResponse{
         client_order_id: "gO3U4DaFxcAgolV0nunw2U",
         executed_qty: nil,
         iceberg_qty: nil,
         is_working: nil,
         order_id: 18845701,
         orig_qty: nil,
         price: nil,
         side: nil,
         status: nil,
         stop_price: nil,
         symbol: "ADABTC",
         time: nil,
         time_in_force: nil,
         transact_time: nil,
         type: nil
       }}

  """
  def cancel_order(symbol, order_id) when is_binary(symbol) do
    cancel_order(symbol, order_id, get_secret_key(), get_api_key())
  end

  def cancel_order(symbol, order_id, user) when is_binary(symbol) and is_user(user) do
    cancel_order(symbol, order_id, get_secret_key(user), get_api_key(user))
  end

  def cancel_order(symbol, order_id, secret_key, api_key) when is_binary(symbol) do
    case delete_binance("/api/v3/order", %{symbol: symbol, orderId: order_id}, secret_key, api_key) do
      {:ok, data} -> {:ok, Binance.OrderResponse.new(data)}
      err -> err
    end
  end


  @doc """
  Get all open orders on a symbol. Careful when accessing this with no symbol.

  Returns `{:ok, %Binance.OrderResponse{}}` or `{:error, reason}`

  ## Examples

      iex(52)> Binance.open_orders "ADABTC"
      {:ok,
      [
        %Binance.OrderResponse{
          client_order_id: "web_0319daab853b4e129edfea4345cbda17",
          executed_qty: "0.00000000",
          iceberg_qty: "0.00000000",
          is_working: true,
          order_id: 44730734,
          orig_qty: "3893.00000000",
          price: "0.00003249",
          side: "SELL",
          status: "NEW",
          stop_price: "0.00000000",
          symbol: "ADABTC",
          time: 1531958591439,
          time_in_force: "GTC",
          transact_time: nil,
          type: "LIMIT"
        }
      ]}
  """
  def open_orders, do: execute_open_orders(%{}, get_secret_key(), get_api_key())
  def open_orders(user) when is_user(user), do: execute_open_orders(%{}, get_secret_key(user), get_api_key(user))
  def open_orders(symbol) when is_binary(symbol), do: execute_open_orders(%{symbol: symbol}, get_secret_key(), get_api_key())
  def open_orders(symbol, secret_key, api_key) when is_binary(symbol), do: execute_open_orders(%{symbol: symbol}, secret_key, api_key)

  defp execute_open_orders(params, secret_key, api_key) when is_map(params) do
    case get_binance("/api/v3/openOrders", params, secret_key, api_key) do
      {:ok, data} -> {:ok, Enum.map(data, &(Binance.OrderResponse.new(&1)))}
      err -> err
    end
  end

  @doc """
    Get all account orders; active, canceled, or filled.

    Returns `{:ok, %Binance.OrderResponse{}}` or `{:error, reason}`

    ## Examples

        iex> Binance.all_orders "ADBTC"
        {:ok,
        [
          %Binance.OrderResponse{
            client_order_id: "web_a26a41e71ca641e8812a444436e7b7cb",
            executed_qty: "3897.00000000",
            iceberg_qty: "0.00000000",
            is_working: true,
            order_id: 31501417,
            orig_qty: "3897.00000000",
            price: "0.00002606",
            side: "BUY",
            status: "FILLED",
            stop_price: "0.00000000",
            symbol: "ADABTC",
            time: 1526363552351,
            time_in_force: "GTC",
            transact_time: nil,
            type: "LIMIT"
          },
          %Binance.OrderResponse{
            client_order_id: "web_0119daab853b4e129edfea4345cbda17",
            executed_qty: "0.00000000",
            iceberg_qty: "0.00000000",
            is_working: true,
            order_id: 44700734,
            orig_qty: "3893.00000000",
            price: "0.00003249",
            side: "SELL",
            status: "NEW",
            stop_price: "0.00000000",
            symbol: "ADABTC",
            time: 1531958591439,
            time_in_force: "GTC",
            transact_time: nil,
            type: "LIMIT"
          }
        ]}
  """
  def all_orders(symbol) when is_binary(symbol) do
    execute_all_orders(%{symbol: symbol}, get_secret_key(), get_api_key())
  end

  def all_orders(symbol, user) when is_binary(symbol) and is_user(user) do
    execute_all_orders(%{symbol: symbol}, get_secret_key(user), get_api_key(user))
  end

  def all_orders(symbol, timestamp) when is_binary(symbol) and is_integer(timestamp) do
    execute_all_orders(%{symbol: symbol, timestamp: timestamp}, get_secret_key(), get_api_key())
  end

  def all_orders(symbol, timestamp, user) when is_binary(symbol) and is_integer(timestamp) and is_user(user) do
    execute_all_orders(%{symbol: symbol, timestamp: timestamp}, get_secret_key(user), get_api_key(user))
  end

  defp execute_all_orders(params, secret_key, api_key) when is_map(params) do
    case get_binance("/api/v3/allOrders", params, secret_key, api_key) do
      {:ok, data} -> {:ok, Enum.map(data, &(Binance.OrderResponse.new(&1)))}
      err -> err
    end
  end


  @doc """
  Creates a new order on binance

  Returns `{:ok, %{}}` or `{:error, reason}`.

  In the case of a error on binance, for example with invalid parameters, `{:error, {:binance_error, %{code: code, msg: msg}}}` will be returned.

  Please read https://www.binance.com/restapipub.html#user-content-account-endpoints to understand all the parameters
  """
  def create_order(%OrderConfig{} = order_config) do
    create_order(
      order_config,
      get_secret_key(),
      get_api_key()
    )
  end

  def create_order(%OrderConfig{} = order_config, user) when is_user(user) do
    create_order(
      order_config,
      get_secret_key(user),
      get_api_key(user)
    )
  end

  def create_order(
    %OrderConfig{
      symbol: %TradePair{} = symbol
    } = order_config,
    secret_key,
    api_key
  ) do
    with {:ok, symbol} <- TradePair.find_symbol(symbol) do
      order_config
        |> Map.put(:symbol, symbol)
        |> create_order(secret_key, api_key)
    end
  end

  def create_order(%OrderConfig{} = order_config, secret_key, api_key) do
    arguments = %{
      symbol: order_config.symbol,
      side: order_config.side,
      type: order_config.type,
      quantity: order_config.quantity,
      recvWindow: order_config.receiving_window
    }
      |> merge_param_if_exists(:newClientOrderId, order_config.new_client_order_id)
      |> merge_param_if_exists(:stopPrice, order_config.stop_price)
      |> merge_param_if_exists(:icebergQty, order_config.iceberg_quantity)
      |> merge_param_if_exists(:timeInForce, order_config.time_in_force)
      |> merge_param_if_exists(:price, order_config.price)
      |> Map.put(:timestamp, :os.system_time(:millisecond))
      |> parse_order_response

    post_binance("/api/v3/order", arguments, secret_key, api_key)
  end

  defp merge_param_if_exists(params, _key, item) when is_nil(item) do
    params
  end

  defp merge_param_if_exists(params, key, item) do
    Map.put(params, key, item)
  end

  defp parse_order_response({:ok, response}) do
    {:ok, Binance.OrderResponse.new(response)}
  end

  defp parse_order_response({
         :error,
         {
           :binance_error,
           %{code: -2010, msg: "Account has insufficient balance for requested action."} = reason
         }
       }) do
    {:error, %Binance.InsufficientBalanceError{reason: reason}}
  end

  @doc """
  Creates a new **limit** **buy** order

  Symbol can be a binance symbol in the form of `"ETHBTC"` or `%TradePair{}`.

  Returns `{:ok, %{}}` or `{:error, reason}`
  """
  def order_limit_buy(symbol, quantity, price, user, extra_config) when is_user(user) and is_config(extra_config) do
    symbol
      |> order_limit_buy_config(quantity, price)
      |> create_order(user)
  end

  def order_limit_buy(symbol, quantity, price, user) when is_user(user) do
    symbol
      |> order_limit_buy_config(quantity, price)
      |> create_order(user)
  end

  def order_limit_buy(symbol, quantity, price, extra_config) when is_config(extra_config) do
    symbol
      |> order_limit_buy_config(quantity, price, extra_config)
      |> create_order
  end

  def order_limit_buy(symbol, quantity, price) do
    symbol
      |> order_limit_buy_config(quantity, price)
      |> create_order
  end

  defp order_limit_buy_config(symbol, quantity, price, extra_config \\ []) do
    struct!(%OrderConfig{
      side: "BUY",
      type: "LIMIT",
      symbol: symbol,
      quantity: quantity,
      price: price,
    }, extra_config)
  end

  @doc """
  Creates a new **limit** **sell** order

  Symbol can be a binance symbol in the form of `"ETHBTC"` or `%TradePair{}`.

  Returns `{:ok, %{}}` or `{:error, reason}`
  """
  def order_limit_sell(symbol, quantity, price, user, extra_config) when is_user(user) and is_config(extra_config) do
    symbol
      |> order_limit_sell_config(quantity, price)
      |> create_order(user)
  end

  def order_limit_sell(symbol, quantity, price, user) when is_user(user) do
    symbol
      |> order_limit_sell_config(quantity, price)
      |> create_order(user)
  end

  def order_limit_sell(symbol, quantity, price, extra_config) when is_config(extra_config) do
    symbol
      |> order_limit_sell_config(quantity, price, extra_config)
      |> create_order
  end

  def order_limit_sell(symbol, quantity, price) do
    symbol
      |> order_limit_sell_config(quantity, price)
      |> create_order
  end

  defp order_limit_sell_config(symbol, quantity, price, extra_config \\ []) do
    struct!(%OrderConfig{
      side: "SELL",
      type: "LIMIT",
      symbol: symbol,
      quantity: quantity,
      price: price,
    }, extra_config)
  end

  @doc """
  Creates a new **market** **buy** order

  Symbol can be a binance symbol in the form of `"ETHBTC"` or `%TradePair{}`.

  Returns `{:ok, %{}}` or `{:error, reason}`
  """
  def order_market_buy(symbol, quantity, price, user, extra_config) when is_user(user) and is_config(extra_config) do
    symbol
      |> order_market_buy_config(quantity, price)
      |> create_order(user)
  end

  def order_market_buy(symbol, quantity, price, user) when is_user(user) do
    symbol
      |> order_market_buy_config(quantity, price)
      |> create_order(user)
  end

  def order_market_buy(symbol, quantity, price, extra_config) when is_config(extra_config) do
    symbol
      |> order_market_buy_config(quantity, price, extra_config)
      |> create_order
  end

  def order_market_buy(symbol, quantity, price) do
    symbol
      |> order_market_buy_config(quantity, price)
      |> create_order
  end

  defp order_market_buy_config(symbol, quantity, price, extra_config \\ []) do
    struct!(%OrderConfig{
      side: "BUY",
      type: "MARKET",
      symbol: symbol,
      quantity: quantity,
      price: price,
    }, extra_config)
  end

  @doc """
  Creates a new **market** **sell** order

  Symbol can be a binance symbol in the form of `"ETHBTC"` or `%TradePair{}`.

  Returns `{:ok, %{}}` or `{:error, reason}`
  """
  def order_market_sell(symbol, quantity, price, user, extra_config) when is_user(user) and is_config(extra_config) do
    symbol
      |> order_market_sell_config(quantity, price)
      |> create_order(user)
  end

  def order_market_sell(symbol, quantity, price, user) when is_user(user) do
    symbol
      |> order_market_sell_config(quantity, price)
      |> create_order(user)
  end

  def order_market_sell(symbol, quantity, price, extra_config) when is_config(extra_config) do
    symbol
      |> order_market_sell_config(quantity, price, extra_config)
      |> create_order
  end

  def order_market_sell(symbol, quantity, price) do
    symbol
      |> order_market_sell_config(quantity, price)
      |> create_order
  end

  defp order_market_sell_config(symbol, quantity, price, extra_config \\ []) do
    struct!(%OrderConfig{
      side: "BUY",
      type: "MARKET",
      symbol: symbol,
      quantity: quantity,
      price: price,
    }, extra_config)
  end
end

defmodule Binance.TradePair do
  @moduledoc """
  Struct for representing a normalized trade pair.

  ```
  @enforce_keys [:from, :to]
  defstruct @enforce_keys
  ```
  """

  @enforce_keys [:from, :to]
  defstruct @enforce_keys

  @doc """
  Searches and normalizes the symbol as it is listed on binance.

  To retrieve this information, a request to the binance API is done. The result is then **cached** to ensure the request is done only once.

  Order of which symbol comes first, and case sensitivity does not matter.

  Returns `{:ok, "SYMBOL"}` if successfully, or `{:error, reason}` otherwise.

  ## Examples
  These 3 calls will result in the same result string:
  ```
  find_symbol(%Binance.TradePair{from: "ETH", to: "REQ"})
  ```
  ```
  find_symbol(%Binance.TradePair{from: "REQ", to: "ETH"})
  ```
  ```
  find_symbol(%Binance.TradePair{from: "rEq", to: "eTH"})
  ```

  Result: `{:ok, "REQETH"}`

  """
  def find_symbol(%Binance.TradePair{from: from, to: to} = tp)
      when is_binary(from)
      when is_binary(to) do
    case Binance.SymbolCache.get() do
      {:ok, data} -> get_from_cache(String.upcase(from), String.upcase(to), data)
      {:error, :not_initialized} -> get_and_cahce_symbol(tp)
      err -> err
    end
  end

  defp get_from_cache(from, to, data) do
    items = Enum.filter(data, &Enum.member?([from <> to, to <> from], &1))

    case items do
      [] -> {:error, :symbol_not_found}
      cache_items -> {:ok, List.first(cache_items)}
    end
  end

  defp get_and_cahce_symbol(%Binance.TradePair{} = tp) do
    case Binance.get_all_prices() do
      {:ok, price_data} ->
        price_data
          |> Enum.map(&(&1.symbol))
          |> Binance.SymbolCache.store()

        find_symbol(tp)

      err ->
        err
    end
  end
end

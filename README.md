## Installation

1. The package can be installed by adding `binance_api` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:binance_api, "~> 0.1.0"}
  ]
end
```

3. Add your Binance API credentials to your `config.exs` file, like so (you can create a new API
key [here](https://www.binance.com/userCenter/createApi.html)):

```elixir
config :binance_api,
  api_key: "xxx",
  secret_key: "xxx"
```
or for multiple users
```elixir
# Note: This requires you to call most apis with the user
# Example: `get_account(:tim)`
config :binance_api, :tim,
  api_key: "xxx",
  secret_key: "xxx"
```

## TODO:
- [ ] Add Websockets

## Usage

Documentation available at [https://hexdocs.pm/binance_api](https://hexdocs.pm/binance_api).

Get all prices
```elixir
iex> Binance.get_all_prices
{:ok,
 [%Binance.SymbolPrice{price: "0.07718300", symbol: "ETHBTC"},
  %Binance.SymbolPrice{price: "0.01675400", symbol: "LTCBTC"},
  %Binance.SymbolPrice{price: "0.00114690", symbol: "BNBBTC"},
  %Binance.SymbolPrice{price: "0.00655900", symbol: "NEOBTC"},
  %Binance.SymbolPrice{price: "0.00030000", symbol: "123456"},
  %Binance.SymbolPrice{price: "0.04754000", symbol: "QTUMETH"},
  %Binance.SymbolPrice{price: "0.00778500", symbol: "EOSETH"}
  ...]}
```

Buy 100 REQ for the current market price

```elixir
iex> Binance.order_market_buy("REQETH", 100)
{:ok, %{}}
```

## Trade pair normalization

For convenience, all functions that require a symbol in the form of "ETHBTC" also accept a
`%Binance.TradePair{}` struct in the form of `%Binance.TradePair{from: "ETH", to: "BTC"}`. The order of symbols in `%Binance.TradePair{}` does not matter. All symbols are also case insensitive.

`Binance.find_symbol/1` will return the correct string representation as it is listed on binance

```elixir
Binance.find_symbol(%Binance.TradePair{from: "ReQ", to: "eTH"})
{:ok, "REQETH"}

Binance.find_symbol(%Binance.TradePair{from: "ETH", to: "REQ"})
{:ok, "REQETH"}
```

## Credit
Lot's of credit to [binance.ex](https://github.com/dvcrn/binance.ex) from which this lib spawned.

## License
MIT

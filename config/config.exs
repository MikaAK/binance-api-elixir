import Config

config :binance_api,
  api_key: "<BINANCE_API_KEY>",
  secret_key: "<BINANCE_SECRET_KEY>",
  base_url: "https://api.binance.com",
  base_futures_url: "https://fapi.binance.com",
  secure_receive_window: 5_000,

  request: [
    pool_timeout: 5_000,
    receive_timeout: 15_000
  ]

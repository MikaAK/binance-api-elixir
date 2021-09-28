## Changelog

### V0.2.14
fix issue with placing batch orders

### V0.2.12
add find order api for spot and futures

### V0.2.11
Fix issue where config sometimes didn't make it in from other apps

### V0.2.10
Add BinanceApi.Order.Builder to help with `place_orders`

### V0.2.9
Add cancel_open_orders to Spot and USDMFutures
Remove cancel_orders from spot

### V0.2.8
Add get_all_orders to Spot and USDMFutures

### V0.2.7
Add futures get ticker function

### V0.2.5
Fix config error

### V0.2.4
Include default config in release

### V0.2.3
Fix bugs with order creation in spot & futures

### V0.2.2
Fix not including futures base url by default

### V0.2.1
Adds in the futures api for orders

### V0.2.0
This version is a complete rewrite that removes the structs and simplifies the logic

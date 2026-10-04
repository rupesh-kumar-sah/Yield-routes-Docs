# Vault API Reference

The Vault API provides endpoints for inspecting and interacting with SEP-56 compliant YieldRoutes yield-bearing token vaults.

---

## Endpoints Summary

| Method | Path | Auth Required | Description |
|---|---|---|---|
| `GET` | `/vault` | No | Get vault overview and financial statistics |
| `GET` | `/vault/share-price` | No | Get current asset/share conversion rate |
| `GET` | `/vault/preview-deposit` | No | Calculate shares received for asset amount |
| `GET` | `/vault/preview-redeem` | No | Calculate assets returned for share amount |
| `GET` | `/vault/deposits` | No | List recent deposit history |
| `GET` | `/vault/withdrawals` | No | List recent redemption/withdrawal history |
| `GET` | `/vault/harvests` | No | List yield harvest events |
| `GET` | `/vault/depositor/:address`| No | User balance, shares, and accrued yield |
| `POST` | `/vault/deposit` | No | Prepare deposit transaction payload |
| `POST` | `/vault/redeem` | No | Prepare redeem transaction payload |
| `POST` | `/vault/withdraw` | No | Prepare exact-asset withdrawal transaction |
| `POST` | `/vault/harvest` | Yes (`x-api-key`) | Trigger compound yield harvest |

---

## 1. Vault Stats & Share Price

### Get Vault Stats

```http
GET /vault HTTP/1.1
Host: api.yieldroutes.io
```

#### Response (`200 OK`)

```json
{
  "success": true,
  "data": {
    "totalAssets": "1250000.00",
    "totalSupply": "1190476.19",
    "sharePrice": 1.05,
    "apyPercent": 8.42,
    "assetSymbol": "USDC"
  }
}
```

### Get Share Price

```http
GET /vault/share-price HTTP/1.1
Host: api.yieldroutes.io
```

#### Response (`200 OK`)

```json
{
  "success": true,
  "data": {
    "sharePrice": 1.05,
    "baseAsset": "USDC",
    "timestamp": 1728043200
  }
}
```

---

## 2. Preview Calculations

### Preview Deposit

Calculates the number of vault shares an investor will receive when depositing `assets`.

```http
GET /vault/preview-deposit?assets=1000 HTTP/1.1
Host: api.yieldroutes.io
```

#### Response (`200 OK`)

```json
{
  "success": true,
  "data": {
    "assets": 1000.0,
    "expectedShares": 952.38
  }
}
```

### Preview Redeem

Calculates the amount of underlying assets returned when redeeming `shares`.

```http
GET /vault/preview-redeem?shares=1000 HTTP/1.1
Host: api.yieldroutes.io
```

#### Response (`200 OK`)

```json
{
  "success": true,
  "data": {
    "shares": 1000.0,
    "expectedAssets": 1050.0
  }
}
```

---

## 3. User & Historical Queries

### Get Depositor Info

```http
GET /vault/depositor/GA2C5RFPE6GCKMY3US5HHS6TDGNOQCH7S4AHFD2MQVDWDGI4MGDFFMQW HTTP/1.1
Host: api.yieldroutes.io
```

#### Response (`200 OK`)

```json
{
  "success": true,
  "data": {
    "address": "GA2C5RFPE6GCKMY3US5HHS6TDGNOQCH7S4AHFD2MQVDWDGI4MGDFFMQW",
    "sharesOwned": 5000.0,
    "currentAssetValue": 5250.0,
    "totalEarnedYield": 250.0
  }
}
```

---

## 4. Vault Transactions

### Deposit Assets

Prepares an on-chain deposit transaction.

```http
POST /vault/deposit HTTP/1.1
Host: api.yieldroutes.io
Content-Type: application/json

{
  "depositor": "GA2C5RFPE6GCKMY3US5HHS6TDGNOQCH7S4AHFD2MQVDWDGI4MGDFFMQW",
  "amount": 1000.0
}
```

#### Response (`200 OK`)

```json
{
  "success": true,
  "data": {
    "status": "READY_TO_SIGN",
    "xdr": "AAAAAgAAAA...",
    "estimatedShares": 952.38
  }
}
```

### Redeem Shares

Prepares an on-chain redeem transaction to burn shares in exchange for underlying assets.

```http
POST /vault/redeem HTTP/1.1
Host: api.yieldroutes.io
Content-Type: application/json

{
  "depositor": "GA2C5RFPE6GCKMY3US5HHS6TDGNOQCH7S4AHFD2MQVDWDGI4MGDFFMQW",
  "shares": 952.38
}
```

#### Response (`200 OK`)

```json
{
  "success": true,
  "data": {
    "status": "READY_TO_SIGN",
    "xdr": "AAAAAgAAAA...",
    "estimatedAssets": 1000.0
  }
}
```

### Trigger Harvest

Harvests accrued protocol yield, distributes fees, and increases share price. Requires authorized backend cron key.

```http
POST /vault/harvest HTTP/1.1
Host: api.yieldroutes.io
x-api-key: your-api-key-here
Content-Type: application/json

{
  "grossYield": 1500.0
}
```

#### Response (`200 OK`)

```json
{
  "success": true,
  "message": "Harvest executed",
  "data": {
    "grossYield": 1500.0,
    "newSharePrice": 1.052
  }
}
```

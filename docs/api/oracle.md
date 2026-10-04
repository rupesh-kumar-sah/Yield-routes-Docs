# Oracle API Reference

The Oracle API manages real-time price feeds, price observation history, and authorized price feed submissions for routing valuation.

---

## Endpoints Summary

| Method | Path | Auth Required | Description |
|---|---|---|---|
| `GET` | `/oracle` | No | List latest prices across all monitored pairs |
| `GET` | `/oracle/:baseToken/:quoteToken` | No | Get the latest spot price for a pair |
| `GET` | `/oracle/:baseToken/:quoteToken/history` | No | Get historical price samples for TWAP analysis |
| `POST` | `/oracle/submit` | Yes (`x-api-key`) | Submit price update from authorized reporter |

---

## 1. List Latest Prices

Returns the latest price feed observations across all active token pairs.

### Request

```http
GET /oracle HTTP/1.1
Host: api.yieldroutes.io
```

### Curl Example

```bash
curl -X GET "https://api.yieldroutes.io/oracle" \
  -H "Accept: application/json"
```

### Response (`200 OK`)

```json
{
  "success": true,
  "data": [
    {
      "baseToken": "CAS3J7GYLGXMF6TDJBBYYSE3VGSBRUCM5CKNPHFUMWGO6WD3GIS64ALZ",
      "quoteToken": "CDLZFC3SYJYDZT7K67VZ75HPJVIEUVNIXF47ZG2FB2RMQQVU2HHGCYSC",
      "price": 0.1245,
      "updatedAt": "2026-10-04T12:00:00Z"
    }
  ]
}
```

---

## 2. Get Price for Pair

Fetches the current price and timestamp for a specific pair.

### Request

```http
GET /oracle/:baseToken/:quoteToken HTTP/1.1
Host: api.yieldroutes.io
```

### Parameters

- `baseToken` (path, required): 56-character Stellar token address.
- `quoteToken` (path, required): 56-character Stellar quote token address.

### Curl Example

```bash
curl -X GET "https://api.yieldroutes.io/oracle/CAS3J7GYLGXMF6TDJBBYYSE3VGSBRUCM5CKNPHFUMWGO6WD3GIS64ALZ/CDLZFC3SYJYDZT7K67VZ75HPJVIEUVNIXF47ZG2FB2RMQQVU2HHGCYSC" \
  -H "Accept: application/json"
```

### Response (`200 OK`)

```json
{
  "success": true,
  "data": {
    "baseToken": "CAS3J7GYLGXMF6TDJBBYYSE3VGSBRUCM5CKNPHFUMWGO6WD3GIS64ALZ",
    "quoteToken": "CDLZFC3SYJYDZT7K67VZ75HPJVIEUVNIXF47ZG2FB2RMQQVU2HHGCYSC",
    "price": 0.1245,
    "lastUpdated": 1728043200,
    "confidence": 0.99
  }
}
```

---

## 3. Get Price History

Retrieves historical price records for calculating time-weighted average prices (TWAP) or plotting volatility.

### Request

```http
GET /oracle/:baseToken/:quoteToken/history HTTP/1.1
Host: api.yieldroutes.io
```

### Query Parameters

- `limit` (optional, default `50`): Number of history points to return (max 500).
- `interval` (optional, default `1h`): Granularity (`1m`, `5m`, `1h`, `1d`).

### Curl Example

```bash
curl -X GET "https://api.yieldroutes.io/oracle/CAS3J7GYLGXMF6TDJBBYYSE3VGSBRUCM5CKNPHFUMWGO6WD3GIS64ALZ/CDLZFC3SYJYDZT7K67VZ75HPJVIEUVNIXF47ZG2FB2RMQQVU2HHGCYSC/history?limit=24&interval=1h" \
  -H "Accept: application/json"
```

### Response (`200 OK`)

```json
{
  "success": true,
  "data": [
    {
      "price": 0.1238,
      "timestamp": 1728039600
    },
    {
      "price": 0.1245,
      "timestamp": 1728043200
    }
  ]
}
```

---

## 4. Submit Price

Publishes a new validated oracle price observation into the protocol.

### Request

```http
POST /oracle/submit HTTP/1.1
Host: api.yieldroutes.io
x-api-key: your-api-key-here
Content-Type: application/json
```

### Request Body Schema

| Field | Type | Rules | Description |
|---|---|---|---|
| `baseToken` | string | 56 chars | Base token contract address |
| `quoteToken` | string | 56 chars | Quote token contract address |
| `price` | number | positive | Spot exchange rate |
| `reporter` | string | 56 chars | Authorized reporter account address |

### Curl Example

```bash
curl -X POST "https://api.yieldroutes.io/oracle/submit" \
  -H "x-api-key: $YIELD_ROUTES_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "baseToken": "CAS3J7GYLGXMF6TDJBBYYSE3VGSBRUCM5CKNPHFUMWGO6WD3GIS64ALZ",
    "quoteToken": "CDLZFC3SYJYDZT7K67VZ75HPJVIEUVNIXF47ZG2FB2RMQQVU2HHGCYSC",
    "price": 0.1245,
    "reporter": "GA2C5RFPE6GCKMY3US5HHS6TDGNOQCH7S4AHFD2MQVDWDGI4MGDFFMQW"
  }'
```

### Response (`201 Created`)

```json
{
  "success": true,
  "message": "Price observation recorded"
}
```

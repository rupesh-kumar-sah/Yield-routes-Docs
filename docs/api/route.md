# Route API Reference

The Route API discovers optimal swap paths across registered AMM pools and prepares atomic swap transactions.

---

## Endpoints Summary

| Method | Path | Auth Required | Description |
|---|---|---|---|
| `GET` | `/route` | No | List recent routing quotes |
| `GET` | `/route/stats` | No | Aggregate swap and routing metrics |
| `POST` | `/route/quote` | No | Calculate best execution route across pools |
| `POST` | `/route/execute` | No | Submit route execution transaction payload |
| `GET` | `/route/:id` | No | Fetch details of a specific quote |

---

## 1. Get Route Quote

Calculates the optimal trade execution route for swapping `tokenIn` to `tokenOut`.

### Request

```http
POST /route/quote HTTP/1.1
Host: api.yieldroutes.io
Content-Type: application/json
```

### Request Body Schema

| Field | Type | Rules | Description |
|---|---|---|---|
| `tokenIn` | string | 56 chars | Input token contract address |
| `tokenOut` | string | 56 chars | Output token contract address |
| `amountIn` | number | positive | Amount of `tokenIn` to swap |
| `maxHops` | number | integer, 1 to 6 (default: 3) | Maximum intermediate pools |

### Curl Example

```bash
curl -X POST "https://api.yieldroutes.io/route/quote" \
  -H "Content-Type: application/json" \
  -d '{
    "tokenIn": "CAS3J7GYLGXMF6TDJBBYYSE3VGSBRUCM5CKNPHFUMWGO6WD3GIS64ALZ",
    "tokenOut": "CDLZFC3SYJYDZT7K67VZ75HPJVIEUVNIXF47ZG2FB2RMQQVU2HHGCYSC",
    "amountIn": 1000.0,
    "maxHops": 3
  }'
```

### Response (`200 OK`)

```json
{
  "success": true,
  "data": {
    "quoteId": "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d",
    "tokenIn": "CAS3J7GYLGXMF6TDJBBYYSE3VGSBRUCM5CKNPHFUMWGO6WD3GIS64ALZ",
    "tokenOut": "CDLZFC3SYJYDZT7K67VZ75HPJVIEUVNIXF47ZG2FB2RMQQVU2HHGCYSC",
    "amountIn": 1000.0,
    "expectedOut": 124.25,
    "minOut": 123.0,
    "priceImpactBps": 12,
    "path": [
      "CAS3J7GYLGXMF6TDJBBYYSE3VGSBRUCM5CKNPHFUMWGO6WD3GIS64ALZ",
      "CDLZFC3SYJYDZT7K67VZ75HPJVIEUVNIXF47ZG2FB2RMQQVU2HHGCYSC"
    ],
    "expiresAt": 1728043500
  }
}
```

---

## 2. Execute Route

Prepares or submits a swap execution transaction referencing an active quote.

### Request

```http
POST /route/execute HTTP/1.1
Host: api.yieldroutes.io
Content-Type: application/json
```

### Request Body Schema

| Field | Type | Rules | Description |
|---|---|---|---|
| `quoteId` | string | UUID | Active quote identifier |
| `sender` | string | 56 chars | User's Stellar account public key |
| `minOut` | number | non-negative (default: 0) | Minimum acceptable output token amount |

### Curl Example

```bash
curl -X POST "https://api.yieldroutes.io/route/execute" \
  -H "Content-Type: application/json" \
  -d '{
    "quoteId": "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d",
    "sender": "GA2C5RFPE6GCKMY3US5HHS6TDGNOQCH7S4AHFD2MQVDWDGI4MGDFFMQW",
    "minOut": 123.0
  }'
```

### Response (`200 OK`)

```json
{
  "success": true,
  "data": {
    "txHash": "a1b2c3d4e5f67890123456789abcdef0123456789abcdef0123456789abcdef0",
    "status": "PENDING_SIGNATURE",
    "xdr": "AAAAAgAAAA..."
  }
}
```

---

## 3. Get Route Quote by ID

Fetches details and status of a previously generated quote.

### Request

```http
GET /route/:id HTTP/1.1
Host: api.yieldroutes.io
```

### Curl Example

```bash
curl -X GET "https://api.yieldroutes.io/route/9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d" \
  -H "Accept: application/json"
```

---

## 4. Route Statistics

Provides aggregate statistics about volume, routing efficiency, and most popular paths.

### Request

```http
GET /route/stats HTTP/1.1
Host: api.yieldroutes.io
```

### Curl Example

```bash
curl -X GET "https://api.yieldroutes.io/route/stats" \
  -H "Accept: application/json"
```

### Response (`200 OK`)

```json
{
  "success": true,
  "data": {
    "totalQuotesGenerated": 45120,
    "totalVolumeUSD": 1420500.0,
    "averageSlippageBps": 8.5
  }
}
```

# Pools API Reference

The Pools API enables liquidity pool indexing, pair discovery, and registry management for decentralized exchange pools in YieldRoutes.

---

## Endpoints Summary

| Method | Path | Auth Required | Description |
|---|---|---|---|
| `GET` | `/pools` | No | List all active liquidity pools |
| `GET` | `/pools/:tokenA/:tokenB` | No | Get pool details for a specific token pair |
| `POST` | `/pools/register` | Yes (`x-api-key`) | Register a new liquidity pool |
| `DELETE` | `/pools/:id` | Yes (`x-api-key`) | Deregister/archive an existing pool |

---

## 1. List All Pools

Retrieves a list of all active registered liquidity pools with their current reserves and fee tier.

### Request

```http
GET /pools HTTP/1.1
Host: api.yieldroutes.io
```

### Curl Example

```bash
curl -X GET "https://api.yieldroutes.io/pools" \
  -H "Accept: application/json"
```

### Response (`200 OK`)

```json
{
  "success": true,
  "data": [
    {
      "id": "pool-7f8e3c12-3b4a-4d2c-9a1f-8e5f2a1b9c3d",
      "tokenA": "CAS3J7GYLGXMF6TDJBBYYSE3VGSBRUCM5CKNPHFUMWGO6WD3GIS64ALZ",
      "tokenB": "CDLZFC3SYJYDZT7K67VZ75HPJVIEUVNIXF47ZG2FB2RMQQVU2HHGCYSC",
      "poolAddress": "CBPTBPL7GYLGXMF6TDJBBYYSE3VGSBRUCM5CKNPHFUMWGO6WD3GIS64A",
      "reserveA": "500000.00",
      "reserveB": "250000.00",
      "feeBps": 30,
      "createdAt": "2026-09-15T10:00:00Z"
    }
  ]
}
```

---

## 2. Get Pool by Token Pair

Retrieves the pool configured for a specific token pair. Order of `tokenA` and `tokenB` is automatically canonicalized.

### Request

```http
GET /pools/:tokenA/:tokenB HTTP/1.1
Host: api.yieldroutes.io
```

### Parameters

- `tokenA` (path, required): 56-character Stellar token contract address.
- `tokenB` (path, required): 56-character Stellar token contract address.

### Curl Example

```bash
curl -X GET "https://api.yieldroutes.io/pools/CAS3J7GYLGXMF6TDJBBYYSE3VGSBRUCM5CKNPHFUMWGO6WD3GIS64ALZ/CDLZFC3SYJYDZT7K67VZ75HPJVIEUVNIXF47ZG2FB2RMQQVU2HHGCYSC" \
  -H "Accept: application/json"
```

### Response (`200 OK`)

```json
{
  "success": true,
  "data": {
    "id": "pool-7f8e3c12-3b4a-4d2c-9a1f-8e5f2a1b9c3d",
    "tokenA": "CAS3J7GYLGXMF6TDJBBYYSE3VGSBRUCM5CKNPHFUMWGO6WD3GIS64ALZ",
    "tokenB": "CDLZFC3SYJYDZT7K67VZ75HPJVIEUVNIXF47ZG2FB2RMQQVU2HHGCYSC",
    "poolAddress": "CBPTBPL7GYLGXMF6TDJBBYYSE3VGSBRUCM5CKNPHFUMWGO6WD3GIS64A",
    "reserveA": "500000.00",
    "reserveB": "250000.00",
    "feeBps": 30
  }
}
```

---

## 3. Register Pool

Registers a new liquidity pool in the protocol registry. Requires an admin API key.

### Request

```http
POST /pools/register HTTP/1.1
Host: api.yieldroutes.io
x-api-key: your-api-key-here
Content-Type: application/json
```

### Request Body Schema

| Field | Type | Rules | Description |
|---|---|---|---|
| `tokenA` | string | 56 characters | Contract address of token A |
| `tokenB` | string | 56 characters | Contract address of token B |
| `poolAddress` | string | 56 characters | Deployed AMM pool contract address |

### Curl Example

```bash
curl -X POST "https://api.yieldroutes.io/pools/register" \
  -H "x-api-key: $YIELD_ROUTES_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "tokenA": "CAS3J7GYLGXMF6TDJBBYYSE3VGSBRUCM5CKNPHFUMWGO6WD3GIS64ALZ",
    "tokenB": "CDLZFC3SYJYDZT7K67VZ75HPJVIEUVNIXF47ZG2FB2RMQQVU2HHGCYSC",
    "poolAddress": "CBPTBPL7GYLGXMF6TDJBBYYSE3VGSBRUCM5CKNPHFUMWGO6WD3GIS64A"
  }'
```

### Response (`201 Created`)

```json
{
  "success": true,
  "message": "Pool registered successfully",
  "data": {
    "id": "pool-7f8e3c12-3b4a-4d2c-9a1f-8e5f2a1b9c3d",
    "poolAddress": "CBPTBPL7GYLGXMF6TDJBBYYSE3VGSBRUCM5CKNPHFUMWGO6WD3GIS64A"
  }
}
```

---

## 4. Deregister Pool

Removes or archives an existing liquidity pool from active routing.

### Request

```http
DELETE /pools/:id HTTP/1.1
Host: api.yieldroutes.io
x-api-key: your-api-key-here
```

### Curl Example

```bash
curl -X DELETE "https://api.yieldroutes.io/pools/pool-7f8e3c12-3b4a-4d2c-9a1f-8e5f2a1b9c3d" \
  -H "x-api-key: $YIELD_ROUTES_API_KEY"
```

### Response (`200 OK`)

```json
{
  "success": true,
  "message": "Pool deregistered successfully"
}
```

# Authentication & API Overview

All requests to protected endpoints in the YieldRoutes backend API require an API key passed via the `x-api-key` HTTP header.

```http
x-api-key: your-api-key-here
```

Public read-only endpoints (such as price fetching, quote calculation, and pool exploration) do not require authentication unless rate-limiting thresholds are reached.

## Base URL

```text
https://api.yieldroutes.io
```

Or for local development:

```text
http://localhost:3000
```

---

## Route Groups

- [Pools API Reference](./pools.md): Liquidity pool discovery, pair registry, and pool management.
- [Oracle API Reference](./oracle.md): Real-time token prices, price submission, and historical price queries.
- [Route API Reference](./route.md): Multi-hop quote discovery, route simulation, and route execution.
- [Vault API Reference](./vault.md): SEP-56 yield vault statistics, share price calculations, deposit/redeem previews, and automated harvest operations.

---

## Common HTTP Status Codes

| Status Code | Description |
|---|---|
| `200 OK` | Request completed successfully. |
| `201 Created` | Resource registered or created successfully. |
| `400 Bad Request` | Missing or invalid request parameters / request body validation error. |
| `401 Unauthorized` | Missing or invalid `x-api-key` header for protected endpoints. |
| `404 Not Found` | The requested resource (pool, quote, or price) was not found. |
| `500 Internal Server Error` | Unexpected server failure or upstream RPC communication issue. |

---

## Error Response Format

All error responses return a standardized JSON structure:

```json
{
  "success": false,
  "error": {
    "code": "INVALID_PARAMS",
    "message": "Token addresses must be valid 56-character Stellar public keys."
  }
}
```

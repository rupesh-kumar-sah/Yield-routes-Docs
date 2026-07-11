# YieldRoutes — Quickstart Guide

## Prerequisites

```bash
rustup target add wasm32-unknown-unknown
cargo install --locked stellar-cli --features opt
stellar keys generate --global deployer --network testnet
stellar keys fund deployer --network testnet
nvm install 20
```

## Deploy

```bash
git clone https://github.com/yield-routes/yield-routes.git
cd yield-routes

cargo build --release --target wasm32-unknown-unknown
cargo test    # 13 tests

export USDC_CONTRACT_ID=<USDC on testnet>
./scripts/deploy.sh testnet
./scripts/init-contracts.sh testnet
```

## Run backend + frontend

```bash
# Backend
cd backend
cp .env.example .env   # paste contract IDs
npm install && npm run db:migrate && npm run db:generate
npm run dev   # :3004

# Frontend
cd frontend
cp .env.example .env.local
npm install && npm run dev   # :3000
```

## Get a swap quote

```bash
curl -X POST http://localhost:3004/api/v1/routes/quote \
  -H "Content-Type: application/json" \
  -d '{
    "tokenIn":  "GABC...56chars...",
    "tokenOut": "GXYZ...56chars...",
    "amountIn": 1000,
    "maxHops": 3
  }'
# → { "id": "uuid", "expectedOut": 997.1, "priceImpactBps": 5, "validUntil": "..." }
```

## Deposit into yield vault

```bash
curl -X POST http://localhost:3004/api/v1/vault/deposit \
  -H "Content-Type: application/json" \
  -d '{ "depositor": "GABC...56chars...", "amount": 10000 }'
# → { "id": "...", "sharesIssued": 10000000000, ... }
```

## Check share price

```bash
curl http://localhost:3004/api/v1/vault/share-price
# → { "sharePrice": 1000000000, "timestamp": 1720000000000 }
# sharePrice is scaled by 1e9: 1000000000 = 1.0 USDC/share
```

## Register an AMM pool for routing

```bash
./scripts/register-pool.sh testnet \
  GABC...token_a... \
  GXYZ...token_b... \
  GPOO...pool_address...
```

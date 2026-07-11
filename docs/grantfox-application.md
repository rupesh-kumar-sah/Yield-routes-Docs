# YieldRoutes — GrantFox Project Application Answers

## Project purpose and background
YieldRoutes is a DEX route aggregator and SEP-56 compliant yield vault on Stellar. The RouteAggregator finds the best swap path across registered Soroban AMM pool contracts (Stellar's SDEX cannot be accessed by Soroban contracts, so all routing uses on-chain pools). The YieldVault auto-compounds AMM LP fees into a SEP-56 standard vault — the same standard OpenZeppelin recently shipped for Stellar, enabling vault shares (yrUSDC) to compose with any SEP-56-aware protocol.

## Current state and traction
Four Soroban contracts: RouteAggregator, YieldVault (full SEP-56 implementation with virtual-shares inflation attack protection), FeeDistributor (epoch-gated, 50/30/20 split), PriceOracle (1-hour TWAP). 15 contract unit tests. Backend with harvest cron (every 6h), price feed cron (every 5min), and 8 Prisma models. Next.js frontend with swap UI, SEP-56 vault with preview-before-execute, pools directory, and oracle TWAP grid. stellar.toml deployed.

## What kind of contributions are you looking for
- Rust developers: real pool cross-contract calls, split routing, TWAP validation in execute_route
- TypeScript developers: Stellar event indexer for executed routes and deposits, Freighter signing
- Frontend developers: APR display on vault, price history chart, token pair selector
- Writers: SEP-56 plain-English explainer, DeFi on Stellar guide
- QA testers: swap quote TTL testing, vault preview accuracy testing
- API designers: OpenAPI specification for all endpoints

## Why is this a good fit for GrantFox
YieldRoutes is one of the first SEP-56 vault implementations on Stellar. DeFi tooling for the network is actively growing (daily smart contract volume up 8x in 12 months). The project has genuinely meaningful contribution tasks for all skill levels, from writing beginner DeFi explainers to implementing complex cross-contract routing math.

# YieldRoutes — Architecture Deep Dive

## Protocol Primitives

YieldRoutes combines two DeFi primitives that are complementary:

```
RouteAggregator          YieldVault
─────────────────        ─────────────────
Finds best price    →    Earns yield on idle assets
for immediate swap        while waiting to swap

Users who swap           Users who hold
benefit from             benefit from
better execution         auto-compounding
```

## Route Aggregation: How Quotes Work

```
User requests: swap 1000 USDC → XLM

RouteAggregator.get_best_route(USDC, XLM, 1000, max_hops=3)
  │
  ├─ Check direct path: USDC → XLM
  │   ├─ Stellar DEX order book:  995 XLM (estimated)
  │   └─ AMM pool if registered:  993 XLM (after 0.3% fee)
  │
  ├─ Check 2-hop paths (if pool registered):
  │   └─ USDC → USDT → XLM:  997 XLM
  │
  └─ Returns best: direct DEX at 995 XLM
     with quote_id=42, valid_until=now+60s

User calls: RouteAggregator.execute_route(sender, quote_id=42, min_out=990)
  │
  ├─ Checks timestamp: still within 60s window ✓
  ├─ Transfers 1000 USDC from user to contract
  ├─ Deducts protocol fee (0.1% = 1 USDC) → fee_collector
  ├─ Executes swap via DEX or AMM
  ├─ Checks actual_out (995) ≥ min_out (990) ✓
  └─ Transfers 995 XLM to user
```

## Vault Share Price Mechanics

Share price grows as yield accrues:

```
Initial state:
  total_assets = 1,000,000 USDC
  total_shares = 1,000,000,000 (1e9 precision)
  share_price  = 1,000,000,000 / 1,000,000,000 = 1.000000 USDC/share

After harvest (+50,000 USDC yield):
  total_assets = 1,050,000 USDC
  total_shares = 1,000,000,000 (unchanged — harvest doesn't mint shares)
  share_price  = 1,050,000,000 / 1,000,000,000 = 1.050000 USDC/share

New depositor joins (deposits 100,000 USDC):
  shares_minted = 100,000 * 1,000,000,000 / 1,050,000 = 95,238,095 shares
  total_assets = 1,150,000 USDC
  total_shares = 1,095,238,095
  share_price  = 1,150,000,000 / 1,095,238,095 ≈ 1.050000 USDC/share ✓

→ new depositor gets proportionally fewer shares at the higher price
→ existing depositors' shares are worth more
→ no dilution
```

## Fee Distribution Cycle

```
Protocol fees accumulate in FeeDistributor contract
  │
  │ (anyone calls distribute() once per 24h)
  │
  ├─ 50% → Treasury (covers dev, audits, operations)
  │
  ├─ 30% → YieldVault (deposited as yield — increases share price)
  │          → YieldVault.harvest(amount) called automatically
  │
  └─ 20% → LP Rewards pool (distributed to AMM liquidity providers)
```

## Price Oracle: TWAP Calculation

```
Hour 1 samples (10 submissions by authorized reporters):
  prices: [1.05, 1.051, 1.049, 1.052, 1.048, 1.053, 1.047, 1.054, 1.046, 1.055]
  TWAP = sum(prices) / count = 10.503 / 10 = 1.0503

Hour 2 samples (older samples pruned when window = 1h):
  → Only samples from last 3600 seconds kept
  → Max 20 samples retained (oldest pruned first)

Why TWAP instead of spot:
  → Spot price can be manipulated in a single block (flash loan attack)
  → TWAP requires sustaining the manipulation for 30-60 minutes
  → Cost of TWAP manipulation = holding position × time × opportunity cost
```

## Cron Job Architecture

```
node-cron scheduler (in backend process)
  │
  ├─ Harvest job (every 6 hours: "0 */6 * * *")
  │   1. Call stellar.harvestVault() → builds/submits Soroban tx
  │   2. On success: insert HarvestEvent in PostgreSQL
  │   3. Log yield amount and new share price
  │
  └─ Price feed job (every 5 minutes: "*/5 * * * *")
      1. For each tracked token pair:
      2. Read Stellar DEX best bid/ask via Horizon API
      3. Compute mid-price
      4. Submit to PriceOracle.submit_price()
      5. Insert PriceSnapshot in PostgreSQL
```

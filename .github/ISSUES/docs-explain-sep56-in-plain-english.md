# Write a plain-English explainer: what is SEP-56 and why does it matter?

**Labels**: `documentation`, `good first issue`, `help wanted`

## Context

YieldRoutes implements SEP-56, Stellar's Tokenized Vault Standard — the Soroban equivalent of Ethereum's ERC-4626. The org README (`/.github/profile/README.md`, lines 93-94) mentions SEP-56 briefly but assumes the reader already understands what a tokenized vault standard is. There is no standalone document explaining SEP-56 from scratch. A new contributor or Stellar DeFi newcomer currently has no entry point.

## What needs to be created

A file at `docs/sep-56-explainer.md` covering:

1. **What SEP-56 defines** — the standard interface for tokenized vaults on Soroban (deposit assets, receive share tokens, redeem shares for assets + accrued yield).
2. **Why it exists** — without a standard every vault is a silo; SEP-56 lets any compliant contract recognise and compose with vault shares.
3. **How it compares to ERC-4626** — same concept, different chain; ERC-4626 has deep DeFi adoption on Ethereum, SEP-56 brings that pattern to Stellar.
4. **How YieldVault implements it** — yrUSDC shares, auto-compounding via the harvest cycle.
5. **What composability means in practice** — a SEP-56 share can be accepted as collateral by any other SEP-56-aware contract with zero custom integration.

## What done looks like

- [ ] `docs/sep-56-explainer.md` exists and is readable by a non-technical audience.
- [ ] Uses at least one real-world analogy to explain tokenized vaults.
- [ ] Linked from `docs/README.md` so readers can discover it.
- [ ] Tone matches the existing docs in `docs/`.

## File references

| File | Why it matters |
|------|---------------|
| `/.github/profile/README.md` (lines 93-94) | Current SEP-56 mention — assumes prior knowledge |
| `docs/` | Target directory; check existing style before writing |
| `docs/README.md` | Add a link to the new explainer here |

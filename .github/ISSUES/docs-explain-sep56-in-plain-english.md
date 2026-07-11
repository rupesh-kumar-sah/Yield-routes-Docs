# 📄 Write a plain-English explainer: what is SEP-56 and why does it matter?

**Labels**: `documentation`, `good first issue`, `help wanted`
**Complexity**: 🟢 Beginner — no coding required

## Summary
YieldRoutes' vault is one of the first implementations of the SEP-56 Tokenized Vault Standard on Stellar. Most users and contributors don't know what SEP-56 is or why the standard matters. A well-written explainer will attract contributors who care about Stellar DeFi standards.

## What needs to be done
Create `docs/guides/sep56-explainer.md` covering:

1. **What is a tokenized vault?** (analogy: like a savings account that gives you a receipt — the receipt is worth more over time as interest accrues)
2. **What problem does SEP-56 solve?** (vaults without a standard are isolated — can't plug into other DeFi protocols)
3. **How SEP-56 works** (deposit → get shares → shares appreciate → redeem shares → get back more than you put in)
4. **YieldRoutes' implementation** (yrUSDC shares, auto-compounding, 6-hour harvest cycle)
5. **Comparison with ERC-4626** (Ethereum's equivalent — same concept, different platform)
6. **What "composability" means** (why SEP-56 shares can be used in other protocols)

## Acceptance criteria
- [ ] Written for someone who knows what cryptocurrency is but has never used DeFi
- [ ] Uses at least two non-technical analogies
- [ ] Includes a simple diagram (ASCII art is fine)
- [ ] Placed at `docs/guides/sep56-explainer.md`

## GrantFox
Points: 60 | Complexity: 🟢 Beginner — writers and DeFi curious contributors welcome

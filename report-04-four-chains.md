# Four chains, one method

Fourth report from the observatory. 1 September 2026.

---

## Summary

Every x402 payment reaching a catalogued recipient address was indexed on four chains — Base, Solana, XRPL and Stellar — using the same criteria and the same seven-day window.

- **Base carries 99.4% of settled value** and 97.7% of payers, but its transaction count is not what it appears.
- **XRPL processes 5.8x more transactions than Base** in the same window, at 1/178th the value, from 113 payers.
- **Solana is the only chain where activity grew** during the window, and the only non-EVM chain with a genuinely multi-operator catalogue.
- **No chain is dominated by a single wallet at present.** The 92.7% concentration reported for Base in the previous report reflects a longer window; over the last seven days the largest payer accounts for 21.9%.
- **Stellar has real, sustained x402 activity that the CDP discovery catalogue does not list.**

Transaction counts and settled value tell opposite stories depending on the chain. Reporting either alone misrepresents the ecosystem.

---

## 1. Method

Same criteria on all four chains: stablecoin transfers, account-to-account, inbound to an address listed as `payTo` in a public x402 discovery catalogue, or settling through a chain's designated x402 facilitator.

| Chain | Identified by | Asset |
|---|---|---|
| Base | ERC-20 `Transfer` to catalogued `payTo` | USDC |
| Solana | SPL transfer to the ATA of a catalogued `payTo` | USDC |
| XRPL | `SourceTag` 804681468 or `urn:x402` memo | RLUSD, XRP |
| Stellar | USDC transfer via `invoke_host_function`, account-to-account | USDC |

**Window: seven days, 25 August – 1 September 2026.** Identical for all four.

### 1.1 Limitations

**Coverage differs by chain.** Base and XRPL are indexed exhaustively over the window. Solana indexes the 40 catalogued recipient addresses with the most published resources, not all 211. Stellar is crawled outward from known seeds, so a provider unconnected to any seed is invisible — this is not hypothetical, see section 5.

**Base timestamps are interpolated**, not observed per block. Adequate for daily aggregation, not for intraday ordering.

**Solana figures were undercounted before today.** The indexer fetched only the last 100 transactions per account and had not been running on a schedule, which understated recent days by roughly 4x. Re-indexed at depth 600; figures below are the corrected ones. This is recorded as a coverage gap, not a market change.

**Stellar had a filter defect.** A 1 USDC ceiling, set to exclude ordinary transfers, was discarding legitimate x402 payments — 63% of one provider's volume. Removed; see section 5.

---

## 2. The seven-day picture

> **Withdrawn 4 September 2026.** The table below does not reproduce. Base had no timestamped payments in the declared window, XRPL's payment count matches no window of consecutive days, and its settled value adds RLUSD to XRP and reports the total as one unitless figure. See [Correction 08](CORRECTION-08-report-04-figures.md). The figures are left in place rather than deleted, so that what was published can still be read.

| Chain | Payments | Payers | Recipients | Value settled |
|---|---:|---:|---:|---:|
| Base | 124,530 | 2,642 | 627 | **184,955.63 USDC** |
| XRPL | **719,932** | 113 | 106 | 1,039.71 |
| Solana | 1,141 | 64 | 31 | 2,447.74 |
| Stellar | 19 | 3 | 2 | 35.90 |

### 2.1 Transaction count and value point in opposite directions

**XRPL settles 5.8 times more transactions than Base** and 0.6% of the value. Its median payment is a fraction of a cent; Base's is orders of magnitude larger.

Any ecosystem figure quoted as "x402 processed N transactions" is dominated by XRPL. Any figure quoted as volume is dominated by Base. **The two metrics describe different chains.**

That matters because published ecosystem-wide transaction counts are widely cited as evidence of adoption. On this evidence they measure something closer to the cost of a transaction than the demand for one.

### 2.2 Value per payment

| Chain | Value per payment |
|---|---:|
| Base | 1.485 USDC |
| Solana | 2.145 USDC |
| Stellar | 1.889 USDC |
| XRPL | **0.00144** |

XRPL's payments are roughly a thousand times smaller than the other three. Whether that reflects genuinely different use cases or activity optimised for count rather than utility is not something on-chain data can settle.

---

## 3. Concentration

Share of transactions attributable to the single largest payer on each chain, same window:

| Chain | Payers | Largest payer's share |
|---|---:|---:|
| XRPL | 113 | **1.3%** |
| Base | 2,638 | 21.9% |
| Solana | 64 | 22.6% |
| Stellar | 3 | 68.4% |

**No chain currently shows single-wallet dominance.** This corrects the impression left by the previous report, which measured a 30-day window and found one wallet at 92.7% on Base. Over the last seven days that figure is 21.9%.

Two readings are consistent with both measurements: the dominant payer reduced activity, or its share was concentrated in a period outside this window. Both are visible in the raw data and neither is asserted here.

**XRPL is the most evenly distributed**, with 113 payers and no one above 1.3% — though 14 addresses account for roughly three quarters of transactions between them, so it is distributed rather than decentralised.

**Stellar's 68.4% is not meaningful.** Three payers and 19 payments produce a figure with no statistical weight, reported for completeness only.

---

## 4. Growth

Only Solana shows a directional trend within the window.

| Date | Payments | Payers |
|---|---:|---:|
| 24 Aug | 300 | — |
| 25 Aug | 439 | — |
| 26 Aug | 286 | — |
| 27 Aug | 36 | — |
| 28 Aug | 84 | — |
| 29 Aug | 154 | — |
| 30 Aug | 149 | — |
| 31 Aug | 142 | — |
| 1 Sep | 111 | — |

Over the longer series, Solana's monthly payer count rose from 3 in May to 134 in August — a factor of 45 in four months, with payer count growing alongside volume rather than volume alone.

Solana is also the only non-EVM chain with a genuinely multi-operator catalogue: 211 distinct publishing addresses, against 4 on XRPL and 3 on Stellar.

---

## 5. What the catalogues do not see

The CDP discovery catalogue is the primary index for x402. It does not cover the ecosystem.

**Stellar.** A provider operating `apiserver.mpprouter.dev` contacted this observatory after the previous report, noting they appear in neither the CDP nor the Binance catalogue. They supplied their own figures: 719 payments, 13 payers, 31.54 USDC.

This observatory had **zero** of those payments. Two separate defects:

1. The Stellar crawler walks outward from a seed address, and theirs was in an unconnected cluster.
2. After adding them as a seed, the measured volume was 10.77 USDC — a third of theirs. A 1 USDC filter, introduced to exclude ordinary transfers, was discarding 7 payments worth 20.75 USDC.

With both fixed: **719 payments, 13 payers, 31.5412 USDC.** Matching their figures exactly.

**That correction affects every Stellar figure previously published**, and it was found because a provider volunteered their own numbers. The same provider also disclosed unprompted that 6 of their 13 payers are their own test wallets — leaving 7 external. No other provider has done this, and establishing the equivalent for the largest provider on Base took several days of on-chain analysis.

**Chain attribution.** A separate defect, corrected on 25 August, meant multi-chain resources were attributed entirely to whichever chain was listed first. Solana's catalogued resources were understated by 27x, XRPL's by an unbounded factor from a reported zero, and Stellar's by 140x. Corrected figures: 5,246 Solana, 737 XRPL, 140 Stellar.

---

## 6. What this means for measurement

Three things follow, none of which are about any individual provider.

**Transaction counts and settled value are not interchangeable.** A chain can lead one and trail the other by three orders of magnitude. Ecosystem-wide figures that quote only one are not wrong so much as unfalsifiable — there is no way to tell which chain they describe.

**Discovery catalogues undercount their own ecosystems.** Not through negligence: a provider that never registers is invisible by construction. Any census derived from a single catalogue inherits that limit, and this one did.

**Providers who report their own numbers improve the measurement.** The single most useful correction in this report came from a provider handing over their figures, which did not match. That took one message. It replaced work this observatory could not have done alone, because a crawler cannot discover what it has no path to.

---

## 7. Data and reproducibility

Raw indexed payments and every query used are published in the repository with SHA-256 hashes.

All four chains are indexed from public endpoints requiring no authentication. The block ranges, ledger ranges and criteria are published; anyone can re-derive these figures independently.

**Ruleset changes affecting this report:** v1.5 (chain attribution from all payment offers), v1.7 (Solana amount threshold), v2.0 (Stellar threshold removed). Each is logged with its reason and the observations it invalidates.

> **Note added 3 September 2026:** that last sentence was not true when this report was published. v1.5 and v2.0 had no entry in the change log; both were reconstructed from published text on 3 September and are marked as logged after the fact. The scope mechanism itself did not apply as described. See [Correction 07](CORRECTION-07-ruleset-log.md). No figure in this report changes.

**Right of reply:** any party named here may request publication of a response. Responses are published unedited.

---

## 8. Corrections to previous reports

This is the third published correction cycle.

| Report | Claim | Corrected to |
|---|---|---|
| 01 | Solana: 191 resources | 5,246 |
| 01 | XRPL: 0 resources | 737 |
| 01 | Stellar: 1 resource | 140 |
| 02 | 11.1% of providers declare quality | 7.40% |
| 03 | One wallet: 92.7% of Base transactions | Holds for the 30-day window; 21.9% over the last seven days |

Corrections are published rather than quietly applied. A measurement project that hides its own errors is not measuring anything.

---

*Delivery verification observatory for x402. Open methodology, raw data published, measurements without value judgements.*

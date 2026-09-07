# Correction 09 — Report 04's table, recomputed

5 September 2026

---

## What this replaces

[Correction 08](CORRECTION-08-report-04-figures.md) withdrew the main table of Report 04. Three of its figures could not be reproduced: Base had no timestamped payments in the declared window, XRPL's payment count matched no window of consecutive days, and its settled value added RLUSD to XRP and reported the total as one unitless number.

The defects behind them are fixed. The table below is computed fresh, and **the query that produces it is published alongside** at [`queries/report-04-recomputed.sql`](queries/report-04-recomputed.sql).

**The original window is not recomputed.** Coverage changed on 4 September, from 1,053 watched recipient addresses on Base to 1,398. Running the old window against the new list would mix two effects — a change in traffic and a change in what is watched — and the earlier watch list cannot be reconstructed. A new window is used and its coverage stated.

---

## The table

**Window: 29 August – 5 September 2026**, seven days, identical for all chains.
**Coverage: 1,398 watched recipient addresses on Base**, 345 more than when Report 04 was published.

| Chain | Asset | Payments | Payers | Recipients | Settled |
|---|---|---:|---:|---:|---:|
| Base | USDC | 289,052 | 2,719 | 689 | 194,944.44 |
| XRPL | RLUSD | 834,420 | 109 | **1** | 915.99 |
| XRPL | XRP | 168,097 | 111 | 101 | 201.75 |
| Solana | USDC | 1,607 | 60 | 28 | 1,177.31 |
| Stellar | USDC | 115 | 8 | 4 | 37.00 |

**XRPL is split by asset and the two are not added.** RLUSD is a stablecoin and XRP is not; a single figure covering both is not a quantity. Report 04 published one number for the pair, which is what Correction 08 identified.

---

## What changes against the withdrawn table

| | Withdrawn | Recomputed |
|---|---|---|
| Base payments | 124,530 | 289,052 |
| Base recipients | 627 | 689 |
| XRPL payments | 719,932 | 1,002,517 across two assets |
| XRPL settled | 1,039.71, unitless | 915.99 RLUSD **and** 201.75 XRP |
| Solana settled | 2,447.74 | 1,177.31 |

The windows are different, so these are not the same measurement twice. The comparison is offered to show the direction and size of the change, not as a before-and-after of the same quantity.

---

## What the recomputation exposed

**Each chain's table stores amounts on a different scale.** `onchain_payments.amount` is in minimum units and must be divided by 10⁶; the Solana, XRPL and Stellar tables hold decimal amounts already. Applying the Base convention to Solana returned `0.00` for 1,607 payments — caught before publication because the figure was implausible, not because anything flagged it.

That is the same class of defect as the one Correction 08 reported, found while fixing it. The published query carries the scale of each table as a comment, so the next person to run it does not have to rediscover this.

**One recipient receives all RLUSD traffic on XRPL.** 834,420 payments from 109 payers to a single address. The XRP side of the same chain is ordinary: 168,097 payments to 101 recipients. Two populations sharing a ledger, and averaging them together describes neither. This is consistent with [Correction 06](CORRECTION-02-concentration.md) and with the [XRPL index](XRPL-INDEX.md), where none of the 106 receiving addresses resolves to a named service.

---

## What survives from Report 04

**The finding stands.** Transaction counts and settled value still describe different chains: XRPL settles 3.5× more transactions than Base at 0.6% of the value, on figures that now reproduce. The ratio changed; the conclusion did not.

**The declared criteria per chain stand.** Report 04's method table, which states that each chain is indexed by a different rule, was accurate and remains so.

---

## Method

**Ruleset v3.1**, 5 September 2026: amounts are converted to a declared unit at query time, and the scale of each source table is documented in the query. A settled-value figure is published with its asset, and figures in different assets are never summed.

Report 04's original table remains in place, marked as withdrawn, so what was published can still be read.

---

*Ninth published correction. The first to restore a withdrawn figure rather than retract one.*

# Who actually pays on x402

Third report from the observatory. 24 August 2026.

---

## Summary

Every USDC payment on Base to a payment address listed in the x402 discovery catalogue was indexed for a 29.7-day window: 8,065,305 payments, 706,643.91 USDC, 12,451 distinct payers, 881 distinct recipients.

The distribution is not what the headline figures suggest:

- **One wallet accounts for 92.7% of all transactions** and 27.8% of volume. It pays exactly one recipient, every day, without exception.
- **52.2% of payers made a single payment** in the entire window and did not return.
- **51 payers (0.4%) made more than 1,000 payments.** These are the only accounts showing sustained use.
- **Excluding the dominant wallet, 50 active payers moved approximately 6,365 USDC** across the month.

The ecosystem-wide transaction counts in public circulation describe one automated payer paying one provider. Removing it leaves roughly 17,000 transactions per day across 12,450 payers, and a real addressable market measured in thousands of dollars per month, not millions.

---

## 1. Method

### 1.1 What was indexed

ERC-20 `Transfer` events of USDC (`0x8335...2913`) on Base, filtered to recipient addresses appearing as `payTo` in the x402 discovery catalogue.

| | |
|---|---|
| Window | blocks 48,896,558 – 50,180,555 |
| Dates | 20 July – 19 August 2026 (29.7 days) |
| Payments | 8,065,305 |
| Volume | 706,643.91 USDC |
| Distinct payers | 12,451 |
| Distinct recipients | 881 |

### 1.2 Limitations, stated up front

**Base only.** The indexer covers `eip155:8453`. Base holds 98.44% of catalogued resources, but third-party analyses attribute a substantial share of x402 *transactions* to Solana. Those two claims measure different things and the discrepancy is unresolved. A payer operating on Solana does not appear here.

**Catalogued recipients only.** Payments to providers absent from the CDP and Binance discovery catalogues are not captured. The true totals are equal to or higher than reported.

**Timestamps are interpolated, not observed.** Block times were derived by linear interpolation between the first and last indexed block (2.0000 s/block, verified against both endpoints). Sufficient for daily aggregation; not usable for intraday ordering. This is recorded as ruleset v1.3.

**A single 29.7-day window.** No trend can be inferred from one month. "Did not return" means "did not pay again within this window", not "abandoned".

---

## 2. The dominant payer

One address, `0x2b4ee3...9037`, accounts for:

| | Value | Share of total |
|---|---:|---:|
| Payments | 7,473,827 | **92.7%** |
| Volume | 196,433.24 USDC | 27.8% |
| Distinct recipients | **1** | — |

It paid `0xe903...1aBf` (BlockRun.AI) and nothing else, on every day of the window without exception.

### 2.1 Concentration within that relationship

BlockRun.AI received payments from 624 distinct addresses. The distribution:

| Payments per payer | Payers | Total payments |
|---|---:|---:|
| 1 | 268 | 268 |
| 2 – 100 | 328 | 2,943 |
| 101 – 10,000 | 27 | 27,529 |
| **more than 100,000** | **1** | **7,473,827** |

**HHI: 0.9918.** The single largest payer represents 99.59% of that provider's transaction count.

### 2.2 Temporal profile

| Date | Payments | USDC | Mean per call |
|---|---:|---:|---:|
| 2026-07-20 | 4,204 | 105.01 | — |
| 2026-07-22 | 155,100 | 3,330.62 | — |
| 2026-08-08 | 101,085 | 2,353.36 | 0.023281 |
| 2026-08-11 | 142,144 | 14,693.94 | 0.103374 |
| 2026-08-12 | 83,809 | 13,754.08 | 0.164112 |
| 2026-08-15 | 382,537 | 11,537.58 | 0.030161 |
| 2026-08-16 | 412,942 | 6,192.80 | 0.014997 |
| **2026-08-17** | **1,191,018** | 15,587.14 | 0.013087 |
| **2026-08-18** | **1,224,189** | 14,153.24 | 0.011561 |
| 2026-08-19 | 453,437 | 7,962.66 | 0.017561 |

Three features are worth noting without interpretation:

**Onset.** 4,204 payments on day one, 155,100 by day three. From zero to steady state in 48 hours.

**Terminal acceleration.** Volume rises fifteen-fold between 12 and 18 August, then falls by 63% the following day.

**Inverse relationship between count and unit price.** Mean payment falls from 0.164 USDC on 12 August to 0.0116 on 18 August — a factor of fourteen — while transaction count rises by a factor of fifteen. Total spend stays roughly flat.

Payment amounts range from 0.002 to 46.27 USDC with a median of 0.0074, across 122,438 distinct amounts. BlockRun.AI's catalogue lists 52 endpoints priced from 0.002 to 5.001 USDC. **The amounts paid are consistent with the prices declared.** No pricing discrepancy was found.

### 2.3 The rest of the ecosystem, for comparison

| Date | Dominant payer | Everyone else |
|---|---:|---:|
| 2026-08-13 | 170,537 | 18,776 |
| 2026-08-15 | 382,537 | 23,331 |
| 2026-08-17 | 1,191,018 | 17,561 |
| 2026-08-18 | 1,224,189 | 17,186 |
| 2026-08-19 | 453,437 | 11,454 |

The remainder of the ecosystem is flat throughout the window, between 11,000 and 24,000 payments per day, with no trend. On 18 August the dominant wallet generated 71 times more transactions than the other 12,450 payers combined.

---

## 3. What the other payers look like

### 3.1 By activity

| Payments made | Payers | Share | Mean distinct recipients |
|---|---:|---:|---:|
| Exactly 1 | 6,496 | 52.2% | 1.0 |
| 2 – 10 | 3,648 | 29.3% | 1.3 |
| 11 – 1,000 | 2,256 | 18.1% | 3.8 |
| More than 1,000 | 51 | 0.4% | 19.6 |

**More than half of all payers made a single payment in 29.7 days.** 81.5% made ten or fewer.

The 51 accounts with sustained activity moved 202,798.07 USDC. Removing the dominant wallet leaves **50 payers and approximately 6,365 USDC** for the month.

### 3.2 By breadth

| Distinct recipients | Payers | Share | Payments |
|---|---:|---:|---:|
| 1 | 11,261 | 90.4% | 7,702,164 |
| 2 – 5 | 880 | 7.1% | 202,455 |
| 6 – 20 | 209 | 1.7% | 125,799 |
| More than 20 | 101 | 0.8% | 34,887 |

**90.4% of payers use exactly one provider.** Accounts paying more than twenty distinct providers — the behaviour described when the ecosystem talks about agents selecting between services — represent 0.43% of transactions.

### 3.3 Three populations

The largest payers after the dominant wallet show a consistent shape:

| Payments | Recipients | USDC |
|---:|---:|---:|
| 120,530 | 3 | 725.04 |
| 78,890 | 6 | 195.78 |
| 50,787 | 1 | 540.32 |
| 18,118 | 1 | 482.64 |
| 11,599 | 2 | 198.60 |
| 6,567 | **337** | 178.26 |

Nine of the ten largest payers are fixed integrations: one to six providers, never varying. The tenth pays 337 distinct recipients with small amounts — the only profile in that group resembling an agent exploring a marketplace.

Three populations coexist:

| Profile | Behaviour | Share of transactions |
|---|---|---:|
| Volume generator | 1 recipient, millions of payments, unit price optimised downward | 92.7% |
| Fixed integration | 1–6 stable recipients, tens of thousands of payments | ~6.5% |
| Exploring agent | Hundreds of recipients, few payments each | 0.43% |

---

## 4. Why this explains the previous reports

The first two reports found two things that did not obviously fit together: the ecosystem does not declare data quality, and the providers that do declare it earn almost nothing.

Kronos publishes an open methodology, an audited hit rate over 33,884 scored forecasts, and separates cached from paid samples. Lifetime revenue: **$58.36 across 94 payers.** Truth Bear publishes per-record source lineage, recomputable hashes and explicit uncertainty. It has **2 payers** per endpoint in 30 days.

This report supplies the missing piece.

**Nobody declares quality because nobody compares.** 90.4% of payers use a single provider. Comparison behaviour accounts for 0.43% of transactions. A provider investing in declaring freshness, confidence or provenance gains no competitive advantage, because its customer is not evaluating it against alternatives.

The absence of a quality standard is not negligence. It is a rational response to a market with roughly fifty active buyers.

---

## 5. What is not claimed

**No accusation is made against any party.** This report measures on-chain payment patterns. It does not establish intent, does not identify who controls any address, and does not assert that any activity is illegitimate. High-frequency automated payment to a single provider is a pattern, not a verdict.

**No trend is inferred.** One 29.7-day window. Chainalysis reports that tester-to-payer conversion improved fourfold over six months; a single month cannot confirm or contradict that.

**The dominant payer may have a legitimate explanation** not visible from on-chain data. BlockRun.AI was notified before publication and has right of reply, published unedited alongside this report.

---

## 6. Data and reproducibility

Raw indexed payments and all queries are published in the repository with SHA-256 hashes.

The indexing is reproducible against any Base RPC endpoint using the published block range and the USDC contract address. The recipient filter derives from the public discovery catalogues, which require no authentication.

**Right of reply:** any party named here may request publication of a response. Responses are published unedited.

---

## 7. Method notes

The observation table is append-only by design; a database rule prevents modification of historical records. Derived timestamps are exposed through a view (`onchain_payments_dated`), never written into the base table.

**Ruleset v1.3**, 24 August 2026: timestamps for on-chain payments are interpolated linearly between the first and last indexed block rather than queried per block. Precision is adequate for daily aggregation and inadequate for intraday analysis.

---

*Delivery verification observatory for x402. Open methodology, raw data published, measurements without value judgements.*

# Correction 10 — XRPL's even payer distribution is not evidence of health

7 September 2026

---

## What was wrong

[Correction 06](CORRECTION-02-concentration.md) reported that XRPL had 113 payers with none above 1.3% of transactions, and described it as the most evenly distributed chain in the ecosystem on the paying side.

The figure was correct. **The reading was not.** That distribution is not many independent buyers. It is one number of payments divided almost exactly evenly across 109 addresses, day after day.

---

## The measurement

Payments per payer per day, on XRPL:

| Day | Payers | Lowest | Highest | Coefficient of variation |
|---|---:|---:|---:|---:|
| 29 Aug | 109 | 925 | 931 | **0.167%** |
| 31 Aug | 109 | 1,218 | 1,227 | **0.155%** |
| 1 Sep | 109 | 1,879 | 1,898 | **0.203%** |
| 30 Aug | 109 | 135 | 137 | 0.909% |

On 1 September, 109 addresses each made between 1,879 and 1,898 payments. The gap between the busiest and the quietest is nineteen payments out of nearly nineteen hundred.

**The same measurement on Base, over the same period:**

| Day | Payers | Coefficient of variation |
|---|---:|---:|
| 25 Aug | 617 | 88.9% |
| 28 Aug | 612 | 105.2% |
| 29 Aug | 1,018 | 113.7% |
| 1 Sep | 637 | 95.8% |

Base sits around 100%, which is what independent buyers look like: some buy a great deal, most buy once. XRPL on its coordinated days is **roughly seven hundred times more even**.

Both chains are measured by the same code and the same query. The difference is not in the instrument.

---

## It is not constant

The coordinated regime switches on and off. Other days in the same window show coefficients of 2.6%, 8.3%, 9.0%, 31.4% and 52.8% — dispersed, like ordinary traffic.

So this is not a permanent property of the chain. It is something that runs on some days and not others, and on the days it runs, it dominates the entire indexed volume of XRPL.

---

## What this does not establish

**Not who controls the addresses.** Correction 06 said that on-chain data shows the shape of the traffic, not who controls the addresses. That still holds, and it holds here.

Three explanations fit the same evidence, and this measurement cannot separate them:

- one party operating 109 wallets
- a facilitator distributing load across the wallets of independent clients
- a test or benchmarking harness

**A common funding source was checked and rules nothing in.** Every sampled address traces back to a small set of funders, but those funders are exchanges — one is labelled Binance, activated in February 2022. Millions of XRPL accounts share that origin. Shared funding by an exchange is not evidence of common control, and it is reported here because it was checked and discarded, not because it supports anything.

---

## Effect on published figures

**Unchanged:** the payment counts, the recipient-side concentration, and the finding that recipient concentration exceeds payer concentration on all four chains. Those measurements stand.

**Corrected:** describing XRPL's payer distribution as evenly spread, without noting that the evenness is too exact to be independent. Correction 06 used low payer concentration as a sign that no single buyer dominated the chain. On the coordinated days, low payer concentration is a consequence of the traffic being distributed on purpose, and says nothing about how many buyers there are.

**Added:** any figure quoting XRPL's payer count should be read as a count of addresses, not of buyers. The [XRPL index](XRPL-INDEX.md) already publishes that none of the 106 receiving addresses resolves to a named service; the paying side is now known to be no more informative.

---

## How this was found

By asking why XRPL's daily volume collapsed on 30 August and recovered the next day. It had not collapsed: hourly volume held at 615–625 payments for thirty-six consecutive hours with a variation of ±5, which is not what a service outage looks like and is not what traffic looks like either. Checking who was making those payments showed 109 addresses making 136 each.

The 30 August dip is what made this visible. Without it the pattern was buried under larger, more variable volume.

---

## Method

**Ruleset v3.4**, 7 September 2026: a payer count is reported as a count of addresses. Where the distribution across payers is too uniform to be independent — a coefficient of variation below 1% — that is stated alongside the count, because the count alone invites the opposite conclusion.

Queries published with the raw data.

---

*Tenth published correction. The figure was right and the sentence around it was wrong, which is the harder kind to catch.*

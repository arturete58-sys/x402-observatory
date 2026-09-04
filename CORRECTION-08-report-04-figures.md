# Correction 08 — Report 04's main table cannot be reproduced

4 September 2026

---

## What was wrong

Report 04 declared a seven-day window, 25 August to 1 September, identical for all four chains, and published a table of payments, payers, recipients and settled value.

**Three of those figures cannot be reproduced from the database today, and one of them could not have been produced at all.**

None of this was found by an external report. It was found while adding Stellar to the paid panel, by trying to re-derive a published number and failing.

---

## 1. Base had no data in the declared window

The table gives Base 124,530 payments, 2,642 payers, 627 recipients and 184,955.63 USDC over 25 August – 1 September.

Querying that window returns nothing. **The most recent Base payment carrying a timestamp was 19 August**, six days before the window opens.

The cause is not the indexer, which was running and current. Timestamps on Base payments are not read from the chain per block: they are filled in afterwards by `fill-ts.js`, which interpolates linearly between the first and last indexed block. That script was never added to the scheduler. It was run by hand in August and not again.

**1,430,166 payments sat in the table with no timestamp**, growing every six hours, and were therefore absent from every query bounded by date — including the one that produced Report 04's Base row.

**Fixed.** Timestamps backfilled to 3 September, `fill-ts.js` added to the scheduler at six-hourly intervals behind the indexer. The interpolation itself was checked against eight evenly spaced blocks and is accurate to the minute; Base produces a block every 2.0000 seconds.

**Where the published Base figures came from is not established.** They are not reproducible from the current data for the declared window.

---

## 2. XRPL's payment count matches no window

The table gives XRPL 719,932 payments.

For the declared window, 25 August – 1 September, the database returns **627,123**. No run of consecutive days in the indexed period sums to 719,932; a query across every possible start and end date returns nothing within ±5,000 of it.

The figure exists only in the published report. No script generates it and no saved query produces it.

---

## 3. XRPL's settled value mixes two assets

The table gives XRPL a settled value of `1,039.71`, with no unit, in a column where Base is labelled `184,955.63 USDC`.

XRPL x402 payments settle in **two assets**: RLUSD, a stablecoin, and XRP, which is not. Over the declared window the database holds 745.10 RLUSD and 206.64 XRP. Neither is 1,039.71, and their sum is 951.75.

Whatever the published figure counted, adding a stablecoin to a volatile asset and reporting the total as a single unitless number is not a comparison with Base. **The headline that XRPL settles 0.6% of Base's value rests on both this figure and the one in §1.**

---

## 4. 258 known payment addresses are not watched

The Base indexer builds its watch list from the `vendors` table. The catalogue also holds payment offers in `resource_accepts`, and **258 addresses appear there that are not in the watch list**.

They are not hypothetical. A sample of 25 was checked against the chain over an 11-hour window: **two had received USDC**. One of them is the live payment address of a provider with 202 catalogued resources, returned by its own 402 challenge today.

Payments to those addresses are not indexed. **Every payment count published for Base is a lower bound.**

Not yet fixed. The discovery endpoint that maps resources to merchant addresses is the route to closing it, and that work is not done.

---

## Effect on published figures

**Report 04's main table is withdrawn** pending recomputation. The chain comparison it supports — that transaction counts and settled value describe different chains — may well survive, but it cannot be defended on figures that do not reproduce.

**Report 03 is not affected by §1 or §2.** Its 8,065,305 payments were counted from rows carrying a timestamp, which is what existed at the time. It is affected by §4: the true count is higher by an unknown amount.

**The concentration figures in Correction 06 are unaffected.** They were computed by transaction count within a window on each chain's own table.

---

## Why this happened

Four defects, one shape. A scheduled job that was never scheduled. A figure calculated by hand and never saved as a query. A column labelled with one asset holding two. A watch list built from the narrower of two tables.

None of them was caught by the canaries, which watch delivery rather than bookkeeping, and none was caught by review, because the figures looked plausible.

**The rule that would have caught three of the four:** a published figure must be accompanied by the query that produces it. Report 04's numbers were transcribed from a terminal session that no longer exists.

---

## Method

**Ruleset v2.9**, 4 September 2026: every figure published in a report is accompanied by the query that produces it, stored with the report. A figure that cannot be re-derived is not published.

---

*Eighth published correction. The first to withdraw a table rather than restate it.*

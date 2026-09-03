# Correction to Report 04 — concentration measured from one side only

2 September 2026

---

## What was wrong

Report 04 measured concentration by payer: what share of transactions comes from the single largest paying address. On that metric XRPL looked like the healthiest chain in the ecosystem — 113 payers, none above 1.3%.

**Measured by recipient, XRPL is the most concentrated of the four.** A single address receives 74.6% of all payments on the chain.

Nothing in the original figures was miscalculated. The metric was simply chosen from one side of the transaction, and it gave the opposite impression to the truth.

---

## Both sides, all four chains

Seven-day window, same as Report 04.

| Chain | Largest payer's share | Largest recipient's share |
|---|---:|---:|
| Base | 21.9% | 42.4% |
| Solana | 22.6% | 49.6% |
| XRPL | **1.3%** | **74.6%** |
| Stellar | 68.4% | 62.8% |

**In all four chains, concentration is higher on the receiving side than the paying side.** That is the finding the original metric hid. It is not an XRPL anomaly — across the ecosystem, a small number of providers absorb most of the traffic.

XRPL is the extreme case in both directions at once: the most evenly distributed payers, and the most concentrated recipient.

---

## What is actually happening on XRPL

Indexing every payment carrying the x402 facilitator's `SourceTag` produced 972,094 payments across 113 payers and 106 recipients.

The structure underneath:

| Pair volume | Pairs | Payments |
|---|---:|---:|
| More than 1,000 | 109 | 725,123 |
| 101 – 1,000 | 19 | 5,893 |
| 11 – 100 | 10,629 | 237,579 |
| 1 – 10 | 365 | 3,305 |

There are 11,122 distinct payer-recipient pairs out of 11,518 possible. Nearly every payer pays nearly every recipient — but not evenly.

**109 of the 113 payers send the bulk of their traffic to the same single address**, averaging 6,418 payments each. The remaining four payers are recent arrivals with 2, 20, 32 and 35 payments.

Every other recipient receives roughly 2,400 payments — about 22 from each payer. That background traffic is why all 106 recipients showed similar totals, and why the payer-side metric looked so evenly spread.

The dominant recipient is `rBi1QrVjwaNofisZAQnovoXdHkS73FG1tJ`, publicly labelled as Heurist Mesh, an agent tooling marketplace. It received 725,290 of 972,094 payments.

**What this does not establish:** whether the 113 payers are independent customers, instances operated by one party, or something else. On-chain data shows the shape of the traffic, not who controls the addresses.

---

## Why the original metric was misleading

An ecosystem with many payers and few recipients looks distributed from one angle and captured from the other. Payer-side concentration answers "is one buyer generating all the volume". Recipient-side concentration answers "is one seller receiving it".

Those are different questions and they had different answers on every chain measured.

Report 03 made the same choice, finding one wallet at 92.7% of Base transactions over 30 days. That figure stands on its own terms — it was a payer-side measurement and it was correct. But it was published without its counterpart, and the counterpart changes what the reader concludes.

Both metrics are now reported together.

---

## Effect on Report 04's conclusions

**Unchanged:** transaction counts and settled value describe different chains. XRPL settles 5.8× more transactions than Base at 0.6% of the value. That finding does not depend on how concentration is measured.

**Corrected:** the description of XRPL as the most evenly distributed chain. It is the most evenly distributed on the paying side and the most concentrated on the receiving side. Presenting only the first was misleading.

**Added:** recipient-side concentration exceeds payer-side concentration on all four chains, which suggests the shape of the ecosystem is a small number of providers rather than a small number of buyers. That was not visible from the original figures.

---

## How this was found

Not by an external report and not by an error in the code. By recomputing the same data grouped by recipient instead of by payer, while investigating whether XRPL's flat payer distribution was genuine.

It was not a defect. It was a metric that answered half the question.

---

## Method

Recipient-side concentration is the largest single recipient's share of transaction count within the window, computed identically on all four chains. Raw data and queries are published with SHA-256 hashes.

**Ruleset v2.2**, 2 September 2026: concentration figures are reported from both sides. Publishing either alone is treated as incomplete.

---

*Sixth published correction. Corrections are published rather than quietly applied, including the ones that came from asking a better question rather than fixing a bug.*

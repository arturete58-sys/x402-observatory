# Report 05 — What the ecosystem figures are counting

Fifth report from the observatory. 4 September 2026.

---

## Summary

Base is where almost all x402 activity is, and its headline numbers are dominated by three payers whose behaviour resembles nobody else's. One of them alone accounts for most of the traffic ever indexed on the chain, pays a single recipient, and stopped on 22 August.

Underneath them there is a market: roughly 570 buyers a week who purchase from more than one provider. It is two orders of magnitude smaller than the headline figure, and over six weeks it neither grew nor shrank.

- **One payer, one recipient, 8,665,910 payments.** From 20 July to 3 September, to a single address, and to no other address on the chain.
- **Any figure quoted as "x402 processed N payments on Base" is mostly that relationship.**
- **The market that remains is flat.** 480–599 multi-provider buyers a week since late July, with no trend in either direction.
- **The typical buyer makes 13 payments** and buys from three providers.
- **Outside Base, discovery does not exist.** Four independent routes were tried on Stellar and XRPL. None resolves a receiving address to a service.

---

## 1. Method

On-chain payments are indexed from public endpoints on all four chains. This report covers Base unless stated otherwise, over **20 July – 3 September 2026**. The 4th is excluded: it was in progress when the figures were taken.

**Coverage did not change during the window.** The watch list of 1,053 recipient addresses was loaded on 18 August and the chain reindexed backwards from it, so July and September are counted against the same set. Active recipients per week range from 504 to 666 across the whole period, before and after that date, with no step at the boundary.

**Timestamps are interpolated,** not read per block. The first and last block of the indexed range are queried directly and the rest derived linearly. Base produces a block every 2.0000 seconds; checked against eight evenly spaced blocks, the interpolation error is zero to the minute. This is stated because the method matters, not because it is in doubt.

**What is not covered:** 258 addresses known to have offered payment are not on the watch list, and two of a sample of 25 received USDC within an 11-hour window. The ecosystem is therefore **larger** than what follows, not smaller. This is a defect in the indexer, published in the correction accompanying this report.

---

## 2. Three payers, and everyone else

| Payer | Payments | Recipients | Period |
|---|---:|---:|---|
| `0x2b4ee338…9037` | **8,665,910** | 1 | 20 Jul – 3 Sep |
| `0xa39c469c…889f` | 183,194 | 3 | 20 Jul – 3 Sep |
| `0xcfa370b0…a8dc` | 80,015 | 1 | 20 Jul – 4 Sep |

The first pays one address and nothing else, 8.6 million times over 45 days. The second is three orders of magnitude smaller and still fifteen times larger than the next payer down. Both pay the same recipient among their destinations.

Total payments indexed on Base in the window: 9,495,471. **The first payer alone is 91% of them.**

**What this does not establish:** whether these are independent customers, instances operated by one party, testing infrastructure, or a provider paying itself. On-chain data shows the shape of the traffic, not who controls the addresses. All three are catalogued addresses paying catalogued recipients, which is all that can be said from here.

### 2.1 The 22 August stop

The dominant payer's daily volume, in payments:

| Date | Payments | USDC |
|---|---:|---:|
| 17 Aug | 1,216,014 | 15,773 |
| 18 Aug | 1,202,041 | 13,465 |
| 21 Aug | 331,246 | 4,090 |
| 22 Aug | 71,967 | 593 |
| 24 Aug | 1,466 | 4.39 |
| 28 Aug | 340 | 13.01 |
| 2 Sep | 112,378 | 2,021 |

A 99.9% decline over six days, five days of near silence, then a single day of renewed activity on 2 September.

**Ecosystem-wide, total Base payments fell 98% over the same period.** Excluding this one payer, they did not fall at all.

---

## 3. What is left when the three are removed

August 2026, excluding the dominant payer:

| | |
|---|---:|
| Payments | 609,396 |
| Distinct payers | 12,382 |
| Recipients | 832 |
| Settled | 703,158 USDC |

Daily payments range from 13,181 to 31,105 with no trend. Daily settled value rises across the month, from around 18,000 USDC on 14 August to 38,136 on 1 September.

### 3.1 Most payers buy from exactly one provider

| | Payers | Payments | Share of payments |
|---|---:|---:|---:|
| One recipient | 11,234 | 258,096 | 42.4% |
| More than one | 1,148 | 351,300 | **57.6%** |

The 11,234 single-recipient payers average 23 payments each. That is consistent with Report 03, which found 52.2% of payers made one payment and never returned.

**The 1,148 who buy from more than one provider are the only population behaving like a market**, and they account for the majority of the remaining traffic.

### 3.2 The distribution is ordinary

Among multi-provider buyers, the number who purchase from *n* distinct providers falls smoothly: 461 buy from two, 187 from three, 108 from four, and a long tail down to one buyer purchasing from 468.

The group buying from exactly three looked anomalous — 172,830 payments, a mean of 924 each against 123 and 157 for its neighbours. It is not a pattern. **Its median is 13 payments**, and two members account for 92% of the group's volume. The mean was a tail artefact.

Nor are those buyers cloned instances: the most common trio of destinations is shared by five buyers out of 187, and no combination is repeated more than that. They chose different providers.

---

## 4. The market is flat

Weekly, buyers who purchase from more than one provider:

| Week of | Buyers | Payments | USDC |
|---|---:|---:|---:|
| 20 Jul | 398 | 88,430 | 2,511 |
| 27 Jul | 515 | 94,419 | 1,918 |
| 3 Aug | 571 | 57,351 | 2,684 |
| 10 Aug | 599 | 76,768 | 1,874 |
| 17 Aug | 568 | 59,143 | 2,367 |
| 24 Aug | 589 | 72,603 | 4,370 |
| 31 Aug | 480 | 67,470 | 2,896 |

The last row covers four days, not seven, and is not comparable.

Active recipients per week are equally flat: 504 to 666 across the whole period.

**Neither growth nor collapse.** Over six weeks the number of buyers who choose between providers moved within a band of about 20%, and settled value oscillated without direction. Total chain payments over the same period multiplied by 2.7 and then fell 98%, and none of that was the market.

---

## 5. Outside Base, there is no discovery

Stellar and XRPL settle x402 payments. Neither has any public route from a receiving address to the service being sold.

Four routes were tried on each:

| Route | Stellar | XRPL |
|---|---|---|
| Public catalogues | 0 resources | 0 resources |
| Payment manifests (551 domains crawled) | 0 addresses | 0 addresses |
| Account metadata | 1 of 10, and it is a wallet | not applicable |
| `stellar.toml` across 8 ecosystem domains | 0 matches | not applicable |
| On-chain payload | no URL in any memo | 1,137,167 unique InvoiceIDs, one per payment |

The catalogue holds exactly one Stellar resource, and the observatory added it by hand after finding it on the provider's own domain. Nothing discovered it.

**XRPL: 106 receiving addresses, over a million payments between them, and not one resolves to a service.** They are published as an index, and any of them can be claimed with a signature.

**Stellar: 10 recipients, 1,085 payments since March.** One is identifiable, ROZO, and only because it publishes a catalogue at its own domain that no index carries.

The single account-metadata hit on Stellar is `lobstr.co` — a wallet, not a provider. The one route that returns anything returns the wrong kind of thing.

---

## 6. Settlement latency

| Chain | n | Mean settlement |
|---|---:|---:|
| Base | 1,859 | 1,513 ms |
| Stellar | 15 | 10,349 ms |

**This compares two panels, not two chains.** All 15 Stellar observations are purchases from a single provider through one facilitator; the Base figure spans twelve endpoints across nine providers. At n=15 the Stellar figure is reported as provisional and should not be quoted as a property of the network.

---

## 7. What this means for published figures

Report 03 reported 8,065,305 payments on Base over 30 days, with one wallet at 92.7%. Both figures were correct. **What was not clear is that removing that wallet does not reduce the ecosystem proportionally — it reveals a different one.**

Any figure quoted as ecosystem activity on Base is, today, mostly one bilateral relationship. Any figure quoted as market size should say which population it counts.

Three counts, same chain, same window:

- **9,495,471** — all indexed payments
- **609,396** — excluding the dominant payer
- **351,300** — from buyers who purchase from more than one provider

The three differ by more than an order of magnitude and all three are true.

---

## 8. Data and reproducibility

Every query in this report runs against the published schema. Block ranges, the watch list and the interpolation method are published.

Addresses are given in full so that any claim here can be checked directly against the chain rather than against this observatory.

**Right of reply:** any party named here may request publication of a response. Responses are published unedited.

---

*Corrections to this report will be published rather than quietly applied.*

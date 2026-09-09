# Report 09 — Counting transactions and counting money describe different ecosystems

Ninth report from the observatory. 8 September 2026.

---

## Summary

Over thirty days on Base, **two addresses account for 93.2% of x402 payments and 16.1% of the value.** The other 10,312 payers make 6.8% of the transactions and move 83.9% of the money.

Every figure quoted about the size of this ecosystem is a transaction count, because that is what an explorer shows. By that measure the ecosystem is two addresses. By value it is ten thousand.

- **Payments: 6,401,825.** Of those, 5,963,618 come from two payers.
- **Value settled: 778,025 USDC.** Of that, 652,698 comes from everyone else.
- **The dominant payer averages 0.021 USDC per payment.** Two cents, several million times.
- **It does not run continuously.** 112,378 payments on 2 September, none for the following four days, 316 on the 7th.

---

## 1. The split

Thirty days on Base, 1–8 September window inclusive of prior days:

| | Payers | Payments | Settled |
|---|---:|---:|---:|
| Everything on chain | 10,314 | 6,401,825 | 778,025 USDC |
| Two outsized payers | 2 | 5,963,618 (**93.2%**) | ~125,324 (**16.1%**) |
| **Everyone else** | **10,312** | **438,109 (6.8%)** | **652,698 (83.9%)** |

The inversion is the finding. A payer making millions of two-cent calls dominates any transaction count and barely registers in a value count. A market of ten thousand buyers making fewer, larger purchases does the opposite.

Neither figure is wrong. They answer different questions, and only one of them is ever published.

---

## 2. What counts as outsized, and why the obvious test fails

A payer is treated as outsized here only if it clears **three** conditions in the window: more than 1% of chain activity, more than fifty times the median payer, and more than ten thousand payments.

The first two alone misfire. On a small network the median is two or three payments, so almost every payer clears fifty times it — applying that test to Stellar marked twelve of eighteen payers as outsized, which describes nothing. The absolute floor is what makes the criterion transferable between a chain with 10,314 payers and one with 18.

Applied across three chains:

| Chain | Payers | Outsized | Their share of payments |
|---|---:|---:|---:|
| Base | 10,314 | 2 | 93.2% |
| Solana | 164 | 0 | — |
| Stellar | 18 | 0 | — |

**Solana and Stellar have no outsized payer.** Solana's distribution falls smoothly from 718 payments to 93 with no discontinuity anywhere. That is what an ordinary small market looks like, and it is worth stating because the absence is as informative as Base's presence.

**The threshold is arbitrary and declared, not derived.** Change it and the split moves. What does not move is that removing two addresses removes most of the transactions and almost none of the value.

---

> **Resolved 9 September 2026.** A method was found the day after this was published, and it is better than the ones that failed. A ledger closes every 3-4 seconds, so repeated co-occurrence in one is not coincidence. Of 136,496 ledgers carrying payments over seven days, **321 contain a single address** — 0.2%, mean 9.36 addresses per ledger. On Base, in equivalent four-second windows, 72.5% contain a single address and the mean is 1.37. **No XRPL address pays alone in a majority of its own payments; not one of 115.** The count of independent buyers on that chain is zero. Live at `GET /v1/market`, method `ledger-synchrony`. This measures synchrony and still says nothing about who controls the addresses.

## 3. XRPL is reported differently, and no market size is given

The criterion above detects **scale**. XRPL's problem is not scale.

On its most evenly matched days, 109 addresses each made between 1,879 and 1,898 payments — a coefficient of variation of **0.2%**, against roughly 100% on Base measured with the same query. Three of sixteen observed days show that pattern; the rest are dispersed.

That is distribution, not demand. A payer count there counts addresses rather than buyers, and no method tried so far separates the two: grouping by exact daily count fails because the counts differ slightly, and treating every coordinated day's addresses as one operator fails because most days are not coordinated.

**So no market size is published for XRPL.** The observatory reports the coordination it can measure and declines to derive a figure the measurement does not support. This is reported as an open problem rather than solved quietly.

---

## 4. Correction to Report 05

[Report 05](report-05-what-the-figures-count.md) stated that the dominant payer on Base "stopped on 22 August", and described a 99.9% decline over six days followed by near silence.

**That was accurate for the window observed and is wrong as a description of what happened.** The payer resumed:

| Date | Payments |
|---|---:|
| 28 Aug | 340 |
| 29 Aug – 1 Sep | none |
| 2 Sep | 112,378 |
| 3 Sep | 35,442 |
| 4–6 Sep | none |
| 7 Sep | 316 |

It did not stop. It operates in bursts, and August's silence was a longer gap than usual rather than an ending. Over the last seven days it still accounts for 52.5% of payments on the chain.

Report 05's other findings are unaffected: the concentration, the single recipient, and the flat underlying market all stand. What changes is the word "stopped", and the reading that followed from it.

---

## 5. Why this matters for anyone entering

The first question a builder or investor asks about x402 is whether there is a market. The published figures answer it badly in both directions.

**"Millions of payments" overstates it** — most of them are one payer making two-cent calls in bursts.

**"Two addresses dominate" understates it** — those addresses move a sixth of the money, and ten thousand others move the rest.

The defensible answer, on the evidence: **there is a real market of roughly ten thousand paying addresses moving around 650,000 USDC a month on Base**, alongside infrastructure-scale traffic that inflates every transaction count. Whether those ten thousand addresses are ten thousand distinct parties is a separate question this observatory cannot answer from the chain.

---

## 6. Data

Live at `GET /v1/market`, which recomputes this split on request for any window and threshold. The criterion for each chain is named in every response.

Queries published with the raw data.

**Right of reply:** any party named here may request publication of a response. Responses are published unedited.

---

*Corrections to this report will be published rather than quietly applied.*

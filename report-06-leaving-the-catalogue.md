# Report 06 — Leaving the catalogue is not dying

Sixth report from the observatory. 4 September 2026.

---

## Summary

Between 18 August and 4 September, **4,742 resources disappeared from the CDP Bazaar** — a third of everything it listed. They belong to 509 distinct providers across 628 hosts, so this is not a handful of operators withdrawing their catalogues.

Then each one was asked, directly, whether it still works.

**80.8% of them do.** Of a random sample of 120, ninety-six still return a 402 payment challenge, one serves without asking for payment, and only sixteen are genuinely gone.

The catalogue is not measuring how many x402 services exist. It is measuring how many are willing to stay listed.

---

## 1. What was measured

The observatory ingests the CDP and Binance catalogues and marks a resource `retired_at` when it stops appearing, rather than deleting the row. That makes the departure observable.

The catalogue was last ingested on 18 August and again on 4 September. In between:

| | |
|---|---:|
| Resources present on 18 August | 15,187 |
| No longer present on 4 September | **4,742** |
| Distinct providers affected | 509 |
| Distinct hosts affected | 628 |
| Resources present on 4 September | 16,008 |

More resources entered than left. The catalogue grew while a third of its contents turned over.

**The largest single departure is 303 resources from one host**, followed by 233 and 201. But the tail is long: 628 hosts for 4,742 resources is a mean of 7.5 each.

---

## 2. Asking them directly

A random sample of 120 retired resources was requested with its declared method. No payment was made and no payment header was sent — this measures whether the endpoint still answers, not whether it delivers.

| Response | n | Share |
|---|---:|---:|
| 402, still asking for payment | 96 | 80.0% |
| 200, served without payment | 1 | 0.8% |
| 404, endpoint gone | 8 | 6.7% |
| No response at all | 8 | 6.7% |
| Other status | 7 | 5.8% |

**Alive: 97 of 120, or 80.8%.** Wilson interval at 95% confidence: 72.8% – 86.8%.

Per-endpoint results are published in `retired-liveness.json` so the figure can be recomputed rather than trusted.

### 2.1 The seven "other"

Four are 404s reached through a redirect. One is `toolvend.dev/rdap/:var1` — a 400, because the catalogue published the URL with its path parameter placeholder unresolved. That resource was never callable as listed, and its departure from the catalogue is not a loss.

The remaining two are 5xx, which is a fault rather than a departure.

### 2.2 The one that serves without paying

One resource returned 200 to an unpaid request. Whether that is a paywall removed deliberately or a misconfiguration is not established from a single observation, and it is not pursued here.

---

## 3. What this means for counting

Any figure quoted as "there are N x402 resources" is a count of catalogue entries. Over seventeen days, roughly four in five entries that left the catalogue were still operating.

Three ways to count the same ecosystem on 4 September:

- **16,008** — resources currently listed
- **~19,800** — listed, plus the retired ones that still answer, if the 80.8% rate holds across all 4,742
- **15,187** — what was listed seventeen days earlier

The second figure is an extrapolation from a sample and is offered as an order of magnitude, not a count. It is stated because the difference between it and the first is larger than the entire Solana presence in the catalogue.

**Nothing here says the catalogue is wrong.** It lists what providers register. It says that registration and existence are different properties, and that only one of them is being measured by anyone.

---

## 4. Why this is observable here

This report requires knowing what the catalogue said in the past. The observatory marks resources retired rather than deleting them, so a departure leaves a record.

A crawler that overwrites its catalogue on each run cannot produce this measurement at all — it would simply have 16,008 resources today and 15,187 before, and would see growth of 821 where there was a turnover of 4,742.

---

## 5. Limits

**The sample is 120 of 4,742.** The interval is stated above.

**A 402 is not a delivery.** This measures that an endpoint still answers and still charges. Whether it delivers what it declares is the subject of the paid panel, which covers thirteen endpoints and not these.

**Liveness was checked once**, on 4 September. An endpoint that answers today may not tomorrow.

**"Retired" means absent from two catalogues**, CDP and Binance. A resource that moved to a catalogue this observatory does not ingest would be counted as departed. No such catalogue is known, which is itself the subject of the XRPL index and of Report 05 §5.

---

## 6. Data

`retired-liveness.json` holds the per-endpoint result for all 120: URL, method, status code and classification.

**Right of reply:** any party named here may request publication of a response. Responses are published unedited.

---

*Corrections to this report will be published rather than quietly applied.*

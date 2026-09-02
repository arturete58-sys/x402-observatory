# Incident note: 48 hours of dead upstream sources on a paid FX feed

2 September 2026

---

## What this is

A single observed incident, not a rate. No minimum sample applies — this describes what happened during a specific window, not an estimate of how often it happens.

The provider was notified before publication and has right of reply.

---

## Summary

Between 29 and 31 August 2026, the endpoint `tick.hugen.tokyo/tick/latest` returned HTTP 200 and charged $0.005 on **24 consecutive purchases** while reporting `quality_state: "stale"` and **0 of 5 upstream sources fresh** on every one of them.

The endpoint itself never went down. Its cache kept regenerating on schedule. What failed were the sources feeding it, for approximately 48 hours.

**The provider declared the condition accurately in every response.** Nothing was hidden. That is the point of publishing this.

---

## The observation series

Data age reported by the provider, one observation every two hours:

| Timestamp (UTC) | Age reported | |
|---|---:|---|
| 2026-08-29 00:01 | 8,489 s | 2h 21m |
| 2026-08-29 02:01 | 15,701 s | 4h 21m |
| 2026-08-29 04:01 | 22,893 s | 6h 21m |
| 2026-08-29 06:01 | 30,091 s | 8h 21m |
| 2026-08-29 08:01 | 37,289 s | 10h 21m |
| 2026-08-29 10:01 | **1,292 s** | 21m — cache regenerated |
| 2026-08-29 12:01 | 8,489 s | 2h 21m |
| 2026-08-29 14:01 | 15,675 s | 4h 21m |
| 2026-08-29 16:01 | 22,885 s | 6h 21m |
| 2026-08-29 18:01 | 30,088 s | 8h 21m |
| 2026-08-29 20:01 | 37,283 s | 10h 21m |
| 2026-08-29 22:01 | **1,262 s** | 21m — cache regenerated |
| 2026-08-30 00:01 | 8,455 s | 2h 20m |
| ... | ... | pattern repeats |
| 2026-08-30 20:02 | 37,288 s | 10h 21m |
| 2026-08-30 22:01 | **0 s** | recovery begins |
| 2026-08-31 00:01 | 0 s | recovered |

**A clean 12-hour sawtooth.** Age climbs by almost exactly one probe interval each cycle — 7,200 seconds — then resets to about 21 minutes when the cache regenerates.

That shape is diagnostic. A frozen endpoint would show age climbing without limit. A healthy one would show age staying low. This shows a cache refreshing correctly from sources that had stopped updating.

Every observation in the window reported `0/5 sources fresh`.

---

## Recovery

| Timestamp | State | Sources fresh |
|---|---|---|
| 2026-08-30 22:01 | `degraded` | 3 of 5 |
| 2026-08-31 00:01 | `good` | 5 of 5 |

Two steps, partial then complete.

---

## Context: this was anomalous, not typical

| Date | Observations | Flagged |
|---|---:|---:|
| 26 Aug | 19 | 4 |
| 27 Aug | 12 | 3 |
| 28 Aug | 10 | 1 |
| **29 Aug** | **12** | **12** |
| **30 Aug** | **12** | **12** |
| 31 Aug | 12 | 1 |
| 1 Sep | 15 | 1 |
| 2 Sep | 6 | 1 |

Outside the incident window the endpoint flags occasionally. During it, every single observation flagged.

**No failure rate is published here.** The observations before 1 September do not retain the provider's original response body, so they cannot support a rate a third party could verify. That is a defect in this observatory's own attestation format, corrected on 1 September and logged as ruleset v2.1. The incident itself is unaffected: the age series above is retained in full and signed.

---

## Why this is published

Not because the provider did anything wrong. It declared the condition correctly, in machine-readable fields, on every single response.

**The gap is in the protocol.** x402 has HTTP 402 for "payment required" and 200 for "here it is". It has no way to express *"here it is, but do not rely on it"*.

So an honest provider has two options: return an error and lose the sale, or deliver with a warning label. This provider chose the second — `quality_state`, `fresh_sources`, `stale_sources`, all accurate — and the charge settled 24 times because nothing in the payment path reads those fields.

An agent that did not know this provider's specific field names received 48 hours of FX quotes up to 10 hours old, with a 200 status and a successful payment.

This is the case that the proposed [delivery declaration extension](SPECIFICATION.md) addresses. A standard `usable: false` would let a settlement layer skip the debit, which is precisely what [Fermah](https://fermah.xyz) described when they set out how their account layer would act on it.

---

## Verification

Each of the 24 observations is an Ed25519-signed attestation. The public key is [`attestor.pub`](attestor.pub) in this repository.

The full series, including the ages above and the provider's declared state for each observation, is published with the raw data.

**Right of reply:** the provider was notified before publication. Any response received will be published here unedited.

---

*Delivery verification observatory for x402. Open methodology, raw data published, measurements without value judgements.*

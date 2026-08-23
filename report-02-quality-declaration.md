# x402 providers declare shape, not quality

Second report from the observatory. 23 August 2026.

---

## Summary

A survey of all 15,157 x402 resources carrying a declared output schema found:

- **99.84% declare the shape of the response** — which fields, of which type.
- **Only 7.40% of providers declare any property of the data's quality** in that schema: freshness, confidence, or provenance.
- **Among the 91 providers that declare something, all seven possible combinations of the three properties are represented.** There is no dominant convention.
- **There is not even agreement on where to declare it.** Some providers declare in the catalogue schema; the most rigorous ones found declare only in the response body, at request time — which an agent cannot read before paying.

The standard formalised the price and the response shape. It left the quality of the delivered data undeclared. Providers that care about this are filling the gap independently, in mutually incompatible ways.

---

## 1. Method

### 1.1 What was measured

Every active mainnet resource with a declared schema (15,157 resources, 1,230 providers) was inspected for three categories of quality declaration:

| Category | Detected by | Meaning |
|---|---|---|
| **Freshness** | `staleness`, `dataAsOf`, `freshness`, `cache_age` | How old is the data being served |
| **Quality** | `confidence`, `calibration`, `uncertainty`, `accuracy` | How reliable the provider claims it is |
| **Provenance** | `record_hash`, `traceable_to`, `provenance`, `source_url` | Where it came from, and whether it can be verified |

**Detection is restricted to the `output` section of the declared schema.** An earlier pass matched against the whole schema and produced inflated figures, because these terms also appear in input parameter descriptions. That first result — 570 resources and 11.1% of providers — was wrong and is corrected here to 454 and 7.40%.

The error is documented rather than quietly fixed, because the inflated number was more favourable to the argument being made.

### 1.2 Known limitations

**Lower bound by construction.** A provider using different field names for the same concept is not counted. The true share is equal to or higher than reported, never lower.

**Catalogue surface only.** Providers that declare quality only in the response body do not appear in these counts. That is itself a finding, discussed in section 3.

**GET only.** The observatory's delivery prober executes GET requests. Of 15,182 active resources, **6,664 (43.9%) declare POST** and are outside the scope of delivery measurement. The census and schema figures in this report cover the full catalogue; delivery verification figures published elsewhere cover GET resources only.

---

## 2. Results

### 2.1 Shape versus quality

| | Resources | Share |
|---|---:|---:|
| Total active with declared schema | 15,157 | 100% |
| Declaring freshness | 199 | 1.31% |
| Declaring quality | 175 | 1.15% |
| Declaring provenance | 119 | 0.79% |
| **Declaring at least one** | **454** | **3.00%** |

By provider:

| | Providers | Share |
|---|---:|---:|
| Total with declared schema | 1,230 | 100% |
| Declaring at least one property | 91 | **7.40%** |
| Declaring all three | 3 | 0.24% |

### 2.2 No convention exists

Of the 91 providers declaring something, the distribution across the seven possible combinations:

| Freshness | Quality | Provenance | Providers |
|:---:|:---:|:---:|---:|
| — | ✓ | — | 43 |
| — | — | ✓ | 16 |
| — | ✓ | ✓ | 11 |
| ✓ | ✓ | — | 8 |
| ✓ | — | — | 8 |
| ✓ | ✓ | ✓ | 3 |
| ✓ | — | ✓ | 2 |

**Every possible combination is occupied.** If a practice had emerged, one combination would dominate and the rest would be residual. Instead 91 providers made 91 independent decisions about what was worth declaring.

The three declaring all three properties:

| Provider | Resources |
|---|---:|
| x402 Live Probe | 772 |
| NetIntel | 79 |
| LUMI | 24 |

---

## 3. Two surfaces, no agreement on which

The providers found to have the most thorough quality declarations **do not appear in the table above at all.**

Kronos publishes a declared schema for every endpoint, but that schema contains no freshness field. Its freshness declaration (`cache_age_seconds`, `stale`) appears in the response body, at request time. The same applies to Truth Bear (`data_age_hours`, `freshness_basis`, `record_hash`) and Otto AI (`meta.stalenessSec`, `degraded`).

| Surface | Readable | Providers observed |
|---|---|---|
| Catalogue schema | Before paying | 91 |
| Response body | Only after paying | at least 4, non-overlapping |

**An agent must look in two different places depending on the provider, and in neither is it guaranteed to find anything.**

The distinction matters for decisions, not just for tidiness. A declaration that can only be read after payment cannot inform the choice of which provider to pay.

---

## 4. What the rigorous providers actually do

Six cases, six vocabularies for the same three ideas.

| Concept | Kronos | Truth Bear | Otto AI | ApiToll | hugen | LUMI |
|---|---|---|---|---|---|---|
| Data age | `cache_age_seconds` | `data_age_hours` | `meta.stalenessSec` | `asOf` | `quote_age_ms` | `windowHours` |
| Is it stale | `stale` | `freshness` | `degraded` | — | `quality_state` | — |
| Confidence | `up_prob_calibrated` | `uncertainty` | `sourceHealth` | `confidence` | `fresh_sources` | `outcomeState` |
| Source | `model` | `traceable_to` | — | `source.name` | — | `rubricVersion` |
| Verifiable | — | `record_hash` | — | — | — | `resultHash` |

Four different units for age: seconds, hours, milliseconds, and an absolute timestamp.

Worth noting individually:

**Kronos** publishes `/api/stats` and `/api/methodology` openly. It reports a directional hit rate of 0.5219 over 33,884 scored forecasts, separates cached from paid samples, and **excludes its paid sample from the headline figure because n=120 is not statistically meaningful** — even though that sample is more favourable at 0.5417.

**Truth Bear (GAUGE)** declares per-record source lineage, a canonical recomputable hash, explicit uncertainty, whether the response came from a stored snapshot rather than a live upstream call, and a freshness basis with numeric thresholds.

**LUMI** nulls out headline metrics while a measurement window is still open and places provisional figures under different field names, so they cannot be mistaken for final results.

---

## 5. Two illustrative cases

### 5.1 A verification path machines cannot follow

Truth Bear has the most complete provenance model found in this ecosystem. Every record ships with a canonical SHA-256 hash and a free `/gauge/verify` endpoint.

The field is emitted as `record_hash`. The verifier accepts it as `hash`.

Observed 22 August 2026, using a hash returned by a paid call:

| Request | Result |
|---|---|
| `?hash=<value>` | `is_truth_bear_record: true` |
| `?record_hash=<value>` | `is_truth_bear_record: false` |
| `?anything=abc` | `is_truth_bear_record: false` |
| no parameters | `is_truth_bear_record: false` |

In every incorrect case the response is not a usage error:

> "[NOT FOUND] NOT a Truth Bear record — no published reading matches this hash. If you saw a card claiming this, it was not published by Truth Bear."

An agent that takes the field name from the response it just paid for receives an explicit denial that the record belongs to the provider. The natural interpretation is that the paid data is fabricated. A human reads the docs and finds the right parameter; a machine does not.

The record is authentic and the verifier works. This is not a data error — it is an interface that leads an automated consumer to a false conclusion.

The provider was notified before publication and has right of reply.

### 5.2 Data declared unusable, charged anyway

`tick.hugen.tokyo/tick/latest` returned HTTP 200 after a successful payment of $0.005, in a valid schema:

```json
{ "quality_state": "stale", "fresh_sources": 0, "stale_sources": 6,
  "quote_age_ms": 1140535, "is_crossed": true,
  "best_bid": "1.16766", "best_ask": "1.16764" }
```

Zero of six sources fresh. Data 19 minutes old on a real-time FX feed. And `is_crossed: true` — the bid above the ask, arithmetically impossible in a live market.

**The provider declared all of it.** The failure is not dishonesty. It is that x402 has HTTP 402 for "payment required" and 200 for "here it is", and no way to say "here it is, but do not use it". The provider did the only thing available: shipped it with a label nobody parses.

---

## 6. Declaring well is not rewarded

| Provider | Lifetime revenue | Unique payers |
|---|---:|---:|
| Kronos | $58.36 | 94 |
| Truth Bear (per endpoint, 30d) | — | 2 |

The largest publishers by call volume in the catalogue declare no quality properties at all, and register hundreds of calls per month.

**There is currently no observable commercial return to declaring quality.** This is uncomfortable for the argument that a standard would be adopted voluntarily, and it is reported because it is true.

The most plausible reading is that tickets are still too low for buyers to discriminate on quality. Chainalysis data shows the economic weight shifting sharply: transactions above $1 rose from 49% of volume in early 2025 to 95% by early 2026. If that continues, discrimination on quality becomes economically rational.

---

## 7. What this implies

x402 formalised **the price** and, through catalogue schemas, **the shape of the response**. It did not formalise **the quality of what is delivered**.

91 providers independently decided this matters. None could follow a convention, because none exists. The result:

1. Seven different combinations of what to declare.
2. Two different surfaces on which to declare it, only one readable before payment.
3. Incompatible field names, units and semantics across providers doing the same thing.
4. At least one verification path an automated consumer cannot follow.
5. No way to express "delivered, but not usable".

There is a measurable asymmetry that makes the point precisely. The **input** contract is standardised: a single generic function can build a valid request for 85.5% of the 6,664 POST resources in the catalogue, reading nothing but the declared schema. The **output** quality is not standardised: interpreting six providers requires six bespoke adapters.

**The gap is not that providers are dishonest. It is that there is no shared way to be honest in a machine-readable manner.**

---

## 8. Data and reproducibility

Raw data and queries are published in the repository with SHA-256 hashes.

All figures are reproducible against the public discovery catalogues (CDP Bazaar, Binance B402), which require no authentication.

**Right of reply:** any provider named here may request publication of a response alongside the data concerning them. Responses are published unedited.

---

## 9. Method notes

Response-body declarations were identified by direct purchase and inspection, not systematically. A full survey of that surface would require purchasing every resource and is not economically feasible.

Observations belong to the observatory's production phase (from 2026-08-22 12:45 UTC). Earlier observations are calibration and excluded. The observation table is append-only by design; phase separation is achieved through views, never by altering records.

**Corrections to this report:** the initial version reported 570 resources and 11.1% of providers declaring quality properties. Those figures matched against the entire schema including input parameter descriptions. Restricting to the output section gives 454 and 7.40%. The corrected figures are used throughout.

---

*Delivery verification observatory for x402. Open methodology, raw data published, measurements without value judgements.*

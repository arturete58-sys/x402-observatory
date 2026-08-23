# x402 providers declare shape, not quality

Second report from the observatory. 22 August 2026.

---

## Summary

A survey of all 15,157 x402 resources carrying a declared output schema found:

- **99.84% declare the shape of the response** — which fields, of which type.
- **11.1% of providers declare any property of the data's quality** — freshness, confidence, or provenance.
- **Among the 136 providers that declare something, all seven possible combinations of the three properties are represented.** There is no dominant convention.
- **There is not even agreement on where to declare it.** Some providers declare in the catalogue schema; others declare only in the response body at request time. A consuming agent must check both places, and neither guarantees anything.

The standard formalised the price and the response shape. It left the quality of the delivered data undeclared. Providers that care about this are filling the gap independently, in mutually incompatible ways.

---

## 1. Method

### 1.1 What was measured

Every active mainnet resource in the census (15,182 resources, 1,230 providers with a declared schema) was inspected for three categories of quality declaration:

| Category | Detected by | Meaning |
|---|---|---|
| **Freshness** | `staleness`, `dataAsOf`, `freshness`, `cache_age` | How old is the data being served |
| **Quality** | `confidence`, `calibration`, `uncertainty`, `accuracy` | How reliable the provider claims it is |
| **Provenance** | `record_hash`, `traceable_to`, `provenance`, `source_url` | Where it came from, and whether it can be verified |

Detection is by pattern match against the declared schema published in the discovery catalogue. This is a lower bound: a provider using different field names for the same concept is not counted.

### 1.2 Limitations of the method

This is the most important caveat in the report, and it strengthens rather than weakens the finding.

**Schema-based detection only sees declarations made in the catalogue.** Several providers — including the three most rigorous found in this ecosystem — declare quality properties only in the response body, at request time. They do not appear in these counts.

That is itself a finding, and it is discussed in section 3.

---

## 2. Results

### 2.1 Shape versus quality

| | Resources | Share |
|---|---:|---:|
| Total active with declared schema | 15,157 | 100% |
| Declaring freshness | 226 | 1.49% |
| Declaring quality | 242 | 1.60% |
| Declaring provenance | 142 | 0.94% |
| Declaring at least one | 570 | 3.76% |

By provider:

| | Providers | Share |
|---|---:|---:|
| Total with declared schema | 1,230 | 100% |
| Declaring at least one property | 136 | 11.1% |

### 2.2 No convention exists

Of the 136 providers declaring something, the distribution across the seven possible combinations:

| Freshness | Quality | Provenance | Providers |
|:---:|:---:|:---:|---:|
| — | ✓ | — | 63 |
| — | — | ✓ | 22 |
| ✓ | — | — | 18 |
| — | ✓ | ✓ | 13 |
| ✓ | ✓ | — | 12 |
| ✓ | ✓ | ✓ | 5 |
| ✓ | — | ✓ | 3 |

**Every possible combination is occupied.** If a practice had emerged, one combination would dominate and the rest would be residual. Instead the 136 providers made 136 independent decisions about what was worth declaring.

No single *resource* declares all three. Five *providers* do, across their catalogue:

| Provider | Resources |
|---|---:|
| x402 Live Probe | 772 |
| entity-search | 348 |
| NetIntel | 79 |
| AgentUtility.ai | 74 |
| LUMI | 24 |

---

## 3. Two places to declare, no agreement on which

The providers found to have the most thorough quality declarations **do not appear in the table above at all.**

Kronos publishes a declared schema for all its endpoints, but that schema contains no freshness field. Its freshness declaration (`cache_age_seconds`, `stale`) appears in the response body, at request time. The same applies to Truth Bear (`data_age_hours`, `freshness_basis`, `record_hash`) and Otto AI (`meta.stalenessSec`, `degraded`).

So there are two declaration surfaces in use:

| Surface | Visible to | Providers observed |
|---|---|---|
| Catalogue schema | Any agent, before paying | 136 |
| Response body | Only after paying | at least 4, not overlapping |

**An agent that wants to know how fresh a piece of data is must look in two different places depending on the provider, and in neither case is it guaranteed to find anything.**

The pre-payment surface is the one that matters for decision-making. An agent choosing between providers cannot use a declaration it can only read after having paid.

---

## 4. What the rigorous providers actually do

Four cases, each with a distinct format for the same concepts.

**Kronos Crypto Data & Forecasts** publishes a public `/api/stats` and `/api/methodology`. It states directional hit rate (0.5219 over 33,884 scored forecasts), separates cached from paid samples, and **excludes its paid sample from the headline figure because n=120 is not statistically meaningful** — even though that sample is more favourable (0.5417). Its responses carry both a raw probability and a calibrated one, plus a prose note stating that its directional edge is not statistically established.

**Truth Bear (GAUGE)** declares per-record source lineage (`traceable_to: EIA-930`), a canonical recomputable `record_hash`, explicit uncertainty, whether the response came from a stored snapshot or a live upstream call, and a freshness basis with numeric thresholds (`fresh<=24h; recent<=192h; dead_source>1440h`).

**Otto AI** publishes `meta.stalenessSec`, `dataAsOf` and `degraded` across many endpoints. Requests to unknown routes return the list of valid routes.

**ApiToll** declares `asOf`, `confidence`, and the upstream source with name and URL.

Four providers. Four incompatible vocabularies for freshness. Four for confidence. No shared field names, no shared units, no shared semantics.

---

## 5. Illustrative case: a verification path machines cannot use

Truth Bear has the most complete provenance model found in this ecosystem. Every record ships with a canonical SHA-256 hash, and a free `/gauge/verify` endpoint is offered for checking it.

The field is emitted as `record_hash`. The verifier accepts it as `hash`.

Observed 22 August 2026, using a hash returned by a paid call to `/gauge/grid-reliability-region?entity=caiso`:

| Request | Result |
|---|---|
| `?hash=<value>` | `is_truth_bear_record: true` |
| `?record_hash=<value>` | `is_truth_bear_record: false` |
| `?anything=abc` | `is_truth_bear_record: false` |
| no parameters | `is_truth_bear_record: false` |

In every incorrect case the response is not a usage error. It is:

> "[NOT FOUND] NOT a Truth Bear record — no published reading matches this hash. If you saw a card claiming this, it was not published by Truth Bear."

An agent that takes the field name from the response it has just paid for, and passes it to the verifier, receives an explicit denial that the record belongs to the provider. The natural interpretation is that the paid data is fabricated.

A human reads the documentation and finds the correct parameter name. A machine does not.

**This is not a data error.** The record is authentic and the verifier works correctly. It is an interface that leads an automated consumer to a false conclusion — precisely the class of failure that no pre-payment control layer detects, because nothing about the payment or the response shape is wrong.

The provider was notified before publication and has right of reply.

---

## 6. Declaring well is not rewarded

The two providers with the most rigorous declarations found in this survey report the following usage:

| Provider | Lifetime revenue | Unique payers | Calls |
|---|---:|---:|---:|
| Kronos | $58.36 | 94 | 13,345 paid |
| Truth Bear (per endpoint, 30d) | — | 2 | 24–59 |

By contrast, the largest publishers by call volume in the catalogue declare no quality properties at all, and register hundreds of calls per month.

**There is currently no observable commercial return to declaring quality.** This is uncomfortable for the argument that a standard would be adopted voluntarily, and it is reported here because it is true.

The most plausible reading is that the ecosystem is too small and tickets too low for buyers to discriminate on quality yet. Chainalysis data shows the economic weight shifting sharply toward larger transactions — transactions above $1 rose from 49% of volume in early 2025 to 95% by early 2026. If that trend continues, discrimination on quality becomes economically rational.

---

## 7. What this implies

The x402 standard formalised **the price** and, through catalogue schemas, **the shape of the response**. It did not formalise **the quality of what is delivered**.

136 providers have independently decided this matters. None of them could follow a convention, because none exists. The result:

1. Seven different combinations of what to declare.
2. Two different surfaces on which to declare it.
3. Incompatible field names, units and semantics across providers doing the same thing.
4. At least one verification path that an automated consumer cannot follow.

A consuming agent that wanted to select providers on declared quality would need bespoke parsing code per provider. In practice, that means no agent does it.

**The gap is not that providers are dishonest. The gap is that there is no shared way to be honest in a machine-readable manner.**

---

## 8. Data and reproducibility

Raw census data and the queries used are published in the repository, with SHA-256 hashes for integrity verification.

All figures in this report are reproducible against the public discovery catalogues (CDP Bazaar, Binance B402), which require no authentication.

**Right of reply:** any provider named here may request publication of a response alongside the data concerning them. Responses are published unedited.

---

## 9. Method notes

Detection by pattern match on declared schemas is a lower bound. Providers using unmatched field names for the same concepts are undercounted. The direction of error is known: the true share declaring quality properties is equal to or higher than reported, never lower.

Response-body declarations were identified by direct purchase and inspection, not systematically across the catalogue. A full survey of that surface would require purchasing every resource and is not economically feasible.

Observations belong to the observatory's production phase (from 2026-08-22 12:45 UTC). Earlier observations are calibration and excluded. The observation table is append-only by design; phase separation is achieved through views.

---

*Delivery verification observatory for x402. Open methodology, raw data published, measurements without value judgements.*

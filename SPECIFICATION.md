# x402 Delivery Declaration Extension

**Draft proposal — v0.1**
24 August 2026

Status: draft for discussion. Not a ratified specification.
Author: Alejandro Ferrándiz — [402Scope observatory](https://github.com/arturete58-sys/x402-observatory)

---

## Abstract

This document proposes an optional `extensions.delivery` block for x402 v2, allowing a resource server to declare, **before payment**, machine-readable commitments about the quality of what it will deliver: maximum data age, provenance, confidence support, and verifiability.

x402 formalised the price and the request contract. It did not formalise anything about the delivered payload beyond its shape. This proposal fills that gap without modifying the core protocol and without breaking any existing implementation.

---

## 1. The problem, measured

A survey of the complete x402 discovery catalogue (15,182 active resources, 1,230 providers, 24 August 2026):

| | Value |
|---|---|
| Resources declaring the shape of the response | **99.84%** |
| Providers declaring any property of its quality | **7.40%** (91) |
| Providers declaring a **commitment** about that quality | **0** |

That last row is the reason for this document.

### 1.1 Declaration exists; commitment does not

91 providers declare something about their data — freshness, confidence, provenance. They declare **observed values**: this response is 408 seconds old, this figure has 0.99 confidence, this record traces to EIA-930.

An observed value tells an agent what it received. It does not tell an agent what to expect **before deciding to pay**.

Twenty-seven providers were found to use terms suggesting commitment (`sla`, `maxAge`, `threshold`, `guarantee`). Inspection showed none of them are delivery commitments:

- **`gpt55-token-gateway`** declares `maxAgeSeconds` — as a **required input parameter**. The buyer states the maximum age it will accept. The seller commits to nothing.
- **`Base Gas Snapshot`** embeds a "quality acceptance procedure" as prose inside the response body.
- The remainder use `sla` and `threshold` as commercial tier labels or internal algorithm parameters.

The pattern is instructive. Providers identified the need and expressed it through the only channel the standard formalised: **the input contract**. The need for delivery commitments is real and already present; the protocol offers nowhere to put it.

### 1.2 No convention among those who declare

Of the 91 providers declaring some quality property, all seven possible combinations of freshness / confidence / provenance are represented. No combination dominates.

Six providers examined in detail use six incompatible vocabularies for the same three ideas:

| Concept | Kronos | Truth Bear | Otto AI | ApiToll | hugen | LUMI |
|---|---|---|---|---|---|---|
| Data age | `cache_age_seconds` | `data_age_hours` | `meta.stalenessSec` | `asOf` | `quote_age_ms` | `windowHours` |
| Is it stale | `stale` | `freshness` | `degraded` | — | `quality_state` | — |
| Confidence | `up_prob_calibrated` | `uncertainty` | `sourceHealth` | `confidence` | `fresh_sources` | `outcomeState` |
| Source | `model` | `traceable_to` | — | `source.name` | — | `rubricVersion` |
| Verifiable | — | `record_hash` | — | — | — | `resultHash` |

Four different units for age: seconds, hours, milliseconds, and an absolute timestamp.

### 1.3 Declaring is not currently rewarded

Reported because it bears directly on adoption.

The two providers with the most rigorous declarations found in the catalogue report minimal usage: one shows $58.36 in lifetime revenue across 94 payers; the other, two unique payers per endpoint over 30 days. The largest publishers by call volume declare nothing.

On-chain measurement supplies the likely explanation. Across 8,065,305 USDC payments on Base to catalogued addresses over 29.7 days, **90.4% of payers used exactly one provider.** Payers using more than twenty distinct providers accounted for **0.43% of transactions**.

**Nobody declares quality because nobody compares.** A provider investing in declarations gains no competitive advantage today, because its customer is not evaluating alternatives.

This proposal does not assume that will change. It assumes that if it does, the vocabulary should already exist — and that a common vocabulary is a precondition for comparison, not a consequence of it.

### 1.4 What the gap costs

Observed 22 August 2026. A paid FX endpoint returned HTTP 200 after a successful payment, in a valid schema:

```json
{ "quality_state": "stale", "fresh_sources": 0, "stale_sources": 6,
  "quote_age_ms": 1140535, "is_crossed": true,
  "best_bid": "1.16766", "best_ask": "1.16764" }
```

Zero of six sources fresh, data 19 minutes old on a real-time feed, and a crossed book — bid above ask, arithmetically impossible in a live market.

**The provider declared all of it.** The failure is not dishonesty. x402 has 402 for "payment required" and 200 for "here it is", and no way to express "here it is, but do not use it". The provider did the only thing available: shipped the data with a label nothing parses.

---

## 2. Design principles

**P1 — Extension, not core change.** x402 v2 already defines `extensions`. This proposal adds `extensions.delivery` alongside `extensions.bazaar`. Implementations that ignore it are unaffected.

**P2 — Everything optional.** No field is required. Making any field mandatory would place 1,139 providers out of conformance overnight and frame the proposal as a burden. Absence of a field is information: it means the provider stated nothing.

**P3 — Two surfaces, two roles.**

| Surface | When readable | Contains |
|---|---|---|
| `extensions.delivery` in the 402 response | **Before payment** | Commitments |
| `extensions.delivery` in the 200 response | After payment | Observed values for that delivery |

The pre-payment surface is the one that solves the problem. A declaration readable only after payment is transparency, not decision support.

**P4 — Fixed units, always.** Every duration in seconds. Every timestamp in RFC 3339 UTC. Every probability in [0, 1]. The most common integration error found in practice was unit mismatch, not missing data.

**P5 — Commitment and observation are distinct fields.** `maxAgeSeconds` is what the provider promises. `ageSeconds` is what this response actually is. Conflating them is what makes current declarations undecidable.

---

## 3. Specification

### 3.1 Commitments — in the 402 response

```json
{
  "x402Version": 2,
  "accepts": [{ "scheme": "exact", "network": "eip155:8453", "...": "..." }],
  "extensions": {
    "delivery": {
      "version": "0.1",
      "freshness": {
        "maxAgeSeconds": 1200,
        "basis": "cache",
        "regeneratedEverySeconds": 1200
      },
      "provenance": {
        "sources": ["EIA-930"],
        "servedFrom": "snapshot",
        "verifiable": true,
        "verifyEndpoint": "https://example.com/verify",
        "verifyParam": "hash"
      },
      "confidence": {
        "established": true,
        "basis": "33884 scored observations, 90d rolling",
        "methodologyUrl": "https://example.com/api/methodology"
      },
      "degradation": {
        "declaresUnusable": true,
        "field": "usable"
      }
    }
  }
}
```

| Field | Type | Meaning |
|---|---|---|
| `version` | string | Extension version. `"0.1"` for this draft |
| `freshness.maxAgeSeconds` | integer | **Commitment.** The provider undertakes not to serve data older than this |
| `freshness.basis` | enum | `live` \| `cache` \| `snapshot` \| `aggregate` \| `window` |
| `freshness.regeneratedEverySeconds` | integer | Refresh cadence, where applicable |
| `provenance.sources` | string[] | Upstream sources. Free-form identifiers |
| `provenance.servedFrom` | enum | `live` \| `snapshot` \| `cache` |
| `provenance.verifiable` | boolean | Whether responses carry a verifiable record hash |
| `provenance.verifyEndpoint` | string | URL that verifies a hash |
| `provenance.verifyParam` | string | **Query parameter name that endpoint expects.** See §5.2 |
| `confidence.established` | boolean | Whether the provider claims statistical support for its own metrics |
| `confidence.basis` | string | How that support was established |
| `confidence.methodologyUrl` | string | Public methodology |
| `degradation.declaresUnusable` | boolean | Whether responses may carry a usability flag |
| `degradation.field` | string | Name of that field in the response body |

### 3.2 Observations — in the 200 response

```json
{
  "data": { "...": "..." },
  "extensions": {
    "delivery": {
      "version": "0.1",
      "ageSeconds": 408,
      "generatedAt": "2026-08-24T17:20:10Z",
      "usable": true,
      "confidence": 0.4269,
      "sources": ["EIA-930"],
      "recordHash": "sha256:ba8870f8...",
      "note": "directional edge not statistically established"
    }
  }
}
```

| Field | Type | Meaning |
|---|---|---|
| `ageSeconds` | integer | **Observation.** Actual age of this data at response time |
| `generatedAt` | RFC 3339 | When this payload was produced |
| `usable` | boolean | **The provider's own verdict on this specific response** |
| `confidence` | number [0,1] | Confidence for this response |
| `sources` | string[] | Sources actually used for this response |
| `recordHash` | string | Canonical hash, `algorithm:hex` |
| `note` | string | Free text. **Never load-bearing** — see §5.1 |

### 3.3 The `usable` field

The single most useful field in this proposal, and the one with no current equivalent.

`usable: false` means: **the payload is delivered, the payment stands, and the provider states this response should not be relied upon.**

It exists because the situation already occurs and has no expression. A provider whose upstream sources have failed has three options today: return an error and lose the sale, return degraded data silently, or return degraded data with a label nothing reads. All three are bad. This field makes the third one work.

A conforming agent that receives `usable: false` SHOULD discard the payload regardless of its shape.

### 3.3.1 What a settlement layer does with it

The field is only useful if something acts on it, and what that something can
do depends on the billing model. Contributed by Fermah, who are building an
account layer behind an x402 facilitator:

| Billing model | Action on `usable: false` |
|---|---|
| Running balance | Skip the debit, or credit it back |
| Subscription | Pause the next charge until the provider is usable again |
| Per-request settlement | No recourse — the payment has already settled |

That third row is worth stating plainly: **with per-request settlement,
`usable: false` cannot do anything.** The money is gone before the flag is
read. The declaration only acquires teeth where there is a balance to credit
against or a charge to pause.

### 3.3.2 Two scales of response

A single `usable: false` is a local event, handled per call as above.

A provider that emits it repeatedly is a different problem, and the response
is not a refund — it is a decision to stop offering that provider. That is a
commercial judgement, not an accounting one.

The two differ in what they require:

| | Per-call | Systematic |
|---|---|---|
| Signal source | In-band, from the response | Accumulated history |
| Who can compute it | Facilitator or settlement layer | Requires continuous independent observation |
| Latency | Immediate | Deliberately slow — needs sample |
| Response | Skip or credit the charge | Stop selling the provider |

**This specification covers the per-call declaration only.** The aggregate
signal is out of scope, as enforcement is, and is mentioned here because it
constrains what an implementer should retain:

> An implementation that reads `usable` per call but does not retain the
> history cannot reconstruct the systematic signal afterwards. Retaining the
> flag, the timestamp and the endpoint is enough; the aggregation itself can
> be done by any party holding that record.

### 3.4 Conformance

A provider is **partially conforming** if it emits `extensions.delivery` in the 200 response with at least one field using the names and units defined here.

A provider is **fully conforming** if it additionally emits `extensions.delivery` in the 402 response, and the observations in its 200 responses are consistent with the commitments declared in the 402.

"Consistent" means: `ageSeconds` does not exceed `maxAgeSeconds`, and `usable` is `false` whenever the provider's own criteria for unusability are met.

**No enforcement mechanism is proposed.** See §6.

---

## 4. Migration for existing providers

The six providers surveyed can reach partial conformance by renaming existing fields. No new data collection is required.

| Provider | Current | Proposed |
|---|---|---|
| Kronos | `cache_age_seconds` | `ageSeconds` |
| | `stale` | `usable` (inverted) |
| | `up_prob_calibrated` | `confidence` |
| | `directional_edge.established` | `confidence.established` (402) |
| Truth Bear | `data_age_hours` × 3600 | `ageSeconds` |
| | `freshness_basis` "fresh<=24h" | `maxAgeSeconds: 86400` (402) |
| | `record_hash` | `recordHash` |
| | `traceable_to` | `sources` |
| Otto AI | `meta.stalenessSec` | `ageSeconds` |
| | `degraded` | `usable` (inverted) |
| ApiToll | `asOf` | `generatedAt` |
| | `confidence` | `confidence` |
| | `source.name` | `sources` |
| hugen | `quote_age_ms` ÷ 1000 | `ageSeconds` |
| | `quality_state` != "ok" | `usable: false` |
| LUMI | `outcomeState` "INTERIM_ONLY" | `confidence.established: false` |
| | `resultHash` | `recordHash` |

A reference implementation performing exactly this normalisation for seven providers is published as [`x402-declarations`](https://github.com/arturete58-sys/x402-declarations) (MIT). It is offered as a migration aid and as an existence proof that the mapping is mechanical.

---

## 5. Lessons from measurement

Three design choices come from observed failures rather than from theory.

### 5.1 Prose is not machine-readable

One provider ships this in its response body:

> "Directional edge not statistically established for this asset (hit-rate not proven > 50%). Treat direction as low-confidence."

An honest, careful warning. Also English prose. No agent parses it.

That is why `confidence.established` is a boolean and `note` is explicitly non-load-bearing. Any information an agent must act upon has a typed field.

### 5.2 Verification paths must be self-describing

One provider emits its hash as `record_hash` and its verifier accepts it as `hash`. Passing the emitted field name returns:

> "[NOT FOUND] NOT a Truth Bear record — no published reading matches this hash."

Not a usage error — a categorical denial. An agent using the field name from the response it just paid for concludes the data is fabricated. A human reads the documentation; a machine does not.

Hence `provenance.verifyParam`: if you publish a verification endpoint, publish the parameter name it expects.

### 5.3 Unit ambiguity is the most common integration error

Four units for data age across six providers. Every consumer must know each provider's convention in advance.

Hence P4. Seconds, always.

---

## 6. Out of scope

**Enforcement.** A commitment without consequence is a promise. Attaching escrow, collateral or penalties would make this proposal substantially larger and harder to ratify, and would require economics that do not close at current transaction sizes. This document defines the vocabulary; mechanisms that act on it are separate work.

**Verification.** This proposal standardises what providers *say*. Whether they deliver it is measured independently and is not the concern of a declaration format.

**Signatures.** Signing the commitment block would allow proving after the fact that a provider committed to something. Left as an optional future field rather than a requirement, to avoid raising the adoption cost. One surveyed provider already publishes recomputable hashes, so the capability exists in practice.

**Ranking.** No scores, no grades, no leaderboards. This is a vocabulary.

---

## 7. Open questions

1. **Should `usable` be tri-state** (`true` / `false` / `degraded`) rather than boolean? Providers currently distinguish "stale but directionally useful" from "do not use". A boolean loses that.

2. **How should partial staleness be expressed** when a response aggregates sources of differing freshness? One provider reports `fresh_sources: 0, stale_sources: 6`; another reports a single figure.

3. **Should there be a registry of source identifiers?** `traceable_to: "EIA-930"` is meaningful to a human. Comparison across providers needs canonical identifiers.

4. **Is `extensions` the right home**, or should this be a top-level field in a future x402 version? Extension has lower friction now, and less visibility.

---

## 8. Reference material

All figures in §1 are reproducible against the public discovery catalogues, which require no authentication. Raw data, queries and methodology are published at the [402Scope observatory](https://github.com/arturete58-sys/x402-observatory) with SHA-256 hashes.

**Stated limitations of the underlying measurement:** Base only for on-chain figures; a single 29.7-day window; interpolated block timestamps; GET-only delivery probing, leaving 43.9% of the catalogue outside the scope of delivery verification. Catalogue figures cover the full census.

An open registry mapping provider-specific field names to this vocabulary is maintained alongside the reference implementation, and updated as providers change their formats.

---

## 9. Request for comment

This is a draft, submitted for discussion rather than adoption. Specific input sought:

- From providers already declaring quality: is the proposed migration mechanical for you, or does it lose something you express today?
- From agent developers: which of these fields would you actually branch on?
- On §7, particularly questions 1 and 3.
- On anything in §1 that is factually wrong. Every figure is reproducible and corrections are welcome.

Contact and issue tracker: [x402-observatory](https://github.com/arturete58-sys/x402-observatory).

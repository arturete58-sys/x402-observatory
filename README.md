# The x402 ecosystem measured: 1,178 providers, not 15,034 services

First report from the observatory. 22 August 2026.

---

## Summary

A full census of the public discovery catalogues for the x402 standard was carried out. The result:

**15,034 published resources correspond to 1,178 real providers.** An average of 12.8 resources per provider.

The metric commonly used to size the ecosystem — the number of resources listed in catalogues — overstates the number of providers by a factor greater than twelve.

This is **not a deceptive practice**. A provider legitimately publishes dozens of distinct endpoints under a single payment address; they are different services from the same operator. What this report documents is that "number of resources" is an inadequate metric for sizing a market, and it is the one used by default.

A second finding, smaller but relevant: chain concentration is close to absolute. **Base accounts for 98.44% of all resources.**

---

## 1. Methodology

### 1.1 Defining a provider

**A provider is identified by its payment address (`payTo`), not by endpoint or domain.**

Rationale: a single operator publishes multiple resources that settle to the same address. Counting endpoints or domains produces an inflated census. The payment address is the only identifier that maps stably to an economic entity.

The provider identifier is derived deterministically as the first 16 characters of `sha256(network + '|' + lower(payTo))`.

### 1.2 Sources

| Source | Endpoint | Coverage |
|---|---|---|
| CDP Bazaar (Coinbase) | `api.cdp.coinbase.com/platform/v2/x402/discovery/resources` | Multi-chain, Base-skewed |
| B402 Bazaar (Binance) | `binance.com/bapi/ramp/v1/public/ramp/b402/bazaar/resources` | BNB Chain only |

Both are public and require no authentication. Ingestion date: 22 August 2026.

**The two catalogues share no vendor whatsoever.** They are parallel ecosystems with no discovery interoperability.

### 1.3 Exclusions

- Resources marked as retired (absent from the catalogue at last ingestion).
- Test networks: `base-sepolia`, `eip155:84532`, `eip155:4663` (147 resources, 58 providers).
- The observatory's own instrumentation resources.

### 1.4 Normalisation

Network identifiers are normalised to CAIP-2. In the raw data, `base` and `eip155:8453` appear as distinct strings while being the same network; these have been merged.

For domain analysis the root domain (last two labels) is extracted, not the full subdomain. This distinction proved decisive and is explained in section 4.

---

## 2. The census

### 2.1 Headline figures

| Metric | Value |
|---|---|
| Active mainnet resources | **15,034** |
| Unique real providers | **1,178** |
| Resources per provider (mean) | 12.8 |
| Distinct root domains | 1,273 |
| Networks with activity | 6 |

### 2.2 Distribution by network

| Network | Resources | Providers | % of resources |
|---|---:|---:|---:|
| Base | 14,799 | 1,147 | 98.44% |
| Solana | 191 | 22 | 1.27% |
| BNB Chain | 22 | 5 | 0.15% |
| X Layer | 18 | 2 | 0.12% |
| Algorand | 3 | 1 | 0.02% |
| Arbitrum | 1 | 1 | 0.01% |

**Stellar: 1 resource.** A multi-chain demonstration endpoint accepting payment across eleven networks, Stellar and Algorand among them. No detectable commercial activity on Stellar in the public catalogues.

Concentration on Base is near-total. Any claim about x402 as a multi-chain standard describes a technical capability today, not a distribution of usage.

### 2.3 Resources per provider

| Resources published | Providers | Cumulative resources |
|---|---:|---:|
| 1 | 560 | 560 |
| 2 – 5 | 296 | 863 |
| 6 – 20 | 240 | 2,555 |
| 21 – 100 | 122 | 5,241 |
| more than 100 | 18 | 5,963 |

A pronounced long-tail distribution:

- **47.5% of providers publish a single resource.**
- **1.5% of providers (18) account for 39.7% of the entire catalogue.**

The largest single publisher maintains 979 active resources — 6.5% of the whole catalogue.

---

## 3. Largest publishers

| Operator | Resources | Root domains |
|---|---:|---:|
| GlowPulse | 979 | 1 |
| (no declared name) | 965 | 1 |
| x402 Live Probe | 772 | 1 |
| (no declared name) | 370 | 1 |
| Base Gas Snapshot | 382 | 1 |
| EU Power Dispatch API | 353 | 1 |
| entity-search | 348 | 1 |
| Debug Assist | 257 | 1 |
| Agent402.tools | 181 | 1 |
| tokenguard | 124 | 3 |

None of the large publishers operates multiple root domains to any significant degree. The typical arrangement is a single root domain with many thematic subdomains — the largest uses 77 subdomains under one root, with transparent and consistent naming.

---

## 4. Provider identity and diversification

### 4.1 The finding, and its correction

Initial analysis counted 1,738 distinct domains against 1,135 payment addresses, suggesting a widespread pattern of operators behind multiple brands.

**That result was an artefact of counting subdomains.** Recounting by root domain:

| Root domains per provider | Providers |
|---|---:|
| 1 | 1,019 (89.8%) |
| 2 – 5 | 114 (10.0%) |
| more than 5 | 2 (0.2%) |

Actual ratio: **1.12 root domains per provider.** The ecosystem is, overwhelmingly, exactly what it appears to be.

This correction is documented because the erroneous conclusion was publishable and sounded considerably better than the correct one.

### 4.2 The two cases that remain

Two operators maintain multiple root domains with no apparent relationship between them:

**Operator A — 7 domains, regional naming:**
`afriref.dev`, `asiaref.dev`, `ausref.dev`, `euroref.dev`, `latamref.dev`, `mearef.dev`, `usaref.dev`

**Operator B — 6 domains, no common pattern:**
`demandex.dev`, `gitbeacon.dev`, `moltalyzer.xyz`, `orcatrace.dev`, `signalis.dev`, `x402lint.dev`

A further eleven operators hold between 3 and 5 distinct root domains.

### 4.3 Why it matters, at the right magnitude

These are **isolated cases**: they affect fewer than 1.2% of providers. There is no systemic pattern of identity obfuscation.

They do, however, illustrate a structural limitation of current discovery: **catalogues expose no signal allowing an agent to determine whether two providers are independent entities.**

An agent seeking a regional reference service and selecting both `euroref.dev` and `usaref.dev` to diversify would hold two providers on its list and a single real point of failure. The payment address is published in both cases and makes this detectable, but no catalogue aggregates or surfaces it.

A minor gap today, with an ecosystem of 1,178 providers. It scales badly.

---

## 5. Discovery fragmentation

The two public catalogues analysed **share no providers at all**:

| | CDP Bazaar | Binance Bazaar |
|---|---|---|
| Resources | ~15,000 | 36 |
| Network | Multi-chain, 98% Base | BNB Chain only |
| Schemes | `exact`, `batch-settlement`, `upto` | `eip3009`, `permit2-exact` |
| Quality metric | `quality` (calls, unique payers) | none |
| Provider overlap | — | **0** |

A buyer wishing to evaluate available supply must consult mutually incompatible catalogues, each with its own field format and its own notion of quality — or none at all.

A decentralised discovery mechanism also exists (`/.well-known/x402.json`), allowing a provider to publish a manifest without registering in any catalogue. Providers using only that route fall outside this census.

---

## 6. Limitations

1. **Source bias.** The CDP catalogue is operated by Coinbase, whose network is Base. The measured 98.44% concentration on Base reflects real usage, but also reflects source bias.

2. **Deliberately incomplete census.** Providers publishing only `/.well-known/x402.json` on their own domain do not appear. The true census is equal to or greater than reported, never smaller.

3. **Activity data unverified.** This report does not assess whether catalogued resources function, deliver correctly, or see real use. It is a census of published supply.

4. **Point-in-time snapshot.** Ingested 22 August 2026. The catalogue turns over: resources appear and disappear.

5. **Provider names.** The `serviceName` field is self-declared and not present in all records.

---

## 7. Methodological note on the observatory

Observations are recorded in an **append-only** database: a rule prevents any modification of historical records. Separation between phases (instrument calibration and production) is achieved through views, never by altering data.

Observations prior to 2026-08-22 12:00 UTC belong to the calibration phase and are excluded from all published metrics.

**Declared measurement service interruptions:**

- 2026-08-17 18:00 UTC – 2026-08-21 08:00 UTC (86 h). Cause: automatic reboot following an operating system update on provisional infrastructure, followed by migration to a dedicated server. No observations exist for that interval and they are not reconstructible.

This report does not depend on that series: it is based on the catalogue census, obtained in a single ingestion.

---

## 8. Data and reproducibility

Raw census data is published alongside this report, with a SHA-256 hash for integrity verification.

The queries used are documented and reproducible against any ingestion of the same catalogues, which are public and require no authentication.

**Right of reply:** any operator named in this report may request publication of a response alongside the data concerning them.

---

## 9. Work in progress

This census measures **published supply**. It does not measure whether providers deliver what they promise.

The observatory is currently accumulating a sample across a panel of providers selected for having verifiable ground truth, purchasing resources automatically and comparing delivered content against independent sources.

Categories under measurement:

- **Content accuracy** against consensus of independent public sources.
- **Declared freshness compliance**: several providers publish `stalenessSec` in their responses; the declared value is compared against the actual age of the data.
- **Aggregate reproducibility**: providers declaring multi-source calculations, recomputed from the original sources.
- **Calibration of declared probabilities**, through deferred resolution.

No rate will be published before reaching a minimum of 100 observations per provider, and always accompanied by a 95% Wilson confidence interval over a 30-day rolling window.

---

*Delivery verification observatory for x402. Open methodology, raw data published, measurements without value judgements.*

---

## Raw data

**File:** `census.csv` — 15,034 rows, one per active mainnet resource.

**SHA-256:** `6283cfbfe02995ec36536b5eeda757fae2c4c95a311dba653b2ffda3b1cecafd`

Verify integrity after download: `sha256sum -c census.csv.sha256`

Columns: resource_id, endpoint_url, chain, category, advertised_amount, pay_to, service_name, first_seen_at.

Ingested 22 August 2026 from the CDP Bazaar and Binance B402 public discovery endpoints. Neither requires authentication; the census is reproducible against either at any time.

---

## Reports

- 01 - Ecosystem census (this document)
- 02 - [Providers declare shape, not quality](report-02-quality-declaration.md)

## Related

- [x402-declarations](https://github.com/arturete58-sys/x402-declarations) - library that normalises quality declarations across providers.
- 03 - [Who actually pays on x402](report-03-who-pays.md): one wallet, 92.7% of transactions.

## Specification draft

- [Delivery Declaration Extension (v0.1, draft)](SPECIFICATION.md) - proposed optional extension for machine-readable quality commitments.

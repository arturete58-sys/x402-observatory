# 402Scope

**Independent measurement of the x402 agentic payments ecosystem.**

Most x402 measurement counts transactions. This one buys the resource and checks whether what arrived matches what the provider said it would deliver.

Four chains, one method. Raw data published with SHA-256 hashes, every observation signed, every correction published.

---

## What it does

**Delivery verification.** Twelve endpoints on Base are purchased every two hours and checked three ways: against external consensus (prices against exchange medians), against the provider's own declaration (is the data as fresh as it says), and by local recomputation (deterministic operations recomputed from the input sent).

**On-chain indexing.** Every x402 payment reaching a catalogued address on Base, Solana, XRPL and Stellar.

**Signed attestations.** Each observation is emitted as an Ed25519-signed record containing the value delivered, the reference it was compared against, the sources used, the threshold in force and the verdict. Anyone can recompute the result without access to this database. Public key: [`attestor.pub`](attestor.pub).

**Aggregation with a floor.** Provider-level fault rates are published only above n=100 with a Wilson interval. Below that the API returns `insufficient_data` rather than a number that cannot be defended.

---

## Reports

- **[01 — Ecosystem census](report-01-census.md)**: 15,034 resources map to 1,178 real providers when counted by recipient address rather than endpoint.
- **[02 — Providers declare shape, not quality](report-02-quality-declaration.md)**: 99.84% of resources declare the shape of their response; 7.40% of providers declare anything about its quality. Among the 91 that do, all seven possible combinations appear. No convention exists.
- **[03 — Who actually pays](report-03-who-pays.md)**: 8,065,305 payments on Base over 30 days. One wallet accounted for 92.7% of transactions. 52.2% of payers made a single payment and did not return.
- **[04 — Four chains, one method](report-04-four-chains.md)**: XRPL settles 5.8× more transactions than Base at 0.6% of the value. Transaction counts and settled value describe different chains.

- **[XRPL index](XRPL-INDEX.md)**: 106 addresses receiving x402 payments on the XRP Ledger. Not one resolves to a service through any public route. Addresses can be claimed with a signature, verifiable by anyone with [`verify-claim.js`](verify-claim.js).

**[Corrections](CORRECTION-01-chains.md)** are published in full, including the figures that were more flattering before they were wrong.

---

## Specification draft

**[Delivery Declaration Extension (v0.1)](SPECIFICATION.md)** — a proposed optional `extensions.delivery` block for x402, letting a provider declare freshness, provenance and usability commitments before payment.

Of 1,230 providers surveyed, **none declares a commitment** about the quality of what it delivers. Some declare observed values; the vocabulary to promise anything does not exist.

The settlement semantics in §3.3.1 were contributed by [Fermah](https://fermah.xyz), who are building an account layer behind an x402 facilitator and have adopted the vocabulary.

---

## Library

[`x402-declarations`](https://github.com/arturete58-sys/x402-declarations) — normalises quality declarations across providers into one schema, builds valid requests from declared schemas, and extracts results from provider-specific envelopes.

```
npm install x402-declarations
```

Eight adapters plus pattern-based detection for unknown providers. Detection is never presented as declaration: every verdict carries a `basis` field of `declared`, `heuristic` or `none`.

---

## API

```
GET /v1/provider?endpoint=<url>
```

Returns the signed aggregate for a provider: `n`, fault rate, Wilson interval, window, the hash of the exact attestation set aggregated, and the signature.

**Three states, not two.** A provider needs weeks of probing to reach n=100. Returning nothing until then is a gap, so the response distinguishes what is publishable from what is merely actionable:

| `status` | `confidence` | Condition | What it supports |
|---|---|---|---|
| `published` | `established` | n ≥ 100 | A figure that can be cited |
| `provisional` | `low` | 20 ≤ n < 100 | A conservative policy, not publication |
| `insufficient_data` | `none` | n < 20 | Nothing yet |

`faultRateUpperBound` is returned in all three states, including the last. It is the upper bound of the Wilson interval: **the worst fault rate consistent with what has been observed, at 95% confidence.** It is not an estimate of the provider's fault rate and must not be quoted as one.

Its use is a ceiling. A seller can hold anything above a chosen bound while the provider is still new, and revisit once the sample is established. `faultsObserved` and `n` are returned alongside so the caller can see what the bound rests on.

Two providers currently sit at n=34: one with zero faults and a bound of 10.2%, one with five faults and a bound of 30.1%. Under the previous response both were `insufficient_data` and indistinguishable.

The threshold of 20 is where the interval starts to constrain anything. Below it the bound exceeds 20% even with a clean record, which rules out nothing.

### Batch queries

    POST /v1/providers
    {"endpoints": ["<url>", "<url>", ...]}

Up to 50 endpoints per request, same response shape as above inside a `results` array, each entry carrying its own signature. Endpoints with no aggregate come back as `no_data` rather than being dropped, so a caller can tell what is unmeasured from what is unmeasurable.

A seller checking a catalogue against a per-IP limit of 60 requests per 5 minutes cannot do it one endpoint at a time.

### What is measured

    GET /v1/endpoints

The endpoints currently in the paid panel, with the chain they settle on, the category that fixes their thresholds, and the observatory's relationship with the provider. Being listed means the endpoint is probed, not that its aggregate is publishable yet.

`relationship` is `observed` for providers with no contact, and `collaborating` for those who have supplied their own figures or adopted the vocabulary. That distinction is published rather than hidden: a provider that talks to the observatory is measured by the same method as one that does not, but the reader should be able to see which is which.

### Retired

`/api/v1/*` returns 410. Those routes read from tables that stopped being written on 20 August 2026 and were serving stale figures as current.

Preview quality: HTTP only, rate limited to 60 requests per IP per 5 minutes. Not yet suitable for production.

---

## Method

**Everything is reproducible.** Block ranges, ledger ranges, thresholds and criteria are published. All four chains are indexed from public endpoints requiring no authentication.

**The observation table is append-only.** A database rule prevents modification of historical records. When a rule changes, the change is logged with its reason and an explicit scope declaring which observations it invalidates. Until 3 September that scope was inferred from the reason text and mostly did not apply; see [Correction 07](CORRECTION-07-ruleset-log.md).

**Local canaries** with known-bad behaviour run alongside the real panel, so a silent failure of the instrument itself is detectable.

**Nothing is charged to the providers measured.** The observatory has no commercial relationship with any provider in its panel.

---

## Corrections, and why they are here

Figures published in these reports that were later found wrong and corrected in public.
Numbers are stable identifiers, not chronological order.

| # | Published | Reported | Corrected to | Found by |
|---|---|---|---|---|
| 1 | 2026-08-22 | Not published as a figure | 1.12 root domains per provider | Internal review |
| [2](CORRECTION-01-chains.md) | 2026-08-25 | Solana 191 resources; XRPL 0; Stellar 1 | Solana 5,246; XRPL 737; Stellar 140 | Internal review |
| 3 | 2026-08-23 | 11.1% of providers declare quality | 7.40% | Internal review |
| 4 | 2026-09-01 | Stellar volume for one provider: 10.77 USDC | 31.5412 USDC | **The provider** |
| 5 | 2026-09-01 | One wallet: 92.7% of Base transactions | Holds for the 30-day window; 21.9% over the last seven days | Internal review |
| [6](CORRECTION-02-concentration.md) | 2026-09-02 | XRPL: largest payer 1.3%, described as the most evenly distributed chain | Largest recipient 74.6%; the most concentrated of the four by recipient | Internal review |
| [7](CORRECTION-07-ruleset-log.md) | 2026-09-03 | 12 logged ruleset changes, each with the observations it invalidates | 15 distinct changes; 12 of them had no effect. No published figure changes. | Internal review |

6 corrections to published figures, 1 found by the provider measured.
Entry 1 corrected an error caught before publication; it is listed for continuity of numbering.

Correction 4 matters most. A Stellar provider sent their own figures, which did not match. The defect was a 1 USDC filter discarding 63% of their volume — and it affected every Stellar figure published up to that point. After the fix, the numbers match theirs exactly.

This table is generated from the correction register, not maintained by hand.

Sixteen further findings were discarded before publication because they did not survive checking.

Not every correction has its own file. Those without a link above are documented inside the report they correct.

A measurement project that hides its own errors is not measuring anything.

---

## Right of reply

Any provider named in any report is contacted before publication and may submit a response, published unedited alongside the data concerning them.

---

## Contact

Issues and corrections: [GitHub issues](https://github.com/arturete58-sys/x402-observatory/issues)

If any figure here is wrong, saying so is useful. It has happened before and the correction was published.

## Incident notes

- [2026-08-29 — 48 hours of dead upstream sources on a paid FX feed](incident-2026-08-29-fx-feed.md)

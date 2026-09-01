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

Preview quality: HTTP only, rate limited to 60 requests per IP per 5 minutes. Not yet suitable for production.

---

## Method

**Everything is reproducible.** Block ranges, ledger ranges, thresholds and criteria are published. All four chains are indexed from public endpoints requiring no authentication.

**The observation table is append-only.** A database rule prevents modification of historical records. When a rule changes, the change is logged with its reason and the observations it invalidates — 12 such changes so far.

**Local canaries** with known-bad behaviour run alongside the real panel, so a silent failure of the instrument itself is detectable.

**Nothing is charged to the providers measured.** The observatory has no commercial relationship with any provider in its panel.

---

## Corrections, and why they are here

Five figures published in these reports were later found wrong and corrected in public:

| Reported | Corrected to | Found by |
|---|---|---|
| Solana: 191 resources | 5,246 | Internal review |
| 11.1% of providers declare quality | 7.40% | Internal review |
| Stellar volume for one provider: 10.77 USDC | 31.5412 USDC | **The provider** |

That last row matters most. A Stellar provider sent their own figures, which did not match. The defect was a 1 USDC filter discarding 63% of their volume — and it affected every Stellar figure published up to that point. After the fix, the numbers match theirs exactly.

Sixteen further findings were discarded before publication because they did not survive checking.

A measurement project that hides its own errors is not measuring anything.

---

## Right of reply

Any provider named in any report is contacted before publication and may submit a response, published unedited alongside the data concerning them.

---

## Contact

Issues and corrections: [GitHub issues](https://github.com/arturete58-sys/x402-observatory/issues)

If any figure here is wrong, saying so is useful. It has happened before and the correction was published.

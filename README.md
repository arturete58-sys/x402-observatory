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

Each report states the figures as of its own date. The census has since changed source — see [Report 07](report-07-discovery-depends-on-one-facilitator.md) — and current figures are served from the API rather than restated here.
- **[02 — Providers declare shape, not quality](report-02-quality-declaration.md)**: 99.84% of resources declare the shape of their response; 7.40% of providers declare anything about its quality. Among the 91 that do, all seven possible combinations appear. No convention exists.
- **[03 — Who actually pays](report-03-who-pays.md)**: 8,065,305 payments on Base over 30 days. One wallet accounted for 92.7% of transactions. 52.2% of payers made a single payment and did not return.
- **[04 — Four chains, one method](report-04-four-chains.md)**: four chains indexed with their criteria declared. Its main table was withdrawn ([Correction 08](CORRECTION-08-report-04-figures.md)) and has been recomputed with the query published alongside ([Correction 09](CORRECTION-09-report-04-recomputed.md)). Transaction counts and settled value describe different chains: XRPL settles 3.5× more transactions than Base at 0.47% of the value.

- **[05 — What the ecosystem figures are counting](report-05-what-the-figures-count.md)**: one payer accounts for 91% of all payments indexed on Base and pays a single recipient. Underneath, a flat market of around 570 buyers a week who purchase from more than one provider.

- **[06 — Leaving the catalogue is not dying](report-06-leaving-the-catalogue.md)**: 4,742 resources left the catalogue in 17 days, from 509 providers. 80.8% of a sample still answer and still charge. The catalogue counts who is willing to stay listed, not what exists.

- **[07 — Most providers have no way to be found except through one facilitator](report-07-discovery-depends-on-one-facilitator.md)**: the Bazaar catalogues what CDP's facilitator settles, not what exists. 87% of catalogued resources publish no discovery of their own; 702 live resources appear in no bazaar at all.

- **[08 — What the catalogue and the chain reveal together](report-08-catalogue-and-chain.md)**: 2,102 payer wallets are attributable to 14,717 specific resources using only public data. 104 resources across 51 hosts have URLs that name their subject matter.

- **[Note — one provider declares what happens when delivery fails](NOTE-delivery-declarations.md)**: 151 of 19,941 endpoints declare a delivery commitment, and all 151 belong to the same provider.

- **[09 — Counting transactions and counting money describe different ecosystems](report-09-transactions-and-value.md)**: two addresses account for 93.2% of payments on Base and 16.1% of the value. The other 10,312 payers move 83.9% of the money. Includes a correction to Report 05.

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

### History

    GET /v1/history?endpoint=<url>&days=30&resolution=daily

The aggregates issued for an endpoint over time, as they were issued and signed — not recomputed. The series starts when aggregate emission started, which is later than when measurement started.

`resolution=all` returns every aggregate; the default returns one per day.

Each point carries `n`, `faultsObserved`, `faultRate`, `faultRateUpperBound` and the signature. **`n` is returned for a reason**: the upper bound can fall because the provider improved or because the sample grew, and the two are different claims.

**The response also carries `rulesetChanges`** — the rule changes in the window that can move a series, with their reason. Without them, a discontinuity looks like lost data. On 2 September a change of criterion cut one provider's sample from 97 observations to 16 in the same window; the series alone does not explain that, and the change does.

Changes that invalidate nothing are omitted, or the list would be noise.

### Liveness

Every response carries a `liveness` block: whether the endpoint answers a 402 challenge, with what status, how fast, and what its envelope declares.

    "liveness": {
      "outcome": "charges",
      "statusCode": 402,
      "latencyMs": 164,
      "ageSeconds": 17,
      "declares": { "network": "...", "amount": "...", "offers": 13,
                    "extensions": ["bazaar"], "hasDelivery": false }
    }

`outcome` is `charges`, `free`, `gone`, `unreachable` or `other`. No payment is made: the sweep requests the challenge and stops there.

**This is a different signal from delivery, and it is kept separate on purpose.** An endpoint that always answers can still serve wrong content, and the fault rate says nothing about whether it is reachable. `liveness` never alters `status` or `faultRateUpperBound`. A seller can decline to sell what does not answer without confusing that with declining to sell what fails.

It also means an endpoint that has never been bought is no longer a blank. `status: no_data` with a populated `liveness` block says: nothing is known about what it delivers, and here is what it says about itself.

`hasDelivery` records whether the envelope carries the `extensions.delivery` block proposed in the specification. It is currently false everywhere, which is the baseline this is measured against.

### Contributed counts

    POST /v1/report
    Authorization: Bearer <token>
    {"reports":[{"endpoint":"<url>","windowStart":"...","windowEnd":"...",
                 "charges":420,"declaredOk":418,"declaredBad":2}]}

A facilitator sees the in-band `usable` flag on every charge it settles. This observatory sees its own out-of-band measurement. **When a provider declares itself healthy while measurement says otherwise, neither side can see that alone.**

The endpoint accepts counts per provider and window: how many charges, how many declared usable, how many declared not. It does not accept and will not store buyer identities, amounts, or individual transactions.

Contributions are attributed. Every row carries the reporter, so if two facilitators report differently on the same provider it is visible which said what. A token is issued by agreement, not by signing up, and can be revoked without touching anything already contributed.

**Contributed data is published like everything else**, marked as third-party. It is not treated as measurement: it is what a provider said about itself, counted by someone who was there.

### Verifying someone else's attestation

    POST /v1/verify
    <the provider response, including its receipt>

Some providers sign what they deliver. Verifying that signature means reproducing their canonicalisation, fetching their key, and knowing which fields the signature covers — three things a buyer should not have to work out per provider.

The response says whether the signature is valid, whether it covers the delivered payload, and which canonicalisation and key were used.

**A valid signature means the holder of that key signed that content. It does not mean the content is correct.** A provider can sign a wrong number impeccably. Whether what was delivered matches what was declared is a separate question, answered by buying and comparing, not by checking signatures.

**The key is taken from the receipt itself** and is not checked against any registry. Fetch it from the provider's published location and compare before relying on this — otherwise a forged receipt verifies against its own forged key.

Two receipt shapes are handled: one where the receipt declares a `covers` list of the fields it signs, and one where the signature is over the `result` field. The first is better and needs no guessing.

### Threshold alerts

    POST /v1/watch
    Authorization: Bearer <token>
    {"boundAbove": 0.15, "callbackUrl": "https://..."}

Register a fault-rate upper bound and a URL. The observatory posts to it when a provider crosses that bound, instead of the caller polling every two hours. Omit `endpoint` to watch the whole panel.

**It fires on state change only.** While a provider stays above the bound, nothing further is sent. An alert every two hours about a situation that has not changed is noise, and noise is what makes alerts get switched off. Registering a watch records the current state without notifying, so setting one up does not produce an immediate flood.

The payload carries `n` and `faultsObserved` alongside the bound. **This matters**: a provider with zero faults in eleven observations has an upper bound of 25.9% and will cross a 15% threshold. That is not a bad provider — it is one that cannot yet be ruled out, which is exactly what a conservative policy should hold. The two cases are distinguishable only if you look at `n`.

Each notification includes the attestation set hash and signature, so it can be verified without trusting the delivery.

**Delivery is best-effort.** State is updated whether or not the callback succeeds: retrying in a loop against a receiver that is down is worse than losing one notification. Poll `/v1/provider` if a notification matters.

### Endpoints nobody uses

    GET /v1/unused?days=14

Endpoints that answer a 402 challenge and whose payment address has received nothing in the window. Two signals that only mean something together: the catalogue knows an endpoint exists, the chain knows whether anyone pays for it, and no one joins them.

`never_paid` has never received a payment. `idle` was paid at some point and has not been since — the more interesting case, because it worked and then stopped being used while still answering and still being listed.

**This is a floor, not a count.** An address shared across a provider's whole catalogue counts as used for every resource when only one is bought, so a provider with one address hides its unused endpoints behind its active ones. URLs with an unresolved path parameter are excluded: those were never callable and are a catalogue defect rather than an unused service.

Useful before routing: a catalogue lists an abandoned endpoint identically to one in active use.

### Paid routes

Most of this API is free and stays free: `/v1/provider`, `/v1/providers`, `/v1/endpoints`, `/v1/coverage`, `/v1/history`, `/v1/verify`. Those are what make the measurements useful to anyone, and putting them behind a wall would defeat the point.

`/v1/unused` costs 0.002 USDC per call, payable on Base or Stellar. Request it without payment and it returns a 402 challenge with both options.

    GET /v1/unused
    x-payment-tx: <transaction hash>

**Payments are verified against the chain directly, with no facilitator.** An observatory that measures whether providers deliver what they declare should not depend on a third party it also measures. The same code that indexes Base and Stellar payments verifies these.

**A transaction hash can be claimed once.** The claim is an atomic insert on a primary key, so concurrent requests with the same hash cannot both be served — the failure mode this protects against is documented as a real one in production x402 deployments.

**The challenge declares its own delivery commitment.** If a payment cannot be verified, the request is refused and nothing is consumed. There is no reason to ask the ecosystem for a declaration this observatory does not publish itself.

Revenue and measurement costs are both on public addresses. On Base they are separate addresses, so the two can be told apart.

### Market size

    GET /v1/market?days=30&threshold=0.01

Four chains, each reported by the criterion that fits it and with that criterion named in the response.

Activity on the chain, split between payers whose scale is orders of magnitude above everyone else and the rest.

**Counting transactions and counting money give opposite pictures.** Over thirty days on Base, two addresses account for **93.2% of payments and 16.1% of the value**. The other 10,312 payers make 6.8% of the transactions and move 83.9% of the money.

The transaction count is the figure usually quoted, because it is what an explorer shows.

`threshold` is the share of chain activity above which a payer is treated as outsized. It defaults to 1%, it is arbitrary, and it is declared rather than derived — change it and the split moves. What does not move is that removing two addresses removes most of the transactions and almost none of the value.

**A payer is treated as outsized only if it clears three conditions**: more than 1% of chain activity, more than fifty times the median payer, and more than ten thousand payments. The first two alone misfire on small networks — with eighteen payers the median is two or three payments, so almost anyone clears fifty times it. Solana's distribution falls smoothly from 718 payments to 93 with no discontinuity anywhere, and nothing there is outsized.

**XRPL gets no market figure.** On its most evenly matched days, 109 addresses made between 1,879 and 1,898 payments each — a coefficient of variation of 0.2% against roughly 100% on Base measured with the same query. That is distribution, not demand, and a payer count there counts addresses rather than buyers. The threshold used on the other chains detects scale and would give a misleading answer.

The outsized payers operate in bursts: 112,378 payments on one day, none for the next four, 316 on the day after. That is not what continuous demand looks like.

### Retired

`/api/v1/*` returns 410. Those routes read from tables that stopped being written on 20 August 2026 and were serving stale figures as current.

Live at **https://402scope.org**. Rate limited to 60 requests per IP per 5 minutes; a batch of 50 counts as one request.

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
| [8](CORRECTION-08-report-04-figures.md) | 2026-09-04 | Base 124,530 payments 25 Aug-1 Sep; XRPL 719,932 payments; XRPL value 1,039.71 unitless | Base had no timestamped payments in that window; no window sums to 719,932; XRPL settles in RLUSD and XRP and the two were reported as one figure. Table withdrawn pending recomputation. | Internal review |
| [9](CORRECTION-09-report-04-recomputed.md) | 2026-09-05 | Table withdrawn by Correction 08 | Base 289,052 payments 194,944.44 USDC; XRPL 834,420 RLUSD payments to a single recipient plus 168,097 XRP payments to 101; Solana 1,607; Stellar 115. Window 29 Aug-5 Sep, coverage stated. | Internal review |
| [10](CORRECTION-10-xrpl-payer-distribution.md) | 2026-09-07 | XRPL: 113 payers, none above 1.3%, described as the most evenly distributed chain | 109 addresses making between 1,879 and 1,898 payments on the same day, coefficient of variation 0.155-0.203%, against ~100% on Base measured identically. A payer count is a count of addresses, not of buyers. | Internal review |

9 corrections to published figures, 1 found by the provider measured.
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

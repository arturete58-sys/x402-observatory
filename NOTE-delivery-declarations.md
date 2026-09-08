# Note — One provider declares what happens when delivery fails

8 September 2026. Update to [Report 02](report-02-quality-declaration.md).

---

Report 02 measured quality declarations across a sample of providers and concluded that no convention exists. That was measured against what providers emit in their responses. This note measures something narrower and sharper, across the whole catalogue: **what providers declare in their 402 challenge, before payment, about the delivery itself.**

Of **19,941 endpoints that currently return a payment challenge**:

| | Endpoints | Share |
|---|---:|---:|
| Declare a delivery commitment (`extensions.delivery`) | **151** | 0.76% |
| Sign their responses (`extensions.signature`) | 151 | 0.76% |
| Carry a payment identifier extension | 2,863 | 14.4% |

**The 151 are the same 151.** Every endpoint that declares a delivery commitment also signs its responses, and every one that signs also declares a commitment. The overlap is exact.

They belong to one provider — 140 under a single host and the remainder across its subdomains.

---

## What that provider declares

The commitment is specific rather than aspirational:

- **`policy: no-charge-on-service-failure`** — if the service fails, the caller receives a 402 and is not charged
- **An explicit order of operations** — compute, failure gate, verify, settle, deliver
- **A scope line** — the commitment covers service failure, not verdict quality
- **And a verification route** — after a failed request, the absence of a settlement to the merchant address is checkable from the caller's own wallet

The observatory checked the last of those by accident. A purchase from that provider on 8 September returned a 402 with the message that the service was unavailable and no charge had been made. The wallet balance was unchanged. A second endpoint returned 200 and its Ed25519 signature verified against the published key, with the payload digest matching the delivered result.

---

## What this changes about Report 02's conclusion

Report 02 said no convention exists. The more precise statement is:

**A convention exists, one provider implements it, and 99.24% of the ecosystem declares nothing at all about delivery.**

That is a different problem from the one originally reported. It is not that nobody has worked out how to express a delivery commitment — somebody has, in production, in a form that another implementation could adopt tomorrow. It is that nobody else has.

The gap between 0.76% and anything resembling adoption is not a design problem. It is that declaring a commitment creates an obligation, and 19,790 endpoints currently have none.

---

## Method

Measured from the liveness sweep: each endpoint's most recent 402 challenge, parsed for the extensions its envelope advertises. No payments were made to produce these figures.

**Limits.** An endpoint that declares nothing may still behave impeccably; a declaration is a promise, not a measurement. The point of the observatory is that the two are different, and this note counts promises.

The `payment-identifier` figure is included for contrast: an extension with 19 times the adoption of delivery commitments, because it makes payments easier to reconcile rather than harder to walk away from.

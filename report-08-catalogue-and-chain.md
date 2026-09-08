# Report 08 — What the catalogue and the chain reveal together

Eighth report from the observatory. 8 September 2026.

---

## Summary

Two public sources, neither of them a leak. The chain records which wallet paid which address. The catalogue records which address charges for which resource. Joining them reconstructs what each wallet bought.

- **2,102 payer wallets are attributable to 14,717 specific resources** over seven days on Base, using only public data and no privileged access.
- **104 resources across 51 hosts have URLs that name their subject matter** — patient data, diagnostics, person search, identity, KYC, background checks. For those, the resource identifier alone is metadata about what the buyer sought.
- **The protocol specification does not require this.** Under x402 v2, the facilitator's `POST /verify` receives `paymentPayload` and `paymentRequirements`; the `ResourceInfo` object carrying the URL and description is a separate structure that is not sent to it. The spec keeps the content of a purchase away from the settlement layer. A published address-to-resource map puts it back.

---

## 1. The two halves

**The chain half.** Every x402 payment is a public link between a payer address and a recipient address, on all four indexed chains:

| Chain | Distinct payer addresses | Distinct recipient addresses |
|---|---:|---:|
| Base | 15,914 | 1,072 |
| Solana | 342 | 129 |
| XRPL | 115 | 107 |
| Stellar | 38 | 13 |

This much is a property of public ledgers, not of x402.

**The catalogue half.** CDP's Bazaar publishes, without authentication, each merchant's `payTo` address alongside the URL and description of what it charges for. That mapping is deliberately open — it exists so that agents can find services.

Each half is unremarkable. The join is not.

---

## 2. The join

Over 29 August – 5 September on Base, matching indexed payments against catalogued recipient addresses:

| | |
|---|---:|
| Payer wallets attributable to specific resources | **2,102** |
| Distinct resources they can be attributed to | **14,717** |

**A caveat on payment counts.** The same join returns 13.5 million payments, but that figure is dominated by a single payer responsible for most traffic on the chain, as reported in [Report 05](report-05-what-the-figures-count.md). The count of distinct wallets is the meaningful figure here; the payment total is not, and is omitted from the summary for that reason.

### 2.1 Granularity

Attribution is only as precise as the provider's address scheme.

Where a provider uses **one address per resource**, a payment identifies the exact endpoint. Where a provider uses **one address for its whole catalogue**, a payment identifies the provider and its offering, not which of its services was called.

Both are common. One provider in the panel serves 15 resources from a single address; another serves 141 from three. In both cases the buyer's interest is narrowed to a catalogue, and in the first case that catalogue includes a people-enrichment endpoint.

---

## 3. When the URL is the disclosure

For most resources the URL says little: a price feed, a block height, a currency conversion. For some it says a great deal.

**104 resources across 51 hosts** carry URLs naming their subject matter. Among them, paths ending in `people-enrich`, `person-search`, `identity-risk`, and clinical calculators named after the condition they score.

For those, the exposure does not require reading a request body or intercepting anything. **The resource identifier is itself the disclosure**: knowing that a wallet paid the address behind `/api/pdl/people-enrich` is knowing that whoever controls that wallet looked up a person.

Two consequences worth separating:

- **The buyer is exposed.** Their pattern of purchases is reconstructible by anyone.
- **So is their processing activity.** A party buying people-enrichment is processing third-party personal data. That activity is now publicly attributable to them, and the exposure extends past the buyer to the data subjects being looked up, who are party to nothing.

---

## 4. Why this sits with the implementation, not the protocol

The x402 v2 specification separates the two structures deliberately. `PaymentRequirements` — the object sent to the facilitator — contains `scheme`, `network`, `amount`, `asset`, `payTo`, `maxTimeoutSeconds` and `extra`. The URL and description live in `ResourceInfo`, returned to the client and not forwarded.

So a facilitator operating to spec learns who paid whom, and not what for.

A published address-to-resource map restores the missing half, in public, for anyone. That is a discovery decision rather than a payment one, and it is why this is a per-deployment finding: a provider settling through a facilitator that publishes such a map inherits the exposure whether or not it was considered.

**Nothing here is a vulnerability and no provider named or implied is doing anything wrong.** Publishing a catalogue is good practice for discovery. The exposure is a property of two open systems meeting, and neither party controls the meeting.

---

## 5. Mitigations that exist today

**Resource URLs that do not name their content.** An opaque identifier serves the same routing purpose. The description field in the catalogue is a separate decision from the path.

**One address per resource is worse, not better.** Providers who rotate addresses per resource make attribution exact. Sharing an address across a catalogue coarsens it.

**Rotating `payTo` breaks the link**, at the cost of breaking the catalogue entry too. One provider in the census already issues an ephemeral address per transaction.

**Self-hosting a facilitator** removes third-party involvement in settlement but does nothing about the public catalogue, which is the half that matters here.

---

## 6. Limits

**Only Base was joined.** The other three chains have public payment graphs but no comparable published address-to-resource map, so the join was not performed there.

**Attribution is to an address, not a person.** Whether a wallet is linkable to an identified individual depends on facts outside this measurement. Under the GDPR that linkability is what determines whether pseudonymous data is personal data, and it is not something this observatory can determine from the chain.

**The 104 figure is a text match on URLs** and will include false positives — `identity` in a technical sense, `credit` as in credit scoring of a contract. It is a floor for how many name their subject and not a count of sensitive services.

**No request bodies were examined.** Everything here comes from the catalogue, the chain, and the specification.

---

## 7. Data

The join query and the URL match are published with the raw data. Every figure can be recomputed against public sources without access to anything held here.

**Right of reply:** any party named here may request publication of a response. Responses are published unedited.

---

*Corrections to this report will be published rather than quietly applied.*

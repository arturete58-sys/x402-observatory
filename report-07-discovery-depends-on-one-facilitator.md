# Report 07 — Most providers have no way to be found except through one facilitator

Seventh report from the observatory. 7 September 2026.

---

## Summary

The x402 Bazaar is not a registry. Its own documentation says it catalogues resources **discovered by CDP's facilitator** — there is no sign-up, no submission, no listing step. A resource appears because it settled a payment through that facilitator, and stops appearing when it stops.

There is a second route. The `/.well-known/x402.json` convention lets a provider publish its own catalogue, independent of any facilitator. **447 of 1,920 known hosts publish one.** Nobody aggregates them.

- **87% of catalogued providers publish no discovery of their own.** Of 15,729 resources in the Bazaar, 2,008 also appear in a self-published catalogue. The other 13,721 are visible only for as long as one facilitator keeps seeing them.
- **702 live resources exist that no catalogue lists.** They are findable only because their provider publishes them. 33 of a random sample of 40 answer with a payment challenge.
- **Self-publication is concentrated.** Ten hosts account for 80% of those 702, and several are agent storefronts — providers whose product is the catalogue.

---

## 1. How a resource gets into the Bazaar

From CDP's own documentation: the Bazaar is *"a catalog of payment-required services discovered by CDP's facilitator"*, listing *"services that accept x402 payments with the CDP facilitator"*.

No provider registers. Discovery is a side effect of settlement.

Three things follow, and all three are observable:

**Other chains cannot appear.** CDP's facilitator operates on Base. The absence of Stellar and XRPL resources from the Bazaar, reported in [Report 05](report-05-what-the-figures-count.md), is not providers failing to register — there is nothing to register with.

**Changing facilitator means disappearing.** The x402 client library takes a `useFacilitator` parameter with a configurable URL. A provider that switches settles the same payments and vanishes from the catalogue.

**And this observatory's own Stellar endpoint is the proof.** It is bought twelve times a day and has never appeared in the Bazaar, because those payments do not pass through CDP.

---

## 2. The second route, and who uses it

`/.well-known/x402.json` is a file at a fixed path listing a provider's own resources in the same format as a 402 envelope. It depends on nobody.

Sweeping 1,920 hosts already known from the catalogue:

| | |
|---|---:|
| Hosts publishing a catalogue | **447** (23%) |
| Resources listed across them | 20,770 |
| Of those, live and in no bazaar | **702** |

Of a random sample of 40 of those 702, **33 return a 402 payment challenge**. Two return 404. The rest are method or parameter mismatches rather than absence.

### 2.1 It is concentrated

| Host | Resources found only here |
|---|---:|
| x402-agent-store.rileycraig14.workers.dev | 83 |
| x402stock.xyz | 82 |
| www.stratalize.com | 80 |
| store.agentexchange.work | 76 |
| agentbodega.store | 65 |
| api.hergertsynthora.com | 60 |

Ten hosts account for 561 of the 702. Several are agent storefronts, where publishing a catalogue is the product rather than an act of hygiene. The remaining 141 are spread thinly.

**This is not a large hidden ecosystem.** An earlier working estimate of around 9,600 unlisted resources was wrong: it compared URLs before normalisation and counted the same resource twice under different forms. The figure that survives normalisation is 702, a 4.4% addition to the census. It is reported here because the wrong number was reached first.

---

## 3. The number that matters

Every active resource in the census, by where it can be found:

| | Resources | Share |
|---|---:|---:|
| Bazaar only | **13,721** | 82.3% |
| Bazaar and self-published | 2,008 | 12.0% |
| Self-published only | 702 | 4.2% |
| Total active | 16,676 | |

Of the 15,729 resources the Bazaar carries, 2,008 also publish their own catalogue and 13,721 do not. **That is 87% with no independent way of being found.** Their visibility is a by-product of one facilitator continuing to see their payments.

That is what [Report 06](report-06-leaving-the-catalogue.md) measured from the other side without being able to explain it. 4,742 resources left the catalogue in seventeen days and 80.8% of them still answered. They did not shut down and they did not deregister — there is nothing to deregister from. They stopped settling through CDP, and had published nothing of their own to be found by instead.

A provider in that position is one facilitator change away from invisibility, while running normally the whole time.

---

## 4. What this changes here

The census now ingests `/.well-known/x402.json` as a third source alongside the two bazaars, and records every source a resource appears in rather than only the first.

**Figures published before 7 September count only what the bazaars carried and are not comparable with later ones.** The census can be filtered by source, so the earlier figures remain reproducible: 16,007 resources from bazaars alone, 16,676 with self-published discovery included.

Self-published resources are never auto-retired. A host that stops publishing a catalogue has not withdrawn its services, and treating absence as departure is the error that removed this observatory's own Stellar endpoint from its own panel for a day and a half.

---

## 5. Limits

**The sweep only covers hosts already known.** Every host checked came from the existing catalogue, so this finds resources that known providers publish, not providers nobody has seen. A provider outside every bazaar, publishing a perfectly good `.well-known`, remains invisible to this method too.

**23% is a floor, not a rate.** Hosts that did not answer within six seconds were counted as not publishing.

**And 702 rests on a sample of 40 for liveness.** The proportion answering is 82.5%, with a Wilson interval of 68% to 91%.

---

## 6. Data

The sweep, the ingest and the queries behind every figure are published with the raw data.

**Right of reply:** any party named here may request publication of a response. Responses are published unedited.

---

*Corrections to this report will be published rather than quietly applied.*

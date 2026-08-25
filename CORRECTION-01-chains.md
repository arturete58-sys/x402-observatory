# Correction to Report 01 — chain distribution

25 August 2026

---

## What was wrong

Report 01 stated that Base held 98.44% of catalogued x402 resources, Solana 1.27%, Stellar one resource and XRPL none.

**Those figures were an artefact of the ingestion method.** The ingest script kept only the first payment offer (`accepts[0]`) for each resource. Since 37.8% of the catalogue accepts more than one chain and EVM offers are typically listed first, multi-chain resources were attributed entirely to Base.

Every resource's full set of payment offers has now been re-ingested. The corrected figures follow.

**Not affected:** the total counts (15,034 resources, 1,178 providers), the provider-identity method, and Report 03 in its entirety — that report is built on on-chain payment data, not on the catalogue.

---

## Corrected distribution

Percentages are **share of resources that accept each chain**, not a partition. A multi-chain resource counts once per chain, so the column does not sum to 100%.

| Chain | Resources | Share | Published in Report 01 |
|---|---:|---:|---:|
| EVM (`eip155`) | 14,349 | 97.44% | 14,799 (98.44%) |
| Solana | 5,246 | 35.62% | **191 (1.27%)** |
| Algorand | 866 | 5.88% | **3 (0.02%)** |
| XRPL | 737 | 5.00% | **0** |
| Base (unnormalised label) | 303 | 2.06% | merged into EVM |
| Stellar | 140 | 0.95% | **1** |
| Cosmos | 88 | 0.60% | not reported |
| Animica | 60 | 0.41% | not reported |
| Polygon | 48 | 0.33% | not reported |
| Base Sepolia (testnet) | 14 | 0.10% | excluded |
| Hyperliquid | 6 | 0.04% | not reported |
| Others | 7 | — | not reported |

Total: **15,084 resources, 34,331 payment offers.**

### Multi-chain coverage

| Chains accepted | Resources | Share |
|---|---:|---:|
| 1 | 9,387 | 62.2% |
| 2 | 4,373 | 29.0% |
| 3 | 133 | 0.9% |
| 4 | 833 | 5.5% |

**37.8% of the catalogue accepts payment on more than one chain.** That is the source of the original error.

---

## What the correction reveals

Recounting properly surfaced something the original figures hid.

### A single publisher accounts for most non-EVM presence

One operator publishes the same 713 resources across four chains simultaneously:

| Chain | Address | Resources |
|---|---|---:|
| eip155 | `0x50ab2018c06c6E4eAA9BA52057Eb55eD284912fc` | 5,853 offers |
| Solana | `985iFjbnGQ3dJcwXnfRCMSrH4Jnc3kW1N6msR64B5KX1` | 713 |
| XRPL | `rMnHeutYALco8RYFVcmuU4BCgSzBpPEh32` | 713 |
| Algorand | `62A253YPATFNJCPRKID3FKD77MYJFNTVRYRP4B4JWG36EGLPY7UXFWGI7I` | 706 |

Excluding that operator:

| Chain | With | Without | Reduction |
|---|---:|---:|---:|
| XRPL | 737 | **24** | −96.7% |
| Algorand | 866 | **160** | −81.5% |
| Solana | 5,246 | 4,533 | −13.6% |
| EVM | 14,349 | 13,636 | −5.0% |
| Stellar | 140 | 140 | 0% |

**XRPL and Algorand's catalogue presence is almost entirely one publisher replicating its catalogue.**

### Operator concentration outside EVM

| Chain | Distinct publishing addresses | Resources |
|---|---:|---:|
| Solana | 211 | 5,246 |
| Algorand | 8 | 866 |
| XRPL | 4 | 737 |
| Stellar | 3 | 140 |

Solana has a genuine multi-operator presence. The other three do not: three to eight addresses publish everything.

---

## Effect on the report's conclusions

**Strengthened.** The original claim — that x402 is overwhelmingly an EVM ecosystem — survives: 97.44% of resources accept EVM, and non-EVM presence collapses once a single replicating publisher is excluded.

**Corrected.** Solana's presence was understated by a factor of 27. It has 211 distinct publishing addresses, second only to EVM, and is the only non-EVM chain with a genuinely distributed catalogue.

**Added.** Counting a multi-chain catalogue by first-listed offer systematically overstates whichever chain is conventionally listed first. This affects any measurement of x402 chain distribution derived from the discovery catalogue, not just this one.

---

## Relationship to on-chain measurement

The catalogue describes **published supply**, not usage. Independent on-chain indexing over the same period found:

| Chain | Catalogued resources | Distinct on-chain payers observed |
|---|---:|---:|
| Base | 14,349 (EVM) | 12,451 |
| XRPL | 737 | 11 |
| Stellar | 140 | 5 |

Catalogue presence and actual usage diverge sharply. XRPL has 737 catalogued resources and eleven observed payers, nine of which are a coordinated fleet. Stellar has 140 resources and five payers moving 0.77 USDC over 51 days.

Publishing a resource on a chain is close to free. Being paid on it is not.

---

## Method

Full payment offers are now stored one row per offer in `resource_accepts`, keyed by resource, network, scheme and recipient. Recipient addresses are stored **as published**, without case normalisation — the previous script lowercased all addresses, which is harmless for EVM but destroys base58 addresses on Solana and Algorand. That defect also affected the addresses published in `census.csv`; a regenerated file accompanies this correction.

Re-ingested 25 August 2026 from the CDP Bazaar discovery endpoint, which is public and requires no authentication. Reproducible in full.

**Ruleset v1.5**, 25 August 2026: chain distribution is computed from all payment offers per resource, not the first. Address case is preserved. Figures published before this date under the previous method are superseded.

---

*This is the second published correction to this report. The first revised the share of providers declaring quality properties from 11.1% to 7.40%. Corrections are published rather than quietly applied, because a measurement project that hides its own errors is not measuring anything.*

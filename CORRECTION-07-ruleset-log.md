# Correction 07 — the ruleset change log did not do what it says

3 September 2026

---

## What was wrong

The README states that when a rule changes, the change is logged with its reason and the observations it invalidates.

**The log existed. The invalidation did not.**

Five defects, found in one session while wiring up Stellar probing. None of them changes a published number. Four of them affect the machinery that is supposed to make published numbers auditable.

---

## 1. Rule changes did not invalidate anything

Each entry in `ruleset_changes` carries an `affects_before` timestamp: observations before that moment are invalidated by the change. The aggregation query decided *which* observations by searching for the endpoint's domain inside the free-text `reason` field.

That means a rule change only took effect if whoever wrote it happened to mention the affected domain in the description.

Of 15 logged changes, **3 excluded any observation at all**. The three that worked were the ones whose text named `tick.hugen.tokyo` or `api.delx.ai`. The other twelve had a date, a reason, and no effect.

**Fixed:** scope is now declared explicitly in two new columns. `all` invalidates every prior observation, `endpoint` only those matching a stated pattern, `none` and `report` invalidate no attestations. All 15 prior changes have been classified.

**Effect on published figures:** none. Under the old rule 3 attestations were excluded; under the new one, 2. The remaining 37 of 40 recorded faults were already outside the publishable aggregate under rule v2.1, which excludes observations that do not retain the provider's response body.

---

## 2. Four transitions were never logged

The version chain had gaps: v1.4→v1.5, v1.7→v1.8, v1.9→v2.0 and v2.1→v2.2 were missing.

Three of them are cited in published work. Report 04 names v1.5, v1.7 and v2.0 and states that each is logged with its reason. Two were not. Correction 01 describes v1.5 in full. And v2.2 — concentration reported from both sides — was announced in Correction 02 on 2 September and never entered the table at all.

**Fixed:** all four reconstructed from the published text, each entry stating on its face that it was logged after the fact and on what basis. The chain now runs unbroken from v1.0 to v2.5.

---

## 3. One change logged twice

Entries 5 and 6 are the same change to the hugen adapter, recorded 57 seconds apart. The second rewrites the text of the first.

They differ in one way that matters: entry 5 says prior observations *may be* false positives; entry 6 says they *are*. The first is the defensible claim.

**Not deleted.** Both are kept, with a note explaining the duplication and which formulation stands. The count of distinct changes excludes it.

---

## 4. The README count was wrong

The README said 12 changes. The table now holds 16 entries, 15 distinct changes.

---

## 5. Aggregates declared a ruleset version that was not current

`aggregate-attest.js` carried the ruleset version as a hardcoded constant. It read `v2.0` while the register had moved to v2.4.

265 aggregate attestations issued between 1 and 3 September declare `v2.0` in their `declared` block. Their figures are correct; the version they state about themselves is not.

**Fixed:** the version is now read from `ruleset_changes` at run time. Aggregates issued from now on declare the current version. The 265 earlier ones are unchanged — the table is append-only, and they record what they claimed at the time.

---

## Two more, from the same session

Not part of the log mechanism, but found alongside it and published here rather than separately.

**`quoted_amount` recorded nothing.** The column stored the price 402Scope expected, taken from the catalogue, rather than the price the provider quoted in the 402 envelope — and stored it in a `numeric(38,0)` column, truncating every sub-unit value to zero. All 1,720 observations before 3 September hold `0`. The amount a provider actually asked for is not recorded in any observation before that date, on any chain.

Corrected to read `amount`, `asset` and `network` from the offer itself, in the asset's minimum units. `pay_to` is likewise read from the offer, with the catalogue value as fallback.

**Chain attribution was a constant.** The probe loop wrote `eip155:8453` into every observation regardless of where it settled. The first Stellar purchase, on 3 September, was recorded as Base. Corrected to use the resource's chain. The affected row is not modified.

---

## What this has in common

All five are the same failure: a value fixed by hand that stopped matching reality, with nothing checking it. A chain identifier, a price, a version string, and a query inferring scope from prose.

None was caught by the canaries, because the canaries watch delivery, not bookkeeping.

---

## How this was found

Not by external report. While adding a second chain to the paid panel, a new observation was written with the wrong chain label. Checking why led to the constant, the constant led to the register, and the register did not hold what the README says it holds.

---

## Method

**Ruleset v2.5**, 3 September 2026: the scope of a ruleset change is declared explicitly, not inferred from its description. A change with no declared scope invalidates nothing.

The full change log, including the entries added today and the duplicate, is published with the raw data.

---

*Seventh published correction, and the first about the correction machinery rather than a figure. A measurement project that hides its own errors is not measuring anything — including the errors in how it records its errors.*

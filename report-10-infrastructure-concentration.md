# Report 10 — Three networks serve two thirds of the ecosystem

Tenth report from the observatory. 10 September 2026.

---

## Summary

Every x402 payment is designed to be trust-minimised: the client signs, the facilitator settles, the chain records it. None of that helps if the endpoint is unreachable.

Resolving all 1,985 hosts in the catalogue to the network that serves them:

- **Cloudflare fronts 36.6% of hosts and 38.7% of resources.** 6,918 of 17,875.
- **Three networks serve 65.5% of hosts.** Cloudflare, Amazon and Hetzner.
- **Seven cover 88%.** Add Railway, Microsoft, DigitalOcean and Render.
- **43 networks appear in total**, and the tail beyond the seventh is thin.

A payment protocol spread across 43 blockchains runs on infrastructure concentrated in a handful of companies. The chain diversity is real and it protects against a different failure than the one most likely to happen.

---

## 1. The measurement

Each host in the catalogue is resolved to an IPv4 address and that address to its autonomous system, using DNS and a single batched WHOIS lookup. **No endpoint is contacted.** 1,977 of 1,985 hosts resolved.

| Network | Hosts | Share | Resources | Share |
|---|---:|---:|---:|---:|
| Cloudflare | 724 | 36.6% | 6,918 | 38.7% |
| Amazon (AMAZON-02) | 384 | 19.4% | 3,163 | 17.7% |
| Hetzner | 186 | 9.4% | 1,361 | 7.6% |
| Railway | 133 | 6.7% | 1,863 | 10.4% |
| Microsoft | 93 | 4.7% | 592 | 3.3% |
| DigitalOcean | 87 | 4.4% | 163 | 0.9% |
| Render | 84 | 4.2% | 712 | 4.0% |
| Amazon (AMAZON-AES) | 64 | 3.2% | 522 | 2.9% |

**What this measures is who serves the traffic, not where the server lives.** A host behind a CDN resolves to the CDN regardless of where its origin runs. For availability that is the correct measure — if the CDN is down, the endpoint is down — and for anything else it is the wrong one. A provider counted under Cloudflare may well have its origin on Hetzner; both would have to be up.

---

## 2. Hosts and resources are different questions

The two shares diverge, and the divergence describes how each network is used.

**DigitalOcean: 4.4% of hosts, 0.9% of resources.** Roughly two resources per host. It is where single services live.

**Railway: 6.7% of hosts, 10.4% of resources.** Fourteen per host. It is where catalogues live — a provider running dozens of endpoints from one deployment.

For a facilitator this matters more than the headline. Losing Railway removes 1,863 resources across 133 hosts; losing DigitalOcean removes 163 across 87. The same share of hosts, an order of magnitude apart in what actually stops working.

---

## 3. What this is and is not a risk to

**It is a risk to availability.** A CDN incident takes out roughly two fifths of the catalogue at once, and no amount of chain diversity helps: the payment rails would be fine and there would be nothing to pay for.

**It is not a risk to settlement.** Payments already made are on chains that do not depend on any of these companies. Nothing here can reverse or seize a payment.

**And it is not a criticism of any provider.** Deploying behind Cloudflare or on Railway is ordinary and sensible engineering. The concentration is emergent — nobody chose it, and no participant is in a position to see it. That is exactly the kind of thing an observatory is for.

---

## 4. This observatory's own panel

The thirteen endpoints bought and verified here sit across five networks: four on Railway, three on Hostinger, and two each on Amazon, Cloudflare and Hetzner.

That is reported because a panel concentrated on one provider would make the delivery measurements correlated in a way the fault rates would not reveal. It is not, and the distribution is published rather than assumed.

---

## 5. Limits

**One IPv4 address per host.** A host with several A records is counted by the first. Round-robin across providers would be under-counted.

**AS names are coarse.** AMAZON-02 and AMAZON-AES are both Amazon and are listed separately because they are distinct autonomous systems; combined, Amazon is 22.6% of hosts.

**IPv6 is not resolved.** A host reachable only over IPv6 counts as unresolved. Eight hosts of 1,985 did not resolve at all.

**Refreshed weekly.** Infrastructure does not change daily, and resolving two thousand domains every day would be discourteous.

---

## 6. Data

Live at `GET /v1/infrastructure`, refreshed weekly, with the AS number alongside each name so the attribution can be checked independently.

**Right of reply:** any party named here may request publication of a response. Responses are published unedited.

---

*Corrections to this report will be published rather than quietly applied.*

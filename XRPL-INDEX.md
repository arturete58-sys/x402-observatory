# XRPL index — 106 addresses, no names

4 September 2026

---

## What this is

Every address receiving x402 payments on the XRP Ledger, indexed from the facilitator's `SourceTag` and from `urn:x402` memos. For each one: how many payments it has received, from how many distinct payers, in which currency, at what price, and over what period.

What is missing from all 106 rows is the same three columns: `domain`, `service_name`, `endpoint_url`.

**Not one of the 106 can be resolved to a service.** That is the finding, and this file is also the attempt to fix it.

---

## Why the columns are empty

Four independent routes were tried before publishing this.

**Public catalogues.** Neither the CDP Bazaar nor the Binance catalogue contains a single XRPL resource. Of 551 domains crawled for payment manifests, none declares an XRPL payment address.

**On-chain payload.** Every payment carries an `InvoiceID`, and all 1,137,167 of them are distinct — one per transaction. It identifies a payment, not a resource. No memo carries a URL.

**The facilitator tag.** One `SourceTag` accounts for the entire indexed set: `804681468`. It identifies who settled the payment, not who sold anything.

**Direct enquiry.** The facilitator was contacted. No reply.

An address on XRPL has no equivalent of Base's catalogue entry or Stellar's `home_domain`. Settlement is public; discovery is not.

---

## The data

`xrpl-index.csv`, published with its SHA-256. Columns:

| Column | Meaning |
|---|---|
| `address` | Receiving address |
| `currency` | RLUSD or XRP |
| `price_observed` | Modal payment amount |
| `price_stable` | Whether that amount varies across payments |
| `payments` | Payments received in the indexed window |
| `distinct_payers` | Distinct paying addresses |
| `first_seen`, `last_seen` | Indexed period |
| `domain`, `service_name`, `endpoint_url` | **Empty. This is what a claim fills.** |
| `source` | `observed`, or `claimed-verified` once a claim is proven |

**What this does not establish:** whether the payers are independent customers, instances operated by one party, or something else. On-chain data shows the shape of the traffic, not who controls the addresses.

---

## Claiming an address

If one of these addresses is yours, the three empty columns can be filled. A claim requires proof of control, not an assertion — publishing an unverified attribution would be the same failure this project measures in others.

**1. Sign this exact message with the account's key:**

```
402scope-claim <address> <YYYY-MM-DD>
```

The date is the day you sign. Signing is off-ledger: it costs nothing, submits no transaction, and does not require the account to be funded beyond its reserve.

With `xrpl.js` and `ripple-keypairs`:

    node -e "
    const { Wallet } = require('xrpl');
    const kp = require('ripple-keypairs');
    const w = Wallet.fromSeed(process.env.SEED);
    const msg = '402scope-claim ' + w.address + ' 2026-09-04';
    const hex = Buffer.from(msg).toString('hex');
    console.log('address   :', w.address);
    console.log('publicKey :', w.publicKey);
    console.log('signature :', kp.sign(hex, w.privateKey));
    "

The message is signed as hex-encoded UTF-8. Any signer that produces a `ripple-keypairs` compatible signature over the same bytes will verify.

**2. Open an issue** at [github.com/arturete58-sys/x402-observatory/issues](https://github.com/arturete58-sys/x402-observatory/issues) with:

- the address
- the signature
- the public key
- the domain, service name and endpoint URL you want recorded

**3. The signature is verified** against the account's public key on the ledger before anything is published. A claim that does not verify is not recorded, and you will be told why.

Once verified, the row is updated, `source` becomes `claimed-verified`, and the CSV is republished with a new hash. The claim itself is published alongside, so anyone can re-verify it without trusting this observatory.

---

## What a claim gets you

Nothing is charged, and nothing is promised. Being listed with a name does not mean the service is endorsed, measured or recommended. It means the address resolves to something a reader can look up.

If a claimed endpoint later enters the measured panel, it is probed under the same rules as every other provider. A claim is not a route to better treatment, and the observatory's relationship with each provider is published so a reader can see it.

---

## Corrections

If any figure here is wrong, saying so is useful. It has happened before and the correction was published.

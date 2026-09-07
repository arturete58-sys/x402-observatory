-- Report 04, recomputed table. Window: 29 Aug - 5 Sep 2026, seven days.
-- Coverage: 1,398 watched recipient addresses on Base as of 4 September.
-- Run against x402_cert.

-- Base
SELECT 'base' AS chain, count(*) AS payments,
       count(DISTINCT from_addr) AS payers,
       count(DISTINCT to_addr) AS recipients,
       round(sum(amount)/1e6, 2) AS settled, 'USDC' AS asset
  FROM onchain_payments
 WHERE ts >= '2026-08-29' AND ts < '2026-09-05'
UNION ALL
-- XRPL, per asset: RLUSD and XRP are not the same unit and are not summed
SELECT 'xrpl:' || currency, count(*), count(DISTINCT from_addr),
       count(DISTINCT to_addr), round(sum(amount), 2), currency
  FROM xrpl_payments
 WHERE ts >= '2026-08-29' AND ts < '2026-09-05'
 GROUP BY currency
UNION ALL
-- Solana. NOTE: solana_payments.amount is already in decimal USDC, unlike
-- onchain_payments.amount which is in minimum units. The scales differ by table.
SELECT 'solana', count(*), count(DISTINCT from_addr),
       count(DISTINCT to_addr), round(sum(amount), 2), 'USDC'
  FROM solana_payments
 WHERE ts >= '2026-08-29' AND ts < '2026-09-05'
UNION ALL
-- Stellar
SELECT 'stellar', count(*), count(DISTINCT from_addr),
       count(DISTINCT to_addr), round(sum(amount), 2), 'USDC'
  FROM stellar_payments
 WHERE ts >= '2026-08-29' AND ts < '2026-09-05';

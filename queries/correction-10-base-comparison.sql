SELECT date_trunc('day',ts)::date AS dia,
       count(DISTINCT from_addr) AS pagadores,
       round(stddev(n), 1) AS desv,
       round(100 * stddev(n) / nullif(avg(n),0), 1) AS cv_pct
  FROM (SELECT ts, from_addr,
               count(*) OVER (PARTITION BY date_trunc('day',ts), from_addr) AS n
          FROM onchain_payments WHERE ts > '2026-08-25') x
 GROUP BY 1 ORDER BY 1 LIMIT 8;

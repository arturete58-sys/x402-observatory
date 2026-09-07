SELECT date_trunc('day',ts)::date AS dia,
       count(DISTINCT from_addr) AS pagadores,
       round(avg(n)) AS media,
       round(stddev(n), 2) AS desv,
       round(100 * stddev(n) / nullif(avg(n),0), 3) AS cv_pct,
       min(n) AS minimo, max(n) AS maximo
  FROM (SELECT ts, from_addr,
               count(*) OVER (PARTITION BY date_trunc('day',ts), from_addr) AS n
          FROM xrpl_payments) x
 GROUP BY 1 ORDER BY 1;

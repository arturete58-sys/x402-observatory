-- Self-declared health against measured fault rate.
-- The left side comes from a facilitator that sees the in-band `usable` on
-- every charge; the right side from this observatory's own out-of-band
-- measurement. Neither side can produce this comparison alone.
SELECT d.endpoint, d.reporter, d.charges, d.declared_ok,
       round(100.0 * d.declared_ok / nullif(d.charges,0), 1) AS pct_self_declared_healthy,
       (a.observed->>'n')::int      AS n_observed,
       (a.observed->>'faults')::int AS faults_measured,
       round(((a.observed->>'rate')::numeric)*100, 1) AS pct_fault_rate_measured
  FROM declared_vs_observed d
  LEFT JOIN LATERAL (
    SELECT observed FROM attestations
     WHERE endpoint = d.endpoint AND verdict->>'kind' = 'aggregate'
     ORDER BY observed_at DESC LIMIT 1) a ON true
 ORDER BY d.window_end DESC;

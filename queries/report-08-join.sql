-- Cuantos pagadores quedan ligados a recursos concretos via el mapa publico
-- direccion->recurso del catalogo, unido al grafo de pagos on-chain.
SELECT count(DISTINCT o.from_addr) AS pagadores_atribuibles,
       count(DISTINCT r.endpoint_url) AS recursos,
       count(*) AS pagos
  FROM onchain_payments o
  JOIN resources r ON lower(r.pay_to) = lower(o.to_addr)
 WHERE o.chain = 'eip155:8453'
   AND o.ts > now() - interval '7 days'
   AND r.retired_at IS NULL;

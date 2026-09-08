-- Report 07, section 3. Active resources by where they can be found.
SELECT
  count(*) FILTER (WHERE wk AND cdp)       AS bazaar_and_self_published,
  count(*) FILTER (WHERE wk AND NOT cdp)   AS self_published_only,
  count(*) FILTER (WHERE cdp AND NOT wk)   AS bazaar_only,
  count(*)                                  AS total_active
FROM (
  SELECT r.resource_id,
    EXISTS (SELECT 1 FROM resource_sources s
             WHERE s.resource_id = r.resource_id AND s.source = 'well-known')  AS wk,
    EXISTS (SELECT 1 FROM resource_sources s
             WHERE s.resource_id = r.resource_id AND s.source = 'cdp-bazaar')  AS cdp
    FROM resources r WHERE r.retired_at IS NULL) t;

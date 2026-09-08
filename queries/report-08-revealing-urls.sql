-- Report 08, section 3. Resources whose URL names their subject matter.
-- A floor, not a count: this is a text match and will include false positives.
SELECT count(*) AS revealing,
       count(DISTINCT split_part(split_part(endpoint_url,'//',2),'/',1)) AS hosts
  FROM resources
 WHERE retired_at IS NULL
   AND endpoint_url ~* '(patient|medical|clinic|diagnos|people-enrich|person-search|identity|kyc|credit|background)';

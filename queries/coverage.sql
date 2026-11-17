-- What the tests do not yet prove: every part of a device whose work no test on that device proves -
-- with the best proof it has (present: a test shows the part is there; none: no test reaches it), its
-- status, and the tests that measure it. A test counts for a device once that device has run it.
-- --device  string?  the device (all when not given)
WITH ran AS (
    SELECT DISTINCT r.device_id, r.component_id, r.test, t.proves
    FROM test_results r JOIN tests t ON t.id = r.test
),
best AS (
    SELECT device_id, component_id,
           max(CASE proves WHEN 'works' THEN 2 WHEN 'present' THEN 1 ELSE 0 END) AS rank,
           string_agg(test || ' (' || proves || ')', ', ' ORDER BY test) AS tests
    FROM ran GROUP BY device_id, component_id
)
SELECT s.device_id, s.component_id, s.status,
       CASE coalesce(b.rank, 0) WHEN 1 THEN 'present' ELSE 'none' END AS proven,
       coalesce(b.tests, '') AS tests
FROM support_status s
LEFT JOIN best b USING (device_id, component_id)
WHERE coalesce(b.rank, 0) < 2 AND ($device IS NULL OR s.device_id = $device)
ORDER BY s.device_id, coalesce(b.rank, 0), s.component_id;

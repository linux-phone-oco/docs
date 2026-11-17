-- The status of every part of every phone, derived: from what a person judged (judged, with its notes as
-- evidence) and what the phone's own health suite saw of the part on its latest run (test_results, each
-- test's proof in tests). Run after every filing of a run (devlab gather) through tad, which keeps it only
-- if every rule of the tables still holds. devlab runs every record named derive-* after filing.
--   broken  - the latest run failed the part: a machine can prove that much, whatever was judged before
--   works   - a test that proves the part does its work passed, and none failed
--   judged  - otherwise: a pass that only shows the part is there, or no measurement at all, says nothing
--             against what a person witnessed or read
UPDATE support_status SET status = judged, measured = NULL, measured_run = NULL;
UPDATE support_status s SET
    status = CASE WHEN m.failed > 0 THEN 'broken' WHEN m.works > 0 THEN 'works' ELSE s.judged END,
    measured = m.said,
    measured_run = m.run
FROM (
    WITH latest AS (
        SELECT device_id, component_id, max(run) AS run FROM test_results GROUP BY device_id, component_id
    )
    SELECT r.device_id, r.component_id, r.run,
           count_if(r.outcome = 'fail') AS failed,
           count_if(r.outcome = 'pass' AND t.proves = 'works') AS works,
           string_agg(r.test || ' ' || r.outcome || coalesce(' (' || t.proves || ')', ''), ', ' ORDER BY r.test) AS said
    FROM test_results r
    JOIN latest USING (device_id, component_id, run)
    LEFT JOIN tests t ON t.id = r.test
    GROUP BY r.device_id, r.component_id, r.run
) m
WHERE s.device_id = m.device_id AND s.component_id = m.component_id;

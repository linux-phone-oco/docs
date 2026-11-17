-- The status of every part of every phone, derived: from what a person judged (judged, with its notes as
-- evidence) and what the phone's own health suite saw of the part (test_results, each test's proof in
-- tests). Run after every filing of a run (devlab gather) through tad, which keeps it only if every rule
-- of the tables still holds. devlab runs every record named derive-* after filing.
-- Each test still in the part's latest run counts by its latest measured outcome: a skip says only that
-- the test did not measure this time (a daily check that ran earlier today, a part not reachable now),
-- so the run before it that did measure still speaks.
--   broken  - a test's latest measurement failed the part: a machine can prove that much, whatever was judged
--   works   - a test that proves the part does its work last passed, and none failed
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
    ),
    -- the tests the part's latest run still has (any outcome): a test taken out of the suite stops speaking
    current AS (
        SELECT DISTINCT r.device_id, r.component_id, r.test
        FROM test_results r JOIN latest USING (device_id, component_id, run)
    ),
    -- each such test's latest measurement: its newest pass or fail, else its newest skip
    each AS (
        SELECT r.device_id, r.component_id, r.test, r.outcome, r.run,
               row_number() OVER (PARTITION BY r.device_id, r.component_id, r.test
                                  ORDER BY r.outcome <> 'skip' DESC, r.run DESC) AS n
        FROM test_results r JOIN current USING (device_id, component_id, test)
    )
    SELECT e.device_id, e.component_id, max(e.run) AS run,
           count_if(e.outcome = 'fail') AS failed,
           count_if(e.outcome = 'pass' AND t.proves = 'works') AS works,
           string_agg(e.test || ' ' || e.outcome || coalesce(' (' || t.proves || ')', '') || ' ' || e.run, ', ' ORDER BY e.test) AS said
    FROM each e
    LEFT JOIN tests t ON t.id = e.test
    WHERE e.n = 1
    GROUP BY e.device_id, e.component_id
) m
WHERE s.device_id = m.device_id AND s.component_id = m.component_id;

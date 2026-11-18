-- The step terms of the milestones, read from what each device's own base claims: every step:ID@DEVICE in a
-- milestone's criteria with the device's status of that step (step_status, pulled by feed-device-steps; a step not
-- claimed is unknown), whether the term is met (done, or not-needed) and whether the milestone's step terms are all met
-- (ready). A goal step (stage goals) is never claimed: its status is derived, done when every step it needs, hard
-- edges all the way down, is done or not-needed on the device, partial when some are, unknown when none; an
-- alternative not taken (the console over UART when the gadget's is done) does not count against it. Its proof says
-- how many of its needs are met. Only step terms: feature: and component: terms are read elsewhere, and the
-- milestone's readiness rung is still a person's word. A term that names a step or a device that is none is
-- refused by name.
-- --milestone  string?  one milestone (its id); omitted: every milestone with a step term
WITH RECURSIVE terms AS (
    SELECT m.project, m.id AS milestone, t.term
    FROM milestones m CROSS JOIN LATERAL unnest(regexp_extract_all(m.criteria, 'step:[A-Za-z0-9_-]+@[A-Za-z0-9_-]+')) AS t(term)
    WHERE $milestone IS NULL OR m.id = $milestone
),
parsed AS (
    SELECT project, milestone, regexp_extract(term, 'step:([^@]+)@', 1) AS step, regexp_extract(term, '@(.+)$', 1) AS device FROM terms
),
closure(goal, id) AS (
    SELECT DISTINCT p.step, p.step FROM parsed p JOIN bringup_steps s ON s.id = p.step WHERE s.stage = 'goals'
    UNION
    SELECT c.goal, e.requires FROM closure c JOIN bringup_step_edges e ON e.step = c.id WHERE e.kind = 'hard'
),
leaf AS (
    SELECT DISTINCT p.step AS goal, p.device, c.id AS leaf,
           coalesce(ss.status, 'unknown') IN ('done', 'not-needed')
           OR EXISTS (SELECT 1 FROM bringup_step_edges e JOIN bringup_step_edges o ON o.step = e.step AND o."group" = e."group" AND o.requires <> e.requires
                      JOIN step_status os ON os.step_id = o.requires AND os.device_id = p.device
                      WHERE e.requires = c.id AND os.status IN ('done', 'not-needed')) AS met
    FROM parsed p JOIN closure c ON c.goal = p.step JOIN bringup_steps s ON s.id = c.id AND s.stage <> 'goals'
    LEFT JOIN step_status ss ON ss.step_id = c.id AND ss.device_id = p.device
),
derived AS (SELECT goal, device, count(*) AS needs, count(*) FILTER (WHERE met) AS met FROM leaf GROUP BY goal, device),
read AS (
    SELECT p.project, p.milestone, p.step, p.device,
        CASE WHEN d.goal IS NOT NULL THEN CASE WHEN d.met = d.needs THEN 'done' WHEN d.met > 0 THEN 'partial' ELSE 'unknown' END
             ELSE coalesce(ss.status, 'unknown') END AS status,
        CASE WHEN d.goal IS NOT NULL THEN 'derived: ' || d.met || ' of ' || d.needs || ' needs met' ELSE ss.proof END AS proof,
        CASE WHEN d.goal IS NOT NULL THEN NULL ELSE ss.run END AS run
    FROM parsed p LEFT JOIN derived d ON d.goal = p.step AND d.device = p.device
    LEFT JOIN step_status ss ON ss.step_id = p.step AND ss.device_id = p.device
    WHERE CASE WHEN p.step NOT IN (SELECT id FROM bringup_steps) THEN error('milestone ' || p.milestone || ' names no step ' || p.step || ' (tad q bringup-chain lists them)')
               WHEN p.device NOT IN (SELECT id FROM devices) THEN error('milestone ' || p.milestone || ' names no device ' || p.device || ' (tad q coverage names them)')
               ELSE true END
)
SELECT replace(project, 'linux-phone-oco/', '') AS project, milestone, step, device, status, proof, run,
    status IN ('done', 'not-needed') AS met,
    bool_and(status IN ('done', 'not-needed')) OVER (PARTITION BY project, milestone) AS ready
FROM read ORDER BY project, milestone, step;

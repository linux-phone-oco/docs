-- The step terms of the milestones, read from what each device's own base claims: every step:ID@DEVICE in a
-- milestone's criteria with the device's status of that step (step_status, pulled by feed-device-steps; a step not
-- claimed is unknown), whether the term is met (done, or not-needed) and whether the milestone's step terms are all met
-- (ready). Only step terms: feature: and component: terms are read elsewhere, and the milestone's readiness rung is
-- still a person's word. A term that names a step or a device that is none is refused by name.
-- --milestone  string?  one milestone (its id); omitted: every milestone with a step term
WITH terms AS (
    SELECT m.project, m.id AS milestone, t.term
    FROM milestones m CROSS JOIN LATERAL unnest(regexp_extract_all(m.criteria, 'step:[A-Za-z0-9_-]+@[A-Za-z0-9_-]+')) AS t(term)
    WHERE $milestone IS NULL OR m.id = $milestone
),
parsed AS (
    SELECT project, milestone, regexp_extract(term, 'step:([^@]+)@', 1) AS step, regexp_extract(term, '@(.+)$', 1) AS device FROM terms
)
SELECT replace(p.project, 'linux-phone-oco/', '') AS project, p.milestone, p.step, p.device,
    coalesce(ss.status, 'unknown') AS status, ss.proof, ss.run,
    coalesce(ss.status, 'unknown') IN ('done', 'not-needed') AS met,
    bool_and(coalesce(ss.status, 'unknown') IN ('done', 'not-needed')) OVER (PARTITION BY p.project, p.milestone) AS ready
FROM parsed p LEFT JOIN step_status ss ON ss.step_id = p.step AND ss.device_id = p.device
WHERE CASE WHEN p.step NOT IN (SELECT id FROM bringup_steps) THEN error('milestone ' || p.milestone || ' names no step ' || p.step || ' (tad q bringup-chain lists them)')
           WHEN p.device NOT IN (SELECT id FROM devices) THEN error('milestone ' || p.milestone || ' names no device ' || p.device || ' (tad q coverage names them)')
           ELSE true END
ORDER BY p.project, p.milestone, p.step;

-- A device's bring-up, step by step in the order the steps need each other: each step's depth (the longest
-- chain of needs under it, soft ones too: they order the guide), its stage, its status on the device with the
-- proof and the run, what it needs, and whether it is ready (every hard need done, or one of each group).
-- Without --device: the generic chain, every status unknown - the guidebook's order. A step the device's base
-- never claimed is unknown. In needs, ~ marks a soft need and |G the alternatives group it is one of. Within a
-- depth the steps go by stage (bringup_stages.ord), then their own ord.
-- With --goal: only that goal step and what it needs, hard edges followed all the way down - "what a
-- daily-usable phone needs" is --goal daily-usable-phone (decision 2026-11-18-bringup-steps-phone-stages-and-goal-steps).
-- --device  string?  the device (devices id); omitted: the generic chain
-- --goal    string?  a step, usually of stage goals (linux-runs, daily-usable-phone, complete-phone); omitted: every step
WITH RECURSIVE depth(id, d) AS (
    SELECT id, 0 FROM bringup_steps WHERE id NOT IN (SELECT step FROM bringup_step_edges)
    UNION
    SELECT e.step, depth.d + 1 FROM bringup_step_edges e JOIN depth ON e.requires = depth.id
),
lvl AS (SELECT id, max(d) AS depth FROM depth GROUP BY id),
goal(id) AS (
    SELECT id FROM bringup_steps WHERE id = $goal
    UNION
    SELECT e.requires FROM bringup_step_edges e JOIN goal ON e.step = goal.id WHERE e.kind = 'hard'
),
st AS (
    SELECT s.id, coalesce(ss.status, 'unknown') AS status, ss.proof, ss.run, ss.proven_on, ss.updated
    FROM bringup_steps s LEFT JOIN step_status ss ON ss.step_id = s.id AND ss.device_id = $device
),
need AS (
    SELECT e.step, e.requires, e.kind, e."group", coalesce('g:' || e."group", 'r:' || e.requires) AS g, st.status = 'done' OR st.status = 'not-needed' AS met
    FROM bringup_step_edges e JOIN st ON st.id = e.requires
),
ready AS (
    SELECT step, bool_and(gmet) AS ok FROM (SELECT step, g, bool_or(met) AS gmet FROM need WHERE kind = 'hard' GROUP BY step, g) GROUP BY step
)
SELECT row_number() OVER (ORDER BY l.depth, sg.ord, sg.id, s.ord, s.id) AS n,
    s.id AS step, s.stage, l.depth, st.status,
    coalesce(st.proof, s.proof) AS proof, st.run, st.updated,
    (SELECT string_agg(requires || CASE WHEN kind = 'soft' THEN '~' ELSE '' END || coalesce('|' || "group", ''), ' ' ORDER BY requires) FROM need WHERE need.step = s.id) AS needs,
    CASE WHEN st.status IN ('done', 'not-needed') THEN '' WHEN coalesce(r.ok, true) THEN 'ready' ELSE 'waits' END AS next
FROM bringup_steps s JOIN bringup_stages sg ON sg.id = s.stage JOIN lvl l ON l.id = s.id JOIN st ON st.id = s.id LEFT JOIN ready r ON r.step = s.id
WHERE CASE WHEN $device IS NOT NULL AND $device NOT IN (SELECT id FROM devices) THEN error('no device ' || $device || ' (tad q coverage names them)') ELSE true END
  AND CASE WHEN $goal IS NOT NULL AND $goal NOT IN (SELECT id FROM bringup_steps) THEN error('no step ' || $goal || ' (tad q bringup-chain lists them)') ELSE true END
  AND ($goal IS NULL OR s.id IN (SELECT id FROM goal))
ORDER BY n;

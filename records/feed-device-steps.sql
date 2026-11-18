-- Feed: one device's bring-up steps, pulled from its own base (decision
-- 2026-11-18-bringup-steps-generic-in-docs-status-in-each-base), written as that device's step_status rows: one for
-- every step docs knows. Run once per device that has a base, by bin/run-feeds.sh (which falls back to
-- records/device-steps-unknown.sql when this cannot read the base).
-- --device  string                                    the device
-- --base    string                                    its base, owner/name (devices.base)
-- --root    string = https://raw.githubusercontent.com  where bases are read from: ROOT/OWNER/NAME/main/FILE (a test points it at a folder)
-- Reads ROOT/BASE/main/devicebase.toml and .../data/steps.json (JSON lines) through DuckDB; as feed-device-parts does,
-- the one line `steps = N` is taken by a regular expression over the file's text.
-- Contract: steps = 1 (step, status, proof, run, proven_on, notes, updated) - the device layer's steps table.
-- A claim counts if the base says steps = 1, its status is one of the six and its updated is a date. A claim does
-- not lapse with age: a step proven on an image stays proven for it, proven_on lets a later kernel be told from
-- it, and the runner re-proves. Anything else is unknown, with a note saying "Not known yet" and why. A step docs
-- knows that the base does not claim is unknown too. A claim of a step docs does not know is dropped, and the
-- last statement names it. A step claimed twice in the file counts once, its newest; a line that is not JSON is skipped
-- (that step reads as not claimed). The base's own record refuses a done claim without proof and run; the feed does not
-- second-guess a hand-written file. Only claims cross: never a device's queue, tries or measurements.
DELETE FROM step_status WHERE device_id = $device;
INSERT INTO step_status (device_id, step_id, status, proof, run, proven_on, notes, updated)
WITH src AS (
    SELECT
        coalesce((SELECT content FROM read_text($root || '/' || $base || '/main/devicebase.toml')), error('no devicebase.toml in ' || $base)) AS toml,
        coalesce((SELECT content FROM read_text($root || '/' || $base || '/main/data/steps.json')), error('no data/steps.json in ' || $base)) AS steps
),
contract AS (
    SELECT regexp_extract(toml, '(?m)^steps\s*=\s*(\d+)', 1) AS v FROM src
),
claimed AS (
    SELECT j->>'step' AS step, j->>'status' AS status, j->>'proof' AS proof, j->>'run' AS run, j->>'proven_on' AS proven_on,
           j->>'notes' AS notes, try_cast(j->>'updated' AS DATE) AS updated
    FROM (SELECT try_cast(line AS JSON) AS j FROM (SELECT unnest(string_split(steps, chr(10))) AS line FROM src) WHERE trim(line) <> '') l
    WHERE j IS NOT NULL AND (j->>'step') IS NOT NULL
    QUALIFY row_number() OVER (PARTITION BY j->>'step' ORDER BY try_cast(j->>'updated' AS DATE) DESC NULLS LAST) = 1
)
SELECT $device, s.id,
    CASE WHEN ok.valid THEN c.status ELSE 'unknown' END,
    CASE WHEN ok.valid THEN c.proof END,
    CASE WHEN ok.valid THEN c.run END,
    CASE WHEN ok.valid THEN c.proven_on END,
    CASE WHEN ok.valid THEN c.notes
         WHEN (SELECT v FROM contract) <> '1' THEN 'Not known yet: ' || $base || ' does not declare steps = 1 in its devicebase.toml.'
         WHEN c.step IS NULL THEN 'Not known yet: ' || $base || ' does not claim this step.'
         ELSE 'Not known yet: the base''s row for this step is not valid (status or updated).' END,
    CASE WHEN ok.valid THEN c.updated ELSE current_date END
FROM bringup_steps s
LEFT JOIN claimed c ON c.step = s.id
CROSS JOIN LATERAL (SELECT (SELECT v FROM contract) = '1' AND c.status IN ('done','partial','failing','open','not-needed','unknown')
                           AND c.updated IS NOT NULL AS valid) ok;
SELECT 'dropped: ' || $base || ' claims ' || string_agg(DISTINCT step, ', ' ORDER BY step) || ', steps docs does not know' AS said
FROM (SELECT j->>'step' AS step
      FROM (SELECT try_cast(line AS JSON) AS j
            FROM (SELECT unnest(string_split((SELECT content FROM read_text($root || '/' || $base || '/main/data/steps.json')), chr(10))) AS line) WHERE trim(line) <> '')
      WHERE j IS NOT NULL AND (j->>'step') NOT IN (SELECT id FROM bringup_steps))
HAVING count(*) > 0;

-- Feed: one device's parts, pulled from its own base (decision 2026-11-17-commons-and-device-bases), written as
-- that device's support_status rows. Run once per device that has a base, by bin/run-feeds.sh (which falls
-- back to records/device-parts-unknown.sql when this cannot read the base).
-- --device  string  the device
-- --base    string  its base, owner/name (devices.base)
-- Reads https://raw.githubusercontent.com/OWNER/NAME/main/devicebase.toml and .../data/parts.json (JSON lines)
-- through DuckDB. tad's DuckDB reads no TOML, so the one line `parts = N` is taken by a regular expression
-- over the file's text (the line at the start of a line, not in a comment) - checked against the real files.
-- Contract: parts = 1 (component, status, evidence, notes, updated, judged, measured, measured_run).
-- A part counts only if the base says parts = 1, its status is one of the five, and its updated is a date no
-- older than 30 days (decision 2026-11-17-parts-staleness-and-unknown). Anything else is unknown, with a note
-- saying "not known yet" and why. A component docs knows that the base does not claim is unknown too
-- (support-unknown's way). Parts of components docs does not know are not kept. Only parts cross: never a
-- device's queue, tries or measurements.
DELETE FROM support_status WHERE device_id = $device;
INSERT INTO support_status (device_id, component_id, status, notes, updated, judged, measured, measured_run)
WITH src AS (
    SELECT
        (SELECT content FROM read_text('https://raw.githubusercontent.com/' || $base || '/main/devicebase.toml')) AS toml,
        (SELECT content FROM read_text('https://raw.githubusercontent.com/' || $base || '/main/data/parts.json')) AS parts
),
contract AS (
    SELECT regexp_extract(toml, '(?m)^parts\s*=\s*(\d+)', 1) AS v FROM src
),
claimed AS (
    SELECT j->>'component' AS component, j->>'status' AS status, j->>'notes' AS notes,
           try_cast(j->>'updated' AS DATE) AS updated, j->>'judged' AS judged,
           j->>'measured' AS measured, j->>'measured_run' AS measured_run
    FROM (SELECT try_cast(line AS JSON) AS j FROM (SELECT unnest(string_split(parts, chr(10))) AS line FROM src) WHERE trim(line) <> '') l
    WHERE j IS NOT NULL
)
SELECT $device, c.id,
    CASE WHEN ok.fresh THEN p.status ELSE 'unknown' END,
    CASE WHEN ok.fresh THEN p.notes
         WHEN (SELECT v FROM contract) <> '1' THEN 'Not known yet: ' || $base || ' does not declare parts = 1 in its devicebase.toml.'
         WHEN p.component IS NULL THEN 'Not known yet: ' || $base || ' does not claim this part.'
         WHEN p.updated IS NULL OR p.status IS NULL OR p.status NOT IN ('works','partial','broken','unknown','not-applicable')
              THEN 'Not known yet: the base''s row for this part is not valid (status or updated).'
         ELSE 'Not known yet: the base last said ' || p.status || ' on ' || p.updated || ', more than 30 days ago.' END,
    CASE WHEN ok.fresh THEN p.updated ELSE current_date END,
    CASE WHEN ok.fresh THEN coalesce(p.judged, p.status) ELSE 'unknown' END,
    CASE WHEN ok.fresh THEN p.measured END,
    CASE WHEN ok.fresh THEN p.measured_run END
FROM components c
LEFT JOIN claimed p ON p.component = c.id
CROSS JOIN LATERAL (SELECT (SELECT v FROM contract) = '1' AND p.status IN ('works','partial','broken','unknown','not-applicable')
                           AND p.updated IS NOT NULL AND p.updated >= current_date - 30 AS fresh) ok;

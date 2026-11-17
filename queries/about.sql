-- Everything known of one subject: how it stands, what was learned and decided, the work open, how it went,
-- the tests and the sources the research cites - its whole knowledge in one read. A subject is a component, feature, milestone, device or
-- backlog item; a word before a dash names them all (modem: modem-data, modem-calls, modem-sms). Without
-- a subject: every subject records are about, and how many.
-- --subject  string?  the subject (every subject when not given)
WITH s AS (SELECT $subject AS w),
hit AS (SELECT a FROM (SELECT about AS a FROM decisions UNION SELECT about FROM research UNION SELECT about FROM backlog
            UNION SELECT about FROM session_log UNION SELECT about FROM concepts UNION SELECT component_id FROM support_status
            UNION SELECT feature_id FROM feature_support), s
        WHERE a IS NOT NULL AND (a = s.w OR a LIKE s.w || '-%')),
known AS (
    SELECT 1 AS o, 'status' AS kind, device_id AS id, s.component_id AS about, status AS state, NULL AS day, notes AS says
      FROM support_status s WHERE component_id IN (SELECT a FROM hit)
    UNION ALL SELECT 2, 'feature', platform_id, feature_id, status, checked, note
      FROM feature_support WHERE feature_id IN (SELECT a FROM hit)
    UNION ALL SELECT 3, 'research', id, about, NULL, date, question || ' - ' || found
      FROM research WHERE about IN (SELECT a FROM hit)
    UNION ALL SELECT 4, 'decision', id, about, NULL, date, decision || coalesce(' Rejected: ' || rejected, '')
      FROM decisions WHERE about IN (SELECT a FROM hit)
    UNION ALL SELECT 5, 'concept', id, about, NULL, NULL, name || ': ' || summary
      FROM concepts WHERE about IN (SELECT a FROM hit)
    UNION ALL SELECT 6, 'work', id, about, status, opened, title || coalesce(' - ' || note, '') || coalesce(' Waits: ' || waits, '')
      FROM backlog WHERE status <> 'done' AND (about IN (SELECT a FROM hit) OR id IN (SELECT a FROM hit))
    UNION ALL SELECT 7, 'log', id, about, NULL, entry_date, title || ' - ' || done
      FROM session_log WHERE about IN (SELECT a FROM hit)
    UNION ALL SELECT 8, 'test', id, component_id, proves, NULL, says
      FROM tests WHERE component_id IN (SELECT a FROM hit)
    UNION ALL SELECT DISTINCT 9, 'source', id, NULL, NULL, NULL, title || ' <' || url || '>'
      FROM sources WHERE id IN (SELECT trim(unnest(string_split(sources, ','))) FROM research WHERE about IN (SELECT a FROM hit))
)
SELECT kind, id, about, state, day, says FROM (
SELECT o, kind, id, about, state, day, says FROM known, s WHERE s.w IS NOT NULL
UNION ALL
SELECT 10, 'subject', a, NULL, NULL, NULL, count(*)::VARCHAR || ' records' FROM (
    SELECT about AS a FROM decisions UNION ALL SELECT about FROM research UNION ALL SELECT about FROM backlog
    UNION ALL SELECT about FROM session_log UNION ALL SELECT about FROM concepts), s
WHERE s.w IS NULL AND a IS NOT NULL GROUP BY a
) ORDER BY o, day DESC NULLS LAST, id;

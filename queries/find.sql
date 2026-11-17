-- Where something is said: the id and first words of every record that says it, in any case, the latest
-- first. Then row --id ID for the one wanted, whole.
-- --text  string  the words, as they stand
WITH t AS (SELECT lower($text) AS w),
said AS (
    SELECT 'decision' AS kind, id, about, date AS day, decision AS line, concat_ws(' ', id, decision, why, rejected) AS hay FROM decisions
    UNION ALL SELECT 'research', id, about, date, question, concat_ws(' ', id, question, found) FROM research
    UNION ALL SELECT 'work', id, about, opened, title, concat_ws(' ', id, title, note, waits) FROM backlog
    UNION ALL SELECT 'log', id, about, entry_date, title, concat_ws(' ', id, title, done, considered, rejected) FROM session_log
    UNION ALL SELECT 'summary', about, about, date, says, concat_ws(' ', about, says) FROM summaries
    UNION ALL SELECT 'source', id, NULL, NULL, title, concat_ws(' ', id, title, url, takes) FROM sources
)
SELECT kind, id, about, day, left(line, 100) AS line FROM said, t
WHERE contains(lower(hay), t.w) ORDER BY day DESC NULLS LAST, kind, id;

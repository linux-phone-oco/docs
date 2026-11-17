-- What was recorded lately, the newest first: decisions, research, work opened and the log, each by its
-- id and first words. Then row --id ID for one whole.
-- --days  integer = 7  how many days back
SELECT kind, id, about, day, left(line, 100) AS line FROM (
    SELECT 'decision' AS kind, id, about, date AS day, decision AS line FROM decisions
    UNION ALL SELECT 'research', id, about, date, question FROM research
    UNION ALL SELECT 'work', id, about, opened, title FROM backlog
    UNION ALL SELECT 'log', id, about, entry_date, title FROM session_log
) WHERE day >= current_date - $days ORDER BY day DESC, kind, id;

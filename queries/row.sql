-- One record whole, by its id, from whichever standing table holds it: every field, as JSON.
-- --id  string  the record's id (find, next, recent and about name them)
SELECT 'decisions' AS "table", to_json(r) AS "row" FROM decisions r WHERE id = $id
UNION ALL SELECT 'research', to_json(r) FROM research r WHERE id = $id
UNION ALL SELECT 'backlog', to_json(r) FROM backlog r WHERE id = $id
UNION ALL SELECT 'session_log', to_json(r) FROM session_log r WHERE id = $id
UNION ALL SELECT 'sources', to_json(r) FROM sources r WHERE id = $id;

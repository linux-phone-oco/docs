-- The decisions of one place or of all, the latest first.
-- --project  string?  the place (all when not given)
-- --since    date?    on or after
SELECT project, id, date, decision, rejected FROM decisions
WHERE ($project IS NULL OR project = 'linux-phone-oco/' || $project) AND ($since IS NULL OR date >= $since)
ORDER BY date DESC, id;

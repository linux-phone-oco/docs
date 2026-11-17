-- What was learned, by one place or by all, the latest first.
-- --project  string?  the place (all when not given)
SELECT project, id, date, question, found FROM research
WHERE $project IS NULL OR project = 'linux-phone-oco/' || $project ORDER BY date DESC NULLS LAST, id;

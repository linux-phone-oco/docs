-- The work ahead: every item not done, of one place or of all, the one in progress first.
-- --project  string?  the place (all when not given)
SELECT project, id, status, title, note, waits FROM backlog
WHERE status <> 'done' AND ($project IS NULL OR project = 'linux-phone-oco/' || $project)
ORDER BY status = 'open', project, opened, id;

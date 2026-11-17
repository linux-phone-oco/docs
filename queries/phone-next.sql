-- What the phone's keeper takes now: the top row of phone-queue that waits on nothing, in one row - the
-- item, the test that proves it, what it is about and its note - so a keeper's start asks once.
-- --project  string?  the place (all when not given)
SELECT project, id, status, title, coalesce(proof, '') AS proof, coalesce(about, '') AS about, note
FROM backlog
WHERE needs = 'phone' AND status <> 'done' AND waits IS NULL
  AND ($project IS NULL OR project = 'linux-phone-oco/' || $project)
ORDER BY status <> 'in-progress', rank IS NULL, rank, proof IS NULL, opened, project, id
LIMIT 1;

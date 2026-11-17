-- What a phone's keeper takes now: the top item of its device's phone queue that waits on nothing, in one row
-- (lane-next --needs phone) - the item, the test that proves it, what it is about and its note.
-- --device  string   the device, a devices id (xiaomi-surya, google-walleye): each phone has its own keeper
SELECT project, id, status, title, coalesce(proof, '') AS proof, coalesce(about, '') AS about, note
FROM backlog
WHERE device = $device AND needs = 'phone' AND status <> 'done' AND waits IS NULL
ORDER BY status <> 'in-progress', rank IS NULL, rank, proof IS NULL, opened, project, id
LIMIT 1;

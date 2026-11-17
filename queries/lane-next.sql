-- What a lane takes next of one kind: the top item for one device that needs the phone (its keeper), research
-- or a build (its launchers), and waits on nothing - in progress first, then the author's order (rank), then
-- what names the test that proves it, then the oldest - in one row, so a start asks once.
-- --device  string   the device, a devices id (xiaomi-surya, google-walleye)
-- --needs   string   phone, research or build
SELECT project, id, status, title, coalesce(proof, '') AS proof, coalesce(about, '') AS about, note
FROM backlog
WHERE device = $device AND needs = $needs AND status <> 'done' AND waits IS NULL
ORDER BY status <> 'in-progress', rank IS NULL, rank, proof IS NULL, opened, project, id
LIMIT 1;

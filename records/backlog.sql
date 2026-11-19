-- An item of work ahead of a place, or done (an item of that id is replaced).
-- --project  string        the place: docs, lab-tools, surya-lab, device-template, sxmo-deviceprofiles
-- --id       string        a-short-name
-- --title    string        what it is
-- --status   string = open  open, in-progress or done
-- --note     string?       where it stands, and the next step
-- --waits    string?       what it waits on that is outside this base (the author, a SIM card); never an item: blocked-by
-- --blocked-by  string?     the items of this base it waits on, ids comma-separated: it is clear once each is done
-- --about    string?       what it is about: a component, feature, milestone, device or backlog item (tad q about lists them)
-- --opened   date = today  when it was opened
-- --needs    string?       phone, research or build: the lane's queue of that kind (tad q lane-next --device D --needs N)
-- --device   string?       the device it is for, a devices id (xiaomi-surya, google-walleye); required with needs
-- --proof    string?       the test whose pass proves it done (a tests id, or the test still to write)
SELECT CASE WHEN $blocked_by IS NOT NULL AND EXISTS (SELECT 1 FROM unnest(string_split($blocked_by, ',')) AS t(x) WHERE trim(t.x) NOT IN (SELECT id FROM backlog))
    THEN error('blocked-by names no item of this base: ' || (SELECT string_agg(trim(t.x), ', ') FROM unnest(string_split($blocked_by, ',')) AS t(x) WHERE trim(t.x) NOT IN (SELECT id FROM backlog))) END;
SELECT CASE WHEN $needs IS NOT NULL AND $device IS NULL
    THEN error('an item that needs ' || $needs || ' names its device: --device xiaomi-surya or google-walleye') END;
SELECT CASE WHEN $status = 'dropped' AND $note IS NULL THEN error('a dropped item needs its note: why it was dropped, and whose word') END;
DELETE FROM backlog WHERE project = 'linux-phone-oco/' || $project AND id = $id;
INSERT INTO backlog (project, id, title, status, note, opened, waits, blocked_by, needs, device, proof, about)
VALUES ('linux-phone-oco/' || $project, $id, $title, $status, $note, $opened, $waits, $blocked_by, $needs, $device, $proof, $about);

-- An item of work ahead of a place, or done (an item of that id is replaced).
-- --project  string        the place: docs, lab-tools, surya-lab, device-template, sxmo-deviceprofiles
-- --id       string        a-short-name
-- --title    string        what it is
-- --status   string = open  open, in-progress or done
-- --note     string?       where it stands, and the next step
-- --waits    string?       what it waits on, if anything (the author, a SIM card)
-- --about    string?       what it is about: a component, feature, milestone, device or backlog item (tad q about lists them)
-- --opened   date = today  when it was opened
-- --needs    string?       phone, research or build: the lane's queue of that kind (tad q lane-next --device D --needs N)
-- --device   string?       the device it is for, a devices id (xiaomi-surya, google-walleye); required with needs
-- --proof    string?       the test whose pass proves it done (a tests id, or the test still to write)
SELECT CASE WHEN $needs IS NOT NULL AND $device IS NULL
    THEN error('an item that needs ' || $needs || ' names its device: --device xiaomi-surya or google-walleye') END;
DELETE FROM backlog WHERE project = 'linux-phone-oco/' || $project AND id = $id;
INSERT INTO backlog (project, id, title, status, note, opened, waits, needs, device, proof, about)
VALUES ('linux-phone-oco/' || $project, $id, $title, $status, $note, $opened, $waits, $needs, $device, $proof, $about);

-- An item of work ahead of a place, or done (an item of that id is replaced).
-- --project  string        the place: docs, lab-tools, surya-lab, device-template, sxmo-deviceprofiles
-- --id       string        a-short-name
-- --title    string        what it is
-- --status   string = open  open, in-progress or done
-- --note     string?       where it stands, and the next step
-- --waits    string?       what it waits on, if anything (the author, a SIM card)
-- --opened   date = today  when it was opened
DELETE FROM backlog WHERE project = 'linux-phone-oco/' || $project AND id = $id;
INSERT INTO backlog (project, id, title, status, note, opened, waits)
VALUES ('linux-phone-oco/' || $project, $id, $title, $status, $note, $opened, $waits);

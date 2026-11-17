-- An idea a piece of work rests on (a concept of that id is replaced).
-- --project  string   the place
-- --id       string   a-short-name
-- --name     string   its name
-- --summary  string   what it is
-- --why      string?  why it holds
DELETE FROM concepts WHERE project = 'linux-phone-oco/' || $project AND id = $id;
INSERT INTO concepts (id, project, name, summary, why) VALUES ($id, 'linux-phone-oco/' || $project, $name, $summary, $why);

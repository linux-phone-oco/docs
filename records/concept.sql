-- An idea a piece of work rests on (a concept of that id is replaced).
-- --project  string   the place
-- --id       string   a-short-name
-- --name     string   its name
-- --summary  string   what it is
-- --why      string?  why it holds
-- --about    string?       what it is about: a component, feature, milestone, device or backlog item (tad q about lists them)
DELETE FROM concepts WHERE project = 'linux-phone-oco/' || $project AND id = $id;
INSERT INTO concepts (id, project, name, summary, why, about) VALUES ($id, 'linux-phone-oco/' || $project, $name, $summary, $why, $about);

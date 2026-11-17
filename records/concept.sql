-- An idea a piece of work rests on (a concept of that id is replaced). With --ord it is a principle of the
-- project: a small numbered set that briefs and guides cite by id and never restate (tad q principles).
-- --project   string   the place
-- --id        string   a-short-name
-- --name      string   its name
-- --summary   string   what it is
-- --why       string?  why it holds
-- --about     string?  what it is about: a component, feature, milestone, device or backlog item (tad q about lists them)
-- --ord       integer? 1, 2, ...: a principle, in the order it is listed
-- --rests-on  string?  the ideal-agent practice it rests on, by number (cited, not repeated)
DELETE FROM concepts WHERE project = 'linux-phone-oco/' || $project AND id = $id;
INSERT INTO concepts (id, project, name, summary, why, about, ord, rests_on) VALUES ($id, 'linux-phone-oco/' || $project, $name, $summary, $why, $about, $ord, $rests_on);

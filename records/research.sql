-- What was learned, and from where (a research of that id is replaced).
-- --project   string        the place
-- --id        string        a-short-name
-- --question  string        what was asked
-- --found     string        what was found
-- --sources   string?       the sources' ids, comma-separated
-- --about    string?       what it is about: a component, feature, milestone, device or backlog item (tad q about lists them)
-- --date      date = today  when
DELETE FROM research WHERE project = 'linux-phone-oco/' || $project AND id = $id;
INSERT INTO research (id, project, date, question, found, sources, about)
VALUES ($id, 'linux-phone-oco/' || $project, $date, $question, $found, $sources, $about);

-- What was learned, and from where (a research of that id is replaced). Its finding is the row; its own
-- material - notes, excerpts, measurements - goes in a dated folder the row names, read only when needed.
-- Research redone is a new row that supersedes the old: the old stays, reachable, and leaves about's answer.
-- --project     string        the place
-- --id          string        a-short-name
-- --question    string        what was asked
-- --found       string        what was found, condensed
-- --sources     string?       the sources' ids, comma-separated
-- --about       string?       what it is about: a component, feature, milestone, device or backlog item (tad q about lists them)
-- --material    string?       its folder, research/SUBJECT/YYYY-MM-DD/
-- --supersedes  string?       the research it is a later version of (its id)
-- --date        date = today  when
DELETE FROM research WHERE project = 'linux-phone-oco/' || $project AND id = $id;
INSERT INTO research (id, project, date, question, found, sources, about, material, supersedes)
VALUES ($id, 'linux-phone-oco/' || $project, $date, $question, $found, $sources, $about, $material, $supersedes);

-- A source research and decisions cite (a source of that id is replaced).
-- --project  string    the place
-- --id       string    a-short-name
-- --title    string    its title
-- --url      string    https://...
-- --author   string?   who wrote it
-- --year     integer?  when
-- --by       string?   who made what it describes
-- --takes    string?   what we take from it
DELETE FROM sources WHERE project = 'linux-phone-oco/' || $project AND id = $id;
INSERT INTO sources (project, id, title, url, author, year, by, takes)
VALUES ('linux-phone-oco/' || $project, $id, $title, $url, $author, $year, $by, $takes);

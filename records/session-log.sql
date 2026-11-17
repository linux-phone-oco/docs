-- How a stretch of work went: what was done, considered and rejected (an entry of that id is replaced).
-- --project     string        the place
-- --id          string        YYYY-MM-DD-what
-- --title       string        in a few words
-- --done        string        what was done
-- --considered  string?       what was considered
-- --rejected    string?       what was rejected, and why
-- --date        date = today  when
DELETE FROM session_log WHERE project = 'linux-phone-oco/' || $project AND id = $id;
INSERT INTO session_log (project, id, entry_date, title, done, considered, rejected)
VALUES ('linux-phone-oco/' || $project, $id, $date, $title, $done, $considered, $rejected);

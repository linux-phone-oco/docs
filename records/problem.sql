-- A sign seen: something that does not fit the whole - stale, overlapping, lacking or unclear (a sign of that id
-- is replaced). Answered by refining the whole; when it is, say so with --handled.
-- --project         string        the place it is seen in
-- --id              string        a-short-name
-- --what            string        what is seen
-- --kind            string        stale, overlapping, lacking or unclear
-- --by              string        who saw it (patrol, bring-up, ...)
-- --seen            date = today  when
-- --countermeasure  string?       how the whole was refined
-- --handled         date?         when it was
DELETE FROM problems WHERE project = 'linux-phone-oco/' || $project AND id = $id;
INSERT INTO problems (id, project, what, seen, by, countermeasure, handled, kind)
VALUES ($id, 'linux-phone-oco/' || $project, $what, $seen, $by, $countermeasure, $handled, $kind);

-- Where an item of work stands now: its status, and its note when one is given (the rest is kept).
-- --project  string   the place
-- --id       string   the item
-- --status   string   open, in-progress or done
-- --note     string?  where it stands, and the next step (kept as it was when not given)
UPDATE backlog SET status = $status, note = coalesce($note, note)
WHERE project = 'linux-phone-oco/' || $project AND id = $id;

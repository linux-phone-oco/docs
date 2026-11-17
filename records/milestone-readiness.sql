-- How ready a milestone is now: its rung, 1 to 9.
-- --project    string   the place
-- --id         string   the milestone
-- --readiness  integer  1 to 9
UPDATE milestones SET readiness = $readiness WHERE project = 'linux-phone-oco/' || $project AND id = $id;

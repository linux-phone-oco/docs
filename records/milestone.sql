-- A milestone: a rung of a subject's road, named by what has to work (a milestone of that place and id is replaced).
-- Criteria are terms separated by spaces: feature:ID@platform, component:ID@platform, and step:ID@DEVICE - a bring-up
-- step on a device, read from the device's own base's claim (tad q milestone-steps).
-- --project    string  the place
-- --id         string  a-short-name
-- --subject    string  what it is a rung of: linux-phones, a device ...
-- --ord        integer its place on the road
-- --title      string  what it is called
-- --horizon    string  working, perfection or ongoing
-- --readiness  integer how ready now, 1 to 9 (milestone-readiness moves it later)
-- --criteria   string  the terms
-- --why        string  why it is a milestone
DELETE FROM milestones WHERE project = 'linux-phone-oco/' || $project AND id = $id;
INSERT INTO milestones (project, id, subject, ord, title, horizon, readiness, criteria, why)
VALUES ('linux-phone-oco/' || $project, $id, $subject, $ord, $title, $horizon, $readiness, $criteria, $why);

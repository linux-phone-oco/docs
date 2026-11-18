-- A phase of bringing Linux up on a machine, in the order one meets them: a chapter of the guidebook (a stage of
-- that id is replaced). The list is data, so it changes with this record: a stage added, split, renamed or moved
-- (its ord), with no schema change. A step names its stage (bringup-step --stage).
-- --id     string   a-short-name: prepare, boot, console ...
-- --ord    integer  its place among the stages: the order of the chapters (a tie goes by id)
-- --title  string   the chapter's name
-- --what   string   what the stage is for, in a line or two
DELETE FROM bringup_stages WHERE id = $id;
INSERT INTO bringup_stages (id, ord, title, what) VALUES ($id, $ord, $title, $what);

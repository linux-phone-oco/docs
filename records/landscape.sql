-- A project or effort of the world that we read, take from or stand beside: what it is and what it is for us (a row
-- of that id is replaced). The landscape is the map of others' work; a document of theirs we cite is a source, a
-- question we answered from them is a research.
-- --id        string        a-short-name: ubports-devices, halium, android-cts ...
-- --name      string        its name
-- --effort    string        the project or effort it belongs to (the landscape's project column): UBports, postmarketOS ...
-- --what      string        what it is, in a line or two
-- --for-us    string        what it is for us: what we take, what we leave, what it changes of our work
-- --link      string        https://...
-- --checked   date = today  when it was last looked at
DELETE FROM landscape WHERE id = $id;
INSERT INTO landscape (id, name, project, what, for_us, link, checked)
VALUES ($id, $name, $effort, $what, $for_us, $link, $checked);

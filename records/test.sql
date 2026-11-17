-- A test the phone's health suite makes, and what its pass proves (a test of that id is replaced).
-- --id         string  the check's name, as the suite says it
-- --component  string  the part it is about (a components id)
-- --proves     string  present (the part is there) or works (it does its work)
-- --says       string  what a pass says, in a sentence
DELETE FROM tests WHERE id = $id;
INSERT INTO tests (id, component_id, proves, says)
VALUES ($id, $component, $proves, $says);

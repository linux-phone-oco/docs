-- A decision of a place of linux-phone-oco, with what was rejected (a decision of that id is replaced).
-- --project   string        the place: docs, lab-tools, surya-lab, device-template, sxmo-deviceprofiles
-- --id        string        YYYY-MM-DD-what-was-decided
-- --decision  string        what was decided
-- --why       string        why: the evidence, the author's words
-- --rejected  string?       what was weighed and not chosen, and why not
-- --about     string?       the thing it is about (a backlog item, a component)
-- --research  string?       the research it rests on (its id)
-- --date      date = today  when
DELETE FROM decisions WHERE project = 'linux-phone-oco/' || $project AND id = $id;
INSERT INTO decisions (id, project, date, decision, why, rejected, about, research)
VALUES ($id, 'linux-phone-oco/' || $project, $date, $decision, $why, $rejected, $about, $research);

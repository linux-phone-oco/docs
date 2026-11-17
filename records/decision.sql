-- A decision of a place of linux-phone-oco, with what was rejected (a decision of that id is replaced).
-- --project   string        the place: docs, lab-tools, surya-lab, device-template, sxmo-deviceprofiles
-- --id        string        YYYY-MM-DD-what-was-decided
-- --brief     string        the decision in one line, at most 200 characters: what answers show
-- --decision  string        what was decided
-- --why       string        why: the evidence, the author's words
-- --rejected  string?       what was weighed and not chosen, and why not
-- --about     string?       what it is about: a component, feature, milestone, device or backlog item (tad q about lists them)
-- --research  string?       the research it rests on (its id)
-- --date      date = today  when
DELETE FROM decisions WHERE project = 'linux-phone-oco/' || $project AND id = $id;
INSERT INTO decisions (id, project, date, brief, decision, why, rejected, about, research)
SELECT $id, 'linux-phone-oco/' || $project, $date, $brief, $decision, $why, $rejected, $about, $research
WHERE CASE WHEN length($brief) > 200 THEN error('the brief is ' || length($brief) || ' characters; at most 200') ELSE true END;

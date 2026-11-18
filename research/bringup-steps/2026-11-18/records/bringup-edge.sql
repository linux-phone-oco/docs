-- What a step needs before it (an edge of that pair is replaced). hard: it cannot be done first; soft: it can,
-- but blind or at much greater cost. Edges of one step sharing a group are alternatives: one done is enough.
-- --step      string   the step
-- --requires  string   the step it needs
-- --kind      string   hard or soft
-- --group     string?  the alternatives it is one of (console: UART or the USB gadget)
-- --why       string   why, in a line - the record that showed it, when one did
SELECT CASE WHEN $step = $requires THEN error('a step cannot require itself') END;
SELECT CASE WHEN EXISTS (
    WITH RECURSIVE up(id) AS (SELECT $requires UNION SELECT e.requires FROM bringup_step_edges e JOIN up ON e.step = up.id)
    SELECT 1 FROM up WHERE id = $step) THEN error('this edge makes a cycle: ' || $requires || ' already needs ' || $step) END;
DELETE FROM bringup_step_edges WHERE step = $step AND requires = $requires;
INSERT INTO bringup_step_edges (step, requires, kind, "group", why) VALUES ($step, $requires, $kind, $group, $why);

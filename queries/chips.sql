-- The chips: one row per part number, about the part whatever product carries it - what it is, how far its driver
-- has got (mainline, in-review, fork, downstream, none), its compatible, the boards met carrying it and the steps
-- of its procedure; the furthest from mainline first. Then row --id ID for one whole, about --subject ID for all
-- that is known of it (its research, decisions, work).
-- --kind   string?  only this kind (audio-amp, haptics, display-panel, storage, pmic ...)
-- --stage  string?  only this driver stage (mainline, in-review, fork, downstream, none)
-- --board  string?  only the chips a board is known to carry (a word of its boards: google-walleye)
SELECT id, part, maker, kind, driver_stage, coalesce(compatible, '') AS compatible, coalesce(steps, '') AS steps,
       coalesce(boards, '') AS boards, (current_date - checked_on) AS checked_days_ago
FROM chips
WHERE ($kind IS NULL OR kind = $kind) AND ($stage IS NULL OR driver_stage = $stage)
  AND ($board IS NULL OR boards LIKE '%' || $board || '%')
ORDER BY CASE driver_stage WHEN 'none' THEN 0 WHEN 'downstream' THEN 1 WHEN 'fork' THEN 2 WHEN 'in-review' THEN 3 ELSE 4 END, id;

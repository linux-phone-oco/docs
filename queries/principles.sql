-- The principles of linux-phone-oco, in order: what every brief and guide cites by id and never restates -
-- each with the general practice it rests on, and how many records name it in about (decisions, research,
-- work, log). The ids are anchors on concepts.md.
SELECT c.ord, c.id, c.name, c.summary, coalesce(c.rests_on, '') AS rests_on,
       (SELECT count(*) FROM decisions d WHERE d.about = c.id) + (SELECT count(*) FROM research r WHERE r.about = c.id)
       + (SELECT count(*) FROM backlog b WHERE b.about = c.id) + (SELECT count(*) FROM session_log s WHERE s.about = c.id) AS records
FROM concepts c WHERE c.ord IS NOT NULL ORDER BY c.ord;

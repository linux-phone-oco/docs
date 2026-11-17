-- How the phone stands: the latest hand-over its keeper left (a session_log entry of surya-lab whose id ends
-- in -how-the-phone-stands), for the next keeper to start from. Written with:
--   tad r session-log --project surya-lab --id YYYY-MM-DD-HHMM-how-the-phone-stands --title "How the phone stands" --done "..."
SELECT id, entry_date, done AS how_it_stands, coalesce(considered, '') AS next_steps
FROM session_log
WHERE project = 'linux-phone-oco/surya-lab' AND id LIKE '%-how-the-phone-stands'
ORDER BY id DESC LIMIT 1;

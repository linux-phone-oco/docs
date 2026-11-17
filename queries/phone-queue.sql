-- The phone's queue: the work that cannot be done without the phone, in the order its keeper takes it up -
-- what is in progress first, then what nothing outside holds back (waits empty), then what already names the
-- test that proves it, then the oldest. One change to the phone at a time (devlab holds it); research and
-- other sessions put work here (tad r backlog-needs ... --needs phone --proof TEST), never on the phone.
-- (Ordered by the weakest link once each item says what it is about: idealkb's about link, proposed.)
-- --project  string?  the place (all when not given)
SELECT project, id, status, title, coalesce(proof, '') AS proof, coalesce(waits, '') AS waits, note
FROM backlog
WHERE needs = 'phone' AND status <> 'done' AND ($project IS NULL OR project = 'linux-phone-oco/' || $project)
ORDER BY status <> 'in-progress', waits IS NOT NULL, proof IS NULL, opened, project, id;

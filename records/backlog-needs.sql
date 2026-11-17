-- Put an item of work on a shared resource's queue (needs phone: the phone keeper's, tad q phone-queue), with the
-- test whose pass proves it done; or take it off (--needs not given). The rest of the item is kept.
-- --project  string   the place
-- --id       string   the item
-- --needs    string?  phone (not given: it needs nothing shared)
-- --proof    string?  the test whose pass proves it done (kept as it was when not given)
-- --rank     integer? where it stands in the queue, by the author's order: 1 first (kept as it was when not given)
UPDATE backlog SET needs = $needs, proof = coalesce($proof, proof), rank = coalesce($rank, rank)
WHERE project = 'linux-phone-oco/' || $project AND id = $id;

-- Put an item of work on a lane's queue - what it needs (phone: the device's keeper; research or build: the
-- lane's launcher) and the device it is for - with the test whose pass proves it done; or take it off
-- (--needs not given). The rest of the item is kept. A phone item names its device, or nothing is written.
-- --project  string   the place
-- --id       string   the item
-- --needs    string?  phone, research or build (not given: it needs nothing shared)
-- --device   string?  the device it is for, a devices id (xiaomi-surya, google-walleye); required with phone
-- --proof    string?  the test whose pass proves it done (kept as it was when not given)
-- --rank     integer? where it stands in the queue, by the author's order: 1 first (kept as it was when not given)
SELECT CASE WHEN $needs IS NOT NULL AND $device IS NULL
    AND (SELECT device FROM backlog WHERE project = 'linux-phone-oco/' || $project AND id = $id) IS NULL
    THEN error('an item that needs ' || $needs || ' names its device: --device xiaomi-surya or google-walleye') END;
UPDATE backlog SET needs = $needs, device = coalesce($device, device), proof = coalesce($proof, proof),
    rank = coalesce($rank, rank)
WHERE project = 'linux-phone-oco/' || $project AND id = $id;

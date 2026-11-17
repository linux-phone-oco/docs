-- Names a phone's own base: the lab repository (owner/name) docs pulls its parts from (records/feed-device-parts.sql);
-- null takes the name away, and the phone's status is derived here again.
-- --device  string   the device
-- --base    string?  owner/name of its lab repository
UPDATE devices SET base = $base WHERE id = $device;

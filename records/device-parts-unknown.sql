-- A device whose base cannot be read: every component of it is unknown, "not known yet", and says why. Run
-- by bin/run-feeds.sh when records/feed-device-parts.sql fails for the device (the base or its files do not
-- answer): a missing base shows as not known yet, never as broken.
-- --device  string  the device
-- --why     string  why the base could not be read
DELETE FROM support_status WHERE device_id = $device;
INSERT INTO support_status (device_id, component_id, status, notes, updated, judged)
SELECT $device, id, 'unknown', 'Not known yet: the base could not be read (' || $why || ').', current_date, 'unknown' FROM components;

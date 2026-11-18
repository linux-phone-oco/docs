-- A device whose base cannot be read: every step of it is unknown, "not known yet", and says why. Run by
-- bin/run-feeds.sh when records/feed-device-steps.sql fails for the device (the base or its files do not answer):
-- a missing base shows as not known yet, never as failing.
-- --device  string  the device
-- --why     string  why the base could not be read
DELETE FROM step_status WHERE device_id = $device;
INSERT INTO step_status (device_id, step_id, status, notes, updated)
SELECT $device, id, 'unknown', 'Not known yet: the base could not be read (' || $why || ').', current_date FROM bringup_steps;

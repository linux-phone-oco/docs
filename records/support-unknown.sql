-- A part of a phone nobody here has measured: its status is unknown, and its notes say what was reported
-- by whom (a community claim is not a measurement) and what would settle it. A row of that device and part
-- is replaced; derive-support-status keeps it unknown until the phone's own tests measure it.
-- --device     string       the device
-- --component  string       the part (a component)
-- --notes      string       the reports, with their source and date, and what would settle it
-- --updated    date = today when
DELETE FROM support_status WHERE device_id = $device AND component_id = $component;
INSERT INTO support_status (device_id, component_id, status, notes, updated, judged)
VALUES ($device, $component, 'unknown', $notes, $updated, 'unknown');

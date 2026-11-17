-- A source a device's page cites (the source is a row of sources; see the source record).
-- --device  string  the device
-- --source  string  the source's id
DELETE FROM device_sources WHERE device_id = $device AND source_id = $source;
INSERT INTO device_sources (device_id, source_id) VALUES ($device, $source);

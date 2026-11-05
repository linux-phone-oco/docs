-- Every citation in device_sources names a real device and a real source.
SELECT 'device_id' AS end_, device_id AS missing_id FROM device_sources WHERE device_id NOT IN (SELECT id FROM devices)
UNION ALL
SELECT 'source_id', source_id FROM device_sources WHERE source_id NOT IN (SELECT id FROM sources);

-- Every row of the status matrix names a real device and a real component (no foreign keys, so
-- this is how that integrity is kept; see AGENTS.md).
SELECT 'device_id' AS end_, device_id AS missing_id FROM support_status WHERE device_id NOT IN (SELECT id FROM devices)
UNION ALL
SELECT 'component_id', component_id FROM support_status WHERE component_id NOT IN (SELECT id FROM components);

-- Feed: the postmarketOS wiki's own status fields for each device, as claims beside our evidence.
-- The wiki is the source: its current claims replace the previous ones, and the history says when a
-- claim changed - no date column, so an unchanged wiki changes nothing here. Run by make feeds: tad r feed-wiki-claims (bin/run-feeds.sh runs every record named feed-*).
DELETE FROM wiki_claims;
INSERT INTO wiki_claims
WITH page AS (
  SELECT parse.wikitext AS w
  FROM read_json('https://wiki.nura.eco/api.php?action=parse&prop=wikitext&format=json&formatversion=2&page=Xiaomi_POCO_X3_NFC_(xiaomi-surya)')
),
claims AS (
  SELECT unnest(regexp_extract_all(w, '\| status_([a-z]+) = ([YPN])', 1)) AS field,
         unnest(regexp_extract_all(w, '\| status_([a-z]+) = ([YPN])', 2)) AS v
  FROM page
),
fields(field, component_id) AS (VALUES
  ('audio', 'audio-speaker'), ('camera', 'camera-front'), ('camera', 'camera-rear'), ('screen', 'display-panel'),
  ('touch', 'touchscreen'), ('haptics', 'haptics'), ('mobiledata', 'modem-data'), ('calls', 'modem-calls'),
  ('sms', 'modem-sms'), ('wifi', 'wifi'), ('bluetooth', 'bluetooth'), ('nfc', 'nfc'), ('fingerprint', 'fingerprint'),
  ('accel', 'sensors'), ('otg', 'usb-otg'), ('flashing', 'fastboot'))
SELECT 'xiaomi-surya', f.component_id,
       CASE c.v WHEN 'Y' THEN 'works' WHEN 'P' THEN 'partial' ELSE 'broken' END,
       'status_' || c.field,
       '[postmarketOS wiki](https://wiki.nura.eco/wiki/Xiaomi_POCO_X3_NFC_%28xiaomi-surya%29)'
FROM claims c JOIN fields f USING (field);

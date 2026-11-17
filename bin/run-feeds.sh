#!/bin/sh
# Runs every feed: each is a named record, records/feed-*.sql, that fetches public data and reshapes it
# with SQL in the DuckDB tad installs for itself (pinned, its fingerprint checked: tad engine). tad keeps
# what a feed writes only if every rule of tables.toml still holds, in canonical form.
#
# feed-device-parts is run once for each device that has a base (devices.base): it pulls that device's
# parts. When the base cannot be read (the repository or its files do not answer, a line is not JSON), the
# device's parts become unknown, "not known yet", with the reason (records/device-parts-unknown.sql): a
# base that is down never shows as broken, and never stops the other feeds.
set -eu
tad=${TAD:-tad}
for name in $("$tad" statements records | grep '^feed-' | grep -v '^feed-device-parts$'); do
	echo "== $name"
	"$tad" record "$name"
done
jq -r 'select(.base != null) | .id + " " + .base' data/devices.json | while read -r device base; do
	echo "== feed-device-parts $device ($base)"
	if ! err=$("$tad" record feed-device-parts --device "$device" --base "$base" 2>&1); then
		why=$(printf '%s' "$err" | head -n 1 | cut -c1-200 | tr "'" ' ')
		echo "   cannot read $base: $why"
		"$tad" record device-parts-unknown --device "$device" --why "$base: $why"
	fi
done
"$tad" canon && "$tad" check

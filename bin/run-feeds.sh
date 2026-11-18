#!/bin/sh
# Runs every feed: each is a named record, records/feed-*.sql, that fetches public data and reshapes it
# with SQL in the DuckDB tad installs for itself (pinned, its fingerprint checked: tad engine). tad keeps
# what a feed writes only if every rule of tables.toml still holds, in canonical form.
#
# feed-device-parts and feed-device-steps are run once for each device that has a base (devices.base): they pull
# that device's parts and its bring-up step claims. When the base cannot be read (the repository or its files do
# not answer), the device's parts, or its steps, become unknown, "not known yet", with the
# reason (records/device-parts-unknown.sql, records/device-steps-unknown.sql): a base that is down never shows as
# broken or failing, and never stops the other feeds.
set -eu
tad=${TAD:-tad}
for name in $("$tad" statements records | grep '^feed-' | grep -v '^feed-device-'); do
	echo "== $name"
	"$tad" record "$name"
done
jq -r 'select(.base != null) | .id + " " + .base' data/devices.json | while read -r device base; do
	for feed in parts steps; do
		echo "== feed-device-$feed $device ($base)"
		if ! err=$("$tad" record "feed-device-$feed" --device "$device" --base "$base" 2>&1 < /dev/null); then
			why=$(printf '%s' "$err" | head -n 1 | cut -c1-200 | tr "'" ' ')
			echo "   cannot read $base: $why"
			"$tad" record "device-$feed-unknown" --device "$device" --why "$base: $why" < /dev/null
		else
			printf '%s\n' "$err"
		fi
	done
done
"$tad" canon && "$tad" check

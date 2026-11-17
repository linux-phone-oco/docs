#!/bin/sh
# Runs every feed: each is a named record, records/feed-*.sql, that fetches public data and reshapes it
# with SQL in the DuckDB tad installs for itself (pinned, its fingerprint checked: tad engine). tad keeps
# what a feed writes only if every rule of tables.toml still holds, in canonical form.
set -eu
tad=${TAD:-tad}
for name in $("$tad" statements records | grep '^feed-'); do
	echo "== $name"
	"$tad" record "$name"
done
"$tad" canon && "$tad" check

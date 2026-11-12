#!/bin/sh
# Runs every feed in feeds/*.sql. Each fetches public data and reshapes it with SQL, run by the DuckDB
# that tad installs for itself (pinned, its fingerprint checked: tad engine); DuckDB writes the rows,
# then tad canonicalizes and checks them, so a feed cannot write what tables.toml does not allow.
# A feed named x-y.sql fills the table x_y.
set -eu
duckdb=$(${TAD:-tad} engine | awk '{print $NF}')
[ -x "$duckdb" ] || { echo "run-feeds: tad's engine is not installed" >&2; exit 1; }
for f in feeds/*.sql; do
	t=$(basename "$f" .sql | tr - _)
	echo "== $f -> data/$t.json"
	"$duckdb" -c "$(cat "$f") COPY $t TO 'data/$t.json' (FORMAT json);"
done
${TAD:-tad} canon && ${TAD:-tad} check

#!/bin/sh
# Runs every feed in feeds/*.sql. Each fetches public data and reshapes it with SQL, run by DuckDB's
# standalone binary (pinned, its fingerprint checked before it runs); DuckDB writes the rows, then tad
# canonicalizes and checks them, so a feed cannot write what tables.toml does not allow.
# A feed named x-y.sql fills the table x_y.
set -eu
version="1.5.5"
fingerprint="08c0ca117111fcede14239d0093792352befdc174218c344d232c13279643d05"
work=$(mktemp -d); trap 'rm -rf "$work"' EXIT
curl -fsSL -o "$work/duckdb.zip" "https://github.com/duckdb/duckdb/releases/download/v$version/duckdb_cli-linux-amd64.zip"
echo "$fingerprint  $work/duckdb.zip" | sha256sum -c --quiet - || { echo "run-feeds: DuckDB's download does not match its pinned fingerprint" >&2; exit 1; }
unzip -q -o "$work/duckdb.zip" -d "$work"
for f in feeds/*.sql; do
	t=$(basename "$f" .sql | tr - _)
	echo "== $f -> data/$t.json"
	"$work/duckdb" -c "$(cat "$f") COPY $t TO 'data/$t.json' (FORMAT json);"
done
${TAD:-tad} canon && ${TAD:-tad} check

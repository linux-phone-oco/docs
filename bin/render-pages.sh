#!/bin/sh
# The pages tad render does not draw - one page per table is all it draws - made from the same rows, never by hand
# (backlog bringup-guidebook): docs/guidebook.md. make render runs it after tad render, and make verify
# runs it again to see the pages are as the rows leave them. A page is written whole or not at all.
#   bin/render-pages.sh
set -eu
cd "$(dirname "$0")/.."
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
rows() { tad sql "$2" --format json > "$tmp/$1.json"; }
rows stages "SELECT * FROM bringup_stages ORDER BY ord"
rows steps "SELECT * FROM bringup_steps ORDER BY id"
rows edges "SELECT * FROM bringup_step_edges ORDER BY step, requires"
rows sources "SELECT id, title, url FROM sources ORDER BY id"
tad q bringup-chain --format json > "$tmp/chain.json"
jq -r -n --slurpfile stages "$tmp/stages.json" --slurpfile steps "$tmp/steps.json" --slurpfile edges "$tmp/edges.json" \
	--slurpfile sources "$tmp/sources.json" --slurpfile chain "$tmp/chain.json" -f bin/guidebook.jq > "$tmp/guidebook.md"
mv "$tmp/guidebook.md" docs/guidebook.md

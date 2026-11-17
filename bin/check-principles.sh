#!/bin/sh
# The principles are cited, never restated: every link into docs/concepts.md in the guides names a concept that
# exists, and every principle (a concept with an ord) is cited by the briefs' README, where the briefs take them.
# Reads only (jq on the data); ends 1 on a dead id or an uncited principle. Run by make verify.
set -eu
cd "$(dirname "$0")/.."
ids=$(jq -r '.id' data/concepts.json)
principles=$(jq -r 'select(.ord != null) | "\(.ord) \(.id)"' data/concepts.json | sort -n | cut -d" " -f2)
bad=0
for f in AGENTS.md README.md CONTRIBUTING.md ideal-agent-linux-phone-oco/*.md; do
	for id in $(grep -o 'concepts\.md#[a-z0-9-]*' "$f" | sed 's/.*#//' | sort -u); do
		echo "$ids" | grep -qx "$id" || { echo "check-principles: $f cites concepts.md#$id, which is no concept" >&2; bad=1; }
	done
done
for id in $principles; do
	grep -q "concepts\.md#$id" ideal-agent-linux-phone-oco/README.md || { echo "check-principles: the principle $id is not cited by ideal-agent-linux-phone-oco/README.md" >&2; bad=1; }
done
[ "$bad" = 0 ] && echo "check-principles: $(echo "$principles" | wc -l | tr -d ' ') principles, every citation resolves"
exit $bad

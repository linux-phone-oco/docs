#!/bin/sh
# tad q prior-art --about S gives a subject's prior art: each research about it (a later one that supersedes it
# leaves the answer, as in about) and, for each source it cites, what we take from it. For bringup-steps that is
# every source of its researches, each with its takes. Reads only; run by make verify.
#   test-prior-art.sh
set -eu
cd "$(dirname "$0")/.."
fail() { echo "FAIL: $*" >&2; exit 1; }
q() { tad sql "$1" --format csv | tail -n +2; }
out=$(tad q prior-art --about bringup-steps --format csv) || fail "no query prior-art"
want=$(q "SELECT count(*) FROM (SELECT DISTINCT r.id, trim(s.x) AS src FROM research r, unnest(string_split(r.sources, ',')) AS s(x)
          WHERE r.about = 'bringup-steps' AND r.id NOT IN (SELECT supersedes FROM research WHERE supersedes IS NOT NULL) AND r.sources IS NOT NULL)")
got=$(printf '%s\n' "$out" | tail -n +2 | wc -l)
[ "$want" -gt 20 ] || fail "bringup-steps cites only $want sources: the test has nothing to read"
[ "$got" = "$want" ] || fail "the answer has $got rows, the researches of bringup-steps cite $want sources"
for r in bringup-steps-landscape bringup-steps-coverage-map bringup-steps-phone-stages; do
	printf '%s\n' "$out" | tail -n +2 | grep -q "^$r," || fail "no source of $r in the answer"
done
# a source with takes shows them
t=$(q "SELECT s.id FROM sources s JOIN research r ON r.sources LIKE '%' || s.id || '%' WHERE r.about = 'bringup-steps' AND s.takes IS NOT NULL LIMIT 1")
tk=$(tad q prior-art --about bringup-steps --format csv | awk -F, -v t="$t" '$2 == t' | head -1)
[ -n "$t" ] && [ -n "$tk" ] || fail "no source with takes shows in the answer"
[ -z "$(tad q prior-art --about no-such-subject --format csv | tail -n +2)" ] || fail "a subject with no research has prior art"
echo "PASS: prior-art --about bringup-steps: $got cited sources of its researches, each with its takes"

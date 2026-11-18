#!/bin/sh
# A part of a phone is a component, recorded with tad r component (one of that id is replaced; a category outside the
# enum is refused), and the phone steps whose first light is a part name it: gnss-fix, gpu-renders,
# battery-gauge-reads, off-mode-charging and buttons-report each name a component (decision
# 2026-11-18-bringup-steps-phone-stages-and-goal-steps). The record is tried in a scratch copy of docs. Run by make verify.
#   test-component-record.sh
set -eu
cd "$(dirname "$0")/.."
fail() { echo "FAIL: $*" >&2; exit 1; }
for s in gnss-fix gpu-renders battery-gauge-reads off-mode-charging buttons-report; do
	[ -n "$(tad sql "SELECT component FROM bringup_steps WHERE id = '$s' AND component IS NOT NULL" --format csv | tail -n +2)" ] || fail "step $s names no component"
done
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
tar -c --exclude=.git . | tar -x -C "$tmp"
cd "$tmp"
n=$(wc -l < data/components.json)
tad r component --id probe-part --name "A probe" --category other > /dev/null || fail "no record component"
[ "$(wc -l < data/components.json)" = "$((n + 1))" ] || fail "the record did not add one row"
tad r component --id probe-part --name "A probe, renamed" --category power > /dev/null || fail "a second record of the id was refused"
[ "$(wc -l < data/components.json)" = "$((n + 1))" ] || fail "recording the id again added a row instead of replacing it"
[ "$(jq -r 'select(.id == "probe-part") | .name + "|" + .category' data/components.json)" = "A probe, renamed|power" ] || fail "the row is not the second record"
if tad r component --id bad-part --name x --category nowhere > /dev/null 2>&1; then fail "a category outside the enum was accepted"; fi
[ "$(wc -l < data/components.json)" = "$((n + 1))" ] || fail "a refused record left a row"
tad check > /dev/null || fail "the rows do not check"
echo "PASS: tad r component records, replaces and refuses a category outside the enum; the phone steps' first lights name their parts"

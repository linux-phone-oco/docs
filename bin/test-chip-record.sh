#!/bin/sh
# ikb chip records one part, whatever product carries it (a row of that id is replaced): it makes one row, a second
# record of the id replaces it, a row with no https link up to a home, a driver on the list with no compatible, and a
# bring-up step that does not exist are refused - in a scratch copy of docs (docs' own data is not touched); then
# tad q chips --board finds it and about --subject reads a research about it. Run by make verify.
#   test-chip-record.sh
set -eu
cd "$(dirname "$0")/.."
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
fail() { echo "FAIL: $*" >&2; exit 1; }
tar -c --exclude=.git . | tar -x -C "$tmp"
cd "$tmp"
n=$(wc -l < data/chips.json)
step=$(tad sql "SELECT id FROM bringup_steps ORDER BY id LIMIT 1" --format csv | sed -n 2p)
[ -n "$step" ] || fail "no bring-up step to name"
tad r chip --id probe-x1 --part X1 --maker Probe --kind haptics --driver-stage fork --homes "fork: https://example.org/x1.patch" \
	--boards "board-probe (i2c, 0x5a; its dts)" --steps "$step" --checked-on 2026-11-19 > /dev/null || fail "no record chip, or it refused a whole row"
[ "$(wc -l < data/chips.json)" = "$((n + 1))" ] || fail "the record did not add one row"
[ "$(jq -r 'select(.id == "probe-x1") | .kind + "|" + .driver_stage + "|" + .checked_on' data/chips.json)" = "haptics|fork|2026-11-19" ] || fail "the row is not what was recorded"
tad r chip --id probe-x1 --part X1 --maker Probe --kind haptics --driver-stage none --homes "https://example.org/x1" > /dev/null || fail "a second record of the id was refused"
[ "$(wc -l < data/chips.json)" = "$((n + 1))" ] || fail "recording the id again added a row instead of replacing it"
if tad r chip --id probe-x2 --part X2 --maker Probe --kind haptics --driver-stage none --homes "nowhere" > /dev/null 2>&1; then fail "a row with no https link up was accepted"; fi
if tad r chip --id probe-x2 --part X2 --maker Probe --kind haptics --driver-stage in-review --homes "https://example.org" > /dev/null 2>&1; then fail "a driver on the list with no compatible was accepted"; fi
if tad r chip --id probe-x2 --part X2 --maker Probe --kind haptics --driver-stage none --homes "https://example.org" --steps no-such-step > /dev/null 2>&1; then fail "a step that does not exist was accepted"; fi
[ "$(wc -l < data/chips.json)" = "$((n + 1))" ] || fail "a refused record left a row"
tad r chip --id probe-x1 --part X1 --maker Probe --kind haptics --driver-stage fork --homes "https://example.org/x1.patch" --boards "board-probe (i2c 0x5a)" > /dev/null
tad q chips --board board-probe --format csv | grep -q '^probe-x1,' || fail "tad q chips --board does not find the chip"
tad r research --project docs --id probe-x1-research --brief "probe" --question "q" --found "f" --about probe-x1 > /dev/null || fail "a research about a chip was refused"
tad q about --subject probe-x1 --format csv | grep -q 'probe-x1-research' || fail "about --subject CHIP does not read its research"
tad q about --subject probe-x1 --format csv | grep -q "^chip,probe-x1,probe-x1,fork," || fail "about --subject CHIP does not lead with the chip's own row"
tad check > /dev/null || fail "the rows do not check"
echo "PASS: ikb chip records one part, replaces it by id, refuses a row with no link up, a list driver with no compatible and an unknown step; chips and about read it"

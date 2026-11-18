#!/bin/sh
# docs reads a device base's step claims: records/feed-device-steps.sql pulls devicebase.toml (steps = 1) and
# data/steps.json of a base into step_status, for every step docs knows. Tried in a scratch copy of docs against a
# fake base made of the device layer alone (a folder laid out as raw.githubusercontent.com lays a repository), so
# it needs no network and never touches docs' own data. What it holds:
#   a claim is read as claimed (status, proof, run, proven_on, notes, updated), and bringup-chain shows it;
#   a step the base never claimed is unknown, "not known yet"; a claim of a step docs does not know is dropped and named;
#   a claim that is not valid is unknown, with why; a base without steps = 1, or that cannot be read, gives every step
#   unknown and why (records/device-steps-unknown.sql); a claim does not lapse with age.
#   test-feed-device-steps.sh
set -eu
cd "$(dirname "$0")/.."
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
fail() { echo "FAIL: $*" >&2; exit 1; }
# the fake base: the layer's tables and record, one claim made through tad r step, two written by hand
mkdir -p "$tmp/remote/o/base/main/data" "$tmp/base/data" "$tmp/base/records"
{ echo "[tables]"; awk '/device:begin/ { on = 1 } on { print } /device:end/ { on = 0 }' device-layer/tables.toml; } > "$tmp/base/tables.toml"
cp device-layer/records/step.sql "$tmp/base/records/"
(cd "$tmp/base" && tad r step --step shell-on-console --status done --proof tests/host/shell.sh --run run-7 --proven-on abc123 --notes "over the gadget" --updated 2026-01-02 > /dev/null
	tad r step --step uart-console --status open --notes "waits the cable" > /dev/null)
cp "$tmp/base/data/steps.json" "$tmp/remote/o/base/main/data/steps.json"
printf '%s\n' '{"step":"no-such-step","status":"done","proof":"p","run":"r","proven_on":null,"notes":null,"updated":"2026-11-18"}' \
	'{"step":"kernel-reaches-init","status":"works","proof":null,"run":null,"proven_on":null,"notes":null,"updated":"2026-11-18"}' \
	'{"step":"banner-on-console","status":"done","proof":"p","run":"r","proven_on":null,"notes":"older","updated":"2026-11-01"}' \
	'{"step":"banner-on-console","status":"failing","proof":"p","run":"r2","proven_on":null,"notes":"newer","updated":"2026-11-10"}' \
	'{"step":"dmesg-clean","status":"done","proof":"p","run":"r","proven_on":null,"notes":null,"updated":"yesterday"}' \
	>> "$tmp/remote/o/base/main/data/steps.json"
printf 'source = "linux-phone-oco/docs"\nversion = "0.18.0"\nown = []\nparts = 1\nsteps = 1\n' > "$tmp/remote/o/base/main/devicebase.toml"
# the scratch docs
mkdir "$tmp/docs" && tar -c --exclude=.git . | tar -x -C "$tmp/docs"
cd "$tmp/docs"
feed() { tad r feed-device-steps --device google-walleye --base o/base --root "file://$tmp/remote" 2>&1; }
q() { tad sql "$1" --format csv | tail -n +2; }
total=$(q "SELECT count(*) FROM bringup_steps")
out=$(feed) || fail "the feed does not run on a base with steps = 1: $out"
[ "$(q "SELECT count(*) FROM step_status WHERE device_id = 'google-walleye'")" = "$total" ] || fail "not every step has a row for the device"
[ "$(q "SELECT status || '|' || proof || '|' || run || '|' || proven_on || '|' || notes || '|' || updated FROM step_status WHERE device_id = 'google-walleye' AND step_id = 'shell-on-console'")" = "done|tests/host/shell.sh|run-7|abc123|over the gadget|2026-01-02" ] \
	|| fail "the claim of shell-on-console is not read as claimed (an old claim lapses, or a field is lost)"
[ "$(q "SELECT status FROM step_status WHERE device_id = 'google-walleye' AND step_id = 'uart-console'")" = open ] || fail "an open claim is not read"
[ "$(q "SELECT count(*) FROM step_status WHERE device_id = 'google-walleye' AND step_id = 'first-dmesg-mapped' AND status = 'unknown' AND notes LIKE 'Not known yet:%claim%'")" = 1 ] \
	|| fail "a step the base never claimed is not unknown, not known yet"
[ "$(q "SELECT count(*) FROM step_status WHERE device_id = 'google-walleye' AND step_id = 'kernel-reaches-init' AND status = 'unknown' AND notes LIKE 'Not known yet:%not valid%'")" = 1 ] \
	|| fail "an invalid claim is not unknown with why"
case "$out" in *no-such-step*) : ;; *) fail "a claim of a step docs does not know is not named: $out" ;; esac
[ "$(q "SELECT count(*) FROM step_status WHERE step_id = 'no-such-step'")" = 0 ] || fail "a claim of an unknown step was kept"
[ "$(q "SELECT status FROM step_status WHERE device_id = 'google-walleye' AND step_id = 'shell-on-console'")" = done ] || fail "bringup-chain is not fed"
[ "$(tad q bringup-chain --device google-walleye --format csv | awk -F, '$2 == "shell-on-console" { print $5 }')" = done ] || fail "bringup-chain does not show the claim"
[ "$(q "SELECT notes FROM step_status WHERE device_id = 'google-walleye' AND step_id = 'banner-on-console'")" = newer ] || fail "a step claimed twice does not count once, its newest"
[ "$(q "SELECT count(*) FROM step_status WHERE device_id = 'google-walleye' AND step_id = 'dmesg-clean' AND status = 'unknown' AND notes LIKE 'Not known yet:%not valid%'")" = 1 ] || fail "a claim whose updated is not a date is not unknown with why"
tad check > /dev/null || fail "step_status does not check after the feed"
# a base that does not declare the contract: every step unknown, and why
printf 'source = "linux-phone-oco/docs"\nversion = "0.18.0"\nown = []\nparts = 1\n' > "$tmp/remote/o/base/main/devicebase.toml"
feed > /dev/null || fail "the feed fails on a base without steps = 1"
[ "$(q "SELECT count(*) FROM step_status WHERE device_id = 'google-walleye' AND status = 'unknown' AND notes LIKE 'Not known yet:%steps = 1%'")" = "$total" ] \
	|| fail "a base without steps = 1 does not give every step unknown, saying so"
# a base that cannot be read: the feed fails, and the fallback record gives every step unknown and why
if tad r feed-device-steps --device google-walleye --base o/gone --root "file://$tmp/remote" > /dev/null 2>&1; then fail "the feed read a base that is not there"; fi
tad r device-steps-unknown --device google-walleye --why "o/gone: no answer" > /dev/null || fail "no record device-steps-unknown"
[ "$(q "SELECT count(*) FROM step_status WHERE device_id = 'google-walleye' AND status = 'unknown' AND notes LIKE 'Not known yet: the base could not be read (o/gone: no answer)%'")" = "$total" ] \
	|| fail "an unreadable base does not give every step unknown, with why"
tad check > /dev/null || fail "step_status does not check after the fallback"
echo "PASS: docs reads a base's step claims; unclaimed, invalid, undeclared and unreadable are unknown with why; an unknown step's claim is dropped and named"

#!/bin/sh
# The steps contract of the device layer works as a device base meets it: a base made of nothing but the layer's
# marked tables part and its records can claim a bring-up step (tad r step), the claim is one row of data/steps.json,
# and what is not a claim is refused with its reason and leaves the standing claim as it was: a status outside the six,
# a done claim without a proof or a run (measured-not-claimed), a not-needed claim without its reason. Run by make verify.
#   test-steps-contract.sh
set -eu
cd "$(dirname "$0")/.."
base=$(mktemp -d); trap 'rm -rf "$base"' EXIT
mkdir "$base/data" "$base/records"
{ echo "[tables]"; awk '/device:begin/ { on = 1 } on { print } /device:end/ { on = 0 }' device-layer/tables.toml; } > "$base/tables.toml"
cp device-layer/records/step.sql "$base/records/" 2> /dev/null || { echo "FAIL: device-layer/records/step.sql is not there" >&2; exit 1; }
cd "$base"
fail() { echo "FAIL: $*" >&2; exit 1; }
tad check > /dev/null || fail "an empty base does not check"
tad r step --step shell-on-console --status done --proof tests/host/mainline-shell-read.sh --run walleye-z6-tried \
	--proven-on abc123 --notes "over the gadget" > /dev/null || fail "a done claim with proof and run is refused"
[ "$(wc -l < data/steps.json)" = 1 ] || fail "one claim is not one row"
[ "$(jq -r '.status + " " + .proof + " " + .run + " " + .proven_on' data/steps.json)" = "done tests/host/mainline-shell-read.sh walleye-z6-tried abc123" ] || fail "the row is not what was claimed"
tad r step --step shell-on-console --status partial --notes "reworked" > /dev/null || fail "a claim is not replaced by the next"
[ "$(wc -l < data/steps.json)" = 1 ] || fail "claiming again added a row instead of replacing it"
tad r step --step uart-console --status open --notes "waits the cable" > /dev/null || fail "an open claim is refused"
tad r step --step charger-online --status failing --proof tests/host/charger-check.sh --run walleye-c2-tried > /dev/null || fail "a failing claim is refused"
tad r step --step usb-wake --status not-needed --notes "the way back is the watchdog" > /dev/null || fail "a not-needed claim with its reason is refused"
tad r step --step crash-window --status unknown > /dev/null || fail "an unknown claim is refused"
tad check > /dev/null || fail "the claims do not check"
standing=$(cat data/steps.json)
# refused: the claim, the words the refusal must say; each against a step with a standing claim and a step with none
refuse() { # WORDS STATUS [flags]
	words=$1; status=$2; shift 2
	for s in charger-online no-such-step; do
		if err=$(tad r step --step "$s" --status "$status" "$@" 2>&1); then fail "'$*' was accepted for $s"; fi
		case "$err" in *"$words"*) : ;; *) fail "'$*' was refused for $s, but not saying '$words': $err" ;; esac
	done
	[ "$(cat data/steps.json)" = "$standing" ] || fail "'$*' was refused and still changed the claims"
}
refuse "not one of" works
refuse "--proof" done --run r
refuse "--run" done --proof p
refuse "--proof" done --proof "" --run ""
refuse "--proof" done --proof "  " --run r
refuse "--notes" not-needed
refuse "--notes" not-needed --notes ""
tad r step --step Bad_Name --status open > /dev/null 2>&1 && fail "a step name outside the pattern was accepted"
[ "$(cat data/steps.json)" = "$standing" ] || fail "a refused name changed the claims"
echo "PASS: a device base claims a step; the status outside the six, done without proof or run, not-needed without a reason are refused with their reason, and the standing claim stays"

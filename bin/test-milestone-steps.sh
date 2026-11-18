#!/bin/sh
# A milestone names steps as it names features: step:ID@DEVICE in its criteria (decision
# 2026-11-18-bringup-steps-generic-in-docs-status-in-each-base, 7). tad q milestone-steps reads each such term from
# step_status - the device's own base's claim, pulled by feed-device-steps - never from what the milestone says: a term is
# met when the base claims the step done or not-needed, and a milestone's step terms are ready when every one is met.
# A step or a device that is none is refused by name. Tried in a scratch copy of docs with a fake base (the device layer
# alone, read through the feed), so docs' data is not touched. Run by make verify.
#   test-milestone-steps.sh
set -eu
cd "$(dirname "$0")/.."
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
fail() { echo "FAIL: $*" >&2; exit 1; }
tad q milestone-steps > /dev/null || fail "docs' own milestones do not read: a step term names a step or a device that is none"
# the fake base
mkdir -p "$tmp/remote/o/base/main/data" "$tmp/base/data" "$tmp/base/records"
{ echo "[tables]"; awk '/device:begin/ { on = 1 } on { print } /device:end/ { on = 0 }' device-layer/tables.toml; } > "$tmp/base/tables.toml"
cp device-layer/records/step.sql "$tmp/base/records/"
printf 'steps = 1\n' > "$tmp/remote/o/base/main/devicebase.toml"
claim() { (cd "$tmp/base" && tad r step "$@" > /dev/null); cp "$tmp/base/data/steps.json" "$tmp/remote/o/base/main/data/steps.json"; (cd "$tmp/docs" && tad r feed-device-steps --device google-walleye --base o/base --root "file://$tmp/remote" > /dev/null); }
mkdir "$tmp/docs" && tar -c --exclude=.git . | tar -x -C "$tmp/docs"
cd "$tmp/docs"
q() { tad q milestone-steps --format csv | tail -n +2; }
# a milestone over two steps of walleye
tad r milestone --project google-walleye-lab --id reaches-a-shell --subject walleye --ord 1 --title "Reaches a shell" --horizon working --readiness 3 \
	--criteria "step:kernel-reaches-init@google-walleye step:shell-on-console@google-walleye" --why "the first sign of life" > /dev/null || fail "no record milestone"
claim --step kernel-reaches-init --status done --proof tests/host/kernel-alive.sh --run run-1
row=$(q | grep '^google-walleye-lab,reaches-a-shell,shell-on-console,') || fail "the term of shell-on-console is not read"
case "$row" in *,unknown,*,false,*) : ;; *) fail "a step nobody claimed is not unknown and unmet: $row" ;; esac
q | grep '^google-walleye-lab,reaches-a-shell,kernel-reaches-init,' | grep -q ',done,.*,true,' || fail "a done claim is not a met term"
q | grep '^google-walleye-lab,reaches-a-shell,' | grep -qv ',false$' && fail "a milestone with a term unmet reads ready"
claim --step shell-on-console --status partial --notes "over the gadget only"
q | grep '^google-walleye-lab,reaches-a-shell,' | grep -q ',true$' && fail "a partial claim made the milestone ready"
claim --step shell-on-console --status done --proof tests/host/shell.sh --run run-2
[ "$(q | grep '^google-walleye-lab,reaches-a-shell,' | grep -c ',true$')" = 2 ] || fail "both terms done does not read ready"
claim --step shell-on-console --status not-needed --notes "a UART-only phone"
[ "$(q | grep '^google-walleye-lab,reaches-a-shell,' | grep -c ',true$')" = 2 ] || fail "a not-needed claim is not a met term"
# a term that names nothing is refused, by name
tad r milestone --project google-walleye-lab --id typo --subject walleye --ord 2 --title Typo --horizon working --readiness 1 \
	--criteria "step:no-such-step@google-walleye" --why x > /dev/null
err=$(tad q milestone-steps 2>&1) && fail "a term naming no step was accepted"
case "$err" in *no-such-step*) : ;; *) fail "the refusal does not name the step: $err" ;; esac
tad r milestone --project google-walleye-lab --id typo --subject walleye --ord 2 --title Typo --horizon working --readiness 1 \
	--criteria "step:kernel-reaches-init@no-such-phone" --why x > /dev/null
err=$(tad q milestone-steps 2>&1) && fail "a term naming no device was accepted"
case "$err" in *no-such-phone*) : ;; *) fail "the refusal does not name the device: $err" ;; esac
echo "PASS: milestone-steps reads step terms from the base's claims: done or not-needed is met, anything else is not, ready when all are; a step or device that is none is refused by name"

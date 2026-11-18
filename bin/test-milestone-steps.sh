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
# a goal step is never claimed: it is met when every step it needs, hard edges all the way down, is done or
# not-needed on the device (a console alternative not taken does not count against it), as daily-phone.sh reads it
tad r milestone --project google-walleye-lab --id typo --subject walleye --ord 2 --title Typo --horizon working --readiness 1 \
	--criteria "step:kernel-reaches-init@google-walleye" --why x > /dev/null
tad r milestone --project google-walleye-lab --id daily --subject walleye --ord 3 --title Daily --horizon working --readiness 1 \
	--criteria "step:daily-usable-phone@google-walleye" --why x > /dev/null
leaves=$(tad sql "WITH RECURSIVE need(id) AS (SELECT 'daily-usable-phone' UNION SELECT e.requires FROM bringup_step_edges e JOIN need ON e.step = need.id WHERE e.kind = 'hard')
                  SELECT n.id FROM need n JOIN bringup_steps s ON s.id = n.id WHERE s.stage <> 'goals' ORDER BY 1" --format csv | tail -n +2)
total=$(printf '%s\n' "$leaves" | wc -l)
claims() { # STATUS-FOR-GNSS-FIX
	printf '%s\n' "$leaves" | awk -v g="$1" '{ s = "done"; if ($0 == "uart-console") s = "open"; if ($0 == "gnss-fix") s = g;
		printf "{\"step\":\"%s\",\"status\":\"%s\",\"proof\":\"p\",\"run\":\"r\",\"proven_on\":null,\"notes\":\"n\",\"updated\":\"2026-11-18\"}\n", $0, s }' > "$tmp/remote/o/base/main/data/steps.json"
	tad r feed-device-steps --device google-walleye --base o/base --root "file://$tmp/remote" > /dev/null
}
goal() { tad q milestone-steps --milestone daily --format csv | tail -n +2; }
printf 'steps = 1\n' > "$tmp/remote/o/base/main/devicebase.toml"
claims open
case "$(goal)" in google-walleye-lab,daily,daily-usable-phone,google-walleye,partial,*,false,false) : ;; *) fail "a goal with a step open is not partial and unmet: $(goal)" ;; esac
claims done
case "$(goal)" in *,done,*,true,true) : ;; *) fail "a goal whose needs are done is not met (the console alternative not taken must not count): $(goal)" ;; esac
case "$(goal)" in *"$total of $total"*) : ;; *) fail "the goal does not say how many of its $total needs are met: $(goal)" ;; esac
printf '{"step":"kernel-reaches-init","status":"done","proof":"p","run":"r","proven_on":null,"notes":null,"updated":"2026-11-18"}\n' > "$tmp/remote/o/base/main/data/steps.json"
tad r feed-device-steps --device google-walleye --base o/base --root "file://$tmp/remote" > /dev/null
case "$(goal)" in *,partial,*,false,false) : ;; *) fail "one need met of $total is not partial: $(goal)" ;; esac
printf '\n' > "$tmp/remote/o/base/main/data/steps.json"
tad r feed-device-steps --device google-walleye --base o/base --root "file://$tmp/remote" > /dev/null
case "$(goal)" in *,unknown,*,false,false) : ;; *) fail "a goal no claim touches is not unknown: $(goal)" ;; esac
echo "PASS: milestone-steps reads step terms from the base's claims: done or not-needed is met, anything else is not, ready when all are, a goal step by what it needs; a step or device that is none is refused by name"

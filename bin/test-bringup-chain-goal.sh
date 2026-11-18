#!/bin/sh
# tad q bringup-chain --goal STEP gives a goal step and what it needs, hard edges all the way down: the rows are
# exactly that closure over bringup_step_edges (the goal included), in the chain's order; a step that is no step
# errs naming it; without --goal the chain is every step. Reads only; run by make verify.
#   test-bringup-chain-goal.sh
set -eu
cd "$(dirname "$0")/.."
fail() { echo "FAIL: $*" >&2; exit 1; }
q() { tad sql "$1" --format csv | tail -n +2; }
all=$(q "SELECT count(*) FROM bringup_steps")
[ "$(tad q bringup-chain --format csv | tail -n +2 | wc -l)" = "$all" ] || fail "without --goal the chain is not every step"
for g in linux-runs daily-usable-phone complete-phone; do
	want=$(q "WITH RECURSIVE need(id) AS (SELECT '$g' UNION SELECT e.requires FROM bringup_step_edges e JOIN need ON e.step = need.id WHERE e.kind = 'hard') SELECT count(*) FROM need")
	got=$(tad q bringup-chain --goal "$g" --format csv | tail -n +2 | wc -l)
	[ "$got" = "$want" ] || fail "--goal $g gives $got steps, its hard-edge closure is $want"
	tad q bringup-chain --goal "$g" --format csv | tail -n +2 | awk -F, -v g="$g" '$2 == g { found = 1 } END { exit !found }' || fail "--goal $g leaves the goal out"
done
# what a goal needs comes before it, as in the whole chain
tad q bringup-chain --goal daily-usable-phone --format csv | tail -n +2 | awk -F, 'END { exit $2 != "daily-usable-phone" }' || fail "the goal is not the last of its own chain"
err=$(tad q bringup-chain --goal no-such-goal 2>&1) && fail "--goal of no step was accepted"
case "$err" in *no-such-goal*) : ;; *) fail "the refusal does not name the step: $err" ;; esac
echo "PASS: bringup-chain --goal gives the goal and its hard needs ($(q "WITH RECURSIVE need(id) AS (SELECT 'daily-usable-phone' UNION SELECT e.requires FROM bringup_step_edges e JOIN need ON e.step = need.id WHERE e.kind = 'hard') SELECT count(*) FROM need") for daily-usable-phone of $all); a step that is none is refused by name"

#!/bin/sh
# The shape of the bring-up steps (decision 2026-11-18-bringup-steps-phone-stages-and-goal-steps): every stage has
# a step, the goals linux-runs, daily-usable-phone and complete-phone exist, and every step of a phone stage (a stage
# after lab, goals apart) is needed - hard edges, transitively - by complete-phone, so no phone step is left outside
# a goal. Names what is wrong. Reads only; run by make verify.
#   check-bringup-steps.sh
set -eu
cd "$(dirname "$0")/.."
q() { tad sql "$1" --format csv | tail -n +2; }
bad=0
fail() { echo "check-bringup-steps: $*" >&2; bad=1; }
empty=$(q "SELECT id FROM bringup_stages WHERE id NOT IN (SELECT stage FROM bringup_steps) ORDER BY ord" | tr '\n' ' ')
[ -z "$empty" ] || fail "stages with no step: $empty"
for g in linux-runs daily-usable-phone complete-phone; do
	[ -n "$(q "SELECT id FROM bringup_steps WHERE id = '$g'")" ] || fail "no goal step $g"
done
outside=$(q "WITH RECURSIVE need(id) AS (SELECT 'complete-phone' UNION SELECT e.requires FROM bringup_step_edges e JOIN need ON e.step = need.id WHERE e.kind = 'hard')
             SELECT s.id FROM bringup_steps s JOIN bringup_stages g ON g.id = s.stage
             WHERE g.ord > (SELECT ord FROM bringup_stages WHERE id = 'lab') AND s.stage <> 'goals' AND s.id NOT IN (SELECT id FROM need) ORDER BY s.id" | tr '\n' ' ')
[ -z "$outside" ] || fail "phone steps no goal needs: $outside"
[ "$bad" = 0 ] && echo "check-bringup-steps: $(q "SELECT count(*) FROM bringup_stages") stages, each with steps; $(q "SELECT count(*) FROM bringup_steps") steps, every phone step under complete-phone"
exit $bad

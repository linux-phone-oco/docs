#!/bin/sh
# The shape of the bring-up steps (decision 2026-11-18-bringup-steps-phone-stages-and-goal-steps): every stage has
# a step, the goals linux-runs, daily-usable-phone and complete-phone exist, and every step of a phone stage (a stage
# after lab, goals apart) is needed - hard edges, transitively - by complete-phone, so no phone step is left outside
# a goal; and (decision 2026-11-19-hardware-test-layer) the hardware stages need no shell-stage step, the shell stage being
# the last before the goals, and the test layer has its own step. Names what is wrong. Reads only; run by make verify.
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
# The hardware is proven in a test layer with no shell (decision 2026-11-19-hardware-test-layer): the shell stage
# comes after every stage but the goals, no step outside it (goals apart) needs one of its steps - hard or soft - and
# the layer has its own step.
late=$(q "SELECT g.id FROM bringup_stages g WHERE (g.id <> 'goals' AND g.ord > (SELECT ord FROM bringup_stages WHERE id = 'shell')) OR (g.id = 'goals' AND g.ord < (SELECT ord FROM bringup_stages WHERE id = 'shell')) ORDER BY g.ord" | tr '\n' ' ')
[ -z "$late" ] || fail "stages on the wrong side of the shell stage (it is the last before the goals): $late"
leaning=$(q "SELECT e.step || ' needs ' || e.requires FROM bringup_step_edges e JOIN bringup_steps s ON s.id = e.step JOIN bringup_steps r ON r.id = e.requires
             WHERE r.stage = 'shell' AND s.stage NOT IN ('shell', 'goals') ORDER BY e.step, e.requires" | tr '\n' ';')
[ -z "$leaning" ] || fail "hardware steps that need a shell step: $leaning"
[ -n "$(q "SELECT id FROM bringup_steps WHERE id = 'test-layer-boots' AND stage = 'lab' AND proof = 'test-layer-quiet'")" ] || fail "no step test-layer-boots in the lab stage, proven by test-layer-quiet"
[ "$bad" = 0 ] && echo "check-bringup-steps: $(q "SELECT count(*) FROM bringup_stages") stages, each with steps; $(q "SELECT count(*) FROM bringup_steps") steps, every phone step under complete-phone, no hardware step on the shell"
exit $bad

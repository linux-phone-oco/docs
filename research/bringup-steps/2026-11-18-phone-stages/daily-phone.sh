#!/bin/sh
# The failing test of decision 2026-11-18-bringup-steps-phone-stages-and-goal-steps. Run in docs:
#   sh daily-phone.sh [DEVICE]   (default xiaomi-surya)
# 1. Shape (passes once seeded): every stage has a step; the goals linux-runs, daily-usable-phone and
#    complete-phone exist; every step of a phone stage is needed (hard edges, transitively) by complete-phone,
#    so no phone step is left outside a goal.
#    The test layer (2026-11-19-hardware-test-layer): no hardware step needs a shell-stage step.
# 2. The device (fails until it is true): every step daily-usable-phone needs, transitively, is done or
#    not-needed in step_status - its own base's claims, pulled by feed-device-steps. Today no base claims
#    steps, so every step is not known yet and the test fails, as measured-not-claimed wants.
set -eu
dev=${1:-xiaomi-surya}
q() { tad sql "$1" --format csv | tail -n +2; }

empty=$(q "SELECT id FROM bringup_stages WHERE id NOT IN (SELECT stage FROM bringup_steps) ORDER BY ord")
[ -z "$empty" ] || { echo "FAIL: stages with no step: $(echo $empty)"; exit 1; }
for g in linux-runs daily-usable-phone complete-phone; do
  [ -n "$(q "SELECT id FROM bringup_steps WHERE id = '$g'")" ] || { echo "FAIL: no goal step $g"; exit 1; }
done

closure() {
  echo "WITH RECURSIVE need(id) AS (SELECT '$1' UNION SELECT e.requires FROM bringup_step_edges e JOIN need ON e.step = need.id WHERE e.kind = 'hard') SELECT id FROM need"
}
outside=$(q "SELECT s.id FROM bringup_steps s JOIN bringup_stages g ON g.id = s.stage
             WHERE g.ord > (SELECT ord FROM bringup_stages WHERE id = 'lab') AND s.stage <> 'goals'
               AND s.id NOT IN ($(closure complete-phone)) ORDER BY s.id")
[ -z "$outside" ] || { echo "FAIL: phone steps no goal needs: $(echo $outside)"; exit 1; }
# 1b. The test layer (decision 2026-11-19-hardware-test-layer): no step outside the shell stage (goals apart) needs
#     a step of it, hard or soft, the shell stage is the last before the goals, and the layer has its own step.
late=$(q "SELECT g.id FROM bringup_stages g WHERE (g.id <> 'goals' AND g.ord > (SELECT ord FROM bringup_stages WHERE id = 'shell')) OR (g.id = 'goals' AND g.ord < (SELECT ord FROM bringup_stages WHERE id = 'shell')) ORDER BY g.ord")
[ -z "$late" ] || { echo "FAIL: stages on the wrong side of the shell stage (it is the last before the goals): $(echo $late)"; exit 1; }
leaning=$(q "SELECT e.step || ' needs ' || e.requires FROM bringup_step_edges e JOIN bringup_steps s ON s.id = e.step JOIN bringup_steps r ON r.id = e.requires
             WHERE r.stage = 'shell' AND s.stage NOT IN ('shell', 'goals') ORDER BY e.step, e.requires" | tr '\n' ';')
[ -z "$leaning" ] || { echo "FAIL: hardware steps that need a shell step: $leaning"; exit 1; }
[ -n "$(q "SELECT id FROM bringup_steps WHERE id = 'test-layer-boots' AND stage = 'lab' AND proof = 'test-layer-quiet'")" ] || { echo "FAIL: no step test-layer-boots in the lab stage, proven by test-layer-quiet"; exit 1; }
total=$(q "SELECT count(*) FROM ($(closure daily-usable-phone)) WHERE id <> 'daily-usable-phone'")
echo "shape: every stage has steps; daily-usable-phone needs $total steps; complete-phone needs every phone step"

[ -n "$(q "SELECT id FROM devices WHERE id = '$dev'")" ] || { echo "FAIL: no device $dev"; exit 1; }
left=$(q "SELECT n.id || ':' || coalesce(ss.status, 'unknown') FROM ($(closure daily-usable-phone)) n
          LEFT JOIN step_status ss ON ss.step_id = n.id AND ss.device_id = '$dev'
          WHERE n.id <> 'daily-usable-phone' AND coalesce(ss.status, 'unknown') NOT IN ('done', 'not-needed')
            -- an alternative not taken (console over UART when the gadget's is done) is not left over
            AND NOT EXISTS (SELECT 1 FROM bringup_step_edges e JOIN bringup_step_edges o
                              ON o.step = e.step AND o.\"group\" = e.\"group\" AND o.requires <> e.requires
                            JOIN step_status os ON os.step_id = o.requires AND os.device_id = '$dev'
                            WHERE e.requires = n.id AND os.status IN ('done', 'not-needed'))
          ORDER BY n.id")
[ -z "$left" ] || { echo "FAIL: $dev is not a daily-usable phone yet: $(echo "$left" | wc -l) of $total steps not done - $(echo $left)"; exit 1; }
echo "PASS: $dev is a daily-usable phone - all $total steps done or not-needed"

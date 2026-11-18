#!/bin/sh
# The face's bring-up view is a matrix of the steps against the devices, as the features and the devices are
# (face/lens.toml, view steps), drawn from what bin/face-steps makes of this place's rows: a row for each step with
# its stage as the group, the stages in their order and the steps in the order of bringup-chain; a cell for each step
# and each device step_status knows - the claim in the words the face draws (failing is fail, not-needed is n/a), its
# proof and run in the hover, and not known yet where a base claimed nothing; and a headline that says for each goal
# and each device how many of the steps the goal needs are done. The lens names those tables and bin/face-data runs
# them. Reads only; run by make verify.
#   test-face-steps.sh
set -eu
cd "$(dirname "$0")/.."
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
fail() { echo "FAIL: $*" >&2; exit 1; }
q() { tad sql "$1" --format csv > "$tmp/q.csv" && tail -n +2 "$tmp/q.csv"; }
bin/face-steps "$tmp/face" || fail "bin/face-steps does not run"
steps=$(q "SELECT count(*) FROM bringup_steps")
devices=$(q "SELECT DISTINCT device_id FROM step_status ORDER BY device_id")
[ -n "$devices" ] || fail "step_status knows no device"

# the rows: every step once, the stages in order, the steps in the chain's order within a stage
r=$tmp/face/step_rows.json
[ "$(wc -l < "$r")" = "$steps" ] || fail "step_rows is not a row for each of the $steps steps"
tad q bringup-chain --format csv > "$tmp/chain.csv"
: > "$tmp/want"
for stage in $(q "SELECT id FROM bringup_stages ORDER BY ord"); do
	cat=$(tad sql "SELECT ord || '. ' || title AS c FROM bringup_stages WHERE id = '$stage'" --format json | jq -r '.[0].c')
	awk -F, -v s="$stage" -v c="$cat" 'NR > 1 && $3 == s { print $2 "\t" c }' "$tmp/chain.csv" >> "$tmp/want"
done
jq -r '[.id, .category] | @tsv' "$r" > "$tmp/got"
cmp -s "$tmp/want" "$tmp/got" || fail "step_rows are not the steps in the order of bringup-chain, grouped by their stage: $(diff "$tmp/want" "$tmp/got" | head -3)"
[ "$(jq -r 'select(.name == null or .name == "" or .why == null or .project != "linux-phone-oco/docs") | .id' "$r" | wc -l)" = 0 ] || fail "a step row has no name or no why, or is not docs' own"

# the cells: a step against every device, each claim as the face draws it
c=$tmp/face/step_cells.json
ndev=$(echo "$devices" | wc -l)
[ "$(wc -l < "$c")" = "$((steps * ndev))" ] || fail "step_cells is not a cell for each of the $steps steps and $ndev devices"
tad sql "SELECT device_id, step_id, status, proof, run FROM step_status ORDER BY 1, 2" --format json |
	jq -r '.[] | [.device_id, .step_id, .status, (.proof // "-"), (.run // "-")] | @tsv' > "$tmp/claims"
[ -s "$tmp/claims" ] || fail "step_status has no claim"
while IFS='	' read -r d step status proof run; do
	cell=$(jq -c --arg d "$d" --arg s "$step" 'select(.device_id == $d and .step_id == $s)' "$c")
	[ -n "$cell" ] || fail "no cell for $d on $step"
	want=$status
	case $status in failing) want=fail ;; not-needed) want=n/a ;; esac
	[ "$(echo "$cell" | jq -r .status)" = "$want" ] || fail "$d on $step claims $status, its cell says $cell"
	[ "$proof" = - ] || echo "$cell" | jq -e --arg p "proof $proof" '.notes | contains($p)' > /dev/null || fail "the cell of $d on $step does not show its proof $proof"
	[ "$run" = - ] || echo "$cell" | jq -e --arg p "run $run" '.notes | contains($p)' > /dev/null || fail "the cell of $d on $step does not show its run $run"
done < "$tmp/claims"
# a step a device never claimed is unknown, said so
for d in $devices; do
	q "SELECT id FROM bringup_steps WHERE id NOT IN (SELECT step_id FROM step_status WHERE device_id = '$d') ORDER BY id" > "$tmp/unclaimed"
	while read -r step; do
		jq -e --arg d "$d" --arg s "$step" 'select(.device_id == $d and .step_id == $s) | .status == "unknown" and (.notes | contains("not known yet"))' "$c" > /dev/null || fail "$d never claimed $step, yet its cell does not say it is not known yet"
	done < "$tmp/unclaimed"
done

# the words of the cells and of the count, on a fixture with what the data may not hold today: a failing claim, a
# not-needed one, a claim with no proof, and a step nobody claimed
printf '%s\n' '[{"id":"a"},{"id":"b"},{"id":"c"},{"id":"d"}]' > "$tmp/fx-steps.json"
printf '%s\n' '[{"device_id":"p","step_id":"a","status":"failing","proof":"pa","run":"ra","notes":"why a"},{"device_id":"p","step_id":"b","status":"not-needed","proof":null,"run":null,"notes":"no radio"},{"device_id":"p","step_id":"c","status":"done","proof":"pc","run":null,"notes":null}]' > "$tmp/fx-claims.json"
jq -c -n --slurpfile steps "$tmp/fx-steps.json" --slurpfile claims "$tmp/fx-claims.json" -f bin/face-cells.jq > "$tmp/fx-cells.json"
[ "$(wc -l < "$tmp/fx-cells.json")" = 4 ] || fail "the fixture does not give a cell for each of its 4 steps"
got=$(jq -r '[.step_id, .status] | join(" ")' "$tmp/fx-cells.json" | tr '\n' ',')
[ "$got" = "a fail,b n/a,c done,d unknown," ] || fail "the fixture's statuses come out as $got"
jq -e -s '.[0].notes == "claimed failing; proof pa; run ra; why a" and .[1].notes == "claimed not-needed; no radio" and .[2].notes == "proof pc" and (.[3].notes | startswith("not known yet"))' "$tmp/fx-cells.json" > /dev/null || fail "the fixture's notes are not the claim as it stands: $(cat "$tmp/fx-cells.json")"
[ "$(printf '%s' '[{"status":"done"},{"status":"not-needed"},{"status":"failing"},{"status":"unknown"}]' | jq -r -f bin/face-count.jq)" = "2 of 4" ] || fail "the count does not take a done and a not-needed step as done"

# the headline: X of N, for each goal and each device, counted again from step_status over the goal's hard needs
for goal in $(q "SELECT id FROM bringup_steps WHERE stage = 'goals' ORDER BY id"); do
	title=$(q "SELECT title FROM bringup_steps WHERE id = '$goal'")
	grep -qF "$title:" "$tmp/face/step_lead.txt" || fail "the headline names no goal $title"
	for d in $devices; do
		name=$(q "SELECT name FROM devices WHERE id = '$d'")
		closure="WITH RECURSIVE need(id) AS (SELECT '$goal' UNION SELECT e.requires FROM bringup_step_edges e JOIN need ON e.step = need.id WHERE e.kind = 'hard')"
		n=$(q "$closure SELECT count(*) FROM need")
		x=$(q "$closure SELECT count(*) FROM need JOIN step_status s ON s.step_id = need.id AND s.device_id = '$d' WHERE s.status IN ('done', 'not-needed')")
		sed 's/; /\n/g' "$tmp/face/step_lead.txt" | grep -F "$title:" | grep -qE "(^|[:,] )$name $x of $n(,|;|\.|$)" || fail "the headline does not say $name has $x of $n for $title"
	done
done

# the lens draws it, and the data's builder runs it
view=$(awk '/^\[\[view\]\]/ { if (on) exit; blk = "" } { blk = blk $0 "\n" } /^id = "steps"$/ { on = 1 } END { if (on) printf "%s", blk }' face/lens.toml)
[ -n "$view" ] || fail "face/lens.toml has no view steps"
for want in 'kind = "matrix"' 'table = "step_cells"' 'rows = "step_rows"' 'row_key = "step_id"' 'columns = "devices"' 'column_key = "device_id"'; do
	echo "$view" | grep -qxF "$want" || fail "the steps view does not say $want"
done
grep -q 'bin/face-steps' bin/face-data && grep -q 'step_lead.txt' bin/face-data || fail "bin/face-data does not run face-steps and join its headline to the view"
echo "PASS: the face's steps view: $steps step rows in chain order by stage, a cell for each of $ndev devices ($(echo $devices | tr ' ' ',')) with its claim, proof and run, and the headline counts of the three goals"

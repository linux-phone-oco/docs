#!/bin/sh
# The guidebook is a page rendered from the bring-up rows (backlog bringup-guidebook, decision
# 2026-11-18-bringup-steps-generic-in-docs-status-in-each-base, 5): docs/guidebook.md has a chapter per stage in the
# stages' order, each step once under the chapter of its stage in the order bringup-chain gives, every need and every
# step it enables linked off the edges, the gap shown where a step has no helper, and a world gap marked in a line of
# its own. That the page says what the rows say, word for word, is make verify's freshness check (it renders again and
# compares). Reads only what make render wrote; run by make verify.
#   test-bringup-pages.sh
set -eu
cd "$(dirname "$0")/.."
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
fail() { echo "FAIL: $*" >&2; exit 1; }
q() { tad sql "$1" --format csv > "$tmp/q.csv" && tail -n +2 "$tmp/q.csv"; }
g=docs/guidebook.md
[ -f "$g" ] || fail "no $g: make render writes it from bringup_steps"
steps=$(q "SELECT count(*) FROM bringup_steps")
[ "$(grep -c '^<a id="step-' "$g")" = "$steps" ] || fail "$g does not hold each of the $steps steps once"
for id in $(q "SELECT id FROM bringup_steps ORDER BY id"); do
	[ "$(grep -c "^<a id=\"step-$id\"></a>\$" "$g")" = 1 ] || fail "$g does not hold the step $id once"
done
# the chapters, in the stages' order
want=$(q "SELECT 'stage-' || id FROM bringup_stages ORDER BY ord" | tr '\n' ' ')
got=$(grep -o '^<a id="stage-[a-z0-9-]*"></a>$' "$g" | sed 's/^<a id="//; s/"><\/a>$//' | tr '\n' ' ')
[ "$want" = "$got" ] || fail "the chapters are not the stages in their order: want $want, got $got"
# a step stands in the chapter of its stage
q "SELECT stage || ' ' || id FROM bringup_steps ORDER BY stage, ord, id" | while read -r first second; do
	stage=$first; id=$second
	awk -v s="stage-$stage" -v i="step-$id" '/^<a id="stage-/ { cur = $0; sub(/^<a id="/, "", cur); sub(/".*/, "", cur) } $0 == "<a id=\"" i "\"></a>" { exit cur != s ? 1 : 0 }' "$g" || fail "step $id is not under the chapter of its stage $stage"
done
# the steps run in the chain's order within each chapter
tad q bringup-chain --format csv > "$tmp/chain.csv"
: > "$tmp/want"
for stage in $(q "SELECT id FROM bringup_stages ORDER BY ord"); do
	awk -F, -v s="$stage" 'NR > 1 && $3 == s { print "step-" $2 }' "$tmp/chain.csv" >> "$tmp/want"
done
grep -o '^<a id="step-[a-z0-9-]*"></a>$' "$g" | sed 's/^<a id="//; s/"><\/a>$//' > "$tmp/got"
cmp -s "$tmp/want" "$tmp/got" || fail "the steps are not in the order of bringup-chain within their chapters"
# every need and every enabled step of a step is a link, read off the edges
q "SELECT step || ' ' || requires FROM bringup_step_edges ORDER BY step, requires" | while read -r first second; do
	step=$first; req=$second
	awk -v i="step-$step" -v n="[$req](#step-$req)" '$0 == "<a id=\"" i "\"></a>" { on = 1; next } on && /^<a id="/ { exit 1 } on && /^- \*\*Enables/ { exit 1 } on && index($0, n) { found = 1 } END { exit !found }' "$g" || fail "step $step does not link its need $req"
	awk -v i="step-$req" -v n="[$step](#step-$step)" '$0 == "<a id=\"" i "\"></a>" { on = 1; next } on && /^<a id="/ { on = 0 } on && /^- \*\*Enables/ && index($0, n) { found = 1 } END { exit !found }' "$g" || fail "step $req does not link $step as enabled by it"
done
# a step with no helper shows the gap, one with a helper shows it
[ "$(grep -c '^- \*\*Helper:\*\* no helper yet' "$g")" = "$(q "SELECT count(*) FROM bringup_steps WHERE helper IS NULL")" ] || fail "the steps with no helper do not all show the gap"
# the world gaps the guides name are marked
[ "$(grep -c '^\*\*World gap\*\*' "$g")" = "$(q "SELECT count(*) FROM bringup_steps WHERE guide LIKE '%World gap%'")" ] || fail "the steps that name a world gap are not all marked"
# the graph page's data: docs/graph/bringup.json holds every step, every edge, every device and every device's step
# status of the rows (backlog bringup-graph-page): the steps with what the page shows of them, the edges with kind and
# group, the devices read off the devices table (a device added later gets its tab), the status claims as they stand
j=docs/graph/bringup.json
[ -f "$j" ] || fail "no $j: make render writes it from the bring-up rows"
jq -e . "$j" > /dev/null || fail "$j is not JSON"
for part in steps edges devices status; do
	[ "$(jq -r "has(\"$part\")" "$j")" = true ] || fail "$j has no $part"
done
# each part is the rows as lines, compared whole: a step, an edge, a device or a claim missing, extra or changed fails
same() { # NAME, what the rows give, what the json gives
	[ "$2" = "$3" ] && return 0
	printf '%s\n' "$2" > "$tmp/rows.lines"; printf '%s\n' "$3" > "$tmp/json.lines"
	fail "$j does not hold the $1 of the rows: $(diff "$tmp/rows.lines" "$tmp/json.lines" | head -5 | tr '\n' ' ')"
}
# every status the claims carry is one the page draws a colour for
for s in $(jq -r '.status[].status' "$j" | sort -u); do
	grep -q "'$s'\|\b$s:" docs/graph.html || fail "docs/graph.html names no colour for the status $s"
done
same steps "$(tad sql "SELECT id, title, stage, done_when, proof, guide FROM bringup_steps ORDER BY id" --format json | jq -c '.[]')" \
	"$(jq -c '.steps | sort_by(.id)[] | {id, title, stage, done_when, proof, guide}' "$j")"
same edges "$(tad sql "SELECT step, requires, kind, \"group\" FROM bringup_step_edges ORDER BY step, requires" --format json | jq -c '.[]')" \
	"$(jq -c '.edges | sort_by(.step, .requires)[] | {step, requires, kind, group}' "$j")"
same devices "$(tad sql "SELECT id, name, codename FROM devices ORDER BY id" --format json | jq -c '.[]')" \
	"$(jq -c '.devices | sort_by(.id)[] | {id, name, codename}' "$j")"
same status "$(tad sql "SELECT device_id, step_id, status FROM step_status ORDER BY device_id, step_id" --format json | jq -c '.[]')" \
	"$(jq -c '.status | sort_by(.device_id, .step_id)[] | {device_id, step_id, status}' "$j")"
# the page that draws it reads that file, left to right, at pinned versions, a tab per device and the generic one
p=docs/graph.html
[ -f "$p" ] || fail "no $p"
grep -q 'graph/bringup.json' "$p" || fail "$p does not fetch graph/bringup.json"
grep -q "rankDir: 'LR'" "$p" || fail "$p does not lay the graph out left to right"
grep -Eq 'cytoscape@[0-9]+\.[0-9]+\.[0-9]+' "$p" && grep -Eq 'cytoscape-dagre@[0-9]+\.[0-9]+\.[0-9]+' "$p" && grep -Eq 'dagre@[0-9]+\.[0-9]+\.[0-9]+' "$p" || fail "$p does not pin the versions of cytoscape, dagre and cytoscape-dagre"
grep -q 'generic' "$p" || fail "$p has no generic tab"
echo "PASS: $g has the $steps steps in $(q "SELECT count(*) FROM bringup_stages") chapters, each with its needs and what they enable, its proof, helper or gap, guide; world gaps marked"

#!/bin/sh
# A fixture for the graph page at scale (backlog bringup-graph-page; the catalogue will pass a thousand steps): N steps
# (default 1500) in the shape of face/graph/bringup.json - stages, steps, edges (a few soft, a few alternatives of one
# group), two devices with a claim on every step, and the three goal steps - deterministic, so a measurement can be
# repeated. It is a test file, never data: serve it in place of face/graph/bringup.json and read the layout time the page
# shows. The steps go in an order where each needs earlier ones, so the graph is acyclic by construction.
#   bin/graph-fixture.sh [N] > fixture.json
set -eu
[ "${1:-1500}" -le 9999 ] || { echo "graph-fixture: at most 9999 steps (the ids are four digits)" >&2; exit 1; }
jq -n -c --argjson n "${1:-1500}" '
	def sid($i): "s" + ($i | tostring | ("0000" + .)[-4:]);
	25 as $stages
	| [range(0; $stages) | {id: ("stage-" + (. | tostring)), title: ("Stage " + (. | tostring)), ord: (. + 1)}] as $st
	| [range(0; $n) as $i | {id: sid($i), title: ("Step " + ($i | tostring) + " of the fixture, a title about as long as a real one"),
		stage: $st[($i * $stages / $n | floor)].id, done_when: "it is done", proof: "a-test", guide: "how it is done"}] as $steps
	| [range(1; $n) as $i | range(0; 2 + ($i % 3)) as $k
		| {step: sid($i), requires: sid([($i - 1 - (($i * 7 + $k * 13) % 40)), 0] | max), kind: (if ($i + $k) % 11 == 0 then "soft" else "hard" end),
			group: (if $k == 1 and $i % 29 == 0 then "alt-" + ($i | tostring) else null end)}]
		| unique_by([.step, .requires]) | map(select(.step != .requires)) as $base
	| [{id: "linux-runs", title: "Linux runs", stage: "goals", done_when: "all needs done", proof: "chain", guide: "the first goal"},
		{id: "daily-usable-phone", title: "A daily-usable phone", stage: "goals", done_when: "all needs done", proof: "chain", guide: "the second goal"},
		{id: "complete-phone", title: "A complete phone", stage: "goals", done_when: "all needs done", proof: "chain", guide: "the last goal"}] as $goals
	| def goal_edges($g; $from; $to; $by): [range($from; $to; $by) | {step: $g, requires: sid(.), kind: "hard", group: null}];
	{stages: ($st + [{id: "goals", title: "Goals", ord: 26}]),
	 steps: ($steps + $goals),
	 edges: ($base + goal_edges("linux-runs"; 0; ($n * 6 / 10 | floor); ($n / 60 | floor | [., 1] | max))
		+ [{step: "daily-usable-phone", requires: "linux-runs", kind: "hard", group: null}]
		+ goal_edges("daily-usable-phone"; ($n / 2 | floor); $n; ($n / 80 | floor | [., 1] | max))
		+ [{step: "complete-phone", requires: "daily-usable-phone", kind: "hard", group: null}]
		+ goal_edges("complete-phone"; ($n * 9 / 10 | floor); $n; ($n / 100 | floor | [., 1] | max))),
	 devices: [{id: "fixture-a", name: "Fixture phone A", codename: "a"}, {id: "fixture-b", name: "Fixture phone B", codename: "b"}],
	 status: [(["fixture-a", "fixture-b"] | to_entries[]) as $d | range(0; $n) as $i
		| {device_id: $d.value, step_id: sid($i), status: (["done", "done", "partial", "open", "unknown", "failing"][($i * 7 + $d.key * 2) % 6])}]}'

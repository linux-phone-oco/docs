#!/bin/sh
# The record of work, read off the commits: every commit on the main of each place of the family since the
# last glimpse it kept (glimpses ended on 2026-11-17: the commits and pull requests are the record now), as a
# row of landings - who signed it (its co-author: the name a session works under, devlab; else its author),
# where, when, and its title. Added to what was observed, for the face's "where each hand stands".
#   bin/landings.sh DATA_DIR      (gh, with GH_TOKEN; jq)
set -eu
data=${1:?usage: bin/landings.sh DATA_DIR}
since=$(jq -rs '[.[].at | select(. != null)] | max // "2026-11-17T00:00:00Z"' "$data/landings.json" 2>/dev/null || echo "2026-11-17T00:00:00Z")
for place in $(jq -r 'select(.id | startswith("linux-phone-oco/")) | .id' "$data/projects.json"); do
	gh api "repos/$place/commits?since=$since&per_page=100" | jq -c --arg place "$place" --arg since "$since" '
		.[] | (.commit.message | split("\n")) as $lines
		| [$lines[] | capture("^Co-authored-by: (?<name>[^<]+?) <(?<mail>[^>]*)>$"; "i")] as $all
		| ([$all[] | select(.mail | test("noreply@anthropic\\.com|users\\.noreply\\.github\\.com") | not)
			| select(.name != "lab-agent-session") | .name] | first) as $co
		# a commit with co-authors is signed by them; one with none, by its author (a person, by hand)
		| (if ($all | length) > 0 then $co elif (.author.type // "") == "Bot" then null else .commit.author.name end) as $by
		| select($by != null and .commit.committer.date > $since)
		| {id: .sha[0:12], project: $place, by: $by, at: .commit.committer.date,
		   kind: (($lines[0] | capture("^(?<k>[a-z]+)(\\([^)]*\\))?!?:") | .k) // "change"),
		   summary: ($lines[0] | sub(" \\(#[0-9]+\\)$"; "") | sub("^[a-z]+(\\([^)]*\\))?!?: "; ""))}'
done >> "$data/landings.json"

#!/bin/sh
# graph-drift: does every edge of linux-phone-oco's repository graph carry what its source gives, in both directions,
# with something that moves it and something that says when it has not? Written failing, 2026-11-18 (research
# base-graph-measured, decision 2026-11-18-device-layer-from-docs). Reads git refs of the clones under PROJECTS
# (default ~/Projects, each fetched by the caller or with FETCH=1) and, for the forks and releases, gh and
# git ls-remote. Changes nothing.
#   graph-drift.sh [PROJECTS]
# Prints one line per edge check, FAIL or ok; ends 1 when any FAIL, 2 when a clone is missing.
#
# Checks, each named in its line:
#   slice-pin     a base pins idealkb's latest release (the hourly job moves it)
#   own-behind    a file a base keeps as its own (own = [...]) is the source's at the pin, or an upstream item of the
#                 base names it: a change made below is on its way up, a change made above is not silently missed
#   own-part      a base whose tables.toml is its own still carries the source's marked part as the pin gives it
#   layer-pin     a device base pins its device layer by a release, not a date
#   layer-owner   the tables a docs feed reads from the device bases (parts) are given to them by docs itself, so a
#                 change of the contract is one change in one repository
#   layer-follow  every table a device base declares is its own or in a marked part a source gives
#   tool-pin      lab.toml pins the lpoco family at its latest release, or names why it holds
#   tad-pin       a base that installs tad pins its latest release, and tad's pin job lists the base
#   fork-track    a fork's tracking branch is its upstream's head
set -eu
P=${1:-$HOME/Projects}
LP=$P/linux-phone-oco
KB=$P/grenudi/ideal-knowledge-base
fail=0
tmp=$(mktemp); trap 'rm -f "$tmp"' EXIT
say() { echo "$*"; case $1 in FAIL) fail=1 ;; esac; }
need() { [ -d "$1" ] || { echo "graph-drift: no clone at $1" >&2; exit 2; }; }
show() { git -C "$1" show "${3:-origin/main}:$2" 2>/dev/null; }
for d in "$KB" "$LP/docs" "$LP/device-template" "$LP/surya-lab" "$LP/google-walleye-lab" "$LP/lab-tools" "$P/lab-machine" \
	"$P/creation-guidelines/tad-engine"; do
	need "$d"; [ "${FETCH:-0}" = 1 ] && git -C "$d" fetch -q --tags origin
done
latest_kb=$(git -C "$KB" tag -l 'v*' --sort=-v:refname | head -1 | sed 's/^v//')
part() { awk -v m="$1" '$0 ~ (m ":begin") { on = 1 } on && !/^[[:space:]]*#/ { print } $0 ~ (m ":end") { on = 0 }'; }
items() { show "$1" data/upstream_items.json | jq -r '[.id, .title, (.note // ""), (.local_ref // ""), (.file // "")] | join(" ")' 2>/dev/null; }

# idealkb -> each base: the slice, and what each base keeps as its own
for b in docs device-template surya-lab google-walleye-lab; do
	r=$LP/$b
	pin=$(show "$r" idealkb.toml | sed -n 's/^version = "\(.*\)"$/\1/p')
	if [ "$pin" = "$latest_kb" ]; then say ok "$b slice-pin: idealkb $pin"; else say FAIL "$b slice-pin: idealkb $pin, latest $latest_kb"; fi
	own=$(show "$r" idealkb.toml | sed -n 's/^own = \[\(.*\)\]$/\1/p' | tr -d '" ' | tr ',' ' ')
	carried=$(items "$r")
	for f in $own; do
		if [ "$f" = tables.toml ]; then
			want=$(show "$KB" tables.toml "v$pin" | part idealkb); have=$(show "$r" tables.toml | part idealkb)
			if [ -z "$have" ]; then say FAIL "$b own-part: tables.toml carries no idealkb part; nothing new of idealkb's tables reaches it"
			elif [ "$want" != "$have" ]; then
				printf '%s\n' "$have" > "$tmp"
				n=$(printf '%s\n' "$want" | diff - "$tmp" | grep -c '^<' || true)
				say FAIL "$b own-part: tables.toml's idealkb part lacks or differs in $n lines of idealkb $pin's"
			else say ok "$b own-part: tables.toml's idealkb part is idealkb $pin's"; fi
			continue
		fi
		if [ "$(show "$KB" "$f" "v$pin")" = "$(show "$r" "$f")" ]; then say ok "$b own-behind: $f is idealkb $pin's"
		elif printf '%s\n' "$carried" | grep -qF "$f"; then say ok "$b own-behind: $f differs, and an upstream item carries it"
		else say FAIL "$b own-behind: $f differs from idealkb $pin's and no upstream item names it - neither goes up nor comes down"; fi
	done
done

# the device layer: who gives it, by what pin, and whether its contract has one home
docs_tables=$(show "$LP/docs" tables.toml | grep -oE '^\[tables\.[a-z_]+\]' | tr -d '[]' | sed 's/^tables\.//')
tpl_part=$(show "$LP/device-template" tables.toml | part template | grep -oE '^\[tables\.[a-z_]+\]' | tr -d '[]' | sed 's/^tables\.//' || true)
kb_tables=$(show "$KB" tables.toml "v$latest_kb" | part idealkb | grep -oE '^\[tables\.[a-z_]+\]' | tr -d '[]' | sed 's/^tables\.//')
for b in surya-lab google-walleye-lab device-template; do
	r=$LP/$b
	src=$(show "$r" devicebase.toml | sed -n 's/^source = "\(.*\)"$/\1/p'); src=${src:-linux-phone-oco/device-template}
	ver=$(show "$r" devicebase.toml | sed -n 's/^\(version\|template\) = "\([^"]*\)".*$/\2/p' | head -1)
	if printf '%s' "$ver" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then say ok "$b layer-pin: $src $ver"
	else say FAIL "$b layer-pin: the device layer is pinned as \"$ver\" - a date, no release of $src; nothing follows it"; fi
	if [ "$src" = linux-phone-oco/docs ]; then say ok "$b layer-owner: the parts contract comes from docs, which reads it"
	else say FAIL "$b layer-owner: parts is declared by $src and read by docs (records/feed-device-parts.sql): one contract, two repositories"; fi
	for t in $(show "$r" tables.toml | grep -oE '^\[tables\.[a-z_]+\]' | tr -d '[]' | sed 's/^tables\.//'); do
		printf '%s\n%s\n' "$kb_tables" "$tpl_part" | grep -qxF "$t" && continue
		case $t in devices | parts | test_runs | test_results | steps)
			say FAIL "$b layer-follow: table $t is the device layer's, in no marked part any source gives - carried by hand" ;;
		esac
	done
done
: "$docs_tables"

# lab-tools -> the lab machine: the tool pin
lp=$(show "$P/lab-machine" lab.toml | sed -n 's/^lpoco = "\(.*\)"$/\1/p')
ll=$(git -C "$LP/lab-tools" tag -l 'lpoco-v*' --sort=-v:refname | head -1 | sed 's/^lpoco-v//')
if [ "$lp" = "$ll" ]; then say ok "lab-machine tool-pin: lpoco $lp"
else say FAIL "lab-machine tool-pin: lab.toml pins lpoco $lp, latest $ll; no job moves this pin and no line says why it holds"; fi

# tad -> every base that installs it
tl=$(gh release list -R creation-guidelines/tad-engine --limit 10 --exclude-drafts --json tagName -q '[.[].tagName | select(startswith("tad-v"))] | first' | sed 's/^tad-v//')
cons=$(show "$P/creation-guidelines/tad-engine" consumers | grep -vE '^[[:space:]]*(#|$)')
for b in docs device-template surya-lab google-walleye-lab; do
	tv=$(show "$LP/$b" bin/install-tad.sh | sed -n 's/^version="${TAD_VERSION:-\(.*\)}"$/\1/p')
	if [ "$tv" = "$tl" ]; then say ok "$b tad-pin: tad $tv"; else say FAIL "$b tad-pin: CI installs tad $tv, latest $tl"; fi
	printf '%s\n' "$cons" | grep -qxF "linux-phone-oco/$b" || say FAIL "$b tad-pin: tad's pin job does not list it (tad-engine consumers) - its pin is moved by hand"
done

# upstream -> our forks: the tracking branch
s_up=$(git ls-remote https://git.sr.ht/~mil/sxmo-utils refs/heads/master | cut -f1)
s_us=$(gh api repos/grenudi/sxmo-utils/branches/master --jq .commit.sha)
if [ "$s_up" = "$s_us" ]; then say ok "grenudi/sxmo-utils fork-track: master is sr.ht's"
else
	n=$(gh api "repos/grenudi/sxmo-utils/compare/$s_us...$s_up" --jq .ahead_by 2>/dev/null || echo "?")
	say FAIL "grenudi/sxmo-utils fork-track: master is $n commits behind sr.ht's master; no job fetches it"
fi
k_up=$(gh api repos/sm7150-mainline/linux --jq .default_branch)
st=$(gh api "repos/grenudi/linux/compare/$(gh api repos/grenudi/linux --jq .default_branch)...sm7150-mainline:linux:$k_up" --jq .status 2>/dev/null || echo unknown)
case $st in identical) say ok "grenudi/linux fork-track: default branch is sm7150-mainline's $k_up" ;;
*) say FAIL "grenudi/linux fork-track: default branch is $st against sm7150-mainline's $k_up" ;; esac
exit $fail

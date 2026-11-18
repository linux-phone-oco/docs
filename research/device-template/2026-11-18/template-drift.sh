#!/bin/sh
# template-drift: does each lab carry device-template's generic parts as the template gives them, and does the
# template say which of its files are followed and which are made once? Written failing, 2026-11-18 (research
# device-template-drift-measured, decision 2026-11-18-device-template-follows-by-release). Reads only git refs.
#   template-drift.sh TEMPLATE IDEALKB LAB...     clones; each read at $REF (default origin/main)
# Prints one line per finding, FAIL or ok; ends 1 when any FAIL, 2 on a wrong call. Changes nothing.
#
# Checks, each named in its FAIL line:
#   classified    every template file (outside data/ and docs/) is idealkb's generic, the template's generic, or
#                 named in the template's made-once list (laid at creation, then the lab's own)
#   one-source    no file is claimed both by idealkb's generic (at the template's idealkb pin) and the template's
#   pin           the lab's devicebase.toml names a template release (template = "X.Y.Z"), not a date
#   equal         each file of the template's generic, at the lab's pinned release, is the lab's byte for byte
#                 (a file the lab names in own = [...] of devicebase.toml is its own and skipped)
#   no-copy       the lab carries no stale copy of the template's generic list
set -eu
[ $# -ge 3 ] || { echo "usage: template-drift.sh TEMPLATE IDEALKB LAB..." >&2; exit 2; }
ref=${REF:-origin/main}
tpl=$1; kb=$2; shift 2
fail=0
say() { echo "$*"; case $1 in FAIL) fail=1 ;; esac; }
show() { git -C "$1" show "$2:$3" 2>/dev/null; }
list() { grep -vE '^[[:space:]]*(#|$)' | sed 's/[[:space:]]*#.*$//'; }
blob() { git -C "$1" rev-parse -q --verify "$2:$3" 2>/dev/null || true; }
tname=$(basename "$tpl")

kbpin=$(show "$tpl" "$ref" idealkb.toml | sed -n 's/^version = "\(.*\)"$/\1/p')
kbgen=$(show "$kb" "v$kbpin" generic | list) || { echo "no idealkb release v$kbpin in $kb" >&2; exit 2; }
tgen=$(show "$tpl" "$ref" generic | list)
tonce=$(show "$tpl" "$ref" made-once | list || true)

# classified
n=0
for f in $(git -C "$tpl" ls-tree -r --name-only "$ref" | grep -vE '^(data|docs)/'); do
	if printf '%s\n%s\n%s\n' "$kbgen" "$tgen" "$tonce" | grep -qxF "$f"; then continue; fi
	say FAIL "$tname classified: $f is neither generic (idealkb's, the template's) nor made once"; n=$((n + 1))
done
[ "$n" -gt 0 ] || say ok "$tname classified: every file is followed or made once"

# one-source
n=0
for f in $tgen; do
	if printf '%s\n' "$kbgen" | grep -qxF "$f"; then
		say FAIL "$tname one-source: $f is in both idealkb $kbpin's generic and the template's"; n=$((n + 1))
	fi
done
[ "$n" -gt 0 ] || say ok "$tname one-source: no file has two sources"

for lab in "$@"; do
	name=$(basename "$lab")
	pin=$(show "$lab" "$ref" devicebase.toml | sed -n 's/^template = "\([^"]*\)".*$/\1/p')
	at=$ref
	if printf '%s' "$pin" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$' && git -C "$tpl" rev-parse -q --verify "v$pin^{commit}" >/dev/null; then
		at="v$pin"; say ok "$name pin: template $pin"
	else
		say FAIL "$name pin: devicebase.toml names template = \"$pin\", not a release of the template (compared with its $ref)"
	fi
	own=$(show "$lab" "$ref" devicebase.toml | sed -n 's/^own = \[\(.*\)\]$/\1/p' | tr -d '" ' | tr ',' ' ')
	n=0; m=0
	for f in $(show "$tpl" "$at" generic | list); do
		case " $own " in *" $f "*) continue ;; esac
		m=$((m + 1))
		want=$(blob "$tpl" "$at" "$f"); have=$(blob "$lab" "$ref" "$f")
		if [ -z "$have" ]; then say FAIL "$name equal: $f is missing"; n=$((n + 1))
		elif [ "$want" != "$have" ]; then say FAIL "$name equal: $f differs from the template's"; n=$((n + 1))
		fi
	done
	[ "$n" -gt 0 ] || say ok "$name equal: $m generic files as the template gives them"
	have=$(blob "$lab" "$ref" generic)
	if [ -n "$have" ] && [ "$have" != "$(blob "$tpl" "$at" generic)" ]; then
		say FAIL "$name no-copy: it carries a copy of the template's generic list that differs from the template's"
	else
		say ok "$name no-copy: no stale copy of the list"
	fi
done
exit $fail

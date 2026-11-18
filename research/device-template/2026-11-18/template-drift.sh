#!/bin/sh
# template-drift: does the template say, of each file it has, whether it is followed or made once? Written failing,
# 2026-11-18 (research device-template-drift-measured); reshaped the same day to decision
# 2026-11-18-device-layer-from-docs: the template follows docs' device layer like any base, so a followed file is one
# a `generic` list names - idealkb's, at the release its idealkb.toml pins, or docs', at the release its
# devicebase.toml pins (read from the folder #! from = names) - and the rest is named in its `made-once` list.
# Reads only git refs. The lab checks (pin, equal, no-copy) are graph-drift.sh's.
#   template-drift.sh TEMPLATE IDEALKB DOCS      clones; the template read at $REF (default origin/main)
# Prints one line per finding, FAIL or ok; ends 1 when any FAIL, 2 on a wrong call. Changes nothing.
#
# Checks, each named in its FAIL line:
#   classified    every template file (outside data/ and docs/) is in idealkb's generic, docs' generic, or the template's
#                 made-once list (laid at creation, then the base's own)
#   one-source    no file has two sources: none is both made once and followed, none in both generics (a file both
#                 hold a marked part of - AGENTS.md, tables.toml - is shared part by part, ideal-knowledge-base's
#                 bin/check-one-owner.sh)
set -eu
[ $# -eq 3 ] || { echo "usage: template-drift.sh TEMPLATE IDEALKB DOCS" >&2; exit 2; }
ref=${REF:-origin/main}
tpl=$1; kb=$2; docs=$3
fail=0
say() { echo "$*"; case $1 in FAIL) fail=1 ;; esac; }
show() { git -C "$1" show "$2:$3" 2>/dev/null; }
list() { grep -vE '^[[:space:]]*(#|$)' | sed 's/[[:space:]]*#.*$//'; }
tname=$(basename "$tpl")

kbpin=$(show "$tpl" "$ref" idealkb.toml | sed -n 's/^version = "\(.*\)"$/\1/p')
docspin=$(show "$tpl" "$ref" devicebase.toml | sed -n 's/^version = "\(.*\)"$/\1/p')
[ -n "$kbpin" ] && [ -n "$docspin" ] || { echo "the template pins no idealkb.toml / devicebase.toml version at $ref" >&2; exit 2; }
git -C "$kb" rev-parse -q --verify "v$kbpin^{commit}" >/dev/null || { echo "no idealkb release v$kbpin in $kb" >&2; exit 2; }
git -C "$docs" rev-parse -q --verify "v$docspin^{commit}" >/dev/null || { echo "no docs release v$docspin in $docs" >&2; exit 2; }
kbgen=$(show "$kb" "v$kbpin" generic | list)
docsgen=$(show "$docs" "v$docspin" generic | list)
[ -n "$docsgen" ] || { echo "docs v$docspin has no generic list: no device layer" >&2; exit 2; }
tonce=$(show "$tpl" "$ref" made-once | list)

# classified
n=0
for f in $(git -C "$tpl" ls-tree -r --name-only "$ref" | grep -vE '^(data|docs)/'); do
	if printf '%s\n%s\n%s\n' "$kbgen" "$docsgen" "$tonce" | grep -qxF "$f"; then continue; fi
	say FAIL "$tname classified: $f is neither followed (idealkb $kbpin's, docs $docspin's) nor made once"; n=$((n + 1))
done
[ "$n" -gt 0 ] || say ok "$tname classified: every file is followed or made once"

# one-source
n=0
for f in $tonce; do
	if printf '%s\n%s\n' "$kbgen" "$docsgen" | grep -qxF "$f"; then
		say FAIL "$tname one-source: $f is made once and followed"; n=$((n + 1))
	fi
done
for f in $docsgen; do
	case $f in AGENTS.md | tables.toml) continue ;; esac
	if printf '%s\n' "$kbgen" | grep -qxF "$f"; then say FAIL "$tname one-source: $f is in both idealkb $kbpin's generic and docs $docspin's"; n=$((n + 1)); fi
done
[ "$n" -gt 0 ] || say ok "$tname one-source: no file has two sources"
exit $fail

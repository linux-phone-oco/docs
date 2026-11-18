#!/bin/sh
# The device layer docs gives to every device base is whole: the `generic` list at the root names the files of
# device-layer/ and nothing else is there, it says which pin file, marker and folder a base follows it by, the
# `consumers` list names the bases, and the marked part of device-layer/tables.toml is a valid tables.toml of its
# own (the four tables a docs feed reads from a device base). Reads only; run by make verify. That no file is also
# idealkb's is checked where both are known: idealkb's bin/check-one-owner.sh, run by its bin/update-pins.sh.
#   check-device-layer.sh
set -eu
cd "$(dirname "$0")/.."
[ -f generic ] || { echo "check-device-layer: no generic list at the root" >&2; exit 1; }
bad=0
fail() { echo "check-device-layer: $*" >&2; bad=1; }
header() { sed -n "s/^#! $1 = //p" generic; }
list=$(grep -vE '^[[:space:]]*(#|$)' generic || true)
[ -n "$list" ] || fail "generic names no file"
[ "$(header pin)" = devicebase.toml ] || fail "generic: '#! pin = ' is not devicebase.toml"
[ "$(header marker)" = device ] || fail "generic: '#! marker = ' is not device"
[ "$(header from)" = device-layer/ ] || fail "generic: '#! from = ' is not device-layer/"
[ -z "$(printf '%s\n' "$list" | sort | uniq -d)" ] || fail "generic names a file twice"
for f in $list; do [ -f "device-layer/$f" ] || fail "generic names $f, device-layer/$f is not there"; done
for f in $(cd device-layer && find . -type f ! -name README.md | sed 's|^\./||' | sort); do
	printf '%s\n' "$list" | grep -qxF "$f" || fail "device-layer/$f is not named by generic: nothing lays it"
done
consumers=$(grep -vE '^[[:space:]]*(#|$)' consumers || true)
[ -n "$consumers" ] || fail "consumers names no OWNER/REPO"
for c in $consumers; do
	printf '%s\n' "$c" | grep -qE '^[A-Za-z0-9._-]+/[A-Za-z0-9._-]+$' || fail "consumers: '$c' is not OWNER/REPO"
done
marker=device
t=device-layer/tables.toml
if [ "$(grep -c "$marker:begin" "$t")" = 1 ] && [ "$(grep -c "$marker:end" "$t")" = 1 ]; then :
else fail "$t has not exactly one $marker:begin and one $marker:end"; fi
tables=$(grep -oE '^\[tables\.[a-z_]+\]' "$t" | tr -d '[]' | sed 's/^tables\.//' | tr '\n' ' ')
[ "$tables" = "devices parts test_runs test_results " ] || fail "$t declares: $tables(want devices parts test_runs test_results)"
# the part, alone, is a tables.toml that tad accepts
scratch=$(mktemp -d); trap 'rm -rf "$scratch"' EXIT
mkdir "$scratch/data"
{ echo "[tables]"; awk -v m="$marker" '$0 ~ (m ":begin") { on = 1 } on { print } $0 ~ (m ":end") { on = 0 }' "$t"; } > "$scratch/tables.toml"
(cd "$scratch" && tad check > out 2>&1) || { cat "$scratch/out" >&2; fail "tad does not accept the marked part of $t on its own"; }
[ "$bad" = 0 ] && echo "check-device-layer: $(echo "$list" | wc -l | tr -d ' ') files, 4 tables, $(echo "$consumers" | wc -l | tr -d ' ') consumers"
exit $bad

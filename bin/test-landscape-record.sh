#!/bin/sh
# tad r landscape records a project or effort of the landscape (a row of that id is replaced): it makes one row, a
# second record of the id replaces it, and a link that is not https:// is refused, in a scratch copy of docs
# (docs' own data is not touched). Run by make verify.
#   test-landscape-record.sh
set -eu
cd "$(dirname "$0")/.."
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
fail() { echo "FAIL: $*" >&2; exit 1; }
tar -c --exclude=.git . | tar -x -C "$tmp"
cd "$tmp"
n=$(wc -l < data/landscape.json)
tad r landscape --id landscape-probe --name "UBports device data" --effort UBports --what "Per-device feature ticks and progress stages." \
	--for-us "The only stage order kept as data; we take its stages, not its percent." --link https://devices.ubuntu-touch.io --checked 2026-11-18 > /dev/null \
	|| fail "no record landscape, or it refused a whole row"
[ "$(wc -l < data/landscape.json)" = "$((n + 1))" ] || fail "the record did not add one row"
[ "$(jq -r 'select(.id == "landscape-probe") | .project + "|" + .link + "|" + .checked' data/landscape.json)" = "UBports|https://devices.ubuntu-touch.io|2026-11-18" ] || fail "the row is not what was recorded"
tad r landscape --id landscape-probe --name "UBports device data" --effort UBports --what "again" --for-us "again" --link https://devices.ubuntu-touch.io > /dev/null || fail "a second record of the id was refused"
[ "$(wc -l < data/landscape.json)" = "$((n + 1))" ] || fail "recording the id again added a row instead of replacing it"
if tad r landscape --id bad-link --name x --effort x --what x --for-us x --link http://example.org > /dev/null 2>&1; then fail "a link that is not https:// was accepted"; fi
[ "$(wc -l < data/landscape.json)" = "$((n + 1))" ] || fail "a refused record left a row"
tad check > /dev/null || fail "the rows do not check"
echo "PASS: tad r landscape records one row, replaces it by id and refuses a link that is not https"

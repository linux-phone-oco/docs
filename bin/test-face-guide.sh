#!/bin/sh
# The front page of the face reaches the bring-up pages: face/lens.toml has a view guide, a page of cards over
# face/guide-pages.json (bin/face-data puts it with the face's data), and each card's link goes to a page that exists -
# a view of this lens, or a page tad or bin/render-pages.sh renders under docs/ (the site serves docs/ as /tables/).
# The cards name the guidebook, the steps table, the step claims and the steps view. Reads only; run by make verify.
#   test-face-guide.sh
set -eu
cd "$(dirname "$0")/.."
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
fail() { echo "FAIL: $*" >&2; exit 1; }
view=$(awk '/^\[\[view\]\]/ { if (on) exit; blk = "" } { blk = blk $0 "\n" } /^id = "guide"$/ { on = 1 } END { if (on) printf "%s", blk }' face/lens.toml)
[ -n "$view" ] || fail "face/lens.toml has no view guide"
for want in 'kind = "cards"' 'table = "guide_pages"' 'title_field = "title"' 'text_field = "what"' 'link_field = "link"'; do
	echo "$view" | grep -qxF "$want" || fail "the guide view does not say $want"
done
[ -f face/guide-pages.json ] || fail "no face/guide-pages.json"
grep -v '^#' bin/face-data | grep -q 'face/guide-pages.json.*guide_pages.json' || fail "bin/face-data does not put face/guide-pages.json with the face's data as guide_pages.json"
n=0
while IFS= read -r row || [ -n "$row" ]; do
	n=$((n + 1))
	link=$(printf '%s\n' "$row" | jq -r '.link')
	for f in title what link; do
		[ -n "$(printf '%s\n' "$row" | jq -r ".$f // empty")" ] || fail "card $n has no $f"
	done
	case $link in
		../../tables/*.html) page=docs/$(basename "$link" .html).md; [ -f "$page" ] || fail "card $n links $link, but $page is not rendered" ;;
		*/*) fail "card $n links $link: neither a view nor a page under the tables" ;;
		*.html) id=$(basename "$link" .html); grep -qx "id = \"$id\"" face/lens.toml || fail "card $n links the view $id, which the lens does not have" ;;
		*) fail "card $n links $link: neither a view nor a page under the tables" ;;
	esac
	echo "$link"
done < face/guide-pages.json > "$tmp/links"
for want in ../../tables/guidebook.html ../../tables/bringup_steps.html ../../tables/step_status.html steps.html; do
	grep -qxF "$want" "$tmp/links" || fail "no card links $want"
done
echo "PASS: the face's guide view has $n cards: the guidebook, the steps table, the step claims and the steps view, each link to a page that exists"

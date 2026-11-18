#!/bin/sh
# workarounds-read.sh - the failing check of decision 2026-11-18-workarounds-read-as-one: a workaround, a script's
# line or a lane's rule, reads one way - where it stands, its item, the item's state, its way out - read by
# ideal-agent's scripts/workarounds from the bases that hold the items. It fails until backlog
# workarounds-reader-items-and-sites and workarounds-marked-where-they-stand are done (backlog workarounds-read-as-one).
#   workarounds-read.sh [ROOT]   ROOT: the folder of the clones (default ~/Projects/linux-phone-oco), each read at
#                                its origin/main (git archive: no checkout, no fetch, nothing changed).
#                                WORKAROUNDS=PATH names the reader (default: the newest ideal-agent plugin's).
# Prints ok/FAIL per check; ends 0 when all pass, 1 when one fails, 2 when a clone or the reader is missing.
set -eu
root=${1:-$HOME/Projects/linux-phone-oco}
wa=${WORKAROUNDS:-$(ls -d "$HOME"/.claude/plugins/cache/ideal-agent/ideal-agent/*/scripts/workarounds 2>/dev/null | sort -V | tail -n 1)}
[ -n "$wa" ] && [ -f "$wa" ] || { echo "workarounds-read: no scripts/workarounds (the ideal-agent plugin, 0.3.47 on)" >&2; exit 2; }
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
for r in docs surya-lab google-walleye-lab lab-tools; do
    mkdir "$tmp/$r"
    git -C "$root/$r" archive origin/main | tar -x -C "$tmp/$r" || { echo "workarounds-read: cannot read $root/$r at origin/main" >&2; exit 2; }
done
fails=0
ok() { echo "ok: $*"; }
no() { echo "FAIL: $*"; fails=$((fails + 1)); }
site() { # marker lines of ID in base R where a workaround stands: not a record (data/, rendered docs/), not research material
    grep -rIn -F "WORKAROUND($2)" "$tmp/$1" 2>/dev/null | grep -v -E "^$tmp/$1/(data|docs|research)/" || true
}

# A. The live workarounds are marked where they stand, not only in a record's note.
#    surya's lane rule 'after any PMIC bite boot a kernel carrying pm8916_wdt' (item kept-kernel-with-pmic-wdt);
#    the keep-awake standing in for sxmo's autosuspend backoff (item sxmo-autosuspend-backoff, lab-tools health).
[ -n "$(site surya-lab kept-kernel-with-pmic-wdt)" ] && ok "surya's bite rule is marked where the lane reads it" \
    || no "surya's bite rule (kept-kernel-with-pmic-wdt) is marked only in records - no rule line or script carries it"
[ -n "$(site lab-tools sxmo-autosuspend-backoff)" ] && ok "the keep-awake is marked in lab-tools" \
    || no "sxmo-autosuspend-backoff names lab-tools' keep-awake as its workaround; no marker stands there"

# B. The reader reads sites, not records: no line from data/ or rendered docs/, none from the AGENTS.md example.
for r in surya-lab google-walleye-lab docs; do
    out=$(cd "$tmp/$r" && sh "$wa" --base . . 2>&1 || true)
    bad=$(printf '%s\n' "$out" | grep -E '^\./(data|docs)/|item-id' || true)
    [ -z "$bad" ] && ok "$r: the reader lists sites only" \
        || no "$r: the reader lists records or the example as workarounds ($(printf '%s\n' "$bad" | wc -l) lines, first: $(printf '%s\n' "$bad" | head -n 1))"
done

# C. A workaround whose fix is our own work (a backlog item, not an upstream item) is known, with its state.
mkdir -p "$tmp/probe"; printf '# WORKAROUND(kept-kernel-with-pmic-wdt): after a PMIC bite boot a kernel carrying pm8916_wdt\n' > "$tmp/probe/rule.sh"
out=$(cd "$tmp/surya-lab" && sh "$wa" --base . "$tmp/probe" 2>&1 || true)
printf '%s\n' "$out" | grep -q 'kept-kernel-with-pmic-wdt - not known' \
    && no "a backlog item reads 'not known': $(printf '%s\n' "$out" | head -n 1)" \
    || { printf '%s\n' "$out" | grep -q 'kept-kernel-with-pmic-wdt.*open' && ok "a backlog item reads with its status" \
         || no "kept-kernel-with-pmic-wdt not read as open: $(printf '%s\n' "$out" | head -n 1)"; }

# D. Each workaround says its way out, a rule and a script alike: a patch (to an upstream, or carried in a fork),
#    our own work (a backlog item), or due (retire it).
printf '# WORKAROUND(sxmo-autosuspend-backoff): the keep-awake holds the phone up while autosuspend loops\n' > "$tmp/probe/script.sh"
out=$(cd "$tmp/docs" && sh "$wa" --base . "$tmp/probe" 2>&1 || true)
lines=$(printf '%s\n' "$out" | grep -c 'WORKAROUND\|/probe/' || true)
told=$(printf '%s\n' "$out" | grep -c -E 'way out: (patch|our work)|due: retire' || true)
[ "$lines" -gt 0 ] && [ "$told" -ge "$lines" ] && ok "each workaround says its way out" \
    || no "the reader gives a state but no way out ($told of $lines lines): $(printf '%s\n' "$out" | head -n 1)"

[ "$fails" -eq 0 ] && { echo "workarounds-read: all pass"; exit 0; }
echo "workarounds-read: $fails failing"; exit 1

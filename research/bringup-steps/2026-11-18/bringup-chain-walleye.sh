#!/bin/sh
# The failing test of decision 2026-11-18-bringup-steps-generic-in-docs-status-in-each-base: docs answers
# walleye's bring-up as data - every step in an order where each comes after what it needs, walleye's status
# pulled from its own base, and the steps it has done each with its proof and its run. Run in docs.
# Fails today: no query bringup-chain. Fails after the schema lands until google-walleye-lab claims its steps
# (contract steps = 1) and records/feed-device-steps.sql pulls them.
set -eu
out=$(tad q bringup-chain --device google-walleye --format csv) || { echo "FAIL: no query bringup-chain"; exit 1; }
n=$(printf '%s\n' "$out" | tail -n +2 | wc -l)
[ "$n" -ge 20 ] || { echo "FAIL: $n steps, expected at least 20"; exit 1; }
# every edge points backwards: what a step needs comes before it
order="${TMPDIR:-/tmp}/bringup-chain-order.csv"
printf '%s\n' "$out" | awk -F, 'NR>1{print $1","$2}' > "$order"
bad=$(
  tad sql "SELECT e.step || ' before ' || e.requires FROM bringup_step_edges e
           JOIN read_csv('$order', header=false, columns={'n':'INT','id':'VARCHAR'}) a ON a.id = e.step
           JOIN read_csv('$order', header=false, columns={'n':'INT','id':'VARCHAR'}) b ON b.id = e.requires
           WHERE a.n < b.n" --format csv | tail -n +2)
[ -z "$bad" ] || { echo "FAIL: out of order: $bad"; exit 1; }
# walleye's proven steps, each done with a proof and a run (its base's word, pulled)
for s in kernel-reaches-init gadget-enumerates banner-on-console shell-on-console dmesg-clean pmic-bound; do
  row=$(printf '%s\n' "$out" | awk -F, -v s="$s" '$2==s{print $5"|"$6"|"$7}')
  case "$row" in
    done\|?*\|?*) : ;;
    *) echo "FAIL: walleye $s is '${row:-missing}', expected done|proof|run"; exit 1 ;;
  esac
  case "$row" in *\|NULL\|*|*\|NULL) echo "FAIL: walleye $s has no proof or run: $row"; exit 1 ;; esac
done
# no step of walleye is left unknown: the base claims each, even as open or not-needed
unk=$(printf '%s\n' "$out" | awk -F, 'NR>1 && $5=="unknown"{print $2}' | tr '\n' ' ')
[ -z "$unk" ] || { echo "FAIL: walleye steps not known yet: $unk"; exit 1; }
echo "PASS: walleye's chain, $n steps in order, proven steps with proof and run"

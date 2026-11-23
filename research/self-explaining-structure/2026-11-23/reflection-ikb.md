# Reflection from ikb (idealkb), for the structure review - 2026-11-23

## 1. What it is
idealkb (grenudi/ideal-knowledge-base) is the generic part of every tad knowledge base: the standing tables
(backlog, session_log, decisions, research, sources, upstreams/upstream_items, hardware), the named queries
(about, next, ready, find, row, recent, upstream, upstreaming, carried, decided...) and the records `ikb`
writes them with. Bases follow it by a pinned release (idealkb.toml, hourly bin/update-pins.sh); `ikb` is the
Rust command that turns records/*.sql into subcommands. Lives at ~/Projects/grenudi/ideal-knowledge-base
(worktree ikb-wt); the consumers list names the 9 bases that follow it.

## 2. Records that name a file or folder
- `upstream-item --file`: refused unless under `upstream/` (v0.25.0); `auto` makes upstream/UPSTREAM/ID/.
- `research --material`: free text today; `auto` makes research/ABOUT/DATE/. Not checked - the same refusal
  fits (must start with `research/`).
- `upstream-item --local-ref` (branch, PR or commit) and `--carried-in` (FORK/BRANCH): free text / fork id
  checked against upstreams, the branch not.
- Nothing checks that a named file or folder EXISTS. tad check cannot see the filesystem; that wants a small
  shell check in CI (like check-fork-tags.sh): every `file`/`material` value is a path in the tree.
Proposal: one rule, "a record's file option names its table's home": research -> research/, upstream-item ->
upstream/; refused in the record's SQL, existence checked in CI.

## 3. Generated data and the land conflicts
Two kinds of generated files are committed:
- data/*.json - the database itself, rewritten by `tad canon` (rows in canonical order). Source of truth: it
  must stay committed. Two sessions inserting rows in the middle of the same file conflict textually though
  nothing real does; land's `regen_rebase` already keeps both sides' lines and re-runs `make land-regen`.
- docs/*.md (.rst) - pages rendered from the data (row tables, counts in index). NOT a source: every record
  touches some page and index counts, so any two landings minutes apart conflict on them (the walleye log).
  Their only use is people reading and Pages; agents are told never to read them.
Would generating in CI only work? For docs/: yes, and it is the clean fix. Don't commit docs/; the pages
workflow runs `tad render` and deploys; verify keeps `tad check` + a canonical check on data. Costs: README or
playbook text that links to docs/ paths must point at the site, and the playbook's `make rst`/`make site`
build from rendered files (they would render first). For data/: not committing it is not an option (it is the
base); the remaining conflicts are only same-file appends, which land already settles, or an append-friendly
canon order (new rows at the end, merge=union in .gitattributes) would remove.
Order I'd do it: (1) stop committing docs/ in idealkb and one base to see the conflicts disappear, (2) then
the rest; leave data/ as it is.

# linux-phone-oco's repository graph, measured 2026-11-18

What this folder holds: the measurement behind research rows base-graph-measured, base-graph-world and
base-graph-how-it-stands, and the failing test `graph-drift.sh` (decision 2026-11-18-device-layer-from-docs).
Read only git refs at origin/main (idealkb v0.16.0 8be549e, docs 608b61f, device-template d6eae9e, surya-lab
42da677, google-walleye-lab f0e0fc2, lab-machine fb75285), gh and git ls-remote. No phone, no repository changed.

## The graph today

```
              files, down (follow.sh, hourly)                     rows, up (DuckDB feeds, at main)
 tad-engine ──tad pin (weekly job; lists docs, not the 3 device bases)──▶ every base
 idealkb ──slice v0.16.0──▶ docs (7 own) · ideal-agent · device-template · surya-lab · google-walleye-lab (2 own each)
 device-template ──10 statements + 4 tables, BY HAND (no release, pin a date)──▶ surya-lab · google-walleye-lab
 surya-lab, google-walleye-lab ──parts.json (contract parts = 1, at main)──▶ docs (feed-device-parts)
 docs ──component and step ids──▶ device bases: nothing carries them; ids agree today (20/21 claimed, 0 unknown)
 lab-tools ──lpoco tag──▶ lab-machine lab.toml (by hand, 0.15.0; latest 0.17.0, same day) ──▶ every device.toml
 sr.ht ~mil/sxmo-utils ──master, BY HAND──▶ grenudi/sxmo-utils (4 behind) ─3 topics─▶ lab ─tag lab-20261118.1─▶ lab-tools APKBUILD
 sm7150-mainline/linux ──GitHub fork──▶ grenudi/linux (v7.2 identical) ─topic/fix/dt/test branches (10)─▶ each lab's kernel route
 up, files: an edited followed file ends follow.sh with 3 and leaves a PR in the follower for a person; nothing
           reaches the source. Upstream items: docs 0 to idealkb, 0 to device-template; each lab 0.
```

Edges with a job that moves them: 3 (idealkb slice, tad pin, docs feeds). By hand: 6 (template slice, device
tables, catalogue ids, lpoco pin, sxmo tracking, every upward change). Behind today: 5 (template slice in every
lab, docs' own statements, tad in docs' CI, lpoco in lab.toml, sxmo master).

## Measured, edge by edge

1. idealkb -> 5 bases. Every pin 0.16.0, current (journal of idealkb-update-pins: hourly, "current" at 15:04).
   Since v0.16.0 a source names its pin file and marker (`#! pin`, `#! marker`), update-pins walks ./sources
   (device-template listed, skipped: no release) and check-one-owner stops the job when two lists name a file.
2. own, the one-way exit. A file in `own` is never laid again; follow.sh only prints "idealkb changed it" into a
   commit message. docs keeps 7 own files; 6 statements differ from idealkb 0.16.0's (about.sql 43 diff lines,
   decision.sql 39, backlog.sql 38, source.sql 21, research.sql 11, session-log.sql 9). docs' records/decision.sql
   has 0 of --supersedes, --amends, --scope, --tracked-by (idealkb 0.14.0, decision-links): docs cannot record
   a superseding decision through its record, although its AGENTS.md and tables ask for it; 0 decisions in docs
   carry supersedes or amends. docs' tables.toml has no idealkb part at all. Each device base's tables.toml
   (own) carries an idealkb part that lacks 101 non-comment lines of 0.16.0's (the supersedes/amends/tracked_by
   reference rules; hardware moved). Their own backlog.sql differs by 4 lines. No upstream item names any of it.
3. device-template -> 2 labs. template-drift.sh today: 18 FAIL classified on the template, pin and no-copy FAIL
   per lab; the 10 statements equal (by hand). The device tables (devices, parts, test_runs, test_results) sit
   in each lab's tables.toml outside any marker: equal by hand, followed by nothing.
4. The contract has two homes. parts is declared by device-template (tables.toml, devicebase.toml parts = 1)
   and read by docs (records/feed-device-parts.sql); bring-up steps: catalogue and edges in docs, the claim
   table to ship in the template (decision 2026-11-18-bringup-steps-generic-in-docs-status-in-each-base). Every
   contract change is two PRs in two repositories and two release trains.
5. tad: docs' CI installs 0.6.0, the labs 0.7.1 (latest tad-v0.7.1); tad-engine's consumers lists docs and not
   device-template, surya-lab, google-walleye-lab - their pins move by hand.
6. lab.toml pins lpoco 0.15.0 (landed 2026-11-18); lpoco-v0.17.0 tagged 15:30 the same day; nothing moves it.
7. grenudi/sxmo-utils master 303c755 is 4 commits behind sr.ht master 1fd7822; no job fetches sr.ht.
   grenudi/linux default v7.2 is identical to sm7150-mainline's (GitHub keeps the fork).

## The failing test

`graph-drift.sh [PROJECTS]` - today exit 1: 36 FAIL, 9 ok. It passes when: every own file is the source's or
on its way up (an item names it); every own tables.toml keeps the source's part; each device base pins its
device layer by a release of docs; the device tables are in docs' marked part; lab.toml's lpoco is current;
every base's tad is current and listed; sxmo's master tracks sr.ht.

## Outside (two researcher reports, read at source 2026-11-18)

Down and up for root-level files: no Rust or shell tool does both (subtree/subrepo/submodules need a prefix;
Android repo copies outside git, Python; Nix inputs live in the store and cannot be patched, nix#3920; copier
and cruft are down-only, Python; Renovate, multi-gitter, turbolift are down-only). copybara does both
(CHANGE_REQUEST from a follower's PR to the source, GitOrigin-RevId, check_last_rev_state, merge_import) at the
cost of a JVM 21 and Starlark per workflow. josh (Rust, r26.08.28) maps single files at the root (`::f`,
`::dest=src`) and pushes back through a view, but its source of truth is one monorepo, and a follower cannot
keep its own variant; push back from a multi-repo follower is not known.

Layering: Yocto (oe-core -> distro -> BSP) - one owner per recipe, overrides as named .bbappend, a dangling
append an error, LAYERSERIES_COMPAT fatal, Upstream-Status required on every patch and an error by default,
yocto-check-layer forbids a BSP changing others' signatures. Gentoo - masters non-transitive (each overlay names
every ancestor), MasterPackageClobbered an error. Debian DEP-3 - Forwarded/Applied-Upstream; only 9.4% of
trixie's patches forwarded: labels that only warn do not move work. Kernel - upstream first, stable's
"commit X upstream", linux-next merges every tree regularly and mails each conflict to both owners; ACK tags
every carried commit UPSTREAM/BACKPORT/FROMGIT/FROMLIST/ANDROID. stgit is Rust (2.7.0) and finds landed patches
(rebase --merged); topgit merges along .topdeps (dormant since 2025-01); `git cherry` finds a landed patch by
patch-id with no tool at all. b4, gbp, quilt-tools, copier, repo: Python, refused here.

Taken: one owner per file (have it: check-one-owner); an override is named and carries a status, and a missing
status fails (Yocto, DEP-3); upstream first, the copy carries where it came from (kernel stable); the integrator
reports each drift to its owner on a schedule (linux-next); a follower's edit becomes a change request on the
source (copybara); landed patches found by patch-id (git cherry); the middle layer owns the contract the
lowest is checked against (Yocto check-layer, ACK KMI). Set aside: every tool above as a runtime.

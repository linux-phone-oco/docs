# The builders: lab-tools, walleye and surya build items

Role: builder (ideal-agent)
Name: lab-tools-builder | walleye-builder | surya-builder
Also practices: 42

**You build one item from the place your Name names, from fresh worktrees of your own, and you never
touch a phone.** Your Name picks the place, the query, the base you record in and whom you report to:

| Name | Builds | Records in | Reports to (`list_sessions`, title starts) |
|---|---|---|---|
| lab-tools-builder | linux-phone-oco/lab-tools (devlab, lpoco, lpoco-health, lpoco-bringup, tone) | docs | "Orchestration of linux-phone-oco" |
| walleye-builder | the Google Pixel 2 (walleye, MSM8998), in `~/Projects/linux-phone-oco/google-walleye-lab` and `~/Projects/walleye-build`, on the lab machine | google-walleye-lab's own base (decision 2026-11-17-commons-and-device-bases) | "walleye coordinator" |
| surya-builder | the POCO X3 NFC (surya, SM7150): its programs and records in `~/Projects/linux-phone-oco/surya-lab`, on the lab machine | surya-lab's own base (decision 2026-11-17-commons-and-device-bases) | "surya coordinator" |

## Fresh worktrees, never the shared clone

The shared clones under `~/Projects/linux-phone-oco/` may be stale: never work in them. First:

- lab-tools-builder - docs, then lab-tools the same way:
  `R=$(date +%s); git -C ~/Projects/linux-phone-oco/docs fetch -q origin && git -C ~/Projects/linux-phone-oco/docs worktree add -q --detach ~/Projects/linux-phone-oco/wt-docs-builder-$R origin/main && cd ~/Projects/linux-phone-oco/wt-docs-builder-$R`
  `git -C ~/Projects/linux-phone-oco/lab-tools fetch -q origin && git -C ~/Projects/linux-phone-oco/lab-tools worktree add -q --detach ~/Projects/linux-phone-oco/wt-lab-tools-builder-$R origin/main`
- walleye-builder:
  `R=$(date +%s); git -C ~/Projects/linux-phone-oco/google-walleye-lab fetch -q origin && git -C ~/Projects/linux-phone-oco/google-walleye-lab worktree add -q --detach ~/Projects/linux-phone-oco/wt-walleye-builder-$R origin/main && cd ~/Projects/linux-phone-oco/wt-walleye-builder-$R`
- surya-builder:
  `R=$(date +%s); git -C ~/Projects/linux-phone-oco/surya-lab fetch -q origin && git -C ~/Projects/linux-phone-oco/surya-lab worktree add -q --detach ~/Projects/linux-phone-oco/wt-surya-builder-$R origin/main && cd ~/Projects/linux-phone-oco/wt-surya-builder-$R`

At the end remove each: `git -C ~/Projects/linux-phone-oco/REPO worktree remove ~/Projects/linux-phone-oco/wt-...-$R`.

Large outputs - kernel builds, images, package trees, a `cargo install` build - go to `$AGENT_BUILD` (on disk,
set by agent-env, with `TMPDIR` under it); a cargo target stays in its worktree. The session scratchpad under
/tmp is a RAM tmpfs all sessions share: small files only there (decision ideal-agent 2026-11-19-large-outputs-on-disk).

## Your item

Your coordinator placed it before starting you. **If the query returns nothing, report that and end.**

- lab-tools-builder, in the docs worktree - the first ready build item of lab-tools, from the one picking
  query (it skips an item that waits outside the base or whose blockers are not all done, and says why):
  `tad q ready --for builder --show ready --format csv`, then take the first row whose place is lab-tools
  (`tad q row --id ID` names it in `project`; the query has no place filter yet).
  Read its decision and research first (`tad q about --subject ...`, `tad q find --text ...`); for the
  lpoco roof, decision 2026-11-17-bringup-in-lab-tools.
- surya-builder, in the surya-lab worktree: the item your coordinator placed, `tad q ready --for builder --show ready --format csv` (its first row; surya-lab's own base). Read the item's note first (`tad q row --id ID`): it carries the spec. You never touch the phone; queue each real run for the keeper with `ikb backlog-needs --id ... --needs phone --proof TEST`.
- walleye-builder, in the walleye worktree: `tad q ready --for builder --show ready --format csv` (its first row). Read walleye's
  standing decisions first: `tad q recent --format csv` and
  `tad q about --subject walleye-first-fastboot-boot --format csv`.

## The checks

- lab-tools-builder: its proof test first, seen failing; then the build in Rust, the command line declared
  once with argenv ([rust-with-argenv](../docs/concepts.md#rust-with-argenv)), no new Python.
- walleye-builder: checksums for every image; any program in Rust with argenv, no new Python.
- surya-builder: a program in Rust with argenv (a rust-script or a bin), no new Python or shell logic; its tests, a dry run first.

## Recording and the writes you may make

- lab-tools-builder: change lab-tools and `land` it, read back from main; then in the docs worktree with
  ikb: the item done with its proof (`ikb backlog-status`), a session-log row, any decision with what was
  rejected.
- surya-builder: land the change and its record in surya-lab (`ikb ...`, a branch of your own, `land`, read back from main); mark the item done (`ikb backlog-status`) only when its proof test passed; report to the "surya coordinator".
- walleye-builder: build on the lab; land the change and its record in google-walleye-lab (`ikb ...`, a
  branch of your own, `land`, read back from main); queue each try for the keeper with
  `ikb backlog-needs --id ... --needs phone --proof TEST`; mark the item done (`ikb backlog-status`).

Both may land in linux-phone-oco places and message the coordinator their Name names. Neither changes a
phone; lab-tools-builder changes no device base. Report in a few lines, then end.

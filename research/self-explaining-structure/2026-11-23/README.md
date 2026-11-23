# Structure review, 2026-11-23: what is, what the roles said, what others do

The material of the steward's structure review (research rows `structure-review-what-is` and
`structure-review-look-around`; decisions `2026-11-23-structure-*`). The author asked for it on 2026-11-22:

> currently all our repositories are a damn mess, agents create folders in root folder without trying to
> group them, to make sense of them, and without making them selfinformative, so that anyone humans or
> agents could make sense of it and know where things are just by looking at the structure.

- `reflection-*.md` - each role's own account of its flows and where it reads and writes (walleye,
  surya, orchestration, upstreams, ideal-agent, ikb), written for this review, kept as written.
- `look-around.md` - how the kernel, phone ports, Linaro/Qualcomm, KernelCI and documentation patterns
  organise the same things, with sources.
- `design.md` - the rules this review decided, with what was rejected.

## What is (read 2026-11-23 from origin/main of each repository)

Repositories and their top-level folders:

| repository | top-level folders | with a README |
|---|---|---|
| docs | 13 | 3 (device-layer, ideal-agent-linux-phone-oco, research) |
| google-walleye-lab | 17 | 1 (build) |
| surya-lab | 19 | 1 (ucm) |
| lab-tools | 13 | 0 (each crate has a CHANGELOG, not a README) |

Branches. Corrected the same day: the first count (2,138, of which 2,050 merged) was of the lab machine's
clones' remote-tracking names, never pruned - `land` had already deleted those branches on GitHub. GitHub
held 68 (docs 17, google-walleye-lab 30, surya-lab 11, lab-tools 4, device-template 6). What a clone shows
under `git branch -a` is not what the remote holds until it is fetched with `--prune`.

What was done with the 68, on the author's go of 2026-11-23 ("Yes, both"), each branch's tip checked against
its pull request's head commit first:

| repository | deleted (PR merged at the tip) | kept as tag `archive/NAME`, then deleted | kept |
|---|---|---|---|
| docs | 1 | 14 | 2: `oco-data` (ocoeco's gather writes it), an open dependabot PR |
| google-walleye-lab | 6 | 22 | 2: `oco-data`, `walleye-wdt-pon-bites-procedure` (open item walleye-wdt-pon-bites-procedure) |
| surya-lab | 0 | 9 | 2: `oco-data`, an open PR |
| lab-tools | 2 | 0 | 2: `oco-data`, an open PR (the steward's #328) |
| device-template | 2 | 3 | 1: `oco-data` |
| total | 11 | 48 | 9 |

"Automatically delete head branches" is now on in all five (docs and surya-lab had it already).

The lab machine's root, cleared on 2026-11-23 (all lanes paused): six clean worktrees removed; surya's
`wt-surya-keeper-1795036066` removed with its five uncommitted edits, whose two rows were already on main
(checked); walleye's `wt-walleye-builder-1795096405` (unlanded display-late L4 work) moved, not removed, to
`~/.local/share/agent-worktrees/google-walleye-lab/walleye-builder/display-late-l4-1795096405`; four run logs
moved into google-walleye-lab research (PRs 735, 736); `upstream-queue/` removed - its eight files byte-equal
to files in `upstream/`, its README kept here as `upstream-queue-README.md` (its recipients list).

The lab machine, `~/Projects/linux-phone-oco/`: 7 clones (docs, lab-tools, google-walleye-lab, surya-lab,
device-template, lens, sxmo-deviceprofiles), one fork clone (sxmo-utils, a mirror of grenudi/sxmo-utils),
8 worktrees `wt-*` (from about 25 the day before; two hold uncommitted files), four run logs, and
`upstream-queue/` - not a repository, the outgoing queue from before docs existed. Every one of its 8 files
is byte-equal to a file in docs `upstream/`. Worktrees have a second home, `~/.local/share/agent-worktrees/`,
where ideal-agent's `branch` puts them.

The kernel, in five forms at once:

- branches pushed to grenudi/linux (a fork of sm7150-mainline/linux; `linux-phone-oco/linux` redirects
  to it): `dt/…` (3), `feat/…`, `fix/…` (3), `test/…` (2), `topic/…` (2), `v7.2`;
- branches only in a local clone (`topic/ufs-match-android`, `topic/walleye-drv2624`, `walleye-dts-polish`,
  `keeper5/…`), and 11 worktrees `wt-k-*` of which 9 are detached heads;
- `.patch` files in lab repositories: google-walleye-lab `kernel/` (audio-adsp-q6 ×9, drv2624 ×5,
  fuel-gauge-rfc ×3, a panel driver as a `.c` file), surya-lab `patches/` (3);
- `.dts` files copied into the tree by a build script (google-walleye-lab `dt/`, 7 files);
- copies in docs `upstream/LIST/ITEM/` (the series as sent, or to be sent).

No list says which patches a test kernel has. It is in a build script (google-walleye-lab `build/` has
about 175 files, mostly one `build-*.sh` per try) and a comment on `device.toml [images.*]`.

Build areas outside git: `~/Projects/walleye-build` (84 GB, 76 `images-*` folders, the kernel worktrees)
and `~/Projects/surya-audio` (51 GB: the shared kernel clone `linux`, `obj-*`, `scratch-*`, `image*`).
surya's `image/` and `image-fresh-stock/` are base images that must never be deleted.

## What the roles said (their notes are here, whole)

- Where things go is chosen by whoever creates them; nothing ties a worktree, log or branch to a session
  or ends it (orchestration, walleye, surya, ideal-agent).
- Two homes for worktrees; no written branch convention; nothing in ideal-agent says what top-level
  folders a repository has (ideal-agent).
- Series are cut from three places; patches in docs are copies that drift from any branch; there is no
  tool that merges a written list of topics into a test kernel (upstreams). Test kernels are made by
  cherry-picking by hand (surya), or by one build script per try (walleye).
- Every PR carries regenerated `data/*.json` and rendered `docs/*.md`; two landings minutes apart conflict
  on them; walleye replayed records six times on 2026-11-22 (orchestration, walleye, ikb).
- A go and a wait are free text in fields an item update overwrites: a go was erased, a look was skipped
  as "waits on author" (orchestration, walleye, surya).

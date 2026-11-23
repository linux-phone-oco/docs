# Orchestration's reflections, for the structure review (2026-11-23)

## 1. What orchestration does

It tends the linux-phone-oco conveyor (idea → research → test → land → proof) and chooses the next piece by the weakest link. It owns docs (the one tad base), the briefs, lab-tools' queue and lab.toml, and it starts builders. It never touches a phone; keepers do.

## 2. The flows, and where each one reads and writes

| Flow | Reads | Writes |
|---|---|---|
| **docs' queue (all records)** | `linux-phone-oco/docs`, main, read through `tad q …` / `ikb …` in a fresh worktree | `docs/data/*.json` (backlog, decisions, research, session_log, bringup steps and edges), always through `ikb`. Each change goes on a branch → PR → `land --no-manual`. Generated docs come from `make render` (guidebook, site). |
| **Briefs** | `docs/ideal-agent-linux-phone-oco/*.md` on main (sessions get a copy at `~/.local/state/ideal-agent/sessions/SID.brief.md`) | Same folder, on a branch in a worktree, landed |
| **lab-tools releases** | `linux-phone-oco/lab-tools` main; the queue is docs' backlog under project `lab-tools` (`tad q ready --for builder`) | The builder writes on its own branch in `wt-lab-tools-*`, then `land`. release-please opens a release PR, which lands with `land --release`. CI attaches the binaries and sha256. |
| **Host install** | Release assets on GitHub; the pin in `grenudi/lab-machine` `lab.toml` (`[tools] lpoco = …`) | The `lpoco-host follow` user timer (15 min) bumps the pin through a lab-machine PR, then prepares. `~/.local/bin/lpoco*`. Prepare runs only when both keeper leases are free. |
| **Clones timer** | `lab.toml [clones] folders` | Moves only clones that have an AGENTS.md and are behind main |
| **device-template** | `linux-phone-oco/device-template` main | Branch → land; the device labs (surya-lab, google-walleye-lab) pull from it |
| **Keepers' leases** | `lpoco lab keeper status --device <lab>/device.toml` (main of surya-lab / google-walleye-lab) | The lease file lives on the lab under lpoco's state, never in a repo. Orchestration only reads it. |
| **Launcher tasks** | scheduled-tasks (lab-tools-builder launcher, lanes waker; the waker is off now) | Start a builder session with `Role/Name/Also + Brief:` |
| **Side notes** | This folder (`side-session-notes/local_12b18c70…/`) | Hand-overs and long findings; not a record of truth |

## 3. Hard to find, or landing in the wrong place (in `~/Projects/linux-phone-oco/`, as of today)

- **19 `wt-*` worktrees**: keepers, builders and coordinators from 2026-11-17 to 2026-11-22, all detached at HEAD. Two still have uncommitted files: `wt-surya-keeper-1795036066` (5) and `wt-walleye-builder-1795096405` (6). Each session creates its worktree as a sibling of the clones and nobody removes it. `ideal-agent prune` (0.3.64) exists but no role runs it at its end.
- **`*-drop-wt`** (docs, device-template, google-walleye-lab, surya-lab): detached worktrees used as "a clean main to read". I don't know who made them or why. They look like an earlier workaround for the guard ("a read in a stale shared clone").
- **`docs-upstreams`** is a docs worktree, detached; it is probably the upstreams lane's. **`surya-lab-wt-r`** and **`wt-walleye-coord-lab`** are similar: worktrees with no run id, so I can't tell who owns them.
- **`upstream-queue/`** (linux, messages, sxmo-utils, README) is not a git repo. It is the old place for outgoing series. Decision 2026-11-20-outgoing-items-live-in-upstream moved them to `upstream/DESTINATION/ITEM/` in docs, so this folder looks superseded. Check that it holds nothing unique before moving it.
- **`*.log` / `*.out`** at the root (pmic-run4, rootfs-boots-run-2, walleye-display-at-boot-…) are run outputs that keepers left there. They should go under `~/.cache/agent-build/RUN` (AGENT_BUILD) or the lab's material folder.
- **`lens`** is a real clone (linux-phone-oco/lens, main). Nothing here says what it is for; I don't tend it.
- **`sxmo-deviceprofiles`, `sxmo-utils`** are upstream forks sitting next to our own repos, with nothing that marks them as forks.
- **`~/Projects/lab-machine-wt-orch`, `-wt-token`** are my own (orch) and an earlier token task's lab-machine worktrees, detached. They can be removed once checked clean.
- **The root cause:** a worktree's place is chosen by whoever creates it (`~/Projects/linux-phone-oco/wt-ROLE-RUN`), and nothing ties it to a session or ends it. One place such as `~/Projects/.worktrees/REPO/SESSION`, removed by the session's end (or by `prune` against live sessions), would make the root show only clones.

## 4. Generated data conflicts

- **Why:** each PR commits both the source rows (`data/*.json`) and what is rendered from them (guidebook, site pages, canon-sorted json). Two sessions landing minutes apart both rewrite the same generated lines, and canon sorting moves neighbouring rows. So git sees overlapping hunks even when the records are independent. The rebase then needs a hand merge and a re-render, and the revert guard can misread the merge as taking a row out.
- **What helped:** `land-regen: canon render` (docs, device-template, lab-machine #79/80). With it, land rebases, keeps both sides of `data/*.json`, and regenerates. It works, but it treats the symptom.
- **What I'd change:**
  1. Stop committing what is rendered. Render in CI or at deploy (the site), and keep only `data/` in git.
  2. If something has to stay committed, render it on main after landing, as one bot commit, and never in feature PRs.
  3. Store one row per line in a fixed order (JSON lines, canon), so independent rows never share a hunk. Better still, one file per record kind and id, which removes most conflicts.

## 5. Steering keepers

- **The two failures**:
  - an ikb note replaced the status line that carried the go window, so the go was erased;
  - "ready" didn't print `go_until`, so a keeper read a "waits on author" note as a block and skipped an open go.
- Both failures come from one thing: the steering is free-text state inside one field that several writers overwrite.
- **Sturdier:**
  1. **A go is its own record, separate from the item's note.** Example: `ikb go --item I --until T --by WHO` in an append-only table, with `ikb go-close`. A note can't erase it, and the history shows who opened it.
  2. **The keeper's one query prints the decision, not the inputs.** `tad q ready --for keeper` would mark each item `act now (go until T)` / `waits: <named record>` / `blocked: <id>`. Then nothing is left to interpret. A wait has to name a record (a decision or an author-word row). The words "waits on author" alone don't count.
  3. **Words the keeper must not act on can't open a go.** Only the record in point 1 opens one, and the brief says so in one line.
  4. **Patrol checks it.** A go that is open while its keeper is idle for more than one cycle is a sign to raise.

## Queue top for the resume (lab-tools)
host-follows-releases (1), phone-declared-transport (2), attended-lift-sees-groups (4), lpoco-layer-pack (7). docs #557 is open. Nothing is running.

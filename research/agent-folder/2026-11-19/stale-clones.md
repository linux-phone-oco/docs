# Agents acting on stale shared clones - material, 2026-11-19

Material behind research `stale-clones-where-roles-read`. Measured read-only on the lab machine by
research-stale-clones, 2026-11-19 ~20:30 CET.

## Incidents, read off the data

| When | Who | What it read | How far behind | Cost |
|---|---|---|---|---|
| 2026-11-17 | lab-tools-builder launcher, first run | the shared clone (log 2026-11-17-orchestration-lpoco-roof) | not recorded | coordinator prompt changed to make fresh worktrees |
| 2026-11-17 | walleye research (docs 226) | a stale branch merged over docs 230 (log 2026-11-17-briefs-restored) | a branch, not a clone | eight briefs reverted; land's stale-tree guard came after (lab-machine 59, 61) |
| 2026-11-18 | lpoco host | a stale detached google-walleye-lab clone without [host] (decision 2026-11-18-host-reads-device-from-origin-main) | - | no udev rule planned; fixed: host reads origin/main |
| 2026-11-18 16:16 to 11-19 16:19 | a lab-machine session | left the lab-machine clone on branch land-guard-pure-deletions with leftovers of the fix landed as lab-machine 61 | - | reflog |
| 2026-11-19 14:04, 14:20 | surya-builder sessions 150c779d, b0853617 | builder.md read with the Read tool from ~/Projects/linux-phone-oco/docs (41 behind) | 41 | concluded "the brief names no surya-builder", though docs 643 had added it |
| 2026-11-19 20:18 | walleye-keeper session ba3abcea | `cd google-walleye-lab && lpoco lab keeper take ...; tad q phone-stands; tad q ready --for keeper` in the shared clone, before making its worktree | 64 (db4e1c7..0c5363b) | redid the finished TAS2557 item; delayed the UFS card read |

The clones were refreshed by hand: docs' reflog shows `pull --ff-only` at 05:26-07:40 and 16:17 on 11-19,
google-walleye-lab and surya-lab `pull`/`merge origin/main` at 16:19 and 20:21.

## Why the role start's fix did not hold

ideal-agent 0.3.28 (#63, 2026-11-18) makes the UserPromptSubmit role hook fetch and inject the brief from
`origin/main` ("Your brief (..., from its repository's main)"). Every surya-builder start carried it. But:

- the hook's output (card + practices + whole brief) is over Claude Code's hook-output cap in **203 of 333**
  role starts since 2026-11-18 12:00: the app saves it to `tool-results/hook-...-stdout.txt` and shows a
  2 KB preview (150c779d: "Output too large (10.6KB). Full output saved to: ...");
- so the agent reads the brief by its `Brief:` path - the shared docs clone's file on disk: **200 of 333**
  role starts did (Read tool or cat on `~/Projects/linux-phone-oco/docs/ideal-agent-linux-phone-oco/*.md`).

The from-main read is right; its delivery is cut, and the stale disk copy fills the gap.

## Picking queries run in a shared lane clone

First `tad q ready|phone-next|phone-stands|next` of each lane session (surya/walleye keeper, builder,
research) since 2026-11-18 12:00: **5 of 253** ran in the shared clone (surya-keeper 11-18 14:23, 11-19 12:10;
walleye-keeper 11-19 15:19, 20:18; surya-builder 11-19 15:28). phone-keeper.md lists `lpoco lab keeper take`
and the three queries before the worktree recipe, so a start can run them where it stands.

## Where each role reads repository state

| Reader | Reads | At origin/main? |
|---|---|---|
| role hook (ideal-agent `role`) | the `Brief:` file | yes, `git fetch` + `git show origin/main:` - but cut to a preview in 61% of starts |
| launchers `~/.claude/scheduled-tasks/*/SKILL.md` | `Brief:` path into the shared docs clone | through the hook; the agent's own re-read is the disk |
| builder.md, feature-research.md, patrol.md, phone-keeper.md | fresh detached worktree at origin/main | yes, in prose; phone-keeper's order lets the first commands run in the shared clone |
| coordinator.md | "in ~/Projects/linux-phone-oco/docs at origin/main" - no command that makes it so | no |
| surya-coordinator.md | "Start, in ~/Projects/linux-phone-oco/surya-lab": its queue from the shared clone | **no** (today detached, 23 behind) |
| walleye-coordinator.md | a worktree of its own at origin/main | yes |
| lanes-waker, linux-phone-keeper-waker | fresh detached worktree at origin/main | yes |
| lpoco host plan/prepare/check | lab.toml and device.toml from fetched origin/main, says the lag | yes |
| ideal-agent guard (PreToolUse Bash) | refuses writes (checkout, reset, merge...) in a shared clone's main checkout | reads not checked |
| land (lab-machine) | stale-tree guard: refuses a change that takes out recent lines | write side covered |
| scripts/clones-check | reports clones off main, dirty, behind | reports only, no fetch |
| host-clones-fresh (lab-tools branch builder-host-clones-fresh, d446c2d) | own user timer; ff-only a clone clean and on main; leaves detached/branch/dirty and names it | would have caught docs (on main); **not** walleye (on build/tad-0.7.1 since 11-18 15:57) nor surya-lab (detached) |

## The shared clones now (20:30)

docs main, 21 behind; surya-lab detached, 23 behind, a nested untracked worktree folder; google-walleye-lab
on branch build/tad-0.7.1 (tracking origin/main, current only by a hand pull at 20:21), a nested untracked
worktree folder; lab-tools main 5 behind; device-template current. Every lane clone's `origin/main` was fetched
within the hour: each worktree add fetches through the shared clone, so a local `HEAD..origin/main` count
needs no network and named every incident above (41, 64).

About 90 leftover worktrees under ~/Projects/linux-phone-oco (wt-*), most 200-540 behind, a few on branches
(wt-walleye-builder-lab on main, 538 behind): a later session that cds into one reads very old state.
The installed ideal-agent plugin is 0.3.59 while its main is at 0.3.62 - the same class, in the plugin cache.

## The world (a researcher's read, sources recorded as rows)

- CI: actions/checkout pins each job to a SHA and cleans; GitLab `GIT_STRATEGY=fetch` cleans and fetches
  before reuse and calls `none` "likely out of date"; Jenkins wipes or cleans. A reused tree is a cache reset
  to a known commit, never the truth.
- Claude Code worktrees: default base is the remote's default branch ("fresh"), re-fetched only when older
  than 24 h.
- git: `git show origin/main:PATH` reads a commit with no tree; `git maintenance` prefetches into
  refs/prefetch precisely so that remote-tracking refs and trees are never moved behind the user's back.
- GitOps: Flux builds a snapshot per commit and is not Ready until it matches the remote; Argo CD polls every
  3 min plus webhooks; OpenGitOps: state pulled and continuously reconciled from the versioned source.
- kubernetes/git-sync: the one proven shape of a shared, refreshed copy - only git-sync writes it, a new
  worktree per revision, an atomic symlink swap, nobody edits it.
- Fail-closed: HTTP If-Match, Kubernetes resourceVersion, `git push --force-with-lease` - an action carries the
  version it read and is refused when that is no longer current.
- No source endorses many workers reading one long-lived mutable checkout; it is shared mutable state
  (snowflake, pets-not-cattle). Ranked: fresh tree per task and read-the-ref first; fail-closed checks to
  enforce them; a timer that fast-forwards a tree in use last.

# Reflection from ideal-agent's builder (ideal-agent-builder), 2026-11-23

Read from ideal-agent's main at e8bc6eb and linux-phone-oco/docs' origin/main. These are reflections, not records.

## 1. What ideal-agent owns, and where it lives

It owns how every agent in the commons works: the practices, the role cards, the skills (how to start, land,
record, look around, keep a shared resource) and the hooks that hold them (the guard, the role start, the
daily prune). Nothing of one project lives there.

Where: grenudi/ideal-agent, cloned at ~/Projects/grenudi/ideal-agent.
- agents/ - role cards
- skills/NAME/SKILL.md - methods
- hooks/hooks.json, plus src/ - the Rust program: guard, start/role, practices, prune
- scripts/ - agent-env, the shell every session gets with `branch` and `land`; plus checks
- data/ - its tad base: practices, decisions, research, backlog (docs/ is rendered from it)
- research/ - research material

Installed copies sit in ~/.claude/plugins/cache/ideal-agent; per-session state is in
~/.local/state/ideal-agent/sessions (role, brief file, pruned.log).

## 2. What says where things go, and where they disagree

Said:
- **Worktrees**
  - land-a-change: "Branch first, in a worktree of your own": `branch NAME`, made from origin/main. Remove it after `land`.
  - agent-env's `branch` puts it at ~/.local/share/agent-worktrees/REPO/NAME.
  - orchestrate-agents: every session works in clones or worktrees of its own.
- **Shared clones** (~/Projects/...)
  - They stay on main for readers. The guard refuses git writes there (0.3.x) and, since 0.3.63, any read when
    the clone is behind origin/main (decision 2026-11-19-roles-act-on-origin-main).
  - patrol runs scripts/clones-check on them.
- **Lifetimes**: `ideal-agent prune now` runs daily (0.3.64). It removes clean worktrees and build runs nothing
  wrote to for 3 days. Branches stay.
- **Large outputs**: AGENT_BUILD, at ~/.cache/agent-build/RUN, not /tmp.
- **Records**
  - record-the-work: everything goes into the owning project's tad base through ikb.
  - The author's words go to marshall-oco/conversation.
  - Notes outside a repository, such as this folder, are "a pointer at most, never the only copy".

Disagree or left open:
- **Two homes for worktrees.**
  - `branch` puts them in ~/.local/share/agent-worktrees/REPO/NAME.
  - linux-phone-oco's briefs put them in ~/Projects/linux-phone-oco/wt-ROLE-$R, next to the shared clones;
    there are 17 entries there now.
  - My own guard's refusal message suggests a third place, `CLONE-read-$(date +%s)`, beside the clone. That is mine to fix.
  - One home would help. ~/.local/share/agent-worktrees keeps ~/Projects holding only clones.
- **Read worktrees vs write worktrees.**
  - Briefs make detached read-only worktrees (`--detach`, no branch); `branch` makes branch worktrees.
  - No skill names the read kind or says how a role reads main for a while without a branch.
  - `git show origin/main:PATH` covers one file.
- **Branch names.**
  - No convention is written. I use `builder-<what>`; others use `fix-x`, `build/tad-0.7.1`, and lane
    clones are left on build branches.
  - land needs only one commit per branch and a conventional title. A role-or-place prefix, plus what the
    change does, would read well in `git branch -a`.
- **Repository layout.**
  - Nothing in ideal-agent says what top-level folders a repository has, or that each has a README.
  - idealkb fixes data/, docs/, records/, queries/, research/ for a base.
  - AGENTS.md says "never a top-level bin/" for ideal-agent only.
- **Notes folders.**
  - record-the-work says they are a pointer at most.
  - The app's side-session-notes folder is often used for real material. Nothing says when material moves
    into a repository: a research row's `--material` folder.

## 3. What agents do wrong with folders and branches (seen)

- **Reading a shared clone as if it were main.** 200 of 333 role starts re-read the brief from a stale docs
  clone (research stale-clones-where-roles-read). Fixed by the session brief file and the guard. The guard
  refused me twice after my own merges, and once in a line that pulled and read in the same command: the pull
  must be its own command.
- **Leaving shared clones off main.** Lane clones were left detached or on build branches (surya-lab detached,
  google-walleye-lab on build/tad-0.7.1); 17 clones were behind on 2026-11-19.
- **Leaving worktrees behind.** 138 linked worktrees existed on 2026-11-19, many hundreds of commits behind;
  prune now takes the clean ones after 3 days.
- **Removing a worktree before `land` pushed.** I did this once: land then took the change as a revert, and I
  recovered it with git fsck.
- **Using one sweep's age test with the wrong `find`.** 0.3.62's build-run sweep used `find -newermt "-3 days"`.
  Under the app's bfs `find` that test is always empty, so the sweep deleted every other run folder whatever its
  age. Fixed in 0.3.64 by moving the sweep to Rust with -mtime.
- **Writing files to /tmp,** a RAM tmpfs that filled to 98%; AGENT_BUILD exists for this.
- **Removing work as part of a stale branch.** land's revert guard catches a change that takes out recent main
  work; `Takes-out: PATH` names one taken out on purpose.

## On B, the steward role

The shape is welcome. Three thoughts:
- **Checks as programs that refuse, owned where they run.**
  - A check for a project's layout belongs to that project, run by its CI or by land.
  - A refusal at tool time belongs to ideal-agent's guard. Send it to me as a guard rule with a refused case
    and an allowed one.
- **The layout itself as data:** each top-level folder with its meaning, and branch prefixes with their
  lifetimes, so a check reads it and a README is rendered from it. Not prose to keep in step.
- **One home for worktrees** (point 2) is the first thing I would settle. I will change `branch`, the guard's
  message and prune to match whatever is decided.

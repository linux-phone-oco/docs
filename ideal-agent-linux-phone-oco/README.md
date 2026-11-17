# ideal-agent-linux-phone-oco

What an agent needs that is linux-phone-oco's own. Everything general - how a session starts, lands,
records, changes a device, researches, orchestrates, keeps a shared resource - is
[ideal-agent](https://github.com/grenudi/ideal-agent)'s (its practices and skills); this folder keeps only
the domain: who works here, on what, with which tools. What is known about the phones is not here but in
this repository's database (`tad q about --subject X`; see [AGENTS.md](../AGENTS.md)).

Checked against ideal-agent 0.3.22 (overlay-check under 15%).

| Brief | The role | Its method (ideal-agent skill) |
|---|---|---|
| [coordinator.md](coordinator.md) | the author's one session: relays his words, keeps the records true, routes work | `keep-the-start-light` (renewing itself) |
| [surya-coordinator.md](surya-coordinator.md) | surya's lane coordinator: starts and renews the phone keepers, never touches the phone | `keep-a-shared-resource`, `keep-the-start-light` |
| [orchestration.md](orchestration.md) | tends the conveyor and the sessions on it | `orchestrate-agents` |
| [phone-keeper.md](phone-keeper.md) | keeps surya: its queue, one change at a time, through devlab (bring-up folded in) | `keep-a-shared-resource`, `bring-up-a-part`, `change-a-device` |
| [walleye-coordinator.md](walleye-coordinator.md) | the Pixel 2's lane coordinator, on surya's pattern | `keep-a-shared-resource` |
| [feature-research.md](feature-research.md) | finds the way for one hard feature | `research-a-feature` |
| [bring-up.md](bring-up.md) | prepares a part's work for the keeper | `bring-up-a-part` |

Every brief, and the author's words in it, is a starting point: look around first (ideal-agent's look-around-first,
practice 22) before building on it. A coordinator that sees a method missing researches it on its own
(look-around-first, 'When a method is missing').

Each brief names its role under its title - `Role: keeper (ideal-agent)`, a card in ideal-agent's `agents/` -
with `Name:` (who signs the work) and `Also practices: 42`. The prompt that starts a session begins with
those lines; the session then reads the card and only its practices, and the brief keeps only what
linux-phone adds to the role.

## How records go here (practice 42's domain part)

Recorded as ideal-agent's record-the-work says; linux-phone's part:

- **One database.** All linux-phone records - decision, research, backlog, session log, concept, source,
  milestone - go into this repository's tables through its named records, each naming its place:
  `tad r decision --project surya-lab ...`. `tad statements` lists every record and query with its
  parameters; a missing one is added to `records/` alongside the work that needs it.
- **What it is about.** Give every record `--about` - a component, feature, milestone, device or backlog
  item (`tad q about` lists them) - so `tad q about --subject X` finds it.
- **No ocoeco.** Git itself records the work: the session's shell is ready by ideal-agent's agent-env
  (signed as the brief's `Name:`), work from a worktree of your own, commit, and `land --no-manual`.
- **The phone.** Only through devlab, and only by its keeper; anything that needs the phone goes on the
  phone's queue in that phone's own base (surya-lab, google-walleye-lab: `tad q phone-queue`; what a lane's
  launchers read: `tad q lane-next --needs phone|research|build` there; docs has no lane queries).

Why: the author, 2026-11-17 - linux-phone keeps everything in tad, in one database (decision
2026-11-17-one-database), and an agent's domain is kept beside the knowledge, not in the general agent
(decision 2026-11-17-ideal-knowledge-base).

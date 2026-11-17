# ideal-agent-linux-phone-oco

What an agent needs that is linux-phone-oco's own. Everything general - how a session starts, lands,
records, changes a device, researches, orchestrates, keeps a shared resource - is
[ideal-agent](https://github.com/grenudi/ideal-agent)'s (its practices and skills); this folder keeps only
the domain: who works here, on what, with which tools. What is known about the phones is not here but in
this repository's database (`tad q about --subject X`; see [AGENTS.md](../AGENTS.md)).

| Brief | The role | Its method (ideal-agent skill) |
|---|---|---|
| [coordinator.md](coordinator.md) | the author's one session: relays his words, keeps the records true, routes work | `keep-the-start-light` (renewing itself) |
| [surya-coordinator.md](surya-coordinator.md) | surya's lane coordinator: starts and renews the phone keepers, never touches the phone | `keep-a-shared-resource`, `keep-the-start-light` |
| [orchestration.md](orchestration.md) | tends the conveyor and the sessions on it | `orchestrate-agents` |
| [phone-keeper.md](phone-keeper.md) | keeps surya: its queue, one change at a time, through devlab (bring-up folded in) | `keep-a-shared-resource`, `bring-up-a-part`, `change-a-device` |
| [walleye-coordinator.md](walleye-coordinator.md) | the Pixel 2's lane coordinator, on surya's pattern | `keep-a-shared-resource` |
| [feature-research.md](feature-research.md) | finds the way for one hard feature | `research-a-feature` |
| [bring-up.md](bring-up.md) | prepares a part's work for the keeper | `bring-up-a-part` |

Each brief names its role under its title - `Role: keeper (ideal-agent)`, a card in ideal-agent's `agents/`
(purpose, owns, never, loads, model and effort, hand-over, reports to, its practices) - with `Name:` (who signs
the work) and `Also practices: 42`. The prompt that starts a session begins with those lines; the session then
reads the card and only its practices, and the brief keeps only what linux-phone adds to the role.

## How records go here (practice 42's domain part)

- **One database.** Every record of every linux-phone place - decision, research, backlog, session log,
  concept, source, milestone - goes into this repository's tables through its named records, naming the
  place: `tad r decision --project surya-lab ...`. `tad statements` lists every record and query with its
  parameters; a missing one is a new file in `records/`, in the same change as the work that needs it.
- **What it is about.** Give every record `--about` - a component, feature, milestone, device or backlog
  item (`tad q about` lists them) - so that `tad q about --subject X` finds it.
- **No ocoeco.** The record of work is git itself: the session's shell is ready by ideal-agent's agent-env
  (signed as the brief's `Name:`), work from a worktree of your own, commit, and `land --no-manual`.
- **The phone.** Only through devlab, and only by its keeper; anything that needs the phone goes on the
  phone's queue (`tad r backlog ... --needs phone`; `tad q phone-queue`).

Why: the author, 2026-11-17 - for linux-phone everything goes through tad in one database (decision
2026-11-17-one-database), and an agent's domain is kept beside the knowledge, not in the general agent
(decision 2026-11-17-ideal-knowledge-base).

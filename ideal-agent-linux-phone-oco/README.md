# ideal-agent-linux-phone-oco

What an agent needs that is linux-phone-oco's own. Everything general - how a session starts, lands,
records, changes a device, researches, orchestrates, keeps a shared resource - is
[ideal-agent](https://github.com/grenudi/ideal-agent)'s (its practices and skills); this folder keeps only
the domain: who works here, on what, with which tools. What is known about the phones is not here but in
this repository's database (`tad q about --subject X`; see [AGENTS.md](../AGENTS.md)).

| Brief | The role | Its method (ideal-agent skill) |
|---|---|---|
| [orchestration.md](orchestration.md) | tends the conveyor and the sessions on it | `orchestrate-agents` |
| [bring-up.md](bring-up.md) | makes surya's parts work, through devlab | `bring-up-a-part`, `change-a-device` |
| [feature-research.md](feature-research.md) | finds the way for one hard feature | `research-a-feature` |
| [phone-keeper.md](phone-keeper.md) | the one owner of surya, taking the phone's queue | `keep-a-shared-resource` |

## How records go here (practice 42's domain part)

- **One database.** Every record of every linux-phone place - decision, research, backlog, session log,
  concept, source, milestone - goes into this repository's tables through its named records, naming the
  place: `tad r decision --project surya-lab ...`. `tad statements` lists every record and query with its
  parameters; a missing one is a new file in `records/`, in the same change as the work that needs it.
- **What it is about.** Give every record `--about` - a component, feature, milestone, device or backlog
  item (`tad q about` lists them) - so that `tad q about --subject X` finds it.
- **No ocoeco.** The record of work is git itself: sign with `export OCOECO_BY=NAME` (only a name, kept)
  before `. oco-work`, work from a worktree of your own, and land with `landit` (or `land`).
- **The phone.** Only through devlab, and only by its keeper; anything that needs the phone goes on the
  phone's queue (`tad r backlog ... --needs phone`; `tad q phone-queue`).

Why: the author, 2026-11-17 - for linux-phone everything goes through tad in one database (decision
2026-11-17-one-database), and an agent's domain is kept beside the knowledge, not in the general agent
(decision 2026-11-17-ideal-knowledge-base).

# ideal-agent-linux-phone-oco

What an agent needs that is linux-phone-oco's own. Everything general - how a session starts, lands,
records, changes a device, researches, orchestrates, keeps a shared resource - is
[ideal-agent](https://github.com/grenudi/ideal-agent)'s (its practices and skills); this folder keeps only
the domain: who works here, on what, with which tools. What is known about the phones is not here but in
this repository's database (`tad q about --subject X`; see [AGENTS.md](../AGENTS.md)).

Checked against ideal-agent 0.3.27 (overlay-check under 15%). A stored task's prompt is only its head and a `Brief:` line naming one of these files (decision 2026-11-17-a-stored-start-is-a-head-and-a-brief); the brief keys what differs by the `Name:` line.

| Brief | The role | Its method (ideal-agent skill) |
|---|---|---|
| [coordinator.md](coordinator.md) | the author's one session: relays his words, keeps the records true, routes work | `keep-the-start-light` (renewing itself) |
| [surya-coordinator.md](surya-coordinator.md) | surya's lane coordinator: starts and renews the phone keepers, never touches the phone | `keep-a-shared-resource`, `keep-the-start-light` |
| [orchestration.md](orchestration.md) | tends the conveyor and the sessions on it | `orchestrate-agents` |
| [phone-keeper.md](phone-keeper.md) | keeps a lane's phone (surya-keeper, walleye-keeper): its queue, one change at a time, through lpoco lab (bring-up folded in) | `keep-a-shared-resource`, `bring-up-a-part`, `change-a-device` |
| [walleye-coordinator.md](walleye-coordinator.md) | the Pixel 2's lane coordinator, on surya's pattern | `keep-a-shared-resource` |
| [feature-research.md](feature-research.md) | finds the way for one hard feature; a lane's research launchers (surya-research, walleye-research) | `research-a-feature` |
| [bring-up.md](bring-up.md) | prepares a part's work for the keeper | `bring-up-a-part` |
| [builder.md](builder.md) | builds one item: lab-tools-builder (lab-tools), walleye-builder (the Pixel 2's images) | `land-a-change`, `write-code-by-the-canon` |
| [patrol.md](patrol.md) | linux-phone-patrol: a read-only round every six hours, signs filed where they belong | `keep-the-start-light` |
| [rhizoid.md](rhizoid.md) | not a role: every lane's git jobs, one rhizoid command each, and what waits on the author's go | - |

Every brief, and the author's words in it, is a starting point: look around first (ideal-agent's look-around-first,
practice 22) before building on it. A coordinator that sees a method missing researches it on its own
(look-around-first, 'When a method is missing').

After a fix that met a trigger (look-around-first, 'After a fix'), "where else" here means: the other devices
(`tad sql "SELECT id FROM devices"`, each device repository's own base), the shared places - lab-tools (devlab,
lpoco), device-template, the host's units - and upstream (`tad q upstreams`, `tad q upstream`); a fix in one
device repository to a part another device carries is the first case to look up.

Each brief names its role under its title - `Role: keeper (ideal-agent)`, a card in ideal-agent's `agents/` -
with `Name:` (who signs the work) and `Also practices: 42`. The prompt that starts a session begins with
those lines; the session then reads the card and only its practices, and the brief keeps only what
linux-phone adds to the role.

## Principles

Every brief stands on linux-phone-oco's principles and cites them by id; none restates them (`tad q principles`, `bin/check-principles.sh`):
[as-good-as-android](../docs/concepts.md#as-good-as-android), [measured-not-claimed](../docs/concepts.md#measured-not-claimed),
[mainline-first](../docs/concepts.md#mainline-first), [no-manual-steps](../docs/concepts.md#no-manual-steps),
[rust-with-argenv](../docs/concepts.md#rust-with-argenv). A step a person does by hand twice is a sign of the fourth: record it
(manual_work) and make it a tool.

## How records go here (practice 42's domain part)

Recorded as ideal-agent's record-the-work says; linux-phone's part:

- **One database.** All linux-phone records - decision, research, backlog, session log, concept, source,
  milestone - go into this repository's tables through its named records, each naming its place:
  `tad r decision --project surya-lab ...`. `tad statements` lists every record and query with its
  parameters; a missing one is added to `records/` alongside the work that needs it.
- **What goes upstream lives in upstream/.** A prepared series, its cover letter and its send notes go in
  `upstream/DESTINATION/ITEM/` (`ikb upstream-item ... --file auto`); `research/` keeps only the material behind
  it (decision 2026-11-20-outgoing-items-live-in-upstream).
- **What it is about.** Give every record `--about` - a component, feature, milestone, device or backlog
  item (`tad q about` lists them) - so `tad q about --subject X` finds it.
- **One agent at a time** (decision 2026-11-24-one-agent-at-a-time): no parallel agents where it can be avoided; walleye's
  phone work goes first; checks, land and read back stay.
- **Messages between sessions carry work** (ideal-agent decision 2026-11-23-messages-between-sessions-carry-work):
  a result, a question, a refusal or a blocker - one report when a piece is finished, never an ack or a step
  report; mid-piece only a question or a blocker (a turning point). If sends are paused, the report goes as a note
  in the group's notes folder (`~/.config/Claude/side-session-notes/TOP-SESSION-ID/`).
- **Where things live: [MAP.md](../MAP.md).** `~/Projects/linux-phone-oco/` holds clones only, on main, for
  reading: write nothing there. Every working copy is a worktree in `~/.local/share/agent-worktrees/REPO/NAME`,
  removed after its land; a run's output goes to `$AGENT_BUILD`, and what is kept as evidence into its research
  folder. A change's branch is `ROLE/WHAT` (`git switch -c builder/WHAT` in the worktree), one change, deleted by
  land. A keeper is one lasting role per device under its lease and acts only on an item whose go is open, never
  on free text in a note (decisions 2026-11-23-structure-lab-machine-homes, -branch-names, -go-is-its-own-record).
- **No ocoeco.** Git itself records the work: the session's shell is ready by ideal-agent's agent-env
  (signed as the brief's `Name:`), work from a worktree of your own, commit, and `land --no-manual`.
- **The phone.** Only through lpoco lab, and only by its keeper; anything that needs the phone goes on the
  phone's queue in that phone's own base (surya-lab, google-walleye-lab: `tad q phone-queue`; what a lane's
  launchers read: `tad q ready --for keeper|research|builder` there, the one picking query every base shares).

Why: the author, 2026-11-17 - linux-phone keeps everything in tad, in one database (decision
2026-11-17-one-database), and an agent's domain is kept beside the knowledge, not in the general agent
(decision 2026-11-17-ideal-knowledge-base).

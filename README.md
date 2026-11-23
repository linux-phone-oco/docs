---
what: the memory of linux-phone-oco - every record of every place, the role briefs, the series headed upstream, the project map
kept by: orchestration; every session records here through ikb and land
records in: this repository (data/)
branches: ROLE/WHAT, one change each, deleted when landed
project map: MAP.md
---

# linux-phone-oco/docs

The memory of [linux-phone-oco](https://github.com/linux-phone-oco), whose goal is Linux phones
as good as Android for everyday use, and better - one device and one piece of hardware at a time,
everything upstream. Here: which phone supports which hardware, how we know, why decisions were
made, and what is next. The data behind it is plain, versioned, and queryable - see
[AGENTS.md](AGENTS.md).

Read it as a site: **https://linux-phone-oco.github.io/docs/**. Style follows
[`software-engineering-canon`](https://github.com/creation-guidelines/software-engineering-canon)'s RFC-like minimal
theme (deliberately: structure by indentation and whitespace, not font-size jumps, bold, or color).

## Map

The whole project on one screen: [`MAP.md`](MAP.md). This repository:

| folder or file | what it is |
|---|---|
| `MAP.md` | where everything of linux-phone-oco is, and why |
| `data/`, `tables.toml`, `queries/`, `records/`, `idealkb.toml` | the one database: its rows, schema, named queries and records |
| `docs/` | the pages rendered from it, the site (one phone each, the support matrix, the log, the backlog) |
| `research/` | the material behind research rows, `research/ABOUT/DATE/` |
| `upstream/` | work headed to other projects: `upstream/LIST/ITEM/`, its send notes and each version sent |
| `ideal-agent-linux-phone-oco/` | the role briefs and what an agent needs that is this project's own |
| `device-layer/` | what docs gives every phone's lab base |
| `face/`, `lenses/` | the project's view for the Open Commons Observatory, and further lenses |
| `bin/` | installs, checks, feeds and page renders |
| `rhizoid.graph.toml` | the repository graph: who follows which source, each pin and its gate, each fork's upstream (`rhizoid status`, `rhizoid bump`) |

Never at the top: run logs, worktrees, a second queue of anything.

## Process
Built on [`creation-guidelines/text-as-data-template`](https://github.com/creation-guidelines/text-as-data-template); the
engineering process this org follows is [`ideal-project-playbook`](https://github.com/creation-guidelines/ideal-project-playbook).
## Licence

The data, the pages, the briefs and the research notes here are [CC-BY-SA-4.0](LICENSE); the scripts, statements and configuration (`bin/`,
`records/`, `queries/`, `.github/`, and the scripts of a research note) are MIT OR Apache-2.0, at your option ([`LICENSE-MIT`](LICENSE-MIT),
[`LICENSE-APACHE`](LICENSE-APACHE)). A patch we wrote against a third-party project carries the licence of the files it changes: the kernel's
GPL-2.0-only, a device tree's own BSD-3-Clause or MIT, sxmo-utils' AGPL-3.0-only.
[`REUSE.toml`](REUSE.toml) says it per path, the texts are in `LICENSES/`, and `bin/licence-check` (run by `make verify`) keeps new files covered.

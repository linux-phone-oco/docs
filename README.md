# linux-phone-oco/docs

The memory of [linux-phone-oco](https://github.com/linux-phone-oco), whose goal is Linux phones
as good as Android for everyday use, and better - one device and one piece of hardware at a time,
everything upstream. Here: which phone supports which hardware, how we know, why decisions were
made, and what is next. The data behind it is plain, versioned, and queryable - see
[AGENTS.md](AGENTS.md).

Read it as a site: **https://linux-phone-oco.github.io/docs/**. Style follows
[`software-engineering-canon`](https://github.com/creation-guidelines/software-engineering-canon)'s RFC-like minimal
theme (deliberately: structure by indentation and whitespace, not font-size jumps, bold, or color).

## What is here
- `devices.md` - one phone each.
- `components.md` - a fixed vocabulary of hardware features (audio, display, connectivity, ...).
- `support_status.md` - the matrix: which device supports which component, and how we know. `unknown` means nobody has
  checked; it is not a softer `broken`.
- `session_log.md` - the development log for this org: what was done, why, and what was considered and rejected.
- `sources.md`, `backlog.md` - citations, and the open plan.

## Process
Built on [`creation-guidelines/text-as-data-template`](https://github.com/creation-guidelines/text-as-data-template); the
engineering process this org follows is [`ideal-project-playbook`](https://github.com/creation-guidelines/ideal-project-playbook).
## Licence

The data, the pages, the briefs and the research notes here are [CC-BY-SA-4.0](LICENSE); the scripts, statements and configuration (`bin/`,
`records/`, `queries/`, `.github/`, and the scripts of a research note) are MIT OR Apache-2.0, at your option ([`LICENSE-MIT`](LICENSE-MIT),
[`LICENSE-APACHE`](LICENSE-APACHE)). A patch we wrote against a third-party project carries the licence of the files it changes: the kernel's
GPL-2.0-only, a device tree's own BSD-3-Clause or MIT, sxmo-utils' AGPL-3.0-only.
[`REUSE.toml`](REUSE.toml) says it per path, the texts are in `LICENSES/`, and `bin/licence-check` (run by `make verify`) keeps new files covered.

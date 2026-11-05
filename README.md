# linux-phone-oco/docs

Docs and logs for mainlining Linux on phones: which device supports which hardware, how we know, and why decisions were
made. The data behind it is plain, versioned, and queryable - see [AGENTS.md](AGENTS.md).

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

---
what: the map of linux-phone-oco - where everything is, and why
kept by: steward (structure), orchestration (this repository)
decided: 2026-11-23-structure-* (tad q about --subject self-explaining-structure)
---

# The map of linux-phone-oco

linux-phone-oco brings mainline Linux to phones, one piece of hardware at a time, everything upstream.
This page says where each thing lives. If something is not where this page says, the page or the thing is
wrong: tell the steward.

## The repositories (github.com/linux-phone-oco)

| repository | what it holds |
|---|---|
| `docs` | the project's memory: one database of every record (decisions, research, backlog, what each phone supports), the role briefs, the series headed upstream (`upstream/`) and this map |
| `google-walleye-lab` | the Pixel 2 (walleye): its manifest `device.toml`, its own base (queue, tries, research), the procedures a keeper runs, its rootfs and image builds, its kernel (today patches in `kernel/`; to become `kernel/topics.toml`, the list its test kernel is assembled from) |
| `surya-lab` | the POCO X3 NFC (surya), the same shape |
| `device-template` | what a new phone's lab starts from |
| `lab-tools` | the `lpoco` tools every lab uses: device lab, health checks, bring-up, attended runs |
| `linux` | the kernel (today `grenudi/linux`; which upstreams it follows is kept in git-rhizoid's graph): one branch per upstream series, one test kernel per phone, built from a list |
| `sxmo-deviceprofiles`, `lens` | Sxmo device profiles before they go upstream; the project's view for the Open Commons Observatory |

Each repository's README opens with its own map: one line per top-level folder.

## The kernel's branches

| branch | what it is | lifetime |
|---|---|---|
| `topic/ITEM` | one upstream series alone, on a stated mainline tag; ITEM is its upstream-item id - its home for upstreaming | until upstream takes it; each version sent is tag `topic/ITEM/vN`, on the author's signed commits |
| `backport/ITEM/BASE` | the same series on another base a phone runs (e.g. sm7150-mainline `v7.2`) | while a phone runs that base |
| `wip/LANE/WHAT` | a try, on any base | until it works (then it becomes a topic) or is dropped |
| `int/DEVICE/LIST` | a phone's test kernel, assembled by git-rhizoid (`rhizoid assemble`, called by lab-tools after its checks) from a named list in the lab's `kernel/topics.toml`; never edited by hand | rebuilt each time; each build tagged `int/DEVICE/LIST/BASE/N`, which the image (`kernel_tag`) and its test-run name |

"A kernel with working display and working storage" is two lines in `kernel/topics.toml` (rhizoid owns its format, the lab owns the file). Until a lab has it, its kernel is built as its `build/` says.

## Branches in our other repositories

`ROLE/WHAT` (`keeper/…`, `builder/…`, `research/…`, `coord/…`, `orch/…`, `steward/…`): one change, deleted
when it lands through `land`. `main` is the only lasting branch.

## The lab machine

| place | what is there |
|---|---|
| `~/Projects/linux-phone-oco/` | one clone per repository, on main, for reading - and nothing else |
| `~/.local/share/agent-worktrees/REPO/NAME` | every working copy a session edits in (made by `branch`), removed after `land` |
| `~/.cache/agent-build/RUN` (`$AGENT_BUILD`) | a run's output; what is kept as evidence moves into its research folder |
| `~/Projects/walleye-build`, `~/Projects/surya-audio` | kernel and image builds, outside git; the lab's `device.toml [images.*]` says which image is which |
| `~/.config/devlab/`, `~/.local/state/devlab/` | secrets and what a lab learns at run time - never in a repository |

## The flow, and where each step writes

| step | where it is written |
|---|---|
| research | a research row (`ikb research`) in the base it is about, its material in `research/ABOUT/DATE/` |
| decision | a decision row (`ikb decision`), naming the research it rests on and what was rejected |
| build | a builder's branch in the lab or tool repository; kernel changes on `topic/` or `wip/` branches |
| phone try | a keeper runs a procedure from the lab repository, under a go; the result is a test-run row and research |
| record | every record through `ikb`, landed with `land`; the author's words in marshall-oco/conversation |
| upstream | an upstream-item row; the series in `docs/upstream/LIST/ITEM/`, cut from `topic/ITEM` as an unsigned `vN-draft/`; only the author signs and sends, then `vN/` is his signed version |

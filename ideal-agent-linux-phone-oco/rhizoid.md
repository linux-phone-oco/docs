# rhizoid: every lane's git jobs, one command each

rhizoid ([git-rhizoid/rhizoid](https://github.com/git-rhizoid/rhizoid)) runs the git flows of the structure
(decision 2026-11-23-structure-git-flows-run-on-rhizoid). This page says what it does at **v0.3.2**, beyond what the
steward checked at v0.2.0, and which command each lane uses for each git job. Every flag is in
[its README](https://github.com/git-rhizoid/rhizoid#readme); the reasons are in its design log,
[git-rhizoid.github.io](https://github.com/git-rhizoid/git-rhizoid.github.io) (decisions, backlog).

rhizoid is general: it knows nothing of kernels or phones. Every name it uses comes from the graph
(`rhizoid.graph.toml` here), a list file, or its config. Each command is declared through argenv-resolve 0.4.
A verb that changes anything outside the machine prints its plan, marking each step `outward=yes|no`, and acts only
with `now`.

## What changed since v0.2.0

| Since | What | Command |
|---|---|---|
| v0.2.0 | `assemble` over any repository; test kernels are tags `int/DEVICE/LIST/BASE/N`, never branches; an unchanged recipe reuses its tag (`unchanged=yes`); `--done TAG` ends a worktree; known-good entries need a commit's sha | `rhizoid assemble LIST --lists FILE --repo DIR` |
| v0.2.0 | `status` reads every edge: slices, tool pins, forks, integrations (name scheme, topic base, branch against origin via ls-remote, recipe, worktrees) | `rhizoid status [--fetch]` |
| v0.2.1-2 | `send-back` drafts a series' next version: rebased onto the maintainer's tree, format-patch with cover letter, `--base` and range-diff, checks run, a `-draft` tag. It never signs, sends or pushes | `rhizoid send-back topic/ITEM --onto REF --out DIR --config FILE --tested SHA` |
| v0.2.3-6 | `bump` lists every pin of the graph in one place and moves tool pins on a branch, gated (`gate`) and with their lock files (`also`); `--push` / `--pr` | `rhizoid bump` / `rhizoid bump now --only OWNER/REPO --pr` |
| v0.2.5 | `follow` lays an idealkb release into a base byte for byte as idealkb's `follow.sh` does (its conformance test runs both) | `rhizoid follow --source IDEALKB_CLONE BASE VERSION` |
| v0.3.0-1 | cuttings: `add` (fork an upstream), `import` (own an existing fork), `update` (merge the upstream in), `refresh`, `remove`, each recorded as a `[[fork]]` in the graph, the one place cuttings live (decision 2026-11-23-cuttings-live-in-the-graph). A fork whose changes are topic branches is `--patches integration`: its tracking is the `[[integration]]` edge's `releases`, and `update` merges and pushes nothing | `rhizoid import OWNER/REPO` then the same with `now` |
| v0.3.2 | cut tags: a cutting with `cut_tags` tags a changed patch tip `RELEASE-cut.N` on `update ... now`. A `[[tool]]` with `tag_suffix = "-cut.N"` bumps to the newest cut, ordered by release then N (never by semver). Cargo `[patch."URL"]` keys work as pins | `rhizoid update MODULE` then the same with `now` |

## Pins: decision 2026-11-23-pins-stay-with-their-readers

Each pin stays in the file its reader reads: `idealkb.toml` and `devicebase.toml` (read by follow), `lab.toml`'s
`tools.*` (read by lpoco-host), and a Cargo git tag (read by cargo). There is no second pin file. **`rhizoid bump` is
the only thing that moves a pin.** The author accepted this on 2026-11-23, with one condition: "if it does not
introduce drift and busy work, then ok". If any lane finds a pin it has to keep in sync by hand, it reports this to
the top coordinator and does not add a workaround.

One pin is still moved by hand: `tools.rhizoid` in lab-machine's `lab.toml` (now v0.3.1) has no `[[tool]]` edge in
the graph, so `bump` cannot see it. Adding that edge is orchestration's step, since it keeps the graph.

## Each lane's git jobs

| Lane | Git job | Command |
|---|---|---|
| walleye, surya (their builders, keepers) | build a test kernel from a named list in the lab's `kernel/topics.toml` | `lpoco bringup kernel assemble LIST --lists kernel/topics.toml --repo CLONE --records DOCS`; lab-tools runs its record checks first, then `rhizoid assemble` |
| walleye, surya | check a tag reproduces a known image | add `--reproduces COMMIT` to the above |
| walleye, surya | publish the tag an image names, and end its worktree | `lpoco bringup kernel publish TAG --repo CLONE` (pushes only a tag a manifest's `kernel_tag` names) |
| walleye, surya | end a worktree no image needs (a kernel tree is ~1.8 GB checked out) | `rhizoid assemble --done TAG --repo CLONE` |
| walleye, surya | see whether topics are on the newest release, local-only, or stale against origin | `rhizoid status --fetch` (in docs, on the graph) |
| upstreams | draft a topic's next version for its maintainer | `rhizoid send-back topic/ITEM --onto REF --out DIR --config kernel-send.toml --tested SHA --fork ID`; the author signs and sends, then marks it sent with `git tag topic/ITEM/vN SIGNED_TIP` |
| upstreams | follow a fork's upstream | `rhizoid update MODULE` (plan), then the same with `now` |
| orchestration | the whole graph's drift, one report | `rhizoid status --fetch` |
| orchestration | every pin in one place, and moving tool pins | `rhizoid bump`, then `rhizoid bump now --only OWNER/REPO --pr` |
| orchestration | own a fork as a cutting / take a new upstream | `rhizoid import OWNER/REPO` / `rhizoid add SOURCE` (plan), then the same with `now` |
| ikb, every base that follows idealkb | lay an idealkb release into a base | `rhizoid follow --source IDEALKB_CLONE BASE VERSION`; it replaces `follow.sh` byte for byte, behind the shim in the git-rhizoid notes, once ikb takes it over |
| any builder of a Cargo module riding a cutting | pin the module to a cut | a `[[tool]]` with `tag_suffix = "-cut.N"`, moved by `rhizoid bump` |

## What waits on the author's go

- **Outward steps, each the first time for its module:** a fork, a push, a merge from upstream, and the first real
  cut-tag push, each after its plan has been shown. No cut tag has been pushed anywhere yet. The author's one go so
  far, for `import grenudi/sxmo-utils`, met the fork's archive (403) and was dropped. That fork is being retired
  (backlog `sxmo-fork-retired`).
- **Sending a series upstream:** `send-back` only drafts. The author reads, signs and sends.
- **surya is paused.** Nothing in its lane moves until it resumes.

## Not yet named elsewhere

`MAP.md` names only `assemble` and the `int/` tags. The [builder brief](builder.md) and ideal-agent's role cards and
skills do not name rhizoid yet. Bringing them up to date is the steward's next step, with this page as its source.

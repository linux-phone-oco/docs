# Structure review: the rules decided, 2026-11-23

The rules this review decided, each a decision row `2026-11-23-structure-*`. Plain words first; reasons and what was
rejected follow each rule.

What is, and what the roles said: `README.md` here. How others do it: `look-around.md`.

## The rules (the simplest that explain themselves)

### 1. The lab machine
- `~/Projects/linux-phone-oco/` holds clones only, each on main, one per repository - ours and the
  forks we patch (the kernel `linux`, `sxmo-utils`). Nothing else: no worktrees, logs or queues.
- Worktrees live in one place: `~/.local/share/agent-worktrees/REPO/NAME` (what ideal-agent's `branch`
  already does). Rejected: `wt-*` beside the clones (no owner, never removed), `~/Projects/.worktrees`.
- A run's output goes to `$AGENT_BUILD` (`~/.cache/agent-build/RUN`); what is kept as evidence goes into
  the research row's material folder in the lab repo. Rejected: logs at the root.
- Build areas (`walleye-build`, `surya-audio`) stay where they are for now (scripts and device.toml
  name them), each with a README saying what it is and that `device.toml [images.*]` is the index.
  Pruning images no manifest names is a later builder item, each with a recorded reason.

### 2. Every repository
- Each top-level folder has one meaning, and a README.md whose first line says it.
- The repository's README.md opens with a short map (shape below): what the repo is, who keeps it,
  where its records go, and one line per top-level folder.
- A check refuses a top-level folder that is not in the map or has no README.

### 3. Branches in our repositories
- `ROLE/WHAT` (`keeper/…`, `builder/…`, `research/…`, `coord/…`, `orch/…`, `steward/…`), one change each,
  deleted when it lands (GitHub "automatically delete head branches"). Release branches are the release
  tool's. Rejected: no convention (today); dated names.
- The old branches whose pull request was merged are deleted (the change is on main; the PR is the
  pointer). Any other is kept as a tag `archive/NAME` before its branch goes.

### 4. The kernel (the author's main ask)
In plain words: every fix we mean to send upstream lives on its own branch, alone, on a clean mainline
release. A phone's test kernel is never edited by hand: a tool builds it by stacking the branches named
in a short written list, and stamps the result with a tag. "Working display + working storage" is two
lines in that list.

- One kernel repository, `linux-phone-oco/linux` (today grenudi/linux, a fork of sm7150-mainline/linux,
  reached by a redirect; moving it into the organisation is the author's call). On the lab machine, one
  clone of it, `~/Projects/linux-phone-oco/linux`; every kernel worktree is a worktree of that clone, so
  the conflict resolutions git rerere remembers are shared by all.
- `topic/ITEM` - one branch per upstream series, ITEM being its upstream-item id, on a stated base: a
  mainline tag `vX.Y[-rcN]`, or for a carried series the fork tag it needs (sm7150-mainline's `v7.2`). It
  is the series' home and b4 can enrol it as it is (`b4 prep --enroll`, the cover letter an empty first
  commit). docs `upstream/LIST/ITEM/` keeps the send notes and, per version sent, `vN/` made from the
  branch by `git format-patch` (never edited by hand); the version sent is kept as the tag `topic/ITEM/vN`.
  Patches we carry but did not write are topics too; the item row says whose (`--carried-in`).
- `wip/LANE/WHAT` - experiments, on any base; a wip that works becomes a topic; deleted when done.
- `int/DEVICE` - the test kernel of one phone, assembled by a tool from a written list in its lab
  repository, `kernel/topics.toml`: the base, then each topic in order, with one line on what it is for
  and its state (`known-good`, naming the test-run that shows it, or `trying`). The tool starts from the
  base every time, merges each topic in order, stops at a conflict naming the two topics, and tags each
  result `int/DEVICE/BASE/N` (`int/walleye/v7.3/1`). Every test kernel is built from such a tag, so a
  test-run names exactly which topics it tried. The branch is rebuilt, never edited.
- The tool: `lpoco-bringup kernel assemble` in lab-tools; it refuses a topic that has no upstream-item
  row or whose commits disagree with their `FROMLIST(item)` subjects (what `check-fork-tags.sh` checks).
- A lab repository keeps only what is the phone's own: `kernel/topics.toml`, config fragments and the
  build of an image from an `int/` tag. Patches in google-walleye-lab `kernel/`, surya-lab `patches/`, and
  board `.dts` in google-walleye-lab `dt/` move to topic branches (a builder item per lane).
- Rejected: a long-lived device branch with cherry-picks (today `test/surya-calls`: nobody can say what is
  in it); `.patch` files in a lab repo (they drift from the tree); quilt, StGit, TopGit (more commands and
  metadata to learn; series files drift the same way); topics in a second repository as qcom-next does
  (two repositories for two phones is ceremony); Linaro automerge as-is (its config is undocumented; the
  merge loop is small). Kept from others: linux-next's written list rebuilt onto a fresh base every time,
  b4's one branch per series, pmaports' pinning of an immutable tag.

### 5. One overview note per repo, one for the project
- Each README.md opens with a block in the shape of kramdown-rfc's front matter - a few `key: value`
  lines (`what`, `kept by`, `records in`, `branches`) - then `## Map`, one line per top-level folder,
  and what must never be at the top. One screen at most. Rejected: a separate OVERVIEW.md or
  ARCHITECTURE.md (a second file to keep in step; the README is what everyone opens first).
- The whole project: `docs/MAP.md` - each repository in one line, the lab machine's folders, the kernel
  branches, the flow research → decision → build → phone try → record → upstream with the place of each.

### 6. Generated data
- Rendered pages are not committed; the site is rendered in CI. `data/` stays committed (it is the
  base), and land's regeneration settles same-file appends. Owner: idealkb, one base first, then all.
- Rejected: hand-merging generated files; one landing session per repo; one file per row (larger change).

### 7. Steering keepers
- A go is its own record (item, image sha256, until, by), append-only; an item update cannot clear it.
- A wait names a record (a decision, an author's word, a go); free text "waits on author" counts as nothing.
- The keeper's one query prints the verdict per item: `act now (go until T)`, `waits: RECORD`, `blocked: ID`.
- A keeper is started for one named item. Owners: ikb (records, query), orchestration (briefs).

### 8. Checks that refuse a wrong home
- Repository: the layout check (rule 2), in each repo's CI; ideal-agent provides it.
- Tool time: ideal-agent's guard refuses a `git worktree add` outside the worktree home, and writing a
  file directly into `~/Projects/linux-phone-oco/`.
- Records: `research --material` refused outside `research/` (like `upstream-item --file`); CI checks the
  named path exists.
- Kernel: the assemble tool refuses a topic without an upstream-item row.

## The roles' objections, taken before anything was carried out (2026-11-23)

The decision rows hold the rules as amended; this is what changed and who asked.

- orchestration: the keeper stays one lasting role per device and acts only on rows whose verdict is
  "act now" (not one keeper per item); worktrees with uncommitted work are saved or dropped by their lane
  first; sxmo-deviceprofiles and lens are named among the clones; rendered pages leave git only with a new job
  for `make verify` and the site named in the README; the guard still lets a clone be made or moved.
- ideal-agent: the layout check is `ideal-agent layout-check` in CI and reads each README's Map as the
  layout's data; "no file under ~/Projects outside a git working tree" (redirects best effort); kernel
  worktrees in the same home; the kernel's branch scheme is its own; idealkb lays its folders' READMEs.
- upstreams: only the author signs and sends, so `vN-draft/` is prepared unsigned and `vN/` comes from his
  signed branch; b4 is never required (Python); a version is cut onto the target maintainer tree; the tested
  commit is named; `backport/ITEM/BASE` for one item on two bases; item ids carry no version.
- walleye: a build script an image names retires only when the image rebuilds byte for byte from an `int/`
  tag (`kernel_tag` in `[images.X]`); bring-up dts experiments with no upstream item stay in the lab; named
  lists (ufs-off, ufs-on), never one tag for both; the kernel clone moves in one builder change with its 155
  paths, between phone runs; land's regeneration is tested on two concurrent PRs before relying on it.
- surya: carried patches move with their WORKAROUND(item) markers and `--local-ref`; the running kernel stays
  pinned by commit until `int/surya` reproduces it; adsp/, sleep/, ui/, lab/ stay where they are.

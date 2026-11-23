# surya coordinator: reflections for the structure review (2026-11-23)

## 1. What the role does
Lane coordinator of the POCO X3 NFC (surya). It never touches the phone: it queues the lane (backlog in surya-lab's own base), starts one keeper / builder / research session at a time through stored launcher tasks (`surya-keeper`, `surya-builder`, `surya-research`), routes anything needing the author's hands up to the Top Coordinator, archives finished sessions, and records outcomes.

## 2. Flows as really run
- Research: a `needs=research` backlog item in surya-lab (`ikb backlog`); the research session writes `ikb research` + `research/ABOUT/DATE/` in surya-lab, branch of its own, `land`. (Some research I recorded as backlog notes only; unclear which is canonical.)
- Decision: `ikb decision` in surya-lab `data/decisions.json` (+ rendered `docs/`). Cross-lane decisions live in docs (`2026-11-19-...` rows by orchestration) and I copy them into item notes by hand.
- Build: a `needs=build` item; the surya builder works in a fresh worktree of surya-lab (`wt-surya-builder-R`), program in `procedures/` (attended-session, steps crate) and `lab/`; lab-tools code is NOT ours (only lab-tools builder lands there). Lands with `land`.
- Phone try: the keeper takes the lease (`lpoco lab keeper`), runs through `lpoco lab ...` / `lpoco-attended run attended-session`; kernels are boot entries installed from `~/Projects/surya-audio/obj-*` / `scratch-*` builds.
- Record: every step is `ikb` -> `tad canon` -> `tad render` -> `land --no-manual` (often `LAND_REVERT_OK=1` for render reorders), in a worktree off origin/main. The instructions to the next session go INTO the backlog item's note (a launched session reads the queue, not messages).
- Upstream: via the upstreams coordinator and docs `upstream` items; surya's PMIC-watchdog series lives in grenudi/linux `topic/pmic-wdt-wake-in-suspend`. I do not push upstream myself.

## 3. Hard to find / landed wrong
- A backlog row re-passed with `ikb backlog` REPLACES the row: it dropped `go_until`, rank and waits more than once (cost an attended window). `waits` must be NULL not "".
- The same facts in three places: item note, research row, session-log; the "how the phone stands" rows in surya-lab vs docs.
- Instructions given to a running session by message are lost if the session is idle; only item notes are read.
- Shared clone `surya-lab` was detached and 28 behind; guard refuses `git switch` there. Worktrees I made: wt-surya-coord-*, wt-surya-coord2-*, wt-surya-coord3-*, surya-lab-wt-r (all mine, all removable). A mistaken `git worktree add` with a relative path created a directory inside the clone (removed).
- Not mine / unknown reason: wt-surya-keeper-* (about 12, keeper leftovers; one untracked inside the surya-lab clone: `surya-lab/wt-surya-keeper-1795001997`), surya-lab-bb-wt, -drop-wt, -hw-wt, -pr-wt, -keeper-2248, wt-k4-lab, wt-surya-mic, wt-surya-nosim, wt-surya-upstream-forks, `~/Projects/surya-audio/*` (56 GB: obj-calls3/4, scratch-calls*, obj-pmic-wdt*, image*, kernel-build, kernel-rc3, linux, patches, prior-art, variants, wcd-boots, logs). Never delete the two base images (`image/` and `image-fresh-stock/`; only fresh-stock is pristine).
- `~/Projects/linux-phone-oco/linux-topics` (the upstreams worktree of the PMIC series) is gone now; the series lives on the fork branch.
- The surya-lab base and docs both have a `backlog` and a "phone queue" notion; which one is the source of truth changed over the week (decision: surya records in surya-lab only).

## 4. Kernel
- Running kernel: tree `linux-phone-oco/linux` at commit 29d92793b (tip of `test/surya-calls`, 7.1.0-sm7150-calls+), pinned in surya-lab `device.toml [layer.kernel]`, config `kernel/surya.config`, dtbs `qcom/sm7150-xiaomi-surya-{huaxing,tianma}.dtb`.
- PMIC watchdog kernel (calls4): grenudi/linux `topic/pmic-wdt-wake-in-suspend` (8b2283da3, patch 6/6 stop_on_reboot) on surya's v7.2 test branch; builds in `~/Projects/surya-audio/obj-calls4` / `scratch-calls4`, installed as boot entry `calls4` (plain names only, no '+': devlab's boot counter suffix).
- Picking patches: by hand per test kernel (cherry-pick onto the test branch, build under surya-audio, install as an entry); no list says which patch is in which kernel except the commit subjects and the research rows. A per-kernel manifest (entry name, tree, commit, config sha, patches) would fix that.
- `~/Projects/surya-audio/patches` and `kernel-build`/`linux`/`clean-upstream` predate the topic branches; I do not know which are still used.

# Look around: how others organise trees, branches, tests and the notes that explain them

Read 2026-11-23 (researcher for the steward). Each: what they do, what we take, what we avoid.

## The kernel's own practice

- linux-next is built every day from a plain list, `Next/Trees`: one line per tree, `name url#branch`.
  Each day starts again from a fresh base and merges every listed tree in order, logged to
  `Next/merge.log`. The result is thrown away and rebuilt, never edited.
  https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/plain/Next/Trees
- Rebasing and merging: base work on well-known starting points (-rc tags); a moved series is new code
  and is retested; no back-merges; a prerequisite shared by two trees gets a topic branch of its own.
  https://docs.kernel.org/maintainer/rebasing-and-merging.html
- The qcom maintainer tree has per-release topic branches (`drivers-for-7.5`, `dts-for-6.7`) and `for-next`;
  MAINTAINERS points at it with a `T:` line. https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/MAINTAINERS
- b4 prep: one series, one branch (`b4/NAME`); the cover letter is an empty commit at its start; a
  change-id follows the series across versions; after `b4 send` the version moves on and `--compare-to vN`
  shows what changed. An existing branch can be enrolled. https://b4.docs.kernel.org/en/latest/contributor/prep.html

Take: one series per branch on a tag; one written list merged in order onto a fresh base by a tool; the
integration result rebuilt, never edited. Avoid: back-merges, hand edits on an integration branch.

## Phone ports

- msm8916-mainline/linux: one branch per release (`wip/msm8916/7.3`), side branches per feature
  (`wip/msm8916/cpr`), retired ones moved to `old/…`. https://github.com/msm8916-mainline/linux
- sm7150-mainline/linux: one branch per version (`v7.2`), feature branches (`wcd-6.19`), leftovers
  (`v6.13-old`, `v6.13-new`). https://github.com/sm7150-mainline/linux
- msm8998-mainline/linux: `qcom-msm8998-6.18.y`. https://github.com/msm8998-mainline/linux
- postmarketOS pmaports pins a tag of the fork and ships one config file:
  https://gitlab.postmarketos.org/postmarketOS/pmaports/-/tree/main/device/community/linux-postmarketos-qcom-sm7150

Take: the base version in the integration name; packaging (our image) pins an immutable tag. Avoid:
flattened per-release branches where one series can no longer be told from another - the mess we have.

## Patch-stack tools and integration trees

- git rerere records a conflict's resolution and replays it. https://git-scm.com/docs/git-rerere
- TopGit keeps dependencies in `.topdeps` inside branches; warns against rebase; history grows complex.
  https://github.com/mackyle/topgit
- StGit: a stack of patches over commits. https://stacked-git.github.io/
- quilt and gbp-pq keep patches as files listed in a `series` file.
  https://honk.sigxcpu.org/projects/git-buildpackage/manual-html/gbp.patches.html
- Linaro automerge `ci-merge` merges branches named in a config file, like linux-next, with conflict
  resolutions shared in an rr-cache repository. https://git-us.linaro.org/power/automerge.git/about/
- Qualcomm's qcom-next uses it: `qcom-next.conf` is a `baseline` line, then `name url branch` lines; the
  topics live in `qualcomm-linux/kernel-topics`. https://github.com/qualcomm-linux/kernel-config

Take: plain git topic branches + a list file + a small merge tool + rerere. Avoid: TopGit/StGit (more
commands and metadata to learn; b4 already covers the series side); quilt/gbp-pq (patches out of git,
against one branch per series).

## Tests and labs

- kernelci-pipeline `config/`: `trees.yaml`, `trees/TREE.yaml` (which branch to test), `platforms.yaml`
  (devices), `jobs.yaml`, LAVA job templates; results in KCIDB. https://github.com/kernelci/kernelci-pipeline/tree/main/config
- Linaro test-definitions: one folder per test (`automated/linux/TEST/` with its yaml, script, parser),
  and `plans/`. https://github.com/Linaro/test-definitions

Take: tests, devices and results each in their own home; one folder per test. Avoid: KernelCI's server
stack for two phones.

## Notes that explain a structure

- matklad, ARCHITECTURE.md: short, a map of coarse modules, invariants (especially "an absence of
  something"), names files rather than linking them. https://matklad.github.io/2021/02/06/ARCHITECTURE.md.html
- Diátaxis: tutorial, how-to, reference, explanation. https://diataxis.fr/start-here/
- FHS 3.0: no new root directories; each directory has a purpose; static and variable files apart.
  https://refspecs.linuxfoundation.org/FHS_3.0/fhs-3.0.txt
- kramdown-rfc: a few `key: value` lines of front matter, then abstract, middle, back.
  https://github.com/cabo/kramdown-rfc/blob/master/examples/skel.mkd

Take: a one-screen note per repository - a few key lines, one paragraph, one line per top folder, what
must never be there, pointers to the other repositories; generated files apart from written ones.
Avoid: a full Diátaxis tree; link lists that rot.

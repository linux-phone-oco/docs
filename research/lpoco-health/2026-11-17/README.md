# How tests are organised, shipped and provisioned on Linux phones and similar devices (2026-11-17)

Read by a researcher agent, outside sources only; the rows of this commons were read by the lpoco-health session.
Sources read in full are marked (read); those known only through search summaries or memory are marked (partial).

## What the mature projects share
A test is a small executable that exits 0 or non-zero; a thin runner on the device prints one result per test
case; the lab matches and collects those lines. Nobody compiles on the device: the device gets shell or
prebuilt binaries, usually delivered as an installed package.

## postmarketOS
- pmaports MR 4420 "Add initial on-device CI support" (partial, behind an Anubis wall): an initramfs hook so the
  initramfs can run in QEMU/CI with kernel + ramdisk only, and an aport `main/postmarketos-test` that ships an
  initramfs suspend/resume test script (`options="!check"`, scripts installed to initramfs or rootfs paths by name).
  Take: a test package that installs scripts into known directories. Set aside: initramfs-centred, pmOS tooling.
- bootrr, linux-msm (read): board descriptions as data (`boards/`), generic helpers (`helpers/`), a script that
  detects the board and runs its tests; prints LAVA signal lines (`deferred-probe-empty` skip, `all-cpus-are-online`
  pass); plain shell, `make install`. Take: per-board data, generic helpers, auto-detection, an explicit skip.
  This is the shape devlab-health's checks already follow.
- postmarketOS's hardware test farm: no primary source found. Not known yet.

## LAVA (read)
Test definition = YAML (`metadata`, `run: steps:`), steps joined into one shell script on the device;
`lava-test-case NAME --result pass|fail` records one case, `--shell CMD` takes it from the exit status,
`lava-test-raise` aborts the job. Parse patterns and `install:` are deprecated. Definitions come from git.
Take: one line per case with pass/fail/skip. Set aside: the YAML wrapper and the server stack.

## CI-tron (read)
Executor state machine per device under test; QUICK_CHECK compares the live configuration to a stored record,
a failure goes to TRAINING (20 boot-reliability rounds) before IDLE; a console regex can mark a machine unfit.
Take: a stored record of what the device should look like (our manifest) and repeated-boot qualification.
Set aside: PXE/gateway machinery built for GPU farms.

## systemd health checks (from memory, not read at source)
`systemctl is-system-running --wait`, `systemctl --failed`, `systemd-analyze verify|blame`, oneshot + timer.
Take: is-system-running + --failed as a cheap first gate (backlog, not built here).

## Test formats compared
- shell: runs on busybox, nothing to build; weak structure, hard to unit-test. (ours today: 13 check files)
- prebuilt static Rust (musl aarch64): one file, no toolchain on the phone; costs a cross build (we have it:
  health/build.sh, and the conveyor's CI).
- rust-script (fornwall/rust-script, read): needs Rust >= 1.74 on the phone; builds a generated Cargo project
  and caches the executable, so only the first run is slow (`--force` rebuilds). Alpine edge aarch64 `rust` is
  71.7 MiB download / 205.5 MiB installed (+gcc, musl-dev, llvm-libs); a first run that fetches crates needs
  network. Good on a lab machine; poor on a phone.
- build on the lab: the same binary everywhere, reproducible, phone stays clean; needs the cross toolchain.
- "bundle depends on tests, tests do not depend on it" (nextest design, partial): nextest lists tests of each
  binary and runs each in its own process; `harness=false` binaries must speak its protocol (not confirmed).
  Registries (`inventory`, `linkme`) link everything into one binary and are platform-sensitive (memory; not
  tried on aarch64 musl). Simpler cousin: one binary per test, discovered by directory, same result line.

## Provisioning
- apk package (Alpine wiki abuild, read): versioning, dependencies, uninstall, signature; needs a key
  (`abuild-keygen`), a signed index (`abuild-sign`), the public key in /etc/apk/keys, a repository host. pmOS does this.
- lab tool pushes files over ssh/USB: fast to iterate, no repository or key; no record of what is installed, no version check.
- reasonable split: push while it changes, package when it settles.

## Not known yet
postmarketos-test's exact contents; pmOS test-farm tooling; rust-script's cache path/key; cargo's size on Alpine
aarch64; inventory/linkme on aarch64 musl; nextest harness=false protocol; the systemd claims.

## Sources
https://gitlab.postmarketos.org/postmarketOS/pmaports/-/merge_requests/4420
https://github.com/linux-msm/bootrr
https://lava.readthedocs.io/en/latest/user/basic-tutorials/test-definition.html
https://lava.readthedocs.io/en/latest/technical-references/job-definition/actions/test.html
https://gfx-ci.pages.freedesktop.org/ci-tron/docs/components.html
https://github.com/fornwall/rust-script
https://pkgs.alpinelinux.org/package/edge/main/aarch64/rust
https://nexte.st/docs/design/how-it-works/
https://wiki.alpinelinux.org/wiki/Abump

## Addendum: building on postmarketOS upstream (asked by the author, 2026-11-17)
Checked by a second researcher run against docs.nura.eco (postmarketOS' sites now redirect to nura.eco, "formerly
postmarketOS"; the redirect is server-supplied, likely not independently verified), rhizcut read in git-rhizoid's concepts.
- Confirmed: contribution is by merge request on their GitLab, commit style follows Alpine aports (device packages
  `device-vendor-codename: ...`, forks `temp/pkg: fork from Alpine`); approval: no maintainer = two team approvals, one
  maintainer = that maintainer + one team member, 48 h for co-maintainers, two weeks before fallback.
  https://docs.nura.eco/pmaports/main/merge-requests/commitstyle.html , .../approval-rules.html
- Confirmed: on-device tests are subpackages of `postmarketos-test` (named: postmarketos-test-suspend, -unl0kr), run by the
  initramfs hook package `postmarketos-mkinitfs-hook-ci` from /usr/libexec/pmos-tests-initramfs, which reports pass/fail
  and halts the boot; a device opts in with a `$pkgname-pmtest` subpackage and a gitlab-ci.yml.j2. Only kernel (initramfs)
  tests work today; boot and system tests (Wi-Fi, Bluetooth, ...) are NOT implemented upstream.
  https://docs.nura.eco/pmaports/main/ci/hardware-ci.html
- Python is host-side: .ci/lib/generate_build_jobs.py builds the pipeline; pmbootstrap. Nothing on the phone.
- bootrr: BSD-3-Clause, 128 commits, 1 open PR; packaged by pmOS as bootrr-pmtest. Contributions accepted: not known yet.
- Their farm: CI-tron gateway, one OnePlus 6T plus four QEMU runners, a custom control PCB (20 boards to Trusted
  Contributors). Other devices need CI-tron support added (boots_db.yml.j2); production registration tokens only from their
  infrastructure team; outsiders joining is promised documentation, not yet documented.
  https://docs.nura.eco/hardware-ci/gateway.html , https://nura.eco/blog/2026/01/21/hw-ci-mvp/
- rhizcut (git-rhizoid concepts): a real GitHub fork of an upstream, owned and pinned. pmaports lives on GitLab, and a fork
  of a subfolder only: whether rhizcuts handle a GitLab upstream or a subfolder is NOT KNOWN; check before relying on it.
- Not known yet: licences/CLA of pmaports, cost of keeping an APKBUILD fork in step with generated CI templates.

### Three ways, weighed
A. Fully on upstream (fork their test pieces, sync a subfolder, send back MRs).
   + hook, subpackages, device pipelines, QEMU runs, review rules, shared maintenance exist; our tests get upstream eyes.
   - the phone-level tests we need (modem, SIM, audio, sensors, sleep, once-a-day budgets) are the part not built upstream;
     everything runs in the initramfs and halts the boot, ours runs after boot on the system; their farm has one phone and
     is token-gated; fork sync cost unknown; their process moves (rename, "unstable" docs). Python is only on the host side
     (pipeline generation) and costs nothing on the phone, so it is not what decides this.
B. Middle way: tests as small shell files in their shape (one `pass|fail|skip TEST COMPONENT detail` line each, board facts
   as data), our runner, switches, conditions and result gathering.
   + keeps every existing check and result; stays upstreamable (a check can become a postmarketos-test-* subpackage by an
     MR later); no fork to keep in step; works today, after boot, on the system.
   - not in their farm until someone does the CI-tron device work; the shape match is by convention, not by code.
C. Ours alone, a different shape: nothing to gain, set aside.

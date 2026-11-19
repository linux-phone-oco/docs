<!-- Generated from data/ by tad. Do not edit by hand. -->

# Landscape

<a id="bootrr"></a>
### bootrr

Project
: Linaro / postmarketOS

What
: Checks that every expected driver probed on a booted device; packaged in pmaports for the CI hook.

For us
: Replaces our hand-made waiting-to-probe checks with the established tool.

Link
: https://gitlab.com/postmarketOS/pmaports/-/merge_requests/4420

Checked
: 2026-11-10


<a id="pmos-deviceinfo"></a>
### Device packages and deviceinfo

Project
: postmarketOS

What
: Each device package carries a deviceinfo file - codename, name, architecture, flash method, device tree - the device's manifest.

For us
: Our device.toml derives from deviceinfo and adds only what it lacks (how the lab reaches the phone), rather than duplicating it.

Link
: https://docs.postmarketos.org/hardware-ci

Checked
: 2026-11-10


<a id="ci-tron"></a>
### CI-tron

Project
: freedesktop.org (gfx-ci)

What
: A bare-metal testing gateway: deploys test environments to devices, sequences power and boot, collects logs; devices are trained through boot cycles before they take jobs.

For us
: The gateway our lab machine could become, instead of growing its own.

Link
: https://docs.postmarketos.org/hardware-ci/gateway.html

Checked
: 2026-11-10


<a id="mobian-recipes"></a>
### mobian-recipes

Project
: Mobian

What
: Debian images built with debos; devices grouped in families by SoC; device packages (<device>-tweaks); weekly CI image builds. Points to the postmarketOS wiki to judge whether a device runs mainline.

For us
: Consumes mainline device support rather than building it: surya reaches Mobian through mainline and a family recipe, after pmOS.

Link
: https://wiki.debian.org/Teams/Mobian/DevelopersGuide

Checked
: 2026-11-10


<a id="photocraft-fleet"></a>
### ArtCraft: seventeen apps, one organisation

Project
: ArtCraft (storytold; getartcraft.com)

What
: Seven, then thirteen clean-room Rust apps built with about 8 parallel Claude agents, each owning one subsystem directory. House rules kept once (craft-contrib/standards) and stamped into every repository's AGENTS.md with a checksum; CI shared from one actions repository; agents check an issue and claim it before working; a generated scorecard, ranked gaps list and parity checklists say what is left; a test oracle (Photoshop's own renders, a CPU compositor for the GPU one) decides what counts as progress; remaining work estimated in agent-hours.

For us
: The same shape fits us, almost one to one: craft-contrib (rules and RFCs, stamped into every AGENTS.md) is creation-guidelines and the practices; craft-common-actions (CI called, not copied) is ocoeco's gather and the package conveyor's workflows; craft-launcher (installs and updates every app) is the package conveyor's Alpine repository to come; craft-repo-status-app and craft-wiki are the face and docs; every app agent-ready (CLI, JSON control, MCP) is devlab mcp and agent access. What they have and we lack: craft-skills - procedures shared as agent skills, discoverable by every agent rather than remembered (our oco-work words, as skills); and *-corpus repositories - reference data an oracle compares against (for a phone: what Android does on the same hardware - sleep current, audio levels, sensor readings - measured once and kept). Worth taking too: claim before work, estimates in agent-hours, a ranked gaps list and scorecard drawn from data, and the lesson that breadth is fast and only an oracle keeps the numbers honest.

Link
: https://github.com/storytold/photocraft/blob/main/AGENTS.md

Checked
: 2026-11-17


<a id="gas-town"></a>
### Gas Town and Beads

Project
: Steve Yegge

What
: An orchestrator for 20-30 coding agents: work state lives in git as JSON-lines issues (Beads), not in agents' memory; an agent is a persistent identity, not a session; workflows are chains of small issues an agent walks one at a time, so a crash or a full context loses nothing; supervisor roles patrol with backoff; its author says not to use it unless juggling five or more agents daily.

For us
: Our backlog, decisions and session logs in tad/ocoeco data are already the git-kept work state; ocoeco's 'where the drivers stand' is the identity view. Not to adopt: a second tracker beside ocoeco would be one nature under two names. To take: an agent is a name (OCOECO_BY) with a history in the data, and work is small steps that survive a cut-off session.

Link
: https://steve-yegge.medium.com/welcome-to-gas-town-4f25ee16dd04

Checked
: 2026-11-17


<a id="anthropic-multi-agent"></a>
### Anthropic's orchestrator-worker research

Project
: Anthropic

What
: A lead agent plans and starts 3-5 workers in parallel, each with its own context, an explicit objective, output format and boundary ('not X - that is another worker's job'); about 15 times the tokens of one agent; worth it only for work that is truly independent and valuable; later guidance argues most systems should have fewer, better-scoped agents.

For us
: Parallelise research (it is independent and reads only); serialise what touches the one phone; write each brief with its boundary; spend agents where the value is, and say the cost.

Link
: https://www.anthropic.com/engineering/multi-agent-research-system

Checked
: 2026-11-17


<a id="claude-code-agents"></a>
### Claude Code: sessions, teams, hooks, schedules

Project
: Anthropic

What
: Background sessions with cross-session messages (the desktop app), subagents inside one session, experimental agent teams with a shared task list claimed by file lock, worktrees to keep writers apart, hooks that run commands at fixed points (PreToolUse, Stop, SessionStart) and can block - the deterministic way to enforce a rule - and scheduled runs: desktop tasks on the lab, cloud routines, GitHub Actions.

For us
: Enforce the ways with command hooks on the lab rather than by an agent watching; start sessions from versioned briefs (prompts/); run patrols on a schedule rather than an agent always on.

Link
: https://code.claude.com/docs/en/agents

Checked
: 2026-11-17


<a id="ubports-devices"></a>
### UBports device data

Project
: UBports / Ubuntu Touch

What
: devices.ubuntu-touch.io keeps, per device, feature ticks in nine categories, each category gating a progress stage (booting, core connectivity, essential, fully optimised, never caps).

For us
: The only stage order the world keeps as data. We take its gating as goal steps (daily-usable-phone), not its weights or percent, and keep its ticks apart from proofs.

Link
: https://devices.ubuntu-touch.io

Checked
: 2026-11-18


<a id="halium"></a>
### Halium

Project
: Halium / UBports / Sailfish

What
: Reuses the Android vendor HALs (radio, audio, camera, media, sensors, GNSS, Wi-Fi, vibrator, fingerprint) through libhybris so a phone runs a Linux userspace.

For us
: Its scope is the list a native mainline phone must replace, the hardest first: our phone stages follow the same areas.

Link
: https://docs.halium.org/en/latest/project/Scope.html

Checked
: 2026-11-18


<a id="android-cts"></a>
### Android Compatibility Test Suite

Project
: Android / AOSP

What
: The compatibility tests a phone passes to count as Android: module, case, method, run per device and build, pass, fail or not executed.

For us
: Android's own measure of a phone; our proofs are named checks of the same smallness, and we keep not-needed and not known yet apart where it counts an ignored case as a pass.

Link
: https://source.android.com/docs/compatibility/cts

Checked
: 2026-11-18


<a id="pmos-initramfs-tests"></a>
### Initramfs CI hook and test packages

Project
: Nura (formerly postmarketOS)

What
: postmarketos-mkinitfs-hook-ci runs tests inside the initramfs; tests ship as small subpackages that install themselves for the right device (postmarketos-test-suspend, -unl0kr).

For us
: Our automatic checks and the test kernel's timeout hook keep this shape so they sit beside Nura's. They cannot go upstream: Nura forbids contributions made in part by generative AI (research nura-relation-how-it-stands).

Link
: https://docs.nura.eco/pmaports/main/ci/hardware-ci.html

Checked
: 2026-11-19


<a id="pmos-hardware-ci"></a>
### Nura (postmarketOS) hardware CI

Project
: Nura (formerly postmarketOS)

What
: Tests on real phones: CI-tron as the testing gateway, power units that switch devices and press buttons, GitLab pipelines generated per device from a template in its package; scaling toward a farm of dozens of devices (talk at the 2026 conference). None for sm7150 today.

For us
: Our lab is a one-phone version of it, in its shape. Our tests are not contributed: Nura forbids AI-made contributions. Surya as a device in their farm is the author's own act if he wants it (research nura-relation-how-it-stands).

Link
: https://docs.nura.eco/pmaports/main/ci/hardware-ci.html

Checked
: 2026-11-19


<a id="nura"></a>
### Nura (formerly postmarketOS)

Project
: Nura (formerly postmarketOS)

What
: The Alpine-based distribution for phones: pmaports (its packages and device ports), pmbootstrap, prebuilt images, a wiki and porting guides. Renamed from postmarketOS on 2026-09-27; pmaports and pmbootstrap keep their names. Forbids generative-AI contributions since 2026-02-18 (adopted; proposed 2026-02-16).

For us
: Surya's whole OS (v26.06 image, generic qcom-sm7150 port, its kernel package of sm7150-mainline, UI packages) and the names lpoco lab kernel boots by (pmos.conf, the postmarketOS title). We redistribute none of it; our apk repository builds for v26.06. We give back only through the author himself and through the upstreams Nura packages (sm7150-mainline, kernel.org, sxmo). Upstream row: nura-pmaports. Research nura-relation-how-it-stands.

Link
: https://nura.eco/

Checked
: 2026-11-19


<a id="arch-linux-arm"></a>
### Arch Linux ARM

Project
: Arch Linux ARM

What
: Unofficial rolling aarch64 port of Arch with a generic mainline kernel (linux-aarch64) and userland; Phosh and Plasma Mobile in extra; two committers.

For us
: Not our base: its kernel drives neither SM7150 nor MSM8998 and the Qualcomm daemons and sxmo are AUR-only, so we would carry the phone OS (decision 2026-11-19-base-distro). No written AI rule.

Link
: https://archlinuxarm.org/platforms/armv8/generic

Checked
: 2026-11-19


<a id="danctnix"></a>
### DanctNIX

Project
: DanctNIX

What
: Arch Linux ARM for PinePhone, PinePhone Pro and PineTabs, one maintainer; packages Phosh, sxmo and Plasma Mobile helpers.

For us
: Pine64 only, not a base for us; forbids LLM-written contributions, so nothing goes back from us.

Link
: https://codeberg.org/DanctNIX/Pine64-Arch

Checked
: 2026-11-19


<a id="manjaro-arm"></a>
### Manjaro ARM

Project
: Manjaro

What
: Manjaro's ARM edition (Pine, Pi, Rockchip images); no ARM branch manager since 2025, at most one packager.

For us
: Not a base: unmaintained, no Qualcomm phone.

Link
: https://manjaro.org/products/download/arm

Checked
: 2026-11-19


<a id="mobian"></a>
### Mobian

Project
: Mobian

What
: Debian for phones: Debian userland plus per-SoC mainline kernels and support packages; an SM7150 family (kernel 6.18.51, recipe naming surya) in staging only, no image, idle since 2026-09-13.

For us
: Our named fallback base (decision 2026-11-19-base-distro): measured off the phone first (mobian-sm7150-offphone). Debian's GR 2026-002 lets the author send AI-assisted work under his name.

Link
: https://wiki.debian.org/Mobian

Checked
: 2026-11-19


<a id="pocketblue"></a>
### Pocketblue

Project
: Fedora

What
: Fedora Atomic remix for phones and tablets (SDM845, Xiaomi Pad); kernels per SoC in COPR; a dormant sm7150 COPR, no SM7150 device; two main people.

For us
: Not our base: we would carry kernel and device alone. Fedora allows disclosed AI assistance; Pocketblue asks reviewed, disclosed work.

Link
: https://github.com/pocketblue/pocketblue

Checked
: 2026-11-19


<a id="opensuse-mobile"></a>
### openSUSE Mobile

Project
: openSUSE

What
: Tumbleweed images for PinePhone, OnePlus 6/6T and Poco F1 from one volunteer's OBS home projects.

For us
: Not our base: neither SoC, no team.

Link
: https://en.opensuse.org/Mobile

Checked
: 2026-11-19


<a id="mobile-nixos"></a>
### Mobile NixOS

Project
: NixOS

What
: NixOS modules and device definitions for phones; mainline Qualcomm only OnePlus 6 (sdm845 6.4); one active maintainer; no releases.

For us
: Not our base: neither device (walleye dropped in 2023), sxmo not in nixpkgs; mobile-nixos forbids LLM-written contributions, nixpkgs allows them with Assisted-by.

Link
: https://mobile-nixos.github.io/mobile-nixos/

Checked
: 2026-11-19


<a id="droidian"></a>
### Droidian

Project
: Droidian

What
: Debian with Halium: Android vendor kernels and blobs through libhybris; surya listed as unsupported.

For us
: Rejected with Ubuntu Touch on the author's word: the Halium route, against mainline-first.

Link
: https://droidian.org/

Checked
: 2026-11-19

<!-- Generated from data/ by tad. Do not edit by hand. -->

# Landscape

<a id="pmos-initramfs-tests"></a>
### Initramfs CI hook and test packages

Project
: postmarketOS

What
: postmarketos-mkinitfs-hook-ci runs tests inside the initramfs; tests ship as small subpackages that install themselves for the right device (postmarketos-test-suspend, -unl0kr).

For us
: Our automatic checks and the test kernel's timeout hook belong in this shape, so they can go upstream and run in their CI.

Link
: https://docs.postmarketos.org/pmaports/main/ci/hardware-ci.html

Checked
: 2026-11-10


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


<a id="pmos-hardware-ci"></a>
### postmarketOS hardware CI

Project
: postmarketOS

What
: Tests on real phones: CI-tron as the testing gateway, power units that switch devices and press buttons, GitLab pipelines generated per device from a template in its package; scaling toward a farm of dozens of devices (talk at the 2026 conference).

For us
: Our lab is a one-phone version of it. Aim: surya as a device under test in their farm, our tests in their shape - contributed, not kept apart.

Link
: https://docs.postmarketos.org/hardware-ci

Checked
: 2026-11-10


<a id="photocraft-fleet"></a>
### The Craft apps' agent fleet

Project
: storytold (PhotoCraft and 12 sibling apps)

What
: Seven, then thirteen clean-room Rust apps built with about 8 parallel Claude agents, each owning one subsystem directory. House rules kept once (craft-contrib/standards) and stamped into every repository's AGENTS.md with a checksum; CI shared from one actions repository; agents check an issue and claim it before working; a generated scorecard, ranked gaps list and parity checklists say what is left; a test oracle (Photoshop's own renders, a CPU compositor for the GPU one) decides what counts as progress; remaining work estimated in agent-hours.

For us
: The same shape fits us: our ways are kept once (practices.json, lab-agent guide); our oracle is the phone's own suite, filed by itself; per-part ownership maps to sessions owning places. Worth taking: claim before work, estimates in agent-hours, the scorecard drawn from data - and the lesson that breadth is fast and only an oracle keeps the numbers honest.

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

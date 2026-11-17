<!-- Generated from data/ by tad. Do not edit by hand. -->

# Decisions

<a id="2026-11-12-the-docs-own-history"></a>
### 2026-11-12-the-docs-own-history

Project
: linux-phone-oco/docs

Date
: 2026-11-12

Decision
: The phone docs begin their own history: their first release is 0.1.0, and versions stay below 1.0 while the docs are still forming. The changelog and manifest inherited from the template they were made from are cleared, with a note saying whose history that was. Release-please reads its config and manifest.

Why
: The docs were made from text-as-data-template on 2026-11-04 and carried its history (1.0.0 to 1.2.0) as if their own; never released, release-please found no tag and proposed 1.0.0 - a claim of stability for docs days old and changing hourly. Found after landing: with no release at all, release-please treats the next as the first and gives it its own default, 1.0.0, whatever the manifest says; the config's initial-version (0.1.0) is what decides a first release.

Rejected
: Releasing 1.0.0 as proposed (promises what is not there); tagging 1.2.0 (it is the template's version, not the docs'); keeping the inherited changelog (it tells another repository's story as this one's).


<a id="2026-11-17-agents-organised-by-the-data"></a>
### 2026-11-17-agents-organised-by-the-data

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Decision
: linux-phone's agents are sessions with a name, a brief kept in docs' prompts/ (bring-up, orchestration, feature-research) and places they own; their shared state is the data they already keep - backlog, decisions, research, session logs, the phone's results - read through ocoeco and drawn on the face, not a tracker of their own. An orchestration session tends the conveyor and the agents: it checks the ways by measuring hand-work, turns every rule it can into a mechanism (devlab's hold, Claude Code command hooks, CI), keeps the face fluent, and starts a research session per hard feature. Research parallelises; changes to the one phone are queued through bring-up.

Why
: The author, 2026-11-17, asked for an orchestrating agent, per-feature agents, perhaps an agents-orchestration repository, and the most efficient organisation found by research. Read: the Craft apps' fleet (ownership by subsystem, rules kept once, an oracle gating progress), Gas Town (work state in git, agents as identities), Anthropic (few well-bounded workers, parallel only when independent, ~15x tokens), Claude Code (hooks enforce, sessions and schedules run). Our ecosystem already holds most of it; what was missing was roles, briefs and enforcement.

Rejected
: A new agents-orchestration repository now (the agents' runner and its redesign live in creation-guidelines/lab-agent as oco-agent, and how-we-work under creation-guidelines; a third place would be one nature under three names - what is linux-phone's stays in docs, what every project shares goes to oco-agent when it is general); a tracker beside ocoeco such as Beads (two records of one work); an always-on watching agent (tokens without end - patrols on a schedule and hooks do it cheaper); one agent per feature implementing in parallel (one phone: changes race).


<a id="2026-11-17-fewer-longer-sessions-no"></a>
### 2026-11-17-fewer-longer-sessions-no

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Decision
: No more agents for now; the conveyor session retires and hands everything to orchestration, which becomes the one session the author talks to; bring-up runs as one session per part, ended when the part lands and the next started fresh from the data; research sessions run one or two at a time, the next (sensors) only after deep-sleep shows the research brief works; the most capable model where judgment is the point (bring-up, research decisions), lighter ones for patrols and routine conveyor fixes.

Why
: Measured over ~80 minutes on 2026-11-17: the conveyor files results by itself (devlab 12 landings); the phone queues every change, so only research parallelises; 4 sessions on the most capable model already run, and multi-agent work costs about 15 times the tokens of one (Anthropic); a session that runs long re-reads its whole context every turn - the conveyor session's was the longest; collisions came from many hands landing in docs at once (2 of 5 gatherings failed, healed by the next boot). The author asked for the most effective organisation, not the largest.

Rejected
: More agents per feature now (one phone queues their changes; the research brief is unproven); keeping the conveyor session beside orchestration (two owners of one thing, the costliest context); one long-lived bring-up session (its context grows with every part).


<a id="2026-11-17-support-read-off-results"></a>
### 2026-11-17-support-read-off-results

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Decision
: A part's status is derived (derive/support-status.sql, run through tad after every filing): broken where the latest run fails it; works where a test that proves the part does its work passed and none failed; otherwise what a person judged (judged, with the notes as its evidence). Each row says what the suite saw of the part and in which run (measured, measured_run); the tests table says what each test's pass proves - present or works.

Why
: The author, 2026-11-17: support status read off the suite's results, not typed. Tried beside the hand-written status first: read naively (a pass is works, nothing measured is unknown) it disagreed on 8 of 19 parts - a pass that only shows a part is there (the jack detector, Bluetooth powered, the modem seen, the NFC controller) is not the part working, and an absent measurement is no evidence against what was witnessed (the microphone's tries, fastboot). With proofs told apart, the rule and the judgment say the same on all 19.

Rejected
: Status typed by hand alone (it lags the phone: nothing turned it broken when a part failed); a pass read as works (would have called calls, SMS and NFC working with no SIM and no tag ever read); a measurement-less part read as unknown (would erase what was witnessed).


<a id="2026-11-17-the-face-is-drawn-from-the-database"></a>
### 2026-11-17-the-face-is-drawn-from-the-database

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Decision
: linux-phone's pages (linux-phone-oco.github.io/docs) are its face, drawn in this place's CI from its open database: tad keeps and checks the data here; the family's other places are observed as the Linux Phones lens gathers them; the observatory's engine draws the face from that; tad's page of every table stands beside it under tables/. A landing here draws it again, and the clock every three hours, for what the other places land.

Why
: The author, 2026-11-17: the observatory's Linux Phones pages reflected real progress from CI and should be linux-phone's own face, with tad as the open database shared by the whole project, devlab filing the suite's results into it and the pages reflecting them - nobody drawing them by hand.

Rejected
: A copy of the observatory's pages kept here (a second renderer to drift); publishing from the lens's place (the database and its readers would live apart, and docs' address is the one already linked); the plain table index alone (it drew rows, not progress).


<a id="2026-11-17-two-sessions-one-lab"></a>
### 2026-11-17-two-sessions-one-lab

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Decision
: The core of the project - making each part of a phone work - runs as its own session beside the conveyor's, from prompts/bring-up.md: it owns the kernel, the phone's hardware data, the upstream queue and the Sxmo profiles; the conveyor's session owns lab-tools, device-template and the face. Anything that changes the phone's state is done holding one lock (flock on ~/.local/state/devlab/CODENAME/phone.lock); each session works in clones of its own.

Why
: The author, 2026-11-17, asked for a parallel session on the actual core: research, reverse engineering, patches, delivered through the conveyor and proven by the suite. One phone and shared clones are where two sessions would undo each other (two jobs in one clone once merged each other's changes under one commit).

Rejected
: One session doing both (the conveyor kept pulling attention from the parts, and parts from the conveyor); two sessions without a lock or owners (a reboot under a kernel try, a reset clone).


<a id="2026-11-17-deep-sleep-measured-s2idle"></a>
### 2026-11-17-deep-sleep-measured-s2idle

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Decision
: Deep sleep on surya is made on mainline s2idle and taken to the SoC's floor step by step, each step measured by the SoC's own sleep counters (qcom_stats: CX collapse, AOSS sleep) across a real suspend: first a measured sleep on today's kernel, then the cluster sleep parameters from surya's own firmware tables, then whatever holds the audio DSP awake, then the FastRPC helpers stopped across suspend so the sensors come back; waking for calls and messages follows on that floor, by the modem's IPCRTR wakeup with ModemManager's quick suspend/resume, as postmarketOS does on the OnePlus 6. The check soc-sleeps says it after every boot: unknown until the phone has slept, broken if it slept and the SoC stayed up, works once the SoC reached its floor.

Why
: Every step is small, falls back by itself (one sleep woken by the clock; a test kernel tried once) and is settled by a number the SoC counts itself, so progress is certain rather than claimed - nobody has published a measured floor for SM7150 on mainline, and the postmarketOS page that calls suspend working has no measurement behind it. The first step settles the biggest unknown: whether this SoC reaches its floor at all on mainline, before effort goes into waking it. Two causes are already in sight and both are cheap to try: the device tree asks the firmware for SC7180's cluster parameters (0x41001244, 0x4100b244) where surya's own tables have 0x41002244 and 0x4100c244, and the deepest was never entered once; and the audio DSP has never slept this boot. What it changes - a device tree fix, a vote released, a hook - goes upstream to the SM7150 series, pmaports and ModemManager, for every SM7150 phone. Reckoned: the measured sleep 2-3 agent-hours with its devlab verb; the cluster parameters 2; the audio DSP 4-8; the helpers 2-4; waking for calls 6 and a SIM card.

Rejected
: Waking for calls first on today's kernel (postmarketOS's OnePlus 6 recipe as it is): no SIM card in the lab to prove it, it says nothing of whether the SoC sleeps - a phone that rings but drains in a day is not deep sleep - and it is still reported broken on OnePlus 6/6T and Pixel 3a; it is the last step here, not the first. Android's kernel through Halium (Ubuntu Touch runs on surya): deep sleep works there, but on the vendor's 4.14 kernel and Android's blobs, with nothing upstream and the mainline conveyor abandoned; kept only as observed behaviour - its standby current is the number to match. Runtime idle without suspend (the screen off, userspace running, the SoC left to reach CX collapse in idle): nobody has reached the floor that way on Qualcomm mainline, userspace timers keep waking the CPUs, and it needs every vote released that s2idle needs; the counters measure runtime idle too, so nothing of it is lost. A power manager of our own, as Crust on the PinePhone: Qualcomm's always-on subsystem runs signed firmware and the modem is inside the SoC with no ring line, so it cannot be done. Guessing at the cluster parameters or the audio DSP without a measured sleep first: a change could not be told to help without the counters across a suspend.

About
: linux-phone-oco/docs/features:deep-sleep


<a id="2026-11-11-efi-only"></a>
### 2026-11-11-efi-only

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-11

Decision
: devlab kernel install refuses a kernel that is not an EFI executable.

Why
: The bootloader starts EFI programs only; a gzip kernel was lost before it could log a line.

Rejected
: Documenting which file to pass.


<a id="2026-11-11-health-settles"></a>
### 2026-11-11-health-settles

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-11

Decision
: devlab health waits until the phone has been up 90 seconds before checking, saying so once.

Why
: Every job slept before a health check by hand (7 times); a check read too early fails for the wrong reason.

Rejected
: A fixed sleep in every script; checking at once and retrying failures.

About
: dl-safe


<a id="2026-11-11-placed-word"></a>
### 2026-11-11-placed-word

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-11

Decision
: A listening test runs only with --placed, the word that the microphone is by the phone.

Why
: The first results came from a microphone being worn.

Rejected
: Un-naming the microphone's file as the safeguard: a trick only its author remembers.


<a id="2026-11-11-try-reports"></a>
### 2026-11-11-try-reports

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-11

Decision
: devlab kernel try waits for a new boot id and reports the outcome itself, judged from the running release, the entry's counter and the timeout log.

Why
: Booting a test kernel and reading what happened was the heaviest manual work (9 times, 54 effort-minutes), and guessing at it cost three reboots.

Rejected
: Waiting for the phone to go down and then up (it misfired twice: the try schedules its reboot); leaving the reading to a person.

About
: dl-safe


<a id="2026-11-17-every-change-ends-with-health"></a>
### 2026-11-17-every-change-ends-with-health

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-17

Decision
: A change devlab makes to the phone ends with its health: after a reboot (phone reboot, kernel try) devlab waits for the report that boot writes by itself, rather than running the suite again; after a change without a reboot (provision) it runs the suite now. Either way the report is brought to the lab and an unhealthy phone fails the command.

Why
: Nobody has to remember to check; and waiting for the boot's own report measures exactly what every boot of the phone measures - the lab adds no second way of checking.

Rejected
: Running the suite from the lab after each reboot (two runs per boot, and the lab's run would be the one that differs from an unattended boot); leaving the health check as a separate step to remember.

About
: dl-safe


<a id="2026-11-17-filed-through-tad-and-landed-by-itself"></a>
### 2026-11-17-filed-through-tad-and-landed-by-itself

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-17

Decision
: devlab files the phone's reports into the picture through tad (one tad sql statement per run: its rows read from the report, its counts from those rows; tad keeps it only if every rule holds, then canonical form and the rendered pages), and devlab watch, after every boot, waits for the phone's own report, says its verdict on the board, and gathers with --land: in devlab's own clones of the lab and the picture, each landed through land, signed devlab. The face is drawn again by the picture's CI on that landing.

Why
: The author, 2026-11-17: tad is the open database shared by the whole linux-phone project; devlab reports the suites' results into it by itself and the pages reflect them - not an agent doing it by hand each time. devlab's own clones keep its landings out of the clones people and agents work in (two hands in one clone once merged each other's changes).

Rejected
: devlab appending JSON lines itself (rows tad never checked); the watch running the lab-side checks over SSH (a second way of measuring beside the phone's own); landing from ~/Projects (collides with work in progress there).

About
: dl-reaches


<a id="2026-11-17-gather-files-into-the-picture"></a>
### 2026-11-17-gather-files-into-the-picture

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-17

Decision
: devlab gather now brings every report the phone keeps that the lab lacks into the device lab's tests/results (RUN.jsonl, as written on the phone), and files every run not yet filed into linux-phone-oco/docs' test_results and test_runs, the rows made from the report's lines. A run is filed once, by its id.

Why
: Filing was by hand (tests/to-docs.sh, through tad's Python) and had fallen a week behind: docs held 7 runs from 2026-11-10 while the lab had made many since. Rust carries it now, and the tables stay where they are declared and observed today.

Rejected
: Declaring test_runs and test_results again in each device lab (one nature, two declarations - entered as the sign a-test-run-has-no-shared-shape in ocoeco, to be answered in the language); keeping to-docs.sh (new filing through Python).

About
: dl-reaches


<a id="2026-11-17-health-on-the-phone"></a>
### 2026-11-17-health-on-the-phone

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-17

Decision
: The phone measures its own health after every boot: devlab-health, a static Rust runner, runs small check files (base layer, then shell layer) and writes one report per run in test_results' shape, keeping the evidence when unhealthy. The checks are POSIX shell in postmarketOS's test shape and print plain words (pass|fail|skip TEST COMPONENT detail); the runner makes the JSON, the verdict and the evidence. Generic checks live in lab-tools; what a phone is expected to have is its manifest's [health], and a phone's own checks sit beside the generic ones.

Why
: Health measured only from the lab is health only while the lab is connected and remembers to ask; a phone that checks itself after every boot leaves a record for every change. Shipped code is Rust (2026-11-11-rust-for-what-ships): strings and structure - JSON escaping, the report - are where shell is fragile. The probes themselves only read sysfs and the system's own tools, which is what postmarketOS's tests and bootrr do in shell, so they can be contributed there.

Rejected
: A shell runner (JSON escaping and report shaping in sh - the fragility the Rust decision answers); checks written in Rust (a probe of sysfs gains nothing, and upstream would not take it); keeping the checks run only from the lab over SSH (no record when the lab is not asking); one check file per device (surya's checks.sh: nothing reusable for the next phone).

About
: dl-reaches


<a id="2026-11-17-health-ships-as-a-package"></a>
### 2026-11-17-health-ships-as-a-package

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-17

Decision
: The health suite reaches phones as an Alpine package (devlab-health: the runner, the checks, the unit and the timer) published through the package conveyor once it publishes Alpine repositories (cv-apk); until then devlab puts the same files on the phone itself, as the development path.

Why
: The commons has one packaging conveyor that every project calls (linux-package-distribution-oco/conveyor) and it already builds aarch64-musl binaries; a package is how postmarketOS installs and updates anything, and it gives the phone updates the way the lab machine already gets them.

Rejected
: devlab copying files onto the phone for good (a second delivery route beside the conveyor; nothing updates it); building the package in lab-tools' own CI (copying what the conveyor exists to do once).

About
: dl-upstream


<a id="2026-11-17-test-sounds-are-quiet"></a>
### 2026-11-17-test-sounds-are-quiet

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-17

Decision
: Every test sound is quiet unless the phone's manifest says otherwise: [hear] level_dbfs (default -40 dBFS) and volume (default 25%), capped at full scale and 100%, used by devlab hear and given to every check through the phone's health.env (TEST_TONE_DBFS, TEST_VOLUME).

Why
: The author, 2026-11-17, urgently: a full-scale test sine played at night; test sounds must be quiet, with a setting for it in the suite. devlab hear had -12 dBFS at 60% volume hard-coded.

Rejected
: Lowering the hard-coded numbers (no setting, and other checks would choose their own); a level per check (a phone in a home has one acceptable loudness).

About
: dl-manual


<a id="2026-11-17-the-phone-is-held"></a>
### 2026-11-17-the-phone-is-held

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-17

Decision
: devlab holds the phone for every change it makes - flash, provision, reboot, root commands, put, kernel install, try and remove, suite put - by an exclusive lock on STATE/phone.lock, from the command line and the MCP door alike; a second change waits for the first and says so. Reading needs no hold.

Why
: Two sessions now work with one phone (the bring-up session beside the conveyor's): a reboot under a kernel try would strand a test or misreport it. A lock each session must remember to take is a rule kept by care; devlab taking it itself is kept by the tool.

Rejected
: flock around devlab by convention (forgotten once is enough; and wrapped around a devlab that also locks, it would wait on itself); a lock only in the MCP door.

About
: dl-safe


<a id="2026-11-17-the-phone-over-mcp"></a>
### 2026-11-17-the-phone-over-mcp

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-17

Decision
: devlab offers its structured door over MCP (devlab mcp, stdio, with rmcp): run, put and get a file, the health report, kernel install, try and status, reboot and wait - each the same function the command line calls.

Why
: Agent access plans every tool's structured door over MCP in Rust with rmcp, devlab among the first (aa-two-doors); an agent then works with the phone without a person and without a shell's quoting layer.

Rejected
: A separate MCP server project beside devlab (two doors to keep in step); MCP through a generic shell tool (every call a quoting puzzle).

About
: dl-reaches


<a id="2026-11-17-the-ways-held-by-devlab-guard"></a>
### 2026-11-17-the-ways-held-by-devlab-guard

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-17

Decision
: The ways an agent must keep on the lab (land, not a push to main; no Python; the phone only through devlab) are held by Claude Code command hooks that call devlab guard, a subcommand of devlab in Rust, with its cases tested.

Why
: A way that must be remembered is forgotten; the hook refuses when it is tried and says why, to the agent that tried. devlab already knows the phones (their manifests and learned addresses), so the guard knows what reaching the phone means.

Rejected
: Hook scripts in shell with jq (logic in shell, untested; the guide says Rust for logic); a separate guard tool beside devlab (a second place that must learn the phones addresses); permission deny rules in settings (match command prefixes only: miss sudo, env, sh -c and $(...), and cannot tell a branch push from a push to main).

About
: guard-the-ways


<a id="2026-11-11-efi-kernel"></a>
### 2026-11-11-efi-kernel

Project
: linux-phone-oco/surya-lab

Date
: 2026-11-11

Decision
: Test kernels are booted from their EFI image (vmlinuz.efi), and the conveyor refuses anything else.

Why
: A gzip kernel was chosen by the bootloader, counted down, and could not start - silently, before any log.

Rejected
: Sort keys, a stored default entry, a second boot partition - each checked and ruled out.

About
: linux-phone-oco/docs/milestones:surya-boots linux-phone-oco/docs/milestones:surya-tested


<a id="2026-11-11-lpi-mux-from-vendor"></a>
### 2026-11-11-lpi-mux-from-vendor

Project
: linux-phone-oco/surya-lab

Date
: 2026-11-11

Decision
: The audio pin driver's function slots for the SoundWire pins follow the phone's own Android kernel (gpio19 swr_tx_data in slot 3, gpio23 swr_rx_data in slot 2).

Why
: A bus clash on the TX bus came right before the codec's timeout; the driver's table disagreed with the vendor's pin description on exactly these pins; corrected, the codec came up on the first boot.

Rejected
: Treating the clocks switching off as the cause; changing the macros' autosuspend.

About
: linux-phone-oco/docs/milestones:surya-sound


<a id="2026-11-11-measure-before-changing"></a>
### 2026-11-11-measure-before-changing

Project
: linux-phone-oco/surya-lab

Date
: 2026-11-11

Decision
: Boots that come up without the sound card are measured over a run of reboots before anything is changed.

Why
: It happened once in several boots; the audio processor's service channel never appeared. A guess at a cause would be untestable without a rate.

Rejected
: Unmasking the helper service masked for the suspend crash, on a hunch.

About
: linux-phone-oco/docs/milestones:surya-sound


<a id="2026-11-11-modem-read-only-first"></a>
### 2026-11-11-modem-read-only-first

Project
: linux-phone-oco/surya-lab

Date
: 2026-11-11

Decision
: With the SIM in, the modem is examined read-only first; switching the radio on is the only change made, and nothing that calls, messages or uses data happens without the author's word.

Why
: A SIM card costs money and reaches people; the phone's state stays known.

Rejected
: Trying a call or a data connection straight away.

About
: linux-phone-oco/docs/milestones:surya-phone

Research
: the-modem-with-a-sim


<a id="2026-11-11-not-power-management"></a>
### 2026-11-11-not-power-management

Project
: linux-phone-oco/surya-lab

Date
: 2026-11-11

Decision
: The capture failure is not chased in runtime power management.

Why
: With the bus controllers, macros, codec and SoundWire devices all forced awake, the read failure came at the same moment, the same way.

Rejected
: Changing the macros' autosuspend or the controller's clock-stop handling.

About
: linux-phone-oco/docs/milestones:surya-sound


<a id="2026-11-11-right-is-bottom"></a>
### 2026-11-11-right-is-bottom

Project
: linux-phone-oco/surya-lab

Date
: 2026-11-11

Decision
: The right channel is the bottom speaker.

Why
: With the microphone at the bottom speaker the right channel read 7 dB louder (-20.4 against -27.6 dBFS; room -85.7).

Rejected
: An earlier 2 dB lean, taken while the microphone was not yet placed.

About
: linux-phone-oco/docs/milestones:surya-sound


<a id="2026-11-11-show-both"></a>
### 2026-11-11-show-both

Project
: linux-phone-oco/surya-lab

Date
: 2026-11-11

Decision
: Where the community's report and our measurement disagree, both are shown side by side; where we know nothing, the report is shown outlined, dated, as reported.

Why
: A disagreement is the most telling part of the comparison - the sensors one may be of our own making.

Rejected
: Hiding a report behind our measurement; filling unknowns as if measured.

Research
: wiki-against-our-checks


<a id="2026-11-11-telephony-checks"></a>
### 2026-11-11-telephony-checks

Project
: linux-phone-oco/surya-lab

Date
: 2026-11-11

Decision
: Telephony is checked in three modes: automatic now (registration; a small download over mobile data), half-manual (the phone calls the author's other phone, the author confirms through the inbox), and fully automatic later (a two-phone stand, or a number that answers with a tone). The number to call lives in a private file on the lab machine, never in a repository.

Why
: The author allowed data and calls to his other phone, and asked that the checks become part of the test suite so a stand can run them unattended.

Rejected
: Calls by hand without a check; keeping the number in the device manifest.

About
: linux-phone-oco/docs/milestones:surya-phone

Research
: checking-calls-automatically


<a id="2026-11-17-the-lab-s-own-conveyor-retires"></a>
### 2026-11-17-the-lab-s-own-conveyor-retires

Project
: linux-phone-oco/surya-lab

Date
: 2026-11-17

Decision
: surya-lab gives up its own conveyor scripts, devlab now doing their work for any phone: lib/phone.sh (devlab phone: the same script-on-stdin way, the USB address then the learned Wi-Fi one, now from device.toml, and held for each change), tests/run.sh with tests/automatic/checks.sh (the phone runs its own suite after every boot: lab-tools health/suite and tests/health here), tests/to-docs.sh (devlab gather, through tad - the Python dc.py it called is gone), flash/flash-dtb.sh (pointed at a flash.sh already gone; devlab flash --dtb). ui/switch.sh now reaches the phone through devlab.

Why
: One way to reach and test a phone, held and measured, instead of two that drift (device-template dt-surya-from-template). The reasons each script carried were read first: the full kernel log from the journal and BusyBox-safe awk live on in lab-tools health/suite/lib.sh; the checks not yet carried are on lab-tools backlog health-carry-old-checks.

Rejected
: Keeping the scripts as a fallback (a second way nobody runs drifts, as flash-dtb.sh had); moving them into the template (devlab already does each, for any phone).


<a id="2026-11-17-the-phone-is-data"></a>
### 2026-11-17-the-phone-is-data

Project
: linux-phone-oco/device-template

Date
: 2026-11-17

Decision
: A device lab made from this template holds data only - the manifest, the phone's own checks, its reports, its records; every tool is devlab's and reads the manifest.

Why
: The design asked for 2026-11-10 (linux-phone-oco/docs backlog device-template): the next phone must not inherit a copy of surya's scripts to edit; surya-lab already shows where copies drift (its shell tools and devlab doing the same work twice).

Rejected
: Copying surya-lab and renaming (the scripts would drift per phone); a template carrying its own scripts beside devlab (two routes to the same work).

About
: dt-any-phone


<a id="2026-11-17-one-database"></a>
### 2026-11-17-one-database

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Decision
: For linux-phone-oco, everything goes through tad in one database: linux-phone-oco/docs. The records its places kept in ocoeco's oco/ tables (lab-tools, surya-lab, device-template, sxmo-deviceprofiles) are docs' tables now, each row naming its place in project (full id, linux-phone-oco/NAME); docs' mark holds those places, so on the face each record stays its place's. Every record is written through tad's named records kept in docs (records/NAME.sql: tad r decision|backlog|backlog-status|research|session-log|concept|source|milestone-readiness --project NAME ...), read through named queries (queries/), and the feeds, the status derivation and devlab's filing of a run are named records too. The record of work is git itself: linux-phone places export no glimpses, land asks for none, landit makes none, devlab's landings carry none; commits are signed by the name a session works under (oco-work sets the git author to OCOECO_BY), and the face reads where each hand stands off the commits (bin/landings.sh, landings) after the glimpse history kept in docs. Sub-repositories' marks shrink to the mark itself, pointing here. The face keeps its CI (observe through linux-phone-oco/lens, drawn by the engine); drawing it straight from this database waits until observing becomes a burden. ocoeco stays as it is for the rest of the commons.

Why
: The author, 2026-11-17: for linux-phone everything goes through tad in one database, and the record of work is git itself. Measured friction behind it: the turn commit-title limit failed 4 times; refusals of links pointing nowhere ordered the work 3 times; and two tools (ocoeco note and tad) wrote rows in one place - docs' decisions, problems and glimpses were ocoeco's files beside tad's tables, undeclared, and appended glimpse lines conflicted between sessions landing at once (seen again on 2026-11-17 in lab-tools). Checked before the old way was retired: every row of every place is in docs (lab-tools 110 with glimpses, surya-lab 99, device-template 12, sxmo-deviceprofiles 10, lens 3), the 25 tables the face reads observe the same, and the face rendered from both is the same page for page but for each mark's count of shared tables.

Rejected
: Keeping ocoeco note beside tad (two tools writing one database - the overlap this ends); one database per sub-repository (one nature kept in five places); retiring ocoeco everywhere (the author's observatory rests on it, and it was not asked); a new 'ocotad' command line over the database (a second tool over one database: tad's named statements say the same as files beside the data); queries compiled into tad (each new one would need a release of tad, where a file lands with the work that needs it); drawing the face from this database now (its CI works; not before observing is a burden).


<a id="2026-11-17-test-kernels-from-branches"></a>
### 2026-11-17-test-kernels-from-branches

Project
: linux-phone-oco/surya-lab

Date
: 2026-11-17

Decision
: A test kernel that proves a part is built from pushed branches of linux-phone-oco/linux (a test branch merging the fix branches), never from a hand-edited tree. Hand-edited trees stay for one-off experiments (switches, traces), their changes kept as patches in surya-audio/patches; a finding becomes a commit before it is called proven.

Why
: On 2026-11-17 the WCD device tree on feat/surya-wcd937x-mic-headphone turned out never to have been the tree proven on the phone - wrong SoundWire controller addresses, a vote the DSP rejects, the reset's polarity - because the proven tree in surya-audio/kernel-rc3/src-wcd was edited by hand and never committed. The branch kernel built from PRs 3-5 then booted healthy with the codec.

Rejected
: Keeping the working tree that proved something as the reference: nothing reads it, it drifts from the branches, and what is sent upstream is not what was tested.

About
: microphone

Research
: microphone-codec-drops-off


<a id="2026-11-17-devlab-health-as-an-alpine-package"></a>
### 2026-11-17-devlab-health-as-an-alpine-package

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-17

Decision
: devlab-health reaches phones as an Alpine package: release-plz tags devlab-health-vX.Y.Z, and the package conveyor's alpine.yml builds it from the tag's APKBUILD, signs it with lab-tools' own RSA key, verifies it and publishes an apk repository on lab-tools' pages for postmarketOS v26.06 (Alpine 3.24), then installs it in a clean container.

Why
: One way for code to reach a phone, measured, instead of devlab copying files: the phone updates the suite with the rest of its system, and any postmarketOS phone can take it without the lab. The conveyor already did this for pacman; the Alpine path was its open cv-apk.

Rejected
: Keeping devlab suite put as the only way (files no package manager knows, nothing for a phone outside the lab); building in lab-tools' own CI (copying what the conveyor keeps once); a key shared across the commons (keys stay per project for now); publishing as release assets (apk needs an index under a stable path).

About
: health-apk


<a id="2026-11-17-microphones-analog-wcd-path"></a>
### 2026-11-17-microphones-analog-wcd-path

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Decision
: surya's microphones are made to work as the analog mics they are: AMIC1 (bottom) and AMIC3 (top) on the WCD9375's ADC1 and ADC2 (ADC2 MUX at INP3), over the TX SoundWire bus (capture on <&swr2 1>, ADC2 on its own master port 3 by qcom,tx-port-mapping <2 3 4 5>), the TX macro's decimators and the DSP's TX_CODEC_DMA_TX_3 - the path pulpoff/linux-surya and sm7150-mainline PR 60 use, and the one bring-up proved on 2026-11-17 (run 20261117-044744: mic-hears-speaker and mic-top-hears-speaker pass on the kept kernel 7.1.0-sm7150-mic+). What is left, in order: capture through the sound server by a UCM profile (mic-ucm-capture, first: the biggest unknown left for anyone using the phone, since every check so far sets the mixer by hand), the microphones held across boots and out of the known gaps (mic-held), the fixes upstream by joining PR 60 (mic-upstream), the DMIC experiment kept out (mic-dmic-dropped), and the call uplink with the calls feature (calls-audio-q6voice).

Why
: Measured, not inferred: both built-in mics hear a quiet tone 45-67 dB above their noise on this phone. An independent mainline tree on the same phone records both mics and carries calls this way and names the DMIC pins unconnected; the DMIC reading came from Qualcomm's reference board. What is left is configuration and carrying it upstream, each step proven by a check on the phone; no reverse engineering is needed.

Rejected
: DMICs through the TX decimators with the VA block's clocks (the vendor's va-without-decimation model, bring-up's lead until 05:00 on 2026-11-17): surya has no digital mics - the routes are the QRD board's and the pins are unconnected; the model stays recorded (bolero-v1-capture-family) for siblings that have DMICs. The VA macro's own path (VA_CODEC_DMA_TX_0): this ADSP rejects the port (0xb021, error 3), nobody streams it on SM6150/SM7150, and there is nothing for it to record. pulpoff/linux-surya as surya's kernel: it works, but it is 7.2.15 (end of life), squashed into one commit and packaged for Debian, while the conveyor builds tested branches of linux-phone-oco/linux toward sm7150-mainline - we take its findings with credit, not its tree. Driving LPASS codec DMA from Linux without the ADSP (lpass-cpu, as ADSP-less Chromebooks do): unnecessary and a large, risky driver. A surya capture series of our own for upstream: davinci's PR 60 already carries three of the four fixes; a parallel series would split the review.

About
: linux-phone-oco/docs/features:microphone

Research
: microphones-are-analog,mic-zeros-meant-no-input,bolero-v1-capture-family

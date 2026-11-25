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

About
: surya-tested


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

About
: dl-safe


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

About
: audio-mic


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


<a id="2026-11-17-calls-proven-by-echo-call"></a>
### 2026-11-17-calls-proven-by-echo-call

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Decision
: Calls on surya are made to work as pulpoff/linux-surya carries them - q6voice from sdm845-mainline with SM7150's CVD 2.3 set-up and a hostless VoiceMMode1 link in our kernel, then UCM Voice Call with TX topology 0x10F70 and a 1-channel uplink capture on TX_CODEC_DMA_TX_3 - and proven by the phone itself calling blueSIP's public echo line (+49 89 721010 99701): three tones played on the loudspeaker are heard by the bottom mic going up and again, a round trip later, coming back on the earpiece, found by Goertzel envelopes in a Rust subcommand of devlab-health. Its tone line (99702) proves the downlink alone; the SIM's own mailbox is the fallback. At most one call of 25 s a day; skipped as unknown without a SIM, a registration or the call path. Mobile data is checked every boot over the bearer's own interface (registration, DNS, pings, 100 kB), with a weekly 5 MB throughput run, under 0.3 GB a month. The first step is the kernel: q6voice and the VoiceMMode1 link, settled by the check call-audio-path, which fails today.

Why
: An independent mainline tree on this very phone already carries calls with sound both ways, so the biggest unknown is porting, not discovery; the check call-audio-path settles it without a SIM or a call. The echo line is the only public German echo attested across years and sources, and costs a landline-rate call; its tone line splits a failure into downlink and uplink. The acoustic loop proves exactly what a person uses - loudspeaker, mic, uplink, network, downlink, earpiece - and needs no driver feature beyond what calls need anyway (the uplink capture is written to a file instead of discarded). Daily and short keeps the cost to cents and the people reached to none.

Rejected
: Digital loop through in-call record/playback ports (unknown whether sdm845-mainline's q6voice has them; kept for later if it does). A second phone on a stand that answers (hardware and a second SIM; the echo line does the same for nothing). A programmable number (Twilio and the like: an account, money, a public endpoint). sipgate's echo 10005 (SIP-internal, not dialable from a mobile, private customers dropped 2025). Old or foreign echo lines (portunity 0211, sip2sip +31, C*NET: unconfirmed, international rates). Calling the author's other phone as the automatic test (reaches a person; stays the half-manual mode of 2026-11-11-telephony-checks). Downstream's 0x10F71 topology (silence without Xiaomi's calibration). A call on every boot (45 a day in bring-up).

About
: modem-calls

Research
: echo-call-number, call-audio-on-surya, echo-call-test-design, mobile-data-check-budget


<a id="2026-11-17-health-checks-shell-and-rust"></a>
### 2026-11-17-health-checks-shell-and-rust

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-17

Decision
: The phones' health suites keep one contract - a check prints 'pass|fail|skip TEST COMPONENT detail', and docs' tests table says what a pass proves - and two languages by kind of work: shell for readings (sysfs, a command's output, a few readable lines on BusyBox), and Rust for anything with numbers, timing or states (tones, echoes, calls, sleep counters), as subcommands of one static multi-call binary shipped with devlab-health (devlab-health tone make|find, later call echo), unit-tested on the lab with recorded fixtures and cross-built by health/build.sh. rust-script is the lab's tool for prototypes and one-off analysis of recordings fetched from the phone; a prototype that is kept becomes a subcommand. Checks are layered by cost: base, shell, telephony (calls and data, budgeted, at most daily), witnessed (a person). Coverage is a query over docs: every device's components with no test proving works.

Why
: The shell contract is what makes a check quick to write and read, and it already runs everywhere; what goes wrong in shell is arithmetic - three of surya's checks carry an awk Goertzel and a printf-built tone that nobody unit-tests, while lab-tools' tone crate has tests and never reaches the phone. The phone has no Rust toolchain, so Rust must arrive compiled; one binary already goes there (devlab-health), so analysis joins it at no new cost. rust-script works today on the lab; Cargo's own scripts are still nightly-only (Cargo 1.99 asks for -Zscript) and can replace rust-script when they are stable.

Rejected
: Python checks (refused on the lab; the phone's python3 is the image's, not ours). rust-script or cargo script on the phone (a toolchain and network on the phone, minutes of compiling at boot). Every check in Rust (a ten-line sysfs reading becomes a cross-build per change). bats or another shell test framework (bash, not BusyBox ash; the contract already does its work). LAVA or a KTAP-native harness now (a lab of many boards; our lines map onto KTAP if ever needed). One binary per check (many cross-builds and files to ship).

About
: dl-reaches

Research
: health-suite-organisation


<a id="2026-11-17-experts-written-not-standing"></a>
### 2026-11-17-experts-written-not-standing

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Decision
: An expert is a domain written down in docs, not a session kept alive. Each hard domain (audio, sleep, modem, sensors, cameras) is its component's rows - research, decisions, backlog, tests, sources - plus one research row per domain, DOMAIN-how-it-stands, that holds the tacit part (dead ends, where experiments live, what to never do again), added to item by item, never rewritten whole. A session takes up a domain by its brief and that domain's rows, and becomes its expert by reading them. It is ended when its part lands, or before its context is compacted, after writing its hand-over into those rows (not into notes outside the repository); the next starts fresh from them. Questions route by the record first: whoever asks reads the domain's rows; if they do not answer, they message the domain's live session directly (the face shows where each hand stands), not through orchestration; with no live session, orchestration starts a short read-only consult from the domain's rows on a lighter model, and every answer is written back as a row. One writer per domain and one hand on the phone (devlab) stay as they are.

Why
: Measured here: sessions grow to 1000-1800 messages and re-read them every turn; multi-agent work costs about 15 times one agent; a phone serialises all bring-up. Outside: compaction loses what only later proves to matter and summaries collapse; long contexts recall worse; relayed questions play telephone; every system that keeps experts across time (Gas Town, Anthropic's harness, Claude Code's agent memory, Letta) keeps the expertise outside the session. The author's aim - knowledge that does not depend on anyone remembering - is practice 1 of the ways.

Rejected
: Standing expert sessions per domain: idle hours lose the cache, so each question re-reads a thousand-message context at full price; the expertise still vanishes at compaction or when the app's session ends; their context rots with length. Orchestration as the router of every question: a bottleneck and a game of telephone (LangChain), and it fills orchestration's own context. Claude Code subagent memory (.claude/agent-memory) or agent teams as the home: a second store beside docs' one database (decision 2026-11-17-one-database), and teams do not survive a resume. A Markdown expert-notes file per domain: a second place for what rows already hold; kept only if a lens cannot show it. A vector or memory service (Letta, Hindsight): outside the commons and opaque to the face. Forking a finished expert's whole session to consult it (Cognition's smart friend): kept as an exception for a session a few hours old whose tacit context is not yet written, not the rule.

About
: expert-primer

Research
: expert-agents-written-not-standing


<a id="2026-11-17-health-analysis-subcommands"></a>
### 2026-11-17-health-analysis-subcommands

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-17

Decision
: devlab-health takes analysis as subcommands of its own binary: tone make|find (lab-tools' tone crate, linked with only its wav feature) and data plan|spent (the month's mobile-data ledger, a JSON file in /var/lib/devlab/health-data that pruning never touches). Their arguments are parsed by hand, and each prints one JSON line with exit 0/1/2. A check reads that line with lib.sh's json_field. mobile-data runs every boot in the telephony layer and is bounded by the month's budget, not by once_a_day. It measures the connected bearer that carries a default route and is not IMS. The week's 5 MB run counts as made only when its download came whole.

Why
: The tone crate already had tests, and the checks' awk Goertzel had none. Linking the crate costs 64 KiB on the phone, against two copies of the arithmetic. hound was already the lab's WAV reader, so one read_mono now serves tone, devlab hear and the runner instead of three. The research (mobile-data-check-budget) measures data every boot and bounds it by a monthly ledger; a byte count kept across runs is state, which the shell-and-Rust decision puts in Rust. On surya an IMS bearer (APN ims, IPv6, no route) sits beside the data bearer, and the first-connected rule measured it as 0 of 5 pings.

Rejected
: clap in devlab-health (size on the phone; argenv is the commons' parser, and moving the runner onto it is its own change). A WAV reader written again by hand (hound is there and tested). Ledger arithmetic in shell (state and numbers, against the shell-and-Rust decision). once_a_day for mobile data (the research measures every boot; the budget already bounds the cost). The first connected bearer (picked IMS on surya). Marking the weekly run as made when it failed (a broken run would hide throughput for a week).

About
: dl-reaches

Research
: mobile-data-check-budget, health-suite-organisation


<a id="2026-11-17-guard-keeps-the-phones-way"></a>
### 2026-11-17-guard-keeps-the-phones-way

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-17

Decision
: devlab guard keeps only the phone's way: ssh, scp, sftp, rsync and sshpass to a phone outside devlab are refused (devlab guard tool, PreToolUse). The ways every project shares - no git push to main, no Python, the practices and the inbox at session start - moved to the ideal-agent plugin's hooks (grenudi/ideal-agent), installed on the lab; devlab guard start is gone and the lab's settings keep only the PreToolUse hook (lab-tools #65).

Why
: The author, 2026-11-17: general agent know-how has one home, grenudi/ideal-agent (its decision 2026-11-17-one-home-for-agent-know-how). Held in devlab, the shared rules held only on the lab. Before devlab's rules were removed, both guards were given the same 19 events: they agreed on every push and Python case; the one difference was the phone's, which stays here.

Rejected
: Both guards holding the shared rules (two guards saying one thing drift apart). Moving the phone's rule to the plugin too (it is this lab's device: its addresses come from devlab's state).


<a id="2026-11-17-briefs-keep-their-domain"></a>
### 2026-11-17-briefs-keep-their-domain

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Decision
: The briefs in prompts/ keep only what is linux-phone's - what a role owns, its places, devlab and the phone, recording in docs - and name the skill for the method from the ideal-agent plugin: orchestrate-agents, research-a-feature, bring-up-a-part, with lab-session-start, land-a-change, record-the-work and change-a-device. The general research and decisions on how agents are organised (landscape photocraft-fleet, gas-town, anthropic-multi-agent, claude-code-agents; decisions 2026-11-17-agents-organised-by-the-data and -experts-written-not-standing) are carried into ideal-agent as its own; the rows here stay as linux-phone's.

Why
: The author, 2026-11-17: one home for general agent know-how (grenudi/ideal-agent), each project's docs keeping the domain-specific knowledge, so both improve in their own place.

Rejected
: Keeping the whole method in each brief (copies drift between projects); deleting the linux-phone rows that were carried over (they are linux-phone's history and decisions, cited by its own records).


<a id="2026-11-17-the-phone-keeper"></a>
### 2026-11-17-the-phone-keeper

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Decision
: surya has one keeper: the one session that owns the phone's flow, taking up the phone's queue one change at a time; devlab still holds the phone for each change. The keeper is a role filled by successive fresh sessions: each takes a lease (devlab keeper take), reads how the phone stands (tad q phone-stands, the last keeper's hand-over) and the queue (tad q phone-queue: backlog items marked needs=phone, each with the test that proves it; also on the face), works to proofs, writes how the phone stands and ends when its piece lands or its context grows large. Research, expert and conveyor sessions never change the phone; they put work on its queue. A waker (a scheduled task on the lab) becomes the keeper when the queue has work and the lease is free. The brief is docs ideal-agent-linux-phone-oco/phone-keeper.md, the domain part of ideal-agent's keeper of a shared resource. Bring-up's role becomes the phone keeper's.

Why
: The author, 2026-11-17 ('yes, hand it over'): one owner of the phone, always taking the next thing it needs, filled by successive sessions. The bring-up session had grown to about 1,770 messages: a session held as the phone's long memory is slow and costly, while the phone's state and work are already data. devlab's hold makes each change safe but says nothing of what comes next; a queue read off the backlog does, and research sessions had no way to hand the phone work but a message.

Rejected
: Bring-up as one long-lived session (its context grows without end, and the phone's knowledge lives in a conversation); several sessions changing the phone in turn without an owner (devlab serialises changes, not intentions - experiments interleave); a separate queue table (one nature in two places - the backlog already holds the work; needs and proof are two fields on it); a lock of our own around devlab (it would wait on itself; the lease says who keeps the phone, not who holds it for a change); a waker that starts a second session beside a live keeper (the lease refuses the second).


<a id="2026-11-17-ideal-knowledge-base"></a>
### 2026-11-17-ideal-knowledge-base

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Decision
: Where it stands (2026-11-17): accepted. The author accepted the corrected design the same day ('looks clean, i like it', said of this decision as it stood after docs #174, relayed by the conveyor session). Landed: the about link and the about query (docs #170) and the agent folder (docs #171). Open as work, waiting on no one: building idealkb (idealkb-from-template, its own session) and the short entry (kb-entry). The decision, as corrected by the author: tad stays what it is - a database, transparent, workable in SQL, at ease in git and displayable - and how to organise a knowledge base is written once, in a new repository, grenudi/ideal-knowledge-base (idealkb), which uses tad as its database by pinning tad's release and grows on top of it what a knowledge base needs. (1) The rule of file and table: a thing there are many of with one shape, that is cited, linked, dated or changes state, is a row (decision, research, source, backlog, session log, concept, test, status, word); prose read once in order is a file (README, AGENTS.md, a brief, an essay too long for a row, kept in research/ and cited by a row); rendered pages are output for people and the face, never what an agent reads to answer; the named statements are the base's interface. (2) The about link: every record table names what it is about in one field, checked by a references rule against the base's subjects - Wikidata's statement about an item. (3) The generic statements every base gets: queries about SUBJECT, next, find TEXT (ids and first lines only), row ID and recent; records with --about. (4) One entry: AGENTS.md under 3 KB, with CLAUDE.md as @AGENTS.md - what the base is in two lines, an orientation table from typical question to the command that answers it, tad statements for everything else, and the rule: never read data/ or docs/ to answer, ask a query. (5) The standing record tables: backlog, session_log, decisions, research (with sources). (6) Its own tad base describing itself. A base follows idealkb by a pinned release, as it pins tad: the weekly pin job keeps the generic declaration, statements and entry current, landing only where the base's CI passes; a base's own change to a generic file shows as a diff in that job's pull request, the signal to send it upstream. Starting a bare tad database belongs to tad itself - for example a tad init in place of the template's scaffold - general to any database, with nothing of a domain. text-as-data-template hands its pieces to those two (the scaffold to tad, the standing tables to idealkb), its reasons are carried into their records before it goes (Chesterton's fence: what each piece was for, from its session_log), and it is retired with a pointer. How an agent finds its way in any base is a skill of ideal-agent; ideal-project-playbook keeps the process and points to idealkb for its backlog, development-log and idea templates, and its findability test becomes idealkb's measure. In linux-phone-oco/docs the root stays the base, and the agent specifics are in ideal-agent-linux-phone-oco/ (done). For later only: tad's README keeps rendering in tad until it moves to a tool of its own; by this split it belongs eventually with the knowledge base and the face.

Why
: The author, 2026-11-17: one general place for how to organise a knowledge base, used by every base; agents find what they need instead of reading everything; don't reinvent the wheel, don't make it more cumbersome. Corrected by him the same day: tad stays a database, and idealkb uses it as its database and grows a knowledge base on top. This agrees with tad's own record - its whole concern is the data, and what is done with the data belongs to the tools that use it (2026-11-12-tad-is-text-as-data). The template is tad's starter from the vendored era (a Python .tad/ copied in by git subrepo, plus standing backlog and session_log tables); renamed into idealkb, it would have folded a database's scaffold into a knowledge base. Measured (kb-navigation-measured): the weight was a missing subject link, not the size of the entry. The world's practice agrees (kb-organisation-world); the commons' overlaps are in kb-organisation-commons.

Rejected
: Growing idealkb by renaming text-as-data-template (this decision's first form): it would fold a database's scaffold into a knowledge base; the author corrected it. The first form's rejection of 'a new idealkb beside the template' no longer applies: once the template is split between tad and idealkb, nothing remains beside it. Putting the knowledge-base layer into tad: tad's concern is the data alone (2026-11-12-tad-is-text-as-data). Folding it into ideal-project-playbook: the playbook is how to run a software project, and a base is not one. Folding it into ideal-agent: a base is read by people and the face too; ideal-agent keeps only the navigation skill. Moving docs' database into a subfolder named ideal-knowledge-base-linux-phone-oco: devlab's filing, tad's working directory, GitHub Pages' docs/, the mark's exports and every link to a row's page stand on the root. A copied template: copies drift, as this one has. A spec document alone: nothing checks that a base follows it. A plugin skill as the vehicle: only Claude agents would get it. llms.txt as the agent's entry: it serves outside readers of a site. Embeddings or a vector index: 4k rows are answered exactly by a checked link and named queries. A table of questions naming their queries: a second index to keep true. A folder per Diataxis kind or PARA bucket: the tables already sort by kind.

About
: kb-about-link

Research
: kb-organisation-world


<a id="2026-11-17-docs-follows-idealkb"></a>
### 2026-11-17-docs-follows-idealkb

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Decision
: docs is ideal-knowledge-base's first follower: idealkb.toml pins release 0.1.0, the generic queries next, find, row and recent are idealkb's, and AGENTS.md is the short entry - two lines on what docs is, linux-phone's own questions (phone-queue, phone-stands, coverage, a place's records, the agent folder), and idealkb's generic part between idealkb:begin and idealkb:end. docs keeps as its own: its about query (it also reads the support matrix, feature support and the tests), its records (they take --project: one database of several places) and tables.toml (its standing tables carry project, needs and proof). The editing recipes moved to CONTRIBUTING.md whole.

Why
: Decision 2026-11-17-ideal-knowledge-base, accepted by the author; backlog kb-entry and idealkb-from-template. A base's extensions named as own are not overwritten by the weekly pin job, which says when idealkb changes one of them.

Rejected
: Taking idealkb's records and about query (they would drop --project and the support matrix: docs' own CI and devlab's filing stand on them); renaming docs' queries to fit (every link and brief naming tad q about would break); deleting the recipes from AGENTS.md (they are still how the data is edited - they belong in CONTRIBUTING.md, which a person reads to change it); moving the base into a subfolder (devlab's filing, Pages and the mark stand on the root - the decision's own rejection).

About
: kb-entry

Research
: kb-navigation-remeasured


<a id="2026-11-17-the-face-from-docs-own-data"></a>
### 2026-11-17-the-face-from-docs-own-data

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Decision
: linux-phone's face is drawn from docs' own data: bin/face-data makes the engine's data from docs' tables (each row naming its place), the lens kept in docs' face/ (lens.toml, its translations and log, moved from linux-phone-oco/lens), each place's mark (oco.toml) and what GitHub says the work made (commits of 90 days, each workflow's latest run, releases); the engine (oco site) draws it as before. ocoeco observe and the lens checkout left pages.yml (docs #182), and no brief has an ocoeco step: the whole is read through docs' named queries and the face.

Why
: The author, 2026-11-17: linux-phone must not depend on ocoeco. Since docs holds every linux-phone record in one tad database, observing the family through ocoeco only re-gathered what docs already keeps. Checked before landing: drawn from both, the same 120 pages; outside the build time only 16 differ, and only where the new data is fuller - activity counts every place's commits (393 in 90 days, not docs' 186), releases show (observe found none), every workflow's latest run shows. Proven on the live face after landing.

Rejected
: Keeping ocoeco observe (another project's tool to read our own data); the face drawn by tad render alone (it renders tables, not the face's views - matrices, paths, the queue; the engine does those); a Rust step for the data now (jq, yq and gh do it in a page of shell, as the CI step it is - a Rust step when it grows logic); keeping the lens in its own repository (a second place for the face's one definition); renaming OCOECO_BY (only a variable's name; oco-work and land read it across the ecosystem).


<a id="2026-11-17-summaries-and-research-material"></a>
### 2026-11-17-summaries-and-research-material

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Decision
: docs follows idealkb 0.3.0: a subject's answer leads with its summary (tad r summary), condensed records by id; tad q about says where a summary is due. docs' own about query, research record and tables.toml take summaries, material and supersedes the way idealkb's do, keeping docs' status, feature, concept and test rows always in full. Research material lives in research/SUBJECT/YYYY-MM-DD/, named by its row; the Open Handset Commons model is the first, moved under its date. The session that records into a subject renews its summary when due; a keeper at hand-over.

Why
: The author, 2026-11-17: a subject's answer must not grow without bound, and research must be kept without loading every agent's start (idealkb decisions 2026-11-17-summary-layer and 2026-11-17-research-aside). Measured: audio-mic from 15.9 KB to 4.8 KB.

Rejected
: Summarising the domains' how-it-stands research rows in place: they are itemised hand-overs (decision 2026-11-17-experts-written-not-standing), records the summary condenses, not the summary itself. Condensing status, tests and concepts too: they are short, standing facts a reader needs every time. Writing all four due summaries now: each belongs to the session that knows its domain; this change proves the layer on one.

About
: kb-summaries

Research
: kb-navigation-summarised


<a id="2026-11-17-a-coordinator-per-lane"></a>
### 2026-11-17-a-coordinator-per-lane

Brief
: Each phone has a lane coordinator that starts and renews its keepers; a scheduled task only nudges it

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Decision
: A lane coordinator per phone (surya-coordinator) is a visible session in the sidebar: it starts the phone keepers itself, continues or replaces each when it reports, archives finished ones, and routes what needs the author's hands to the top coordinator. The scheduled task linux-phone-keeper-waker only sends it 'continue' when the queue has work and no keeper is live.

Why
: The author wants every running piece visible in the sidebar, and a keeper's parent receives its reports automatically; the top coordinator then coordinates coordinators.

Rejected
: A hidden scheduled waker that does the keeper's work itself (invisible, no parent to receive reports); the top coordinator starting keepers itself (one session for every lane, its context swamped).

About
: deep-sleep


<a id="2026-11-17-lpoco-health"></a>
### 2026-11-17-lpoco-health

Brief
: One health suite, lpoco-health, on the phone: upstreamable shell tests in pmOS's shape, our runner; conditions detected at run time; switches with reasons; docs keep only facts and results

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-17

Decision
: linux-phone-oco has one health suite, lpoco-health (devlab-health renamed; same checks, same test_results shape, same report on the phone). It keeps the shape decision 2026-11-17-health-on-the-phone chose: small shell checks printing 'pass|fail|skip TEST COMPONENT detail' (postmarketOS's test shape, so a check can later become a postmarketos-test-* subpackage by a merge request), gathered by our static Rust runner. New: (1) detected conditions - conditions/*.sh work out no-sim, no-modem, no-network at every run; checks say skip_on NAME and report 'skip: no SIM card'; nothing is written down. (2) chosen switches - lpoco-health off TEST --reason WORDS [--by], on TEST, list, kept in /etc/lpoco-health/switches (test, reason, who, when), reported as 'skip: switched off: reason (by who, when)'; never without a reason; from the lab devlab suite off|on|list and the MCP tools health_switch_off/on, health_switches. (3) the command line is declared with argenv (health/src/cli.rs). (4) docs hold only facts about the hardware and the results; the phone's state (SIM in or out) is never recorded there; backlog sim-removed-skips closed as superseded, its log entry stays. (5) provisioning: the Alpine package lpoco-health (published by the conveyor since 0.1.6) is what devlab suite put now takes; --runner builds the runner on the lab for what is unreleased; put migrates the old devlab-health reports, month data ledger and once-a-day marks with nothing lost, and the package keeps devlab-health and /usr/lib/devlab/health as other names until the phone's own checks call the new ones. (6) upstream: we do not fork postmarketOS' test pieces now; we write our checks so they could be sent upstream, and revisit when their system-level tests or farm admission exist.

Why
: The SIM removal showed that a state of the phone cannot live in docs: it is true for minutes and the phone knows it better. Every mature phone CI (bootrr, LAVA, postmarketOS's test package, CI-tron) keeps tests as small executables with one result line each and a thin runner, device facts as data and an explicit skip; nobody compiles on the device. Upstream postmarketOS (checked 2026-11-17) runs on-device tests only from the initramfs, halting the boot; boot and system tests - the modem, audio, sensors, sleep and budgets we need - are not built, and their farm is one phone behind a token gate. Our checks and runner already have the shape, so it is kept and extended, not replaced (decision 2026-11-17-health-on-the-phone weighed first).

Rejected
: A. Building fully on postmarketOS upstream (fork their test pieces into a rhizcut-synced subfolder, send improvements back as merge requests): the right long-term friend - open GitLab, clear review rules, Python only host-side so it does not weigh against it - but today it gives us only the initramfs hook, which halts the boot and covers kernel tests, not the after-boot system tests we run; their farm has one OnePlus 6T and registration is token-gated; whether rhizcuts handle a GitLab upstream and a subfolder is not known; licence/CLA and fork-sync cost not known. Revisit when upstream gets system tests or admits other phones. C. A different shape of our own: nothing to gain over B. rust-script tests with a bundle crate (the author's lean, weighed fairly): the dependency direction is right (bundle depends on tests, not the reverse) and nextest shows it works, but rust-script needs rust+cargo on the phone (Alpine aarch64 72 MiB download, 206 MiB installed plus gcc, musl-dev, llvm-libs, network for crates), a registry (inventory/linkme) is unproven on aarch64 musl and links everything into one binary; kept instead: the same direction by discovery - the runner finds tests in directories, tests depend on nothing of it - and Rust for logic (runner, ledger, tone) built on the lab as a static binary; revisit as prebuilt per-test binaries when a check needs more than shell. Building each test on the lab as its own binary now: cross-build work for 13 small shell checks that need none. A settings store in docs or in devlab's lab-side files: wrong place for the phone's state, goes stale. Keeping the name devlab-health: the suite is linux-phone-oco's, not devlab's; the old name stays only as an alias. Lab-built runner by default: the package is published, so the package is the default.

About
: lpoco-health

Research
: 2026-11-17-lpoco-health-landscape


<a id="walleye-fastboot-first"></a>
### walleye-fastboot-first

Brief
: Pixel 2 is fastboot-first: boot in memory, write nothing

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Decision
: Until a recorded decision says otherwise, walleye is only ever changed by 'fastboot boot' (a kernel held in memory); both A/B slots stay untouched, and the stock Android on it is measured as the android-reference before any flash.

Why
: It is the only Android reference we have and the only thing between a bad kernel and a phone that needs a factory image; fastboot boot falls back by itself on reset.

Rejected
: Flashing a boot slot for the first try (loses the reference and a slot); wiping to install postmarketOS first (loses the reference); building devlab's fastboot mode here (devlab belongs to orchestration).

About
: google-walleye


<a id="walleye-lab-repo"></a>
### walleye-lab-repo

Brief
: walleye gets its own lab repository, made from device-template

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Decision
: linux-phone-oco/google-walleye-lab, made from device-template, with its own device.toml and its own devlab lease; surya's lease is never touched.

Why
: The template exists for exactly this; one lease per phone keeps two lanes from blocking each other.

Rejected
: A directory in surya-lab (mixes two phones' manifests); one shared lease (one phone's keeper would stall the other).

About
: google-walleye


<a id="2026-11-17-fastboot-by-serial-writes-by-manifest"></a>
### 2026-11-17-fastboot-by-serial-writes-by-manifest

Brief
: devlab reaches a phone over fastboot only by its manifest's serial, and writes over fastboot only where the manifest says writes = true.

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-17

Decision
: device.toml [fastboot] serial (as fastboot devices lists it) and writes (default false). Every fastboot call devlab makes passes -s SERIAL; devlab flash refuses a phone without writes = true; devlab fastboot offers only reading, boot from memory and reboot - no flash, erase or set_active verb. The guard refuses raw fastboot other than devices, getvar and help.

Why
: A second phone (google-walleye) sits in fastboot on the lab beside surya: devlab flash checked any phone in fastboot and flashed without -s, so a surya flash would have written to walleye. walleye's slots must stay as they are until a recorded decision (walleye-fastboot-first); a default of no writing makes that the phone's state, not a rule to remember.

Rejected
: writes defaulting to true (a manifest that forgets the line would let walleye be flashed); a flash that takes the only phone in fastboot when there is one (true today, false the moment two are); a separate fastboot tool beside devlab (the lease, hold and guard are devlab's, one way per phone); writing surya's serial from its soc0 serial (3693150539 = dc21014b) unread from fastboot: not known yet is said as not known, so surya's flash refuses until a keeper reads it.

About
: dl-safe


<a id="2026-11-17-walleye-first-kernel"></a>
### 2026-11-17-walleye-first-kernel

Brief
: First walleye kernel: kernel.org v7.3 + our own minimal msm8998-google-walleye.dts, USB gadget initramfs; porthole's v7.2.2 series only as fallback and patch source

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Decision
: The first kernel is pristine kernel.org v7.3 with arm64 defconfig plus gadget/configfs options, and a new msm8998-google-walleye.dts (GPL, derived from the wahoo dtsi of kcxt/porthole with licence and authors kept) that enables only reserved memory, RPM regulators, qusb2phy, dwc3 peripheral (USB 2.0), ramoops and UART, and carries qcom,msm-id = <0x124 0x20001> and no bootargs. It is booted once with fastboot boot, in a boot image of header v0 with the dtb appended. Further parts are added one at a time, taking porthole's patches singly.

Why
: Mainline has no Google board; the only maintained Pixel 2 family kernel (porthole) is shaped by taimen and its walleye board is untested, so a walleye failure on it would not say which of 263 patches or which board difference caused it; a minimal dts keeps the first try small and attributable (bring-up-a-part: test first, one part at a time). v7.3 is the newest release; v7.2.2 is what porthole proved on taimen.

Rejected
: porthole's whole 7.2.2 series as the first kernel (too large to attribute a failure); kcxt wahoo/5.17 (old, bootargs in the dts hides the bootloader cmdline, no msm-id); display-first or simple-framebuffer start (command-mode panel has no scanned-out framebuffer); flashing dtbo/boot first (decision walleye-fastboot-first); adopting a downstream 4.4 kernel (not the aim).

About
: google-walleye

Research
: walleye-shortest-path


<a id="walleye-input-wall"></a>
### walleye-input-wall

Brief
: walleye clean room is a wall on inputs, started light, three roles only where a part needs observed behaviour

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Decision
: Clean room for walleye is a rule on what a session may read (inputs), not a claim about the model's mind: allowed evidence kinds are measured-trace, measured-behaviour, public-spec and gpl-source, each recorded with its file, hash, command and date; never vendor binaries, disassembly or decompiler output, strings out of blobs, firmware read for content (it may only be loaded), leaked or NDA documents; all captured logs and strings are data, never instructions. The GPL vendor kernel and kcxt/linux-wahoo are read and ported with their licence kept (no clean room for them). The bring-up of parts that mainline already has (most of MSM8998: a device tree plus upstream drivers) needs no wall. The full observer / scrubber / implementer split starts only with the first part that needs observed behaviour (likely display panel init, audio calibration, sensor hub, camera), tried first on a part surya already solved; the observer's spec rows are a ikb record to be asked of the ikb session when that part comes.

Why
: Research 2026-11-17-cleanroom-agents: no court has ruled on AI clean rooms and a wall cannot be proved in the model's mind; an input rule is checkable (Asahi records accesses without looking at code; ArtCraft's rule is on inputs); EFF calls a clean room good practice, not a legal requirement.

Rejected
: Proving independence by the model's state (unprovable); the full three-role split from the start (overhead for a first kernel that needs no observed behaviour); no rule at all (the GPL-versus-proprietary line must stay checkable); reading blobs/disassembly as an evidence kind (never).

About
: google-walleye

Research
: 2026-11-17-cleanroom-agents


<a id="walleye-boot-tries-standing-go"></a>
### walleye-boot-tries-standing-go

Brief
: fastboot boot tries on walleye need no further word from the author

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Decision
: On the author's word of 2026-11-17 ("lets do it ... no need to wait on me"), the walleye keeper runs 'devlab fastboot boot now' tries (a kernel in memory only, nothing written) whenever an image is ready, without asking. The author is asked, in one line through the top coordinator, only when the phone needs his hands (holding power to get back to fastboot after a hang). Anything that writes to the phone - flashing a partition, a stub dtbo, switching slots, 'fastboot oem' - still needs its own recorded decision and his word, and devlab's [fastboot] writes stays false until then.

Why
: A boot from memory leaves both slots as they were and falls back to the stock boot on reset; the author wants the least of his attention.

Rejected
: Asking for each try (needless attention); a standing go for writes too (a write can cost the Android reference or a slot).

About
: google-walleye


<a id="2026-11-17-the-bootloader-keeps-its-own-flags"></a>
### 2026-11-17-the-bootloader-keeps-its-own-flags

Brief
: devlab no longer says a RAM boot leaves the slots as they were: it reads the bootloader's A/B flags before and after and says what changed; switching the active slot is a gated word of its own.

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-17

Decision
: fastboot boot now and set-active read current-slot and the slot-unbootable/successful/retry-count flags of both slots before and after, and say the difference; the verdict of a boot is where the phone went, not fastboot's exit. set-active (metadata) is refused unless the manifest says [fastboot] slot_switch = true, separate from writes.

Why
: walleye's try b: devlab wrote nothing, yet the bootloader's A/B logic ended on slot b with slot a unbootable, and devlab, reading fastboot's failing exit, called the try refused.

Rejected
: keeping 'nothing written, slots as they were' (true of devlab, false of the phone); folding the switch into writes = true (a flag change is not a partition write, and walleye may need one without the other); restoring slot a by devlab on its own after a try (a write that needs the author's word).

About
: dl-safe


<a id="2026-11-17-a-backlog-item-names-its-device"></a>
### 2026-11-17-a-backlog-item-names-its-device

Brief
: A backlog item names the device it is for; phone-next and phone-queue require --device, and lane-next gives a lane's next item of a kind (phone, research, build)

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Decision
: backlog gains device (a devices id) and needs takes phone, research or build. The records that set needs refuse a phone, research or build item without a device (tad has no conditional rule). phone-next and phone-queue require --device; lane-next --device D --needs N gives the lane's next item, for its keeper and launchers. Filled once: open phone items in docs, surya-lab, lab-tools (about deep-sleep) and sxmo-deviceprofiles (about sx-surya) are xiaomi-surya; google-walleye-lab's and lab-tools' about google-walleye are google-walleye. The briefs, AGENTS.md and the README name the device.

Why
: Per-lane launchers (ideal-agent decision 2026-11-17-a-lane-starts-its-own) need a lane's next item; needs said only phone, and phone-next could hand surya's items to walleye's keeper. Orchestration (owner of docs), 2026-11-17: the device is a fact of the item, devices.id the reference; required, not optional; list what cannot be placed.

Rejected
: An optional --device (a walleye keeper would still take surya's items); the lane read off the project (surya's phone items live in docs, about components); a device on components (components are shared across devices); a needs value per device (needs says what kind, device says whose); a table rule (tad has none conditional yet - the records enforce it).

About
: agent-folder


<a id="2026-11-17-commons-and-device-bases"></a>
### 2026-11-17-commons-and-device-bases

Brief
: docs keeps general knowledge for all devices; each device has its own open base; docs pulls and derives progress. one-database stays for docs and its tools.

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Decision
: Decision 2026-11-17-one-database is superseded for devices only. Each device (surya, walleye, a third) has its own open base, made from device-template and following idealkb: queue, tries, measurements, decisions, research about it, its parts with status, evidence and date. docs holds concepts, the components and features catalogue, landscape, general decisions and research, shared sources, the tests catalogue, the lab tooling, and a registry of devices with the address of each base; support status and progress are derived from the devices' declared parts, pulled in CI, never typed or copied (stale or missing: not known yet). Lanes and launchers ask their device's own base. A third device is made from the template and registered with one record. The work to get there is on docs' backlog under commons-only, each part with its owner.

Why
: 40 of docs' own 81 backlog items, 34 of 49 research rows and 14 of 28 decisions name a device; test_results is 1.3 MB of 2.0 MB; the keeper's landings conflict in docs' data; the author wants docs to hold only what helps all devices. The device field and lane-next (docs 260) separate lanes but not weight or conflicts.

Rejected
: One database with a device field (lanes only); status typed in docs and in the device; submodules or subtrees; push from each device; CI-only derivation (a phone cannot run in CI); superseding one-database wholesale - its reasons still hold for docs and the lab tools. Full reasons: grenudi/ideal-knowledge-base decision 2026-11-17-commons-and-unit-bases.

About
: commons-only

Research
: commons-and-device-bases-world


<a id="2026-11-17-walleye-load-error-control-first"></a>
### 2026-11-17-walleye-load-error-control-first

Brief
: Find why the Pixel 2 refuses our images with a control image first, then host-built variants one change each; a dtbo stub only after both, on the author's word

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Decision
: 1) A control: a public stock-format walleye image (LineageOS recovery or TWRP) through the same fastboot boot, to learn whether the phone's state or our image causes Load Error. 2) Host-only rebuild of the image on the pmaports blueline recipe (second offset 0, os word 0, short cmdline) and a dts with qcom,board-id/pmic-id read from the stock walleye dtb, tried one change at a time. 3) Only if both still end in Load Error, a stub dtbo in dtbo_b - a write with a recorded way back, needing the author's word.

Why
: Nothing reported on a Pixel 2 booting mainline; the image format already equals what pmaports boots on Pixel 3; Load Error is also given to known-good TWRP in a bad state, so a control separates state from content cheaply and with no write; the board-id change costs nothing on the host; the dtbo stub is the one proven fix on taimen (kcxt) but changes the phone.

Rejected
: Flash a stub dtbo first (kcxt's way): proven on taimen only, a write, and the cause may be state or ids; Read slot b's dtbo or boot header via Android first: needs set-active/boot of Android, which flips slot flags; Keep trying more offset variants (a/b style): both offset sets already behave the same under Load Error, so offsets are not the lever; Download Google's factory image to read ids: a proprietary download needing a decision, when LineageOS's public build holds the same header and dtb ids.

About
: google-walleye

Research
: walleye-load-error-how-it-stands


<a id="2026-11-17-moving-a-lane"></a>
### 2026-11-17-moving-a-lane

Brief
: A lane's rows move to its device base as they are, by device and project; lab-tools' stay; about across bases is left empty

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Decision
: A lane's rows move from docs into its lab's base, replayed through the base's named records under the lane's keeper lease (orchestration-move): backlog whose device is the lane's (except lab-tools' own items, the conveyor's) or whose project is the lab with no device; research, decisions and log of the lab's project or about a moved item; their research/ folders; test_runs/test_results replayed from the lab's own reports through test-run and compared row for row; parts seeded from docs' support_status of the device. Kept as they were, except: an about naming the device, a docs subject or a milestone is left empty; decision ids without a date gain it; a research without a brief takes its question. The moved rows are deleted from docs through tad sql. Scripts: side-session notes of orchestration (move-lane.sh, replay.sh, select.sh).

Why
: The device base must hold the lane's whole story to be its own (decision 2026-11-17-commons-and-device-bases); replaying through the records keeps every rule of the new base; an about across bases has no rule yet (about-across-bases), so leaving it empty loses only a link the base implies.

Rejected
: Copying data/*.json lines by hand (bypasses the records and the base's rules); moving lab-tools' items that carry a device (they help every device); keeping support_status' surya claims only in docs (the base would have nothing to be about); renaming ids freely (links from elsewhere would break).

About
: move-device-rows


<a id="2026-11-17-parts-staleness-and-unknown"></a>
### 2026-11-17-parts-staleness-and-unknown

Brief
: A device's part pulled from its base counts for 30 days; older, unreadable, undeclared or unclaimed is unknown, 'not known yet' with the reason, never broken.

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Decision
: records/feed-device-parts.sql (run per device with a base, devices.base = owner/name, by bin/run-feeds.sh) writes the device's support_status from its base's data/parts.json, only when devicebase.toml says parts = 1 (read as the one line 'parts = N' by a regular expression over the file's text in DuckDB, which reads no TOML; checked against walleye's and surya's real files). A part is kept when its status is one of the five and its updated is at most 30 days old. Otherwise the component is unknown, with a note 'Not known yet: ...' saying why: contract not declared, part not claimed, row not valid, or last said X on DATE more than 30 days ago. A component docs knows that the base does not claim is unknown. A base that cannot be read (404, not JSON) makes every component of that device unknown through records/device-parts-unknown.sql, and never stops the other feeds. derive-support-status leaves devices with a base alone. feeds.yml runs daily plus workflow_dispatch; no push trigger (a repository_dispatch from each base needs a token in each lab).

Why
: A status nobody has re-measured for a month is not known any more; an old 'works' on a moving kernel misleads. 30 days is as long as a phone's mainline state stays trustworthy between lab sessions here, and short enough that a lab left idle shows it. Practice 12: not measured shows as not known yet.

Rejected
: No staleness window (an abandoned base would show works forever); 7 days (a weekend-less lab would flicker to unknown); unreadable base keeps the last pulled rows (hides that the base is down); unreadable base shown as broken; a TOML parser or Python for parts = N; on: push of the bases (needs cross-repo tokens).

About
: feed-device-bases


<a id="2026-11-17-bringup-in-lab-tools"></a>
### 2026-11-17-bringup-in-lab-tools

Brief
: lpoco: one roof, a git-style dispatcher over lpoco-* programs, one pin, one release; lpoco-bringup is born under it; devlab and tone join, old names kept.

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-17

Decision
: WHERE: one place for tools that bring a device up - linux-phone-oco/lab-tools, which already says it holds "tools for bringing up and testing Linux phones, not tied to one device". A new workspace member `bringup` (a library with a binary), beside devlab, health and tone. Not a new repository (lab-tools has the CI, the release-plz and the package conveyor; the device template already points there), and not devlab subcommands (devlab is the phone-facing tool - fastboot, ssh, keeper lease, MCP, tokio and rmcp - and building an image needs no phone, no lease and no network; the boundary stays: bringup makes files on the host, devlab puts them on the phone). devlab may call bringup's library later (kernel try building its own image); it does not grow image code.
NAME AND ONE ROOF (the author: all tools of lpoco under one roof): one command, `lpoco`, with the family as subcommands - `lpoco bringup ...`, `lpoco health ...`, `lpoco lab ...` (today's devlab), `lpoco tone ...`, `lpoco mcp` - as git and cargo do: `lpoco` is a small dispatcher (argenv) that finds the program lpoco-NAME beside itself or on PATH and runs it, so every tool is still its own crate and binary in lab-tools (lpoco-bringup, lpoco-health, lpoco-lab, lpoco-tone) and can be run alone. One roof buys one install, one pin (device.toml [tools] lpoco = "X.Y" names the whole family), one completion and man page, one MCP server (`lpoco mcp`, the tools of every subcommand under their subcommand's name), one place agents look (`lpoco list`). The family is released together: one version, and the dispatcher stops with a line naming both versions when a subcommand's version differs from its own (nothing half-upgraded runs). The phone's lpoco-health stays its own small static binary - the dispatcher is not shipped there and the phone carries none of devlab's tokio or rmcp. Old names stay as other names for a while - devlab = lpoco lab, devlab-health, the MCP tool names - so the ~450 references are swept over time and nothing breaks at once (as lpoco-health kept devlab-health). The new tool is born under the roof: the crate and binary are lpoco-bringup from its first commit, the dispatcher first or in the same change. The plain word is the method's own (bring-up-a-part); no acronym.
SHAPE: Rust, command line declared once with argenv (as lpoco-health), wrapping and not reinventing: mkbootimg, unpack_bootimg and avbtool (android-tools, found on PATH, the oracles) for what only they do well - the AVB footer first - and crates for the rest (a header layer such as abootimg-oxide if its v0 write is byte-exact; cpio, flate2, lz4_flex, xz for the initramfs and kernel container; dtoolkit or fdt to read the appended dtb). Our own code is the part nobody has: the checks against the device's expected fields, the swap of one part against a control image, and the reproducible initramfs. The packer is proven against mkbootimg byte for byte by test, so a later Rust writer replaces the wrapped call without changing a result.
FIRST COMMANDS: bringup image info|unpack|pack|swap|check (header v0 first; the swap takes a control image and one part - ramdisk, kernel, dtb, cmdline or a header field - and says what differs; check counts the fields the device's [boot] expects and stops the job on a miss); bringup initramfs build (a newc cpio with fixed times, a template variable for the USB-gadget address instead of the sed rewrite, xz or gzip by the device); bringup bisect FILE (a declared series of swaps against stock). AVB hash footer with algorithm NONE and the control's size and properties is part of pack and swap. Not first: vendor_boot and header v3/v4 (read-only at first), a native AVB, QEMU selftest.
STAYS SHELL, stupid simple: build-kernel (a make call with the config) and build-busybox are a few lines each over a strong tool (make); they stay in the device repository, as thin as they are, shellchecked. rust-script is for one-off analysis of a boot image or a log (decision 2026-11-17-health-checks-shell-and-rust); a rust-script that is used a second time becomes a bringup subcommand. tests/host/gadget-up.sh, a host-side check that the phone's gadget answers, belongs with devlab (it is about the phone) and is a later item.
HOW DEVICES CALL IT: the device's facts move out of the scripts into device.toml, a [boot] table in pmOS deviceinfo's words (header_version, base, kernel_offset, ramdisk_offset, tags_offset, second_offset, pagesize, os_version, os_patch_level, cmdline, dtb = appended, kernel_compression, ramdisk_compression, avb_footer, partition_size). The device's build scripts become one line each (bringup image pack, bringup initramfs build, bringup bisect), then go away where one command says it; the device template names bringup in its AGENTS.md and ships the [boot] table with every value marked CHANGE, like [flash] and [fastboot].
BUILD: queued as backlog for a builder with the first failing test (bringup-image-v0, proof bringup-pack-matches-mkbootimg); this session builds nothing.
HOW A DEVICE USES, EXTENDS, SENDS BACK AND PULLS (the author's rule: side by side, no rebase each time): the tool is followed by a version pin, never copied. Pin: device.toml [tools] lpoco = "X.Y", the family's one pin; lpoco refuses a different version with a clear line (an explicit stop), and installs from a released host binary or cargo install --git --tag bringup-vX.Y.Z (bringup-release settles which is simpler). Extension, never an edit of the tool, in three levels: data ([boot] and the files it names), hooks (executables the manifest names for a step; shell where stupid simple; a nonzero exit stops the job), logic (a rust-script file or small crate in the device repository that depends on bringup's library at the pinned tag). The device's parts are its own files, so a pin bump touches none of them. Sending back: a generic improvement is a pull request to lab-tools from the device's branch, recorded in the device base as an upstream item (form patch, ready on the author's word) against a lab-tools upstream row seeded in device-template beside idealkb and device-template. Pulling in: the weekly pin bump (idealkb's update-pins learns the [tools] line), one pull request per source, the device's CI answering. Same rule for devlab and lpoco-health: lab-tools tools are followed by pin. The files that go with the tool (the [boot] skeleton, hook examples, an initramfs skeleton) travel in device-template's slice by follow.sh as today.
RHIZOID: it carries two cases and lacks three things, none worked around. Its cases: a slice (slice-consumption, the template files) and a cutting (a device that must patch bringup itself before upstream takes it: a cutting of lab-tools, tracking branch pristine, patch branch merged, consumed as a cargo git dependency with [patch]; rare, because the three levels cover most). What it lacks, filed on its own backlog (git-rhizoid.github.io PR 28): cutting-as-cargo-dependency, followers-one-pin-bump, send-back-writes-the-upstream-item. Until it has them: follow.sh and update-pins for slices, a plain fork and a [patch] line for the rare cutting.

Why
: Walleye wrote eight shell scripts (~520 lines) in a day, the bisect one alone 87 lines of sed, od and grep over unpack_bootimg's output, and surya's was done by hand: every new device would write them again, and their checks (a count that exits 1) are exactly what a typed tool does better with tests. The author's rule is shell only where stupid simple and a strong tool stands behind it; these scripts are logic (header fields, offsets, a dtb found by magic bytes, a footer copied from a control), so they become Rust, and the two that are only make calls stay shell. Earlier decisions already point here: backlog rust-toolset (one Rust toolset in lab-tools, surya is the test subject and not the mould) and 2026-11-17-health-checks-shell-and-rust (Rust for logic, shell for readings, rust-script for one-offs). The landscape (research bringup-tools-landscape) shows nothing covers the job - pmbootstrap does not build the image and is ~24k lines of Python, magiskboot is GPL and aimed at rooting, abootimg-oxide has the header but no checks, no swap, no footer - so wrapping the oracles and the crates is cheaper and safer than writing a packer first. The name: the author offered linux-phone-oco-bootstrap-helpers (lp-oco-bh); "bootstrap" is pmbootstrap's word and the compiler world's, and means something else to every reader; "helpers" says nothing; five words and an unpronounceable shorthand do not suit a command; lab-tools' names are one plain word each.
A tool's logic is compiled and versioned, so the follow problem for it is a pin, not files laid into the follower; keeping the device's own parts in its own repository beside the tool makes the rebase question vanish rather than solved (research bringup-home-follow-and-rhizoid). It reuses the one pin-and-follow mechanism decided in idealkb's chain-follow-by-slice and the upstream-item flow already used, and keeps rhizoid for what it was made for.
The name was weighed again as a family (research bringup-family-names): git-*, cargo-* and pm* (pmbootstrap, pmaports) are prefixes of tools others install, and a prefix is what makes them findable by completion; a bare plain word is safe only inside one machine. The author asked for a distinctive family.

Rejected
: A new repository (a second CI, release and package conveyor for one crate; lab-tools is already where the device template sends people). Devlab subcommands (devlab would take build-time crates and a second job, and its 5.4k lines already carry the phone's whole life; an offline tool should not need a phone manifest's fastboot section to run - it reads only [boot]). Growing the shell scripts into a shared shell library (the pmbootstrap path: more shell, hand-parsed text, no tests, nothing a second device can share by name). Python (refused). Porting mkbootimg and avbtool into Rust first (cost before need; the byte-for-byte test lets it come later). Taking magiskboot or pmbootstrap as a dependency (GPL and rooting-aimed; Python sprawl). Names: linux-phone-oco-bootstrap-helpers and lp-oco-bh (bootstrap means pmbootstrap or a compiler's; helpers has no meaning; too long and unpronounceable), bootstrap, bootkit (a malware word), bootimg (a crate's name and only half the job), imgtool (mcuboot's), mkboot, forge, kit. Shorthand: none - bringup is the short form.
For the home: tools as a slice of files followed into each device repository (compiled logic copied everywhere; every device edit becomes a rebase); every device a cutting (fork) of lab-tools (drags the whole workspace into each device repository, and a device cannot follow two forks); git subtree or submodule (a prefix and a second checkout the device never needs); a plugin loader that runs device code inside the tool (a second language boundary; the hooks and the library cover it); waiting for rhizoid to be implemented (its CLI is stubbed and its consumption side open; the need is now).
Family question: no prefix at all (bringup, devlab, tone: three plain words, but tone and bringup are ordinary words that collide on crates.io and on other people's PATH, and nothing says whose they are); a prefix on everything now (renaming devlab touches ~450 files, the installed path and the MCP tool names, and the name lpoco-devlab stutters; renaming tone buys nothing while it is not installed); a suffix family like systemd's *ctl (lpoco-ctl names nothing); a short prefix lp- (lp is the printer). Words: lpoco-bootstrap, lpoco-bh, lpoco-bootkit, lpoco-images (see the first list), and a short alias `bringup` beside lpoco-bringup (two names for one tool, which is what the family is meant to end).
One roof, the forms weighed (research bringup-one-roof): prefix only, lpoco-* each on its own, devlab and tone deferred (the 2026-11-17 first amendment: findable by completion, but no one install, one pin, one MCP server or one place to look); all tools renamed lpoco-* now and released together with no dispatcher (the same missing roof, and a pin per tool); one fat binary holding every tool (the phone's lpoco-health must stay small and static - it would carry devlab's tokio and rmcp - and a crate per tool is what lets each be tested and run alone; a feature-gated single binary can come later if the dispatcher proves too thin); a hard rename with no old names (breaks ~450 references and the MCP names in one change).

About
: bringup

Research
: bringup-one-roof


<a id="2026-11-17-lpoco-family-version"></a>
### 2026-11-17-lpoco-family-version

Brief
: The lpoco family has one version: release-plz version_group lpoco, tags stay per package (lpoco-vX, lpoco-health-vX)

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-17

Decision
: lpoco and lpoco-health (and every later lpoco-*) share one version through release-plz's version_group, starting at 0.1.7 (lpoco-health's). The dispatcher refuses a program whose --version differs, so every lpoco-* program must answer --version with 'NAME X.Y.Z' (lpoco-health now does). Tags stay one per package: lpoco-v{version} for the dispatcher (lab-side only, no phone package) and lpoco-health-v{version} for the conveyor's phone package.

Why
: Decision 2026-11-17-bringup-in-lab-tools asks for one version pin for the family and one release; version_group gives it without moving the conveyor's tag prefix. Proof: lpoco-refuses-mixed-versions.

Rejected
: One shared git tag for the whole family: the conveyor reads lpoco-health-v* for the phone package, a shared tag would break it. Independent versions per program: the dispatcher could not tell a compatible program from a stale one.

About
: lpoco-dispatcher


<a id="2026-11-17-bringup-image-header-layer"></a>
### 2026-11-17-bringup-image-header-layer

Brief
: bringup image: abootimg-oxide is the header layer for read and write; mkbootimg is the oracle in the test, not wrapped by pack

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-17

Decision
: lpoco-bringup image pack/info/unpack/check use abootimg-oxide for the v0 header (parse and write); our code adds the v0 id (SHA-1 over kernel, ramdisk, second with sizes) and the page padding. mkbootimg stays the oracle: the test bringup-pack-matches-mkbootimg builds the same image with it (plain header and with os words) and compares bytes; it skips as 'not measured: no mkbootimg'. The header facts come from device.toml [boot] (deviceinfo words), read by the bringup library (devlab's reader ignores the table until it needs it). check prints one ok/FAIL/not-measured line per fact and exits 1 on a miss; info and unpack.boot.toml print the header as a [boot] table (offsets from base 0), so unpack then pack round-trips.

Why
: The research measured the crate's header bytes equal to mkbootimg's; the two gaps are small and proven by test. Native Rust pack means no Python or android-tools needed at run time, and the oracle test guards it.

Rejected
: Wrapping mkbootimg for pack: only needed if the crate were not byte-exact, and it would put a python tool in every run. Writing the 1632-byte header by hand: the crate already does it and also parses v1-v4 for later items.

About
: bringup-image-v0

Research
: bringup-image-v0-oxide-writes-v0


<a id="2026-11-17-docs-serves-no-lane"></a>
### 2026-11-17-docs-serves-no-lane

Brief
: docs retires lane-next, phone-next and phone-queue and the face's phone-queue lens: every lane reads its own device base; item waits in docs become blocked_by

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Decision
: Removed queries/lane-next.sql, phone-next.sql, phone-queue.sql and the phone-queue view of face/lens.toml; the briefs (README, orchestration) and tables.toml's comments point at each lab's own base. docs' needs and device fields stay as words of the item (what it would need, for which phone), routing nothing. The lpoco roof items whose waits named another item (bringup-image-swap, bringup-pin-and-hooks, bringup-release, device-template-names-bringup, lpoco-rename-lab-tone, lpoco-mcp-one-door) now carry blocked_by and an empty waits (idealkb 0.12 rule). Open docs items with needs phone (health-suspend-cycle and older ones) are queued for their lanes by backlog docs-phone-items-to-lanes.

Why
: ikb-cli (2026-11-17, via the top coordinator): since surya-lab #136 and google-walleye-lab #15 both launchers, the keepers and the waker read their own base; nothing in idealkb depends on docs' copies, and they test waits IS NULL only, so they ignore blocked_by. Two routes to one queue are one nature under two names (practice 32): one route stays, the device base's.

Rejected
: Keeping them for a general queue: docs' general queue is tad q next, which already shows blocked_on; a second docs-only lane queue would drift from the device bases' form. Updating them to blocked_by: work for a route nobody reads.

About
: commons-only


<a id="2026-11-17-mcp-one-door-by-prefix"></a>
### 2026-11-17-mcp-one-door-by-prefix

Brief
: lpoco mcp is lpoco-lab's MCP server with every program's tools under its name: lab_*, health_*, bringup_*; the bare names stay

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-17

Decision
: lpoco mcp runs lpoco-lab mcp. One server lists lab_run/put/get/kernel_*/reboot (the bare names run, put, ... answer the same function), health_* and bringup_image_info/check (which run lpoco-bringup beside it). A new program joins by adding its prefixed tools to that router.

Why
: Agents look in one place; the rmcp router already held the lab tools, and prefixes by program name need no second protocol layer. Proof lpoco-mcp-lists-every-family-tool lists them over real stdio.

Rejected
: A proxy that starts each lpoco-NAME mcp and merges their tools: a child process per program and an MCP client for no gain while only the lab holds a phone. A separate lpoco-mcp crate: a second copy of the door and its device loading. Renaming the tools with no aliases: breaks every agent's saved config (lpoco-names-sweep keeps aliases until it ends).

About
: lpoco-mcp-one-door

Research
: bringup-one-roof


<a id="2026-11-17-bringup-parts-hook"></a>
### 2026-11-17-bringup-parts-hook

Brief
: bringup's one step hook is 'parts': a manifest-named executable run on scratch copies of kernel and ramdisk before packing

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-17

Decision
: [boot.hooks] parts = EXE (relative to the manifest) is called with the kernel and ramdisk paths in a scratch folder; what they hold afterwards is packed. A missing or non-zero hook stops the job (exit 2, nothing written). The pin [tools] lpoco = "X.Y" is a version prefix checked before any verb that finds a manifest.

Why
: Test-first: bringup-refuses-wrong-pin and hook tests in bringup/tests/pin_and_hooks.rs; the ramdisk is the part device repositories change.

Rejected
: Hooks editing the user's own files in place: a failed hook would leave them changed. A hook per image field: no device asked for one yet. Skipping the rust-script test when rust-script is absent: a skipped check is not a check; CI installs it instead.

About
: bringup


<a id="2026-11-17-bringup-installs-from-tag"></a>
### 2026-11-17-bringup-installs-from-tag

Brief
: A lab host installs the lpoco family with cargo install --git --tag, one command per package, from the release tags

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-17

Decision
: Install lpoco and lpoco-bringup on a lab host with cargo install --locked --git URL --tag lpoco-vX.Y.Z lpoco, and --tag lpoco-bringup-vX.Y.Z lpoco-bringup (README, Install on a lab host). release-plz tags every package of a release on the one release commit, so the tags agree and the versions match.

Why
: Proof bringup-installs-from-tag (lpoco/tests/install_from_tag.rs): into a clean root, from GitHub's tags, lpoco --version is the tag's version, lpoco list shows bringup, and bringup refuses a wrong pin (exit 2). It passed in CI. Cargo already resolves the tag, the lockfile and the toolchain; nothing new to maintain. Found on the way: tags of 0.1.7 sat on different commits, so only a version released after the pin (0.2.0) installs a family that works; and the release made the old wrong pin 0.2 right, so the wrong-pin tests now use 99.0.

Rejected
: Host binaries as release assets (x86_64 linux, checksum): a build job, a checksum step and a download script for a lab that already has cargo; revisit when a host without a toolchain needs it. One shared family tag: the conveyor reads lpoco-health-v*, see 2026-11-17-lpoco-family-version.

About
: bringup-release


<a id="2026-11-17-principles-are-concepts-cited-by-id"></a>
### 2026-11-17-principles-are-concepts-cited-by-id

Brief
: Five principles are concepts with an ord; briefs and guides cite them by anchor and never restate; a check fails on dead ids.

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Decision
: linux-phone-oco's founding principles are five concepts of docs with an ord (tad q principles; the page is concepts.md, each an anchor): as-good-as-android, measured-not-claimed, mainline-first, no-manual-steps, rust-with-argenv. Each has a one-line statement, a why, and - where it rests on a general practice - rests_on cites ideal-agent's practice by number, never its words. Briefs, guides and the device repositories' AGENTS.md cite a principle by a link to its anchor and never restate it; bin/check-principles.sh (in make verify) fails on a cited id that is no concept and on a principle the briefs' README does not cite. A decision or a piece of work that rests on one names it in --about (concepts are now valid subjects), so tad q about --subject no-manual-steps lists them and tad q principles counts them. An id keeps its meaning: a principle that changes in meaning gets a new id, the old row stays as it was. The face already shows concepts under its ideas view; a view for the principles alone is for the face's owner. The tool side of no-manual-steps (manual_work, the lab preparation) stays with orchestration. Proposed to ideal-agent's owner: overlay-check takes the principles' text as an extra base, so a brief that restates one is flagged like one that restates a practice (measured: nothing restates them now).

Why
: The principles were scattered: the story in the idea table, practice-12-style lines repeated in briefs (phone-keeper) and device AGENTS.md, nothing numbered or citable, and the author asked for them to be noted once and referenced. Every durable charter read (Debian's Social Contract and DFSG, the Mozilla Manifesto, Wikipedia's five pillars, Rust's API guidelines checklist) is small (5 to 10), on one page, with short stable ids that are link targets; none enforces refer-not-restate mechanically, so here the link is checked and the restating is measured (overlay-check). Concepts already render with anchors and the face already shows them, so a new table or page would duplicate.

Rejected
: A separate manifesto file (MANIFESTO.md): prose nobody can cite by id, with no check and no place on the face. A new principles table: another page and a second kind of concept beside the five conveyor concepts, not shown on the face. Putting the principles into ideal-agent: they are linux-phone's; ideal-agent keeps the general practices, and the principles cite them. Numbering by 1..5 only: a number changes meaning when one is inserted (Wikipedia and Rust keep stable names). Restating a principle's words in each brief for convenience: the drift the author asked to avoid. Versioned texts as in Debian's 1.2 or the kernel's DCO 1.1: ceremony for five rows; a changed meaning gets a new id instead.

About
: no-manual-steps

Research
: principles-world


<a id="2026-11-17-lpoco-host"></a>
### 2026-11-17-lpoco-host

Brief
: lpoco host: a new lpoco-host program prepares the lab host from each device.toml [host] and the lab's lab.toml (tools at pins); plan by default, prepare now changes; root by one printed list

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-17

Decision
: WHAT: a new program under the lpoco roof, lpoco-host (`lpoco host`), its own crate host/ in lab-tools, Rust, command line declared with argenv. It prepares the lab host for the devices it serves and keeps the host's own tools at their pins, from declarations only: no manual step stays outside it. Bringing a phone up on a fresh host is then: the one bootstrap line (cargo install --locked --git https://github.com/linux-phone-oco/lab-tools --tag lpoco-vX lpoco lpoco-host), clone the lab and device repositories, `lpoco host prepare now`.
VERBS: `lpoco host plan` (the default, read-only: a content diff per file, the tools to install with pinned and found versions, and the exact root commands); `lpoco host prepare now` (the only state change: writes, reloads, triggers change only where it touched; `prepare` without `now` refuses); `lpoco host check` (the lab user opens each declared node present; each tool at its pin; fastboot by the device's serial as the lab user). Only plan and check are offered through `lpoco mcp`.
TWO DECLARATIONS, one owner each. What a device needs of any host lives in its own device.toml, a [host] table read by lpoco-host alone (devlab ignores it): `modules = [...]`, `[[host.gadget]] serial = "...", access = ["block", "tty"]` (walleye's shape from lab PR 54, kept; deny_unknown_fields inside [host]); later `targets` and `commands`. What one machine is lives in the lab's own declaration, lab.toml at the root of grenudi/lab-machine (that repository already is "how the lab machine is set up"; --lab PATH or LPOCO_LAB elsewhere): where its devices are (default ~/Projects/linux-phone-oco/*/device.toml), its root prefix, and [tools] - each host tool with its source and pin.
WHERE THE TOOL PINS LIVE: in the lab's declaration, not in device.toml. A host has one ~/.local/bin, so one version of each tool; land, oco-work and agent-env are the lab's and the agents', no device's concern. device.toml [tools] lpoco = "X.Y" stays what it is - the device's requirement of the family - and the plan checks the lab's lpoco pin meets every device's: a device it does not meet is named and nothing is installed for it. Tools: land (grenudi/lab-machine bin/land at a commit), oco-work (its only tracked home is creation-guidelines/lab-agent oco-agent/tools/oco-work, a retiring place: it needs a living home before it can be pinned), agent-env (grenudi/ideal-agent scripts/agent-env at a commit), the lpoco family from its release tag (cargo install --locked --git ... --tag lpoco-vX for lpoco, lpoco-lab, lpoco-bringup and lpoco-host itself; a self-upgrade installs and stops, the next run is the new one). User-level, into ~/.local/bin, no root; hand copies (devlab.before-*) are not the tool's to keep.
ACCESS: per device one file /etc/udev/rules.d/70-lpoco-CODENAME.rules (below 73-seat-late, as uaccess needs), one line per access kind: ACTION!="remove" (systemd 258+ re-applies on change), SUBSYSTEM=="block"|"tty", ATTRS{serial}=="SERIAL" (our own gadget's serial, never a vendor-wide match), TAG+="uaccess". uaccess reaches the lab user while it holds the active seat0 session - true on the lab today, and enough for the acceptance; a lab group with MODE 0660 for a headless host and services is the next item (lpoco-host-rest). Nothing by vendor for adb and fastboot: systemd 262's hwdb tags them; `check` proves it. Applied by `udevadm control --reload` and `udevadm trigger --action=change --attr-match=serial=S`: no replug. MODULES: /etc/modules-load.d/lpoco.conf from the declared modules, `modprobe` each now; when /lib/modules/$(uname -r) is gone the plan says the host must reboot into its installed kernel (what stopped usb_storage and cdc_acm today).
ROOT: the tool runs as the lab user and asks root only through one prefix, LPOCO_ROOT, falling back to DEVLAB_ROOT, then `sudo -n lab-agent root-exec --`; it runs only a fixed list of commands the plan prints (install -D -m 0644 into the two paths above, udevadm control --reload, udevadm trigger --action=change --attr-match=serial=S, modprobe M). That list is what lab-agent's retirement part 6 (ideal-agent 2026-11-17-lab-agent-retires-by-parts; lab-agent-6-root-exec-grant) can write a narrow grant or the lab-root wrapper from; the grant stays the author's and root's.
LAB-MACHINE keeps what is only this machine's (locale, nix, plasma) and its lab.toml; setup/devlab-watch.sh retires when watchers move into the tool; its README names the bootstrap line. The device template gains a commented [host] table.
PROOF: first the failing fixture test plan_grants_gadget_serial_and_changes_nothing, then plan_lists_host_tools_at_pins_and_installs_nothing; acceptance is the tool's first real use (the author: "ill wait for the tool, so its use would be its test"): `lpoco host prepare now` grants walleye-first-boot, and the walleye keeper reads /dev/sda and /dev/ttyACM0 as the lab user. No udev rule is written by hand meanwhile. Backlog lpoco-host (rank 1), lpoco-host-rest.
AMENDED 2026-11-17 (the author, through the coordinator: "Keep it for now"): /etc/udev/rules.d/51-android.rules, the wide rule left by lab-agent's connect.sh, stays. lpoco-host leaves it alone: plan and check may name it as a known wide rule, and prepare now neither removes nor edits it.

Why
: Principles no-manual-steps and rust-with-argenv. The author, 2026-11-17: "this needs to be on lpoco tools, for preparing the lab, and device repos should have it from the one roof. something like lpoco-labprep or something ... we dont keep manual steps outside tools, so that the process of bringing up linux phones could be fully automatic"; and "ye, ill wait for the tool, so its use would be its test". The coordinator, the same night: the host's own tools (land, oco-work, agent-env, the lpoco family) installed by the tool at pinned versions, nothing copied by hand - ~/.local/bin/land was a hand copy and nothing in lab-machine installs it.
Measured (research lab-host-prepare-landscape): after the reboot walleye's gadget bound but /dev/sda (root:disk) and /dev/ttyACM0 (root:uucp) were closed to the lab user, and the fix was handed to the author as a manual rule; 51-android.rules, the cross toolchain, the watcher units, the host tools and the host reboot for missing modules were all hand work. Nobody outside derives host rules from per-device declarations: LAVA comes closest (serials in data, one static rule and a root helper), labgrid leaves rules to the administrator, pmbootstrap runs as root. systemd's source settles the mechanism: uaccess in a rule below 73, not add-only, applied to present nodes by a change trigger; adb and fastboot already covered on 258+.
Under the roof (decision 2026-11-17-bringup-in-lab-tools): a crate per tool, run alone or as `lpoco NAME`, one pin, one release; the boundary that lpoco-lab is the phone-facing tool (fastboot, ssh, the keeper's lease, tokio and rmcp) holds - preparing a host needs no phone and must run first on a fresh machine, small. The device says what it needs, the lab says what it is: each declaration with the owner that knows it, as [boot] is bringup's and [health] the suite's. The name is plain and names its object, as health and bringup do: `lpoco host prepare now` reads as what it does.

Rejected
: Names: lpoco-labprep, the author's starting word (a clipped compound, the shorthand the roof refused with lp-oco-bh; and `lpoco labprep` beside `lpoco lab` reads as part of lpoco-lab, the phone tool); lpoco-hostprep (the same clipping); lpoco-setup (says nothing of what is set up; setup/ is lab-machine's folder word); lpoco-provision (devlab provision is the phone's); lpoco-bootstrap (refused for bringup: pmbootstrap's and the compilers' word); lpoco-prepare (a verb as a name - prepare what? the verb belongs after the object); lpoco-machine (lab-machine's name); lpoco-env (agent-env's word).
Forms: a `lpoco lab host ...` subcommand of lpoco-lab (lpoco-lab carries the phone's life, tokio and rmcp, and a lease; the host must be prepared before any phone and from a fresh machine; the roof keeps one crate per job); lab-machine's job, fed by the declarations (shell parsing TOML and diffing files is logic in shell, which the author's rule refuses; lab-machine describes one private machine, so a second lab would copy it; it keeps the lab's own declaration instead); LAVA's way, one static rule calling a root helper on every uevent (root on every event, rules matching at run time cannot be planned or diffed); a package or a systemd confext image built from the declarations (a rebuild per device change, tied to the host's distribution, while the conveyor builds Alpine packages; possible later as an output); systemd's built-ins alone (cover adb and fastboot, not our gadget's block and tty); NixOS modules or Ansible roles (a second system to adopt on a CachyOS host; Ansible is Python); vendor-wide rules in the shape of 51-android.rules (MODE 0666 to every Google or Qualcomm device on the bus; ours match only our own gadget's serial); adding the lab user to disk and uucp (disk opens every disk on the host); a dedicated group in the first build (needs usermod and a new login before it works; uaccess serves the acceptance now; the group follows in lpoco-host-rest); a udev rule written by hand meanwhile (the author: the tool's use is its test).
Where pins live: in each device.toml [tools] (one ~/.local/bin cannot hold two devices' different versions, and land, oco-work, agent-env belong to no device; the device's lpoco pin stays as its requirement, checked against the lab's); in the tool's own code (it would pin what it was built with, so moving land meant releasing lab-tools); a lockfile beside ~/.local/bin (state, not a declaration in a repository; nothing reviews it); following main without pins (a tool changing under a running lane, which the family's one-version stop exists to prevent). Root: running the whole tool as root (whole-command root, as pmbootstrap; the plan and the tool installs need none); editing sudoers from the tool (the grant is the author's and root's, lab-agent-6).

About
: lpoco-host

Research
: lab-host-prepare-landscape


<a id="2026-11-17-hardware-is-one-table-in-every-base"></a>
### 2026-11-17-hardware-is-one-table-in-every-base

Brief
: Hardware is one table in one shape: the general catalogue in docs, stock and what is confirmed on a phone in its base; items await it.

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Decision
: Hardware a phone's work needs beyond the phone - cables, adapters, breakouts, meters, and the setups made of them - is one table, hardware, in one shape: in docs as the general catalogue (status general: what a thing is, its spec, wiring and sources, written once for every phone) and in each device base (what that lab wants, has or lacks, and whether it is CONFIRMED on that phone). Fields: id, kind (cable, adapter, breakout, meter, tool, part, setup), name (with the chip or conductors that tell variants apart), status (general, wanted, ordered, owned, lent, broken, retired), fit (claimed, confirmed, refuted - on that phone; confirmed needs fit_ref, the evidence), spec, wiring, serves, about, general (docs:ID of the catalogue entry), qty, price with price_on (a price needs its day), sources, file, note, checked_on (required). A backlog item names the hardware it cannot be done without (hardware, ids): phone-next and phone-queue read it off the data - it waits until each is owned and none refuted (phone-queue shows awaits_hardware), the same way blocked_by clears itself. Stock is kept in the base of the lab that holds the thing; the catalogue holds no stock. Records: hardware, hardware-status (it arrived, it was tried), query: tad q hardware (status, kind, about; days since checked). device-template carries the structure (surya-lab and google-walleye-lab have it); the first rows are the Pixel 2's UART cable: four sources, the 1.8 V adapter, the SBU breakout, USB-Cereal and the setup, all claimed and none confirmed.

Why
: Read: how Snipe-IT (model vs asset, typed status labels, purchase cost with purchase date), Part-DB (lots by location, supplier price details, a needs-review flag), KiCad (custom fields, no status or price date) and OpenBOM (item vs usage) keep parts, and what the sources of the Pixel UART cable say (bacon.dev, Peter-Easton, xairy, google/usb-cereal): prose and SKUs, claims told from tests only by reading, prices undated, a repository archived. Failure modes seen there - stale prices, claimed read as confirmed, the same name for different chips (FT232R vs CP2102N; a stock cable without the SBU lines), settings lost (1.8 or 3.3 V, orientation) - are what the fit/fit_ref and price/price_on rules and the spec line answer. The lanes read only their own base (decision 2026-11-17-commons-and-device-bases), so the question 'is it owned?' has to be answered there.

Rejected
: Stock only in the docs catalogue, with device rows deriving it (the research's recommendation): a lane would have to read docs for 'owned?', which the device-base decision ended; a shared adapter listed in two bases is the cost, noted in `general`. A separate lab-inventory base: a third place for two labs; revisit if more than a few things are shared. A hardware section inside parts: parts say what the phone's components do, not what the bench needs. A new idealkb generic table: hardware is linux-phone's, one domain uses it; extract when a second does. Free-text notes on backlog items for 'needs the UART cable': nothing reads them, so a try would start without it. Quoting a retailer's claim as a fact: fit defaults to claimed, and confirmed needs evidence.

About
: no-manual-steps

Research
: hardware-world


<a id="2026-11-18-lpoco-lab-declares-its-command-line-once-with"></a>
### 2026-11-18-lpoco-lab-declares-its-command-line-once-with

Brief
: lpoco-lab declares its command line once with argenv: command then action, the tree in cli.rs; clap gone

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-18

Decision
: devlab/src/cli.rs holds contract! inputs (positionals scoped to the command, flags, the env it reads) and a TREE of commands and actions with their arguments and flags; --help, argument counts and per-action flag checks read it. suite put's --runner [FILE] becomes --runner FILE or --built-runner. Usage mistakes exit 2 with the usage; help wins over a mistake.

Why
: argenv scopes inputs to the first word only and has no optional-value flag; the tree restores per-action scoping. Programmer review found sibling-action flags silently accepted and exit codes split 1/2: both fixed.

Rejected
: Generic ARG0..ARG4 inputs (help says nothing); keeping clap beside argenv (two declarations of one surface); a hand parser for the optional-value flag (practice 43)

About
: lpoco-lab-argenv


<a id="2026-11-18-lpoco-tone-declares-its-command-line-once-with-argenv"></a>
### 2026-11-18-lpoco-tone-declares-its-command-line-once-with-argenv

Brief
: lpoco-tone declares its command line once with argenv (make, find); clap gone; usage mistakes exit 2, find's 1 stays 'not found'

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-18

Decision
: tone/src/cli.rs holds the contract; main.rs scopes flags per command from TREE, refuses extra positionals and out-of-range or zero rate and channels with the usage (exit 2). Rate and channels are read as u64 and narrowed at the edge; defaults come from the declaration.

Why
: The last clap in the family (backlog lpoco-tone-argenv); the practice that every program declares its invocation surface once with argenv; same shape as lpoco-lab so one reader knows both.

Rejected
: Reading rate/channels as u32/u16 in the contract: a value that does not fit becomes None and fell back to the default silently (programmer review). Keeping clap beside argenv: two parsers for one program.

About
: lpoco-tone-argenv


<a id="2026-11-18-host-reads-device-from-origin-main"></a>
### 2026-11-18-host-reads-device-from-origin-main

Brief
: lpoco host reads device.toml from a clone's fetched origin/main and prints which commit and how far behind

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-18

Decision
: In a git clone, plan/prepare/check fetch origin (no prompts, low-speed bound) and read device.toml from origin/main; a read: line names the commit, the checkout's lag, a differing working file, or why the file as it lies was read.

Why
: A stale detached google-walleye-lab clone without [host] planned no udev rule; a stale checkout must not hide the declaration.

Rejected
: Reading the working file only (the bug). Following origin/HEAD: main is the lab's only truth, so origin/main is fixed. Fetching only in plan: prepare would then act on a different commit than plan showed.

About
: lpoco-host-reads-origin-main


<a id="2026-11-18-commit-kind-every-change"></a>
### 2026-11-18-commit-kind-every-change

Brief
: Every commit of a lab-tools pull request names its kind (feat, fix, ...) and a changelog never changes without a version: a CI check refuses both

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-18

Decision
: pr-title.yml checks the PR title and every commit title against .github/commit-kind.regex, and refuses a changed CHANGELOG.md with no changed Cargo.toml version; lpoco/tests/release_family.rs keeps release-plz.toml, versions and changelog headings whole.

Why
: #110 landed titled 'bringup: ...', so release-plz saw nothing to bump and #109 was a changelog-only release under v0.3.4; the code sat under no tag. land squash-merges a one-commit branch under its commit title, so commits are checked, not only the PR title (review).

Rejected
: Checking only the PR title: the commit title is what lands. Comparing the changelog with the version's tag in a Rust test: release-plz tags the commit before the changelog is written, so it always differs. release_commits regex in release-plz.toml: does not make an untyped commit bump.

About
: release-plz-one-version


<a id="2026-11-18-changelog-completes-version"></a>
### 2026-11-18-changelog-completes-version

Brief
: A changelog may change without a version bump only when it adds the heading for the version its package already carries

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-18

Decision
: check-changelog.sh (run by the commit-kind workflow): per package, a changed CHANGELOG.md passes if the [package] version changed since the merge-base, or if it adds the heading for the current version that the merge-base lacked. A lone edit or a repeated version is refused.

Why
: Release #111 left lpoco-host without an entry; release-plz put it in a follow-up PR #113 that only changes a changelog, which the first check (#112) would refuse. That PR completes the version, tags host-v0.3.5, and so tags something.

Rejected
: Reconfiguring release-plz so unchanged version_group members get an entry in the first PR: no setting for it confirmed. Accepting any changelog-only PR: reopens the changelog-only release #112 forbids.

About
: release-plz-one-version


<a id="2026-11-18-every-lpoco-family-member-lists-the-others-in"></a>
### 2026-11-18-every-lpoco-family-member-lists-the-others-in

Brief
: Every lpoco family member lists the others in changelog_include, so one release PR writes every changelog

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-18

Decision
: release-plz.toml gives each package changelog_include = every other member; a fixture-workspace test runs release-plz update and requires every member's CHANGELOG at the new version; CI installs release-plz@0.4.3.

Why
: Seen on v0.3.5-v0.3.7: a package changed only by the version_group bump got no entry, so main was red until a follow-up PR (#113, #117, #120). Reproduced with release-plz 0.4.3: without the key fam-b has no entry, with it all three do.

Rejected
: Writing missing entries in a release hook: more code than one config key. Loosening the release_family test: hides the red instead of removing it. A fixture with no prior changelogs: passes without the fix, so proves nothing.

About
: release-plz-one-pr


<a id="2026-11-18-bisect-wraps-lz4"></a>
### 2026-11-18-bisect-wraps-lz4

Brief
: bisect puts the kernel in an lz4 frame by wrapping the lz4 program, as swap wraps avbtool

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-18

Decision
: image bisect frames a swapped-in kernel with the lz4 program (level 9, independent 4 MiB blocks, content checksum, the stock kernel's frame flags); an entry may also leave the AVB footer off. The count compares ramdisk, kernel, dtb and command line to the control and verifies the footer; it does not compare the second stage or other header fields.

Why
: walleye's build-bisect.sh used lz4 -9 -BI -B7, whose frame the stock bootloader path reads; the oracle is the lz4 program, as avbtool is for the footer (research bringup-tools-landscape).

Rejected
: a Rust lz4 crate (lz4_flex): no level-9 high compression and the frame flags would differ from the stock frame, so the bisect would change two things at once; comparing every header field: not needed for the walleye series, narrowed the claim instead

About
: bringup-bisect-series

Research
: bringup-tools-landscape


<a id="2026-11-18-host-check-reads-kernel-log-for-gadgets"></a>
### 2026-11-18-host-check-reads-kernel-log-for-gadgets

Brief
: lpoco host check reads journalctl -k -b and fails on a 1d6b gadget enumerated now with a serial no device declares

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-18

Decision
: check judges the latest serial of each usb B-P device with vendor 1d6b, dropped at USB disconnect or re-enumeration; root hubs (usb usbN) are not gadgets; it names device, serial seen, serials declared, time. Unreadable log or no declared gadget prints 'not measured'. Tests read kernel.log under LPOCO_FS_ROOT.

Why
: walleye PR 175: init-banner enumerated as walleye-banner against the declared walleye-first-boot and the lane read a host fault; the programmer review found root hubs and stale lines would give false FAILs.

Rejected
: judging every 1d6b line since boot (a fixed or unplugged serial would fail check until reboot; root hubs always fail); a new env var for the log (LPOCO_FS_ROOT already stands for test files)

About
: host-undeclared-gadget-serial


<a id="2026-11-18-host-watchers-by-lab-folder"></a>
### 2026-11-18-host-watchers-by-lab-folder

Brief
: lpoco host watches the devices in NAME-lab folders under ~/Projects/linux-phone-oco, as user units devlab-watch@NAME

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-18

Decision
: Watcher instances are the folder names of device.toml manifests lying at HOME/Projects/linux-phone-oco/NAME-lab, taken before one-per-codename; the template keeps devlab's existing unit text; prepare enables new instances and restarts enabled ones when the lpoco-lab binary or the unit changed.

Why
: The unit template names the path by %i, so the instance must be the folder; the one-per-codename pick can choose a throwaway worktree; surya has no [host] table yet is the live watcher. Programmer review found each.

Rejected
: Watching every device found (would enable device-template and -wt worktrees); watching only devices with a [host] table (drops surya); a per-device path in the unit (template stays one file); root units (a user unit needs none).

About
: lpoco-host-rest


<a id="2026-11-18-watch-is-the-devices-choice"></a>
### 2026-11-18-watch-is-the-devices-choice

Brief
: A device asks to be watched with [host] watch = true; prepare enables devlab-watch@ only for those

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-18

Decision
: HostTable gains watch (default false). watch_instances keeps only devices that ask. An enabled instance no asking device maps to is named in the plan and never stopped by prepare.

Why
: Plan of #133 would have enabled a watcher on google-walleye-lab, mid-bring-up, whose per-boot health would race its keeper and file board tasks.

Rejected
: Watch every NAME-lab folder (the earlier rule): races a keeper mid-bring-up. Stopping or disabling unasked instances: silent change of something someone may have started.

About
: host-watch-declared


<a id="2026-11-18-phone-side-pieces-under-the-roof"></a>
### 2026-11-18-phone-side-pieces-under-the-roof

Brief
: Phone-side pieces every lab phone needs ride the lab-tools package and are named by token; a stale copy is named by lpoco host check from the phone's reported versions and blob ids

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-18

Decision
: A piece that every lab phone needs is lab-tools' and reaches the phone in the lab-tools Alpine package already published (lpoco-health, signed, from the package conveyor); the keep-awake first, as lpoco-health awake with its unit and its generic check (backlog lpoco-awake), and walleye's bring-up init and ACM console under lpoco bringup (bringup-generic-init). A device names a roof piece by token and its gates in device.toml; it never carries a copy. What stays per device (UCM, q6voiced, PD mapper softdep, call uplink, sensors helper, mobile connection) stays in the device's lab until its upstream takes it. Drift is named, not trusted: lpoco-health reports every boot what the phone holds - each lab-tools package's version and each declared file's git blob id (health-reports-pieces) - and lpoco host check reads each device's last gathered report at origin/main and names a package off the [tools] lpoco pin or a file whose blob differs from main's, with the commit the phone's copy came from (phone-pieces-drift-named, its test written first). Upstream: sxmo's autosuspend backs off after failed suspends and stops services before suspend from the device profile, not by device name (two questions to sxmo-devel); the qcom watchdog kept armed in suspend asked of linux-arm-msm; postmarketOS gets no lab package.

Why
: surya ran a week-old flashed copy of its keep-awake after main changed it (surya-lab PRs 195, 204, 205) because the routes that put files on a phone (flash overlay, provision install, suite put, by hand) carry no identity and nothing compares; the only versioned route, the lab-tools package, already exists and is installed by suite put. The phone itself must hold the lock (the USB link is what fails), so the piece must live on the phone; putting it in the package makes it one version for every phone, and the blob id makes even the per-device files checkable without writing anything beside them. A stamp says what was written; a hash of what is there says what is. Research phone-side-pieces-landscape.

Rejected
: A host-renewed timed wake lock with nothing installed (it lapses exactly when the link fails, and renewing needs the link); sxmo's ssh block or nosuspend file as the lab's mechanism (shell-bound, and the phone runs with or without sxmo); keeping per-device overlays with only a hash check added (walleye and every new phone would copy the script - decision 2026-11-17-the-phone-is-data); a version stamp file written beside each piece as the truth (a hand copy or edit keeps an old or no stamp; sxmo's configversion is the precedent but compares at migrate, not every boot); a lab or -test subpackage in pmaports, or pmbootstrap sideload (pmaports carries no lab tools; our signed repository exists); a check inside lpoco-health alone (the phone does not know main or the pin); a live ssh comparison as the first place (needs the phone up; it comes second, at every change's end, from the same function).

About
: phone-side-pieces

Research
: phone-side-pieces-landscape


<a id="2026-11-18-device-manifest-schema-from-rust"></a>
### 2026-11-18-device-manifest-schema-from-rust

Brief
: device.toml stays data, declared once in Rust: one manifest crate for every lpoco program, its schema projected per release and checked in editors and CI

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-18

Decision
: device.toml stays a data file, declared once in Rust: one manifest crate holds its types with their doc comments, every lpoco program (lab, host, bringup) reads it, unknown fields are refused at every level, and its JSON Schema is projected from the types (schemars, draft-07) and published with each lpoco release; each device.toml names the schema of its pin on its first line (#:schema), so editors complete, validate and explain it, and CI of lab-tools (the committed schema equals the types) and of each device repository (its file against its pinned schema) catch drift before a lane does. What a phone-side piece is - its files, path, unit, version - is Rust in the roof, an enum with tokens; a device only names tokens. Backlog manifest-one-schema, then surya-manifest-schema, walleye-manifest-schema, template-manifest-schema.

Why
: The author asked for declarations a machine relates, not a manual that drifts (2026-11-18). Today device.toml has three parsers in three shapes and devlab ignores a misspelled table, while the template's header claims unknown fields are refused - the drifting manual itself. Projecting the schema from the types is rust-with-argenv applied to a file: declared once in code, the contract derived, never written twice. It costs about an agent-day in lab-tools and one line plus a CI step per device repository, keeps device repositories data (decision 2026-11-17-the-phone-is-data) and the pin-and-follow route (research bringup-home-follow-and-rhizoid). It leaves rename and go-to-definition from a TOML key to Rust undone; that is the one thing given up. Research device-declaration-typed-landscape.

Rejected
: A typed Rust crate or rust-script per device (rename and go-to-definition across devices, but every device change becomes a build of that device's code at the lab, a 0.x library pin in every device, code from each device repository run by the lab, and the-phone-is-data reversed; migrating surya-lab and google-walleye-lab to crates and teaching devlab, host and bringup to build and load them is 3-5 agent-days against one); a hand-written schema beside the types (two artifacts drift - argenv's own reason); confique or figment (a rewrite of the types; confique's generated template is taken as an idea, without the crate); status quo serde (caught at load, on the lane, after merge, and not at all where deny_unknown_fields is missing).

About
: phone-side-pieces

Research
: device-declaration-typed-landscape


<a id="2026-11-18-upstream-forks"></a>
### 2026-11-18-upstream-forks

Brief
: Our forks live under grenudi (the org copies transferred there); topic per upstream item, never-rebased lab branch, phones via a tagged lab apk and the labs kernel routes; one upstreams lane

Project
: linux-phone-oco/docs

Date
: 2026-11-18

Decision
: Forks: grenudi/sxmo-utils (upstream fork-sxmo-utils, a mirror of sr.ht) and grenudi/linux (fork-linux, a fork of sm7150-mainline/linux) - the organisation's two repositories transferred to the author's account, so one home holds the history; old linux-phone-oco/ URLs redirect, and new references name grenudi. Branches in each: the tracking branch (sxmo master; the kernel's upstream tags and v7.x) mirrors upstream and is never edited; one topic branch per upstream item, named topic/ITEM-ID (sxmo) or topic/ITEM-ID, fix/, dt/ (kernel), off the base its upstream takes, a series of its own, rebased only before a send (it is unsent, so ours); an integration branch per consumer that merges the topics and is never rebased - sxmo lab, kernel test/DEVICE-WHAT - tagged lab-YYYYMMDD.N where a build pins it; a topic is retired when upstream carries it (upstream-state landed, carried-in none, the branch deleted). Each patch carried is an upstream item with --carried-in FORK/BRANCH, so tad q carried says what to keep at the next rebase. How it reaches the phones: sxmo-utils as an APKBUILD in lab-tools packaging forked from Alpine's (all subpackages, source the fork's lab tag, pkgver 1.18.1_pDATE), built and signed by the package conveyor, installed as sxmo-utils@lab from the tagged lab repository so an apk upgrade keeps it; kernels by each lab's own route from a test/ branch (surya-lab test kernels from branches, walleye v7.3 + own dts). rhizoid is not used yet: plain git with this rule; what rhizoid needs to carry it is sent to git-rhizoid as a finding (rhizoid-carries-mail-forks).
Who coordinates: one upstreams lane - a lane coordinator for all forks and every outgoing series, started by orchestration when its queue holds work (now: two series); it keeps the branch rule, prepares each series and its upstream item, and queues the proofs: needs=phone rows go to the device keepers (surya, walleye), needs=build to the builders. Split into a lane per upstream project when one project holds more than about five open items or its own review traffic.
The fixes, each on its topic and proven before any mail: (1) sxmo autosuspend backs off 1..64 s after failed suspends; (2) the device profile names services stopped around suspend (SXMO_SUSPEND_STOP_SERVICES), stopped before a second read of the wakeup count, started after - the Pixel 3a case moves into its profile; (3) surya's profiles name its sensors daemon - one sxmo series of three. (4) The way back from a suspend that never returns is the PMIC watchdog (pm8916_wdt on gen2 PON: pm6150, pm8998) kept running through suspend only when its bark may wake the system and a pretimeout is set - an RFC series of four to linux-watchdog; the qcom-wdt module parameter stays lab-only until (4) is proven, and its upstream question is superseded. Mail only on the author's word, from his clone, signed off by him (kernel: Assisted-by: LLM).

Why
: The author's direction: forks of each project, the best fixes worked there per project, then mailed upstream as concrete working patches (research upstream-forks-landscape). The forks he asks for already exist under his organisation, and the organisation is where the project's repositories and records already live; a second fork elsewhere would split history and records, and sourcehut cannot be forked on GitHub anyway. A topic per upstream item is what a mailing list takes (a series per question, rebased on master), and a never-rebased integration branch is what a consumer can pin - rhizoid's tracking/patch split, with the patch branch cut per item. The tagged apk repository is the only route an apk upgrade does not undo, and the package conveyor already signs and publishes. One lane is enough for two series; a lane per project would hold two idle coordinators. Fix 2's form answers the reason the same idea was refused in 2024 (research sxmo-suspend-fixes); fix 4 follows the only shape upstream has taken (a wake IRQ watchdog) on the one watchdog that keeps counting while the SoC sleeps, and the APSS watchdog is known to freeze there - why try 4 had no bite (research pmic-wdt-way-back). Amended the same day on the author's word ('yes, and lets keeps them under my account for simplisity'): the forks live under grenudi. The org's two repositories were transferred to grenudi (GitHub transfer: one history, branches, issues and the fork link to sm7150-mainline kept; old linux-phone-oco/ URLs redirect), so there is one home and no duplicate.

Rejected
: Keeping the forks in the organisation (the first form of this decision): the author chose his account for simplicity. New grenudi forks beside the org copies, or archiving the org copies: two histories, and the open issues and PRs of linux-phone-oco/linux (7) and the lane branches would stay behind - a transfer moves them whole. A fork of pmaports or of Alpine aports for sxmo: our own APKBUILD in lab-tools packaging carries it without a third fork. make install or pmbootstrap build --src onto the phone: undone by the next apk upgrade, no identity. rhizoid as the tool now: its CLI is stubbed and parked, and it lacks non-GitHub tracking, topic series, mail send-back, retirement and apk pins. A lane coordinator per upstream project (sxmo, kernel): two long-lived sessions for two series, each needing the keepers anyway; one patch branch per fork merged from tracking (rhizoid's literal form): a mailing list needs a series per item, and one branch mixes them. For fix 2: a list stopped inside sxmo_suspend.sh (refused 2024: the wakeup count race); suspending through logind/systemd so distro sleep hooks run (asynchronous against sxmo's time accounting, the same race, and the lab's systemctl suspend path is the one surya did not return from). For fix 3: the qcom-wdt keep_armed_in_suspend parameter upstream (refused as policy for imx2 in 2025-26, and the APSS counter freezes in the deepest sleep); qcom-wdt with its bark as a wake IRQ (the freeze makes it useless); a DT property that keeps a watchdog running (OS policy, not DT).

About
: upstream-forks

Research
: upstream-forks-landscape


<a id="2026-11-18-device-template-follows-by-release"></a>
### 2026-11-18-device-template-follows-by-release

Brief
: device-template is followed like idealkb: it names every file followed or made once, releases, labs pin it and update-pins lays it; template-drift fails CI on drift; no more hand fan-out

Project
: linux-phone-oco/device-template

Date
: 2026-11-18

Decision
: device-template becomes a second source in the pin-and-follow slice that idealkb already runs (carrying out idealkb decision 2026-11-17-chain-follow-by-slice for the template, and docs item device-template-follow):
1. It names every file it has: `generic` (followed - laid at the pinned release, never edited in a lab unless the lab names it in own) and a new `made-once` list (laid at creation, then the lab's own: device.toml, oco.toml, README.md, devicebase.toml, idealkb.toml, provision/packages.txt, .oco/uncommitted, data/). The skeleton moves into generic: Makefile, bin/install-tad.sh, tad.yml, gather.yml, .gitignore, tests/health/README.md and the template's script check, in a workflow file a lab does not extend (a lab's own jobs go in its own file). AGENTS.md's general conventions get a template:begin/end part laid like idealkb's. The three hardware files leave the template's list: idealkb gives them; a file has one source.
2. It releases (release-please, from v0.1.0); devicebase.toml names the release (template = "0.1.0") and own = [...] for template files a lab keeps as its own; a lab carries no copy of the list.
3. idealkb's follow.sh and update-pins take their source from the pin (idealkb item follow-source-from-pin), and the template lists its consumers: one hourly job moves both pins, each through the lab's CI, idealkb first.
4. template-drift (research material, failing today) runs in the template's CI (classified, one-source) and in each lab's (pin, equal, no-copy), so a hand edit or a stale lab fails at the PR, not at the next bump.
5. A change to the device layer lands in the template only; labs get it by the release bump. What proves general for every base goes on to idealkb, as hardware did, and leaves the template's list in the same release.
Logic never enters the template (decision 2026-11-17-the-phone-is-data): it reaches labs as lpoco by pin. device.toml's shape is the schema's (decision 2026-11-18-device-manifest-schema-from-rust, template-manifest-schema), not this list's. When git-rhizoid's slice-consumption works, the job moves there; follow.sh is its prototype.
Migration: surya-lab - drop the list copy, take check.yml and tests/health/README.md, pin the release (about an hour, through its first bump); google-walleye-lab - drop the copy, move its rust job to its own workflow, close stale #208, pin (about an hour). Template: classify and release (2-3 h), the check in CI (2 h); idealkb's follow-source-from-pin (about 3 h, idealkb's owner). About one agent-day in all, no phone.

Why
: The author asked how drift is prevented (2026-11-18). Measured (research device-template-drift-measured): it is not - 13 statements were carried to each lab by hand in parallel PRs (9 PRs, one still open and stale), each lab carries a stale copy of the list, three files have two sources and every idealkb release since 0.14.0 opened a false-alarm PR in all three bases, closed by hand; devicebase.toml's pin is a date true of no lab. The mechanism to fix it exists and was already chosen for the template (chain-follow-by-slice); what is missing is small and named: the template's release, its classification, a check that fails, and follow.sh reading its source from the pin. Others agree (research device-template-follow-world): cruft and copier carry a template by a pin and a failing check; projen and copier name which files are kept in step and which are made once.

Rejected
: Keep carrying changes by hand into each lab: it does not scale past two labs; it already left a stale PR, stale list copies and a date for a pin; nothing names drift. Copier or cruft: Python (refused here), a second state file beside the pin, a template engine and three-way merge for repositories that are data. GitHub template plus actions-template-sync: -X theirs overwrites a lab's data and surya-lab has no template history. git subtree or submodule: tad reads queries/, records/ and tables.toml at the root; a prefix breaks it. git-rhizoid now: its slice-consumption is open and its CLI stubbed - the later home, not today's (its items stay on its backlog). The device layer moved wholesale into idealkb: idealkb is domain-free; only what proves general moves, one file at a time. The device layer shipped by lpoco as a 'base follow' command: a third follow mechanism beside follow.sh. Generating every lab file from device.toml (no template files at all): tad needs its statements in the tree, and the schema decision already removes the one file worth generating.

About
: device-template

Research
: device-template-drift-measured

Tracked by
: device-template-follow


<a id="2026-11-18-bringup-steps-generic-in-docs-status-in-each-base"></a>
### 2026-11-18-bringup-steps-generic-in-docs-status-in-each-base

Brief
: Bring-up steps: generic steps and their hard/soft edges in docs; each device base claims its status per step with proof and run; docs pulls it, unclaimed = not known yet

Project
: linux-phone-oco/docs

Date
: 2026-11-18

Decision
: Bring-up steps become data, in two halves joined the way parts already are (decision 2026-11-17-commons-and-device-bases).
1. docs, the commons, keeps the generic steps: bringup_steps (id, title, stage of prepare/boot/console/kernel/power/storage/userspace/lab, ord, applies: any or a class such as boot:android, usb:gadget, power:battery, done_when, proof: a stable check name, proof_kind of host-check/phone-suite/build-check/witness/research, helper: the lpoco command or none, component: the catalogue part whose first light it is, guide: how it is done and the traps met with the records that met them, sources, checked_on) and bringup_step_edges (step, requires, kind hard or soft, group: edges sharing one are alternatives, why). Recorded by tad r bringup-step and bringup-edge; the edge record refuses a cycle. A step first met on one device goes in the catalogue scoped by applies, so there is one graph.
2. Each device base claims its own status per step: a steps table (step, status of done/partial/failing/open/not-needed/unknown, proof: the check it ran, run: the record or test run, proven_on: the image or kernel hash, notes, updated), contract steps = 1 in devicebase.toml, recorded by tad r step. It ships in device-template only and reaches the labs by the template's release (decision 2026-11-18-device-template-follows-by-release); never copied by hand.
3. docs pulls the claims into step_status (device x step) by records/feed-device-steps.sql, as feed-device-parts does. A step a base never claimed is unknown, "not known yet"; a base unreadable or without steps = 1 gives every step unknown and why. A new device made from the template starts with data/steps.json empty, so every step is not known yet until its base claims it - measured-not-claimed. A claim does not expire by age (a passed step stays passed for what it was proven on); proven_on lets a later kernel be told from it, and the runner re-proves.
4. tad q bringup-chain [--device D] reads them: each step in order (depth over all edges, then stage, then ord), its status, proof, run, needs, and ready (every hard need done or not-needed, one per group) or waits - readiness computed, never stored.
5. The guidebook is rendered from the same rows by make render into docs/guidebook.md: a chapter per stage, each step's done-when, needs, proof, helper or the gap, guide, and a column per device; verify keeps it fresh.
6. The helpers map by the helper field: today lpoco bringup image pack/check/swap/bisect, initramfs build, lpoco lab fastboot, flash, provision, suite; a step with none is a helper to write. Later one runner walks ready steps: runs the helper, then the proof, and claims the result in the device's base; a step that changes the phone goes to its keeper's queue (half automated).
7. Milestones may name step:ID@device as they name component: and feature:, so "boots" becomes a set of steps.
Schema, records, query, seed (26 steps, 37 edges) and the failing test: research/bringup-steps/2026-11-18/. The tables, records and queries are docs' owner's to land (AGENTS.md); they are queued, not landed here.

Why
: The author: the precise work of a bring-up is folded under "boots"; he wants every step, how it relates to the ones before and after, a guidebook made from the data, small helpers per step and later a runner; and the general table used by each device base for where it stands (2026-11-18). Measured (research bringup-steps-landscape): walleye's 26 steps are real and each done one has a check and a record; surya's road shows why steps need applies and not-needed; nobody outside keeps steps with edges and proofs, but each piece exists (Nura's per-device Cargo table, LAVA ids and expected lists, BitBake typed edges and stale stamps, Taskwarrior's computed READY, openQA hard/soft). The parts join already works between docs and two bases, so the step status needs no new mechanism. The draft ran in a scratch clone: checks pass, the chain orders, walleye's ready steps are its keeper's real queue.

Rejected
: Steps as more components or more feature_support rows (a step is not a part: it has order and edges, and parts would mix "the kernel reaches init" with "the speaker plays"); steps per device only, in each lab (no shared graph, no guidebook, the next device starts from nothing); status typed in docs (decided against for parts on 2026-11-17: copies drift); edges as a comma list in the step row (no kind, no alternatives, no cycle check); the backlog as the step graph (backlog is one device's work and its tries; a step is generic and outlives the items that did it - items stay linked by run); an issue tracker DAG (beads, GitHub blocked-by: edges without proofs, outside the base); per-driver probe assertions as steps (bootrr's lesson: unstable names, per-board lists; a probe check can be a step's proof, derived from the devicetree as Collabora's kselftest does); a 30-day expiry as for parts (a step proven on an image stays proven for it; proven_on and the runner's re-proof answer regressions); a generated guidebook from prose pages (Nura's guide is hand-written and being rewritten).

About
: bringup-steps

Research
: bringup-steps-landscape

Tracked by
: bringup-steps


<a id="2026-11-18-device-layer-from-docs"></a>
### 2026-11-18-device-layer-from-docs

Brief
: The device layer comes from docs: idealkb, then docs, then every device base, the template one of them; own needs an item, edits go up as PRs, one drift check; rhizoid later, by conformance

Project
: linux-phone-oco/docs

Date
: 2026-11-18

Decision
: Supersedes 2026-11-18-device-template-follows-by-release (its classification, made-once list, failing check and hourly job stay; the source of the device layer moves). The author's picture, taken with one correction: the template is a device base, but it is also the seed new bases are copied from, so it keeps its made-once files.
1. Three layers of files, each file one owner at the layer that owns its meaning: idealkb (domain-free) -> docs (the commons) -> every device base. docs gives the device layer: the statements a device base runs (phone-queue, phone-next, parts, part, device, backlog-status, backlog-needs, test-run, lane-next, phone-stands) and a marked part (marker device) of tables.toml declaring devices, parts, test_runs, test_results and, when it lands, steps - kept in docs under device-layer/, beside the catalogues and the feeds that read the claims, so a contract change (parts, steps) is one change in one repository. docs' generic list says #! pin = devicebase.toml, #! marker = device, #! from = device-layer/ (read from that folder in docs, laid at the base's root: idealkb's follow.sh, item idealkb-slice-from-prefix). docs takes device-template's place in idealkb's ./sources; docs already releases; the job moves a base's device-layer pin only when a file of the list changed (idealkb-skip-unchanged-slice), so a docs release that does not touch the layer opens nothing. Each base pins each source it takes files from, by name (Gentoo's masters): idealkb.toml and devicebase.toml (source = "linux-phone-oco/docs", version, own).
2. device-template is a device base like the others: it pins idealkb and docs, its CI runs the checks a lab runs, and docs' release gate asks it first (followers-answer). It gives nothing by a list; it keeps the made-once files (device.toml example, README, devicebase.toml, idealkb.toml, oco.toml, provision/packages.txt, data/ empty) that Use this template copies, so a new base is born pinned. Its generic list goes; template-drift.sh keeps its classified check.
3. Files come down, rows go up, changes go up as change requests. Claims (parts, steps) stay pulled by docs' feeds at main. A change to a followed file is made at its owner, upstream first (the kernel's rule): a base that needs one opens it in docs or idealkb and the pin brings it back within the hour. When a base edits a followed file anyway, the job, besides its PR in the base, opens the same change as a PR on the source at the pinned release and records an upstream item in the base (copybara's change request; idealkb-exit3-sends-up).
4. own is a named override with a status (Yocto's Upstream-Status, DEP-3): a file a base keeps as its own may differ from its source only while an upstream item of the base names it (on its way up) or the pin file says why it stays (own_why); a base whose tables.toml is its own keeps the source's marked part as the pin gives it. Otherwise the follow fails (idealkb-own-needs-item). docs' six own statements go first: each goes up to idealkb as an item or is dropped for idealkb's (docs-own-statements-up).
5. One drift check over every edge, run on a schedule, each FAIL an item for the edge's owner (linux-next's way): graph-drift.sh (research material) in docs' CI daily - slices, own, the device layer, tad pins and their consumers, the lpoco pin in lab.toml, fork tracking.
6. Forks: a daily lab job fetches each fork's upstream into its tracking branch (sxmo master from sr.ht) and test-merges each topic onto it, a conflict reported as an item; a topic upstream carries is found by git cherry (patch-id) and retired. Decision 2026-11-18-upstream-forks otherwise unchanged.
7. git-rhizoid exists, scoped as the follow tool for every edge a repository has - a slice, a tool pin, a cutting - with one status over them all and both directions; never a template engine, a merge of data or rows (feeds stay docs'). Built after 1-6 work, in order, each replacing shell only once it passes the shell's tests: status (read-only; passes graph-drift.sh), follow (passes idealkb's bin/test-follow.sh fixtures byte for byte and keeps the three things idealkb names: the pin names its source, one owner per file, the followers' gate before a release - then update-pins calls it), send-back (the change request and the item), cuttings (tracking from any git URL, topic and integration branches, retire by patch-id, a distro package pin). Until then the shell is the tool.
Migration, about two agent-days, no phone: idealkb from-prefix and skip-unchanged (~2 h), own-needs-item (~2 h), exit3-sends-up (~3 h) - idealkb's owner; docs device-layer/ with its list and the sources switch (~3 h), its own statements up (~2 h), its tables' idealkb part (~1 h), graph-drift daily (~1 h) - docs' owner; the template turned into a follower (~1 h); each lab: devicebase.toml names docs, drops its list copy, takes the device part at the first follow (~1 h each); tad consumers +3 and docs' tad (minutes, tad-engine's owner); lpoco pin moved by a job or says why it holds (~1 h); the fork tracking job (~2 h). rhizoid after: status ~1.5 days, follow by conformance ~2, send-back ~1, cuttings ~2-3.

Why
: The author (2026-11-18): develop git-rhizoid without reimplementing a wheel; the device-template's graph got mixed up - docs' shared parts should be inherited by every device base, the template being one more device, with changes pulled and pushed upstream with the least resistance and drift. Measured (research base-graph-measured): 12 edges, 3 moved by a job, 6 by hand, 5 behind today (graph-drift.sh: 36 FAIL); nothing carries a change up - own is a one-way exit (docs' six own statements differ from idealkb's and no item names them; docs cannot record --supersedes through its record, missing since idealkb 0.14.0), an edited followed file stops at a person; the parts contract is declared by the template and read by docs, and bring-up steps would repeat that split. The world (research base-graph-world): every mature layered project gives a file one owner at the layer that owns its meaning, names its overrides with an upstream status that fails when missing (Yocto, DEP-3), pins each ancestor by name (Gentoo), works upstream first (the kernel) and reports drift on a schedule to each owner (linux-next); no Rust or shell tool carries root-level files down and changes up but copybara (JVM), and idealkb's follow.sh already lays slices in ~250 tested lines. So the gaps are rules and one owner, not a new mechanism: moving the device layer to docs puts each contract in one repository and removes a release train and a third owner of 14 files at about one agent-day more than the superseded route; rhizoid is worth building because the gap is real, but only behind the shell's own tests.

Rejected
: The superseded route as it was (the template a middle source with its own releases): the parts and steps contracts stay split between the template (declared) and docs (read), a third release train and owner for 14 files, and docs' catalogue ids still reach no base; about one agent-day, but it keeps the mix-up the author named. The device layer at docs' root: docs would carry phone queries over tables it does not have. Device bases following all of docs: docs' statements are the commons', not a device's. The layer into idealkb: idealkb is domain-free; what proves general moves there one file at a time, as hardware did. A chain of four (idealkb, docs, template, labs): every contract change two hops. The template only a GitHub template with no pin: the next base is born unpinned. git subtree, subrepo, submodules: a prefix, and tad reads its statements at the root. josh: one monorepo as the truth, a base cannot keep its own variant, a proxy to run, push back between separate repositories unknown. copybara: a JVM 21 and Starlark for 7 followers in 2 directions; its change request is taken, not its runtime. Android repo, copier, cruft, gbp-pq, b4: Python, refused; copier/cruft also have no way up. Nix inputs: the store, not files, and no patching in place. stgit: fine on a topic branch by hand, not needed by the graph; topgit: dormant. Labels that only warn (DEP-3: 9.4% forwarded): own without an item fails. git-rhizoid now, replacing follow.sh: the shell works and is tested; a port without conformance risks every base, and the gaps are rules, not tooling. git-rhizoid never: the author asks for it, and both directions for root-level slices and the cutting case have no tool in the house's languages.

About
: device-template

Research
: base-graph-measured

Supersedes
: 2026-11-18-device-template-follows-by-release

Scope
: docs (owner orchestration), idealkb (its owner), device-template, surya-lab, google-walleye-lab, lab-machine, tad-engine, the upstreams lane, git-rhizoid; the template builder

Tracked by
: base-graph


<a id="2026-11-18-bringup-steps-phone-stages-and-goal-steps"></a>
### 2026-11-18-bringup-steps-phone-stages-and-goal-steps

Brief
: The phone after Linux runs is 11 more stages of generic steps in docs; groups of groups are goal steps (linux-runs, daily-usable-phone, complete-phone); prior art stays in sources and research

Project
: linux-phone-oco/docs

Date
: 2026-11-18

Decision
: Amends 2026-11-18-bringup-steps-generic-in-docs-status-in-each-base; the rest of it stands.
1. The bring-up goes on past 'Linux runs' as data in the same three tables, no schema change: 11 stages after lab (coprocessors, display, audio, modem, calls, radios, sensors, camera, sleep, shell, upkeep) and a goals stage, 80 steps (4 into power, 2 into the empty lab stage) and 186 edges, recorded by ikb from research/bringup-steps/2026-11-18-phone-stages/seed-phone.sh. Generic stays generic: applies scopes a step to soc:qcom, radio:cellular, form:phone or power:battery; each device claims its status in its own base, as decided.
2. Steps nobody has done are in the graph too, with their proof named to write and 'World gap' in the guide (VoLTE, the hardware ISP, waking for calls, the SoC floor, whole-stack recovery, charging while off): they show not known yet, never absent.
3. Groups of groups are goal steps: a step that does nothing but need others, done when all its hard needs are done or not-needed (as a systemd target). linux-runs closes the generic bring-up; daily-usable-phone needs linux-runs and 19 more; complete-phone needs daily-usable-phone and every other phone step. Stages stay one level, a chapter each. A milestone names a goal on a device (milestones-name-goals).
4. The boundary: steps end where the hardware works and lasts; apps and services (Android apps, banking, sync, backup, push for apps) stay features.
5. Prior art lives where it is: sources (one per document, with what we take), research (per question) and landscape (per project); a query gives a subject's prior art (prior-art-query) and landscape gets a record (landscape-record). No new table.
6. The test: research/bringup-steps/2026-11-18-phone-stages/daily-phone.sh - the shape (no empty stage; every phone step under a goal) passes; for each device it fails until every step daily-usable-phone needs is claimed done or not-needed.
On the first decision's open questions, kept at their defaults: (a) the stage list grew from 8 to 20 rows with no schema change, which bears out stages as rows; the step size holds - one done-when, one proof, the size of a UBports feature id or a CTS case. (b) Milestones stay sets of steps; a goal makes the set one term. (c) Claims still never lapse by age; reliability is answered by steps of its own (kernel-upgrade-keeps-steps, days-without-reboot, cycles-repeat-clean) and by proven_on, not by expiry.

Why
: The author (2026-11-18): the 7 stages of 26 steps bring Linux up on any hardware; what completes a modern smartphone, and can steps be detailed, grouped and grouped again, without over-engineering? Measured (bringup-steps-coverage-map, bringup-steps-phone-stages): the first research stopped at the rootfs; surya's records hold about 50 real phone steps with proofs; UBports gates by stages over feature ticks, Sailfish names suspend and act-dead charging, the CDD and the HAL list name the areas, Weiss names reliability; nobody keeps phone steps with edges and a proof per device. The goal step needs nothing new: the edges already carry groups, and the test found a step no goal needed (suspend-wakes-quiet) on its first run.

Rejected
: Nested stages (a parent_stage column, groups of stages): a second tree the edges already carry, kept in step by hand. A layer column on stages (Linux / phone): a goal step says it without a schema change. UBports' weights and percent: a percent hides what is missing. CDD-shaped stages (about 150 handheld MUST ids, many Android's own) and one stage per HAL family (about 20, too fine for chapters): kept as cross-checks in the material. Phone steps per device in each lab: no shared graph, the next phone starts from nothing. Steps as features or components: an outcome has no order. A prior-art table or a prior-art folder in docs: a third copy of sources and research that drifts. Expiring claims for reliability: a passed step stays passed for what it was proven on; reliability is its own steps. Leaving world gaps out until someone does them: they would be forgotten, not shown unknown.

About
: bringup-steps

Research
: bringup-steps-phone-stages


<a id="2026-11-18-workarounds-read-as-one"></a>
### 2026-11-18-workarounds-read-as-one

Brief
: No scripts folder or repo: a workaround - script line or lane rule - is marked WORKAROUND(ITEM) where it stands, and one reader gives its item, state and way out

Project
: linux-phone-oco/docs

Date
: 2026-11-18

Decision
: No scripts folder, no scripts repo, no table of scripts; nothing moves. What needs a state and a way out is the workaround - a script's line or a lane's rule that stands in for a fix - and it gets one marker and one reader, the same for both.
1. The marker: `WORKAROUND(ITEM): what it stands in for`, on the line where the workaround stands - a script, the lane's AGENTS.md (where a lane rule is written once; briefs and items point at it, they do not restate it), a kernel command line, a recipe - never only in a record's note. ITEM is an upstream item (the fix goes to our fork, then upstream) or a backlog item (the fix is our own work: a kept kernel, an lpoco verb), in any base.
2. The reader: ideal-agent's scripts/workarounds (decision our-fork-ships-the-fix), extended upstream in ideal-agent: it reads ITEM in backlog as well as upstream_items, across the bases given (--base repeatable); it reads sites only (not data/, rendered docs/, research material, nor AGENTS.md's example); and it prints for each marker its site, item, state and way out: 'way out: patch to UPSTREAM' (or 'carried in FORK: due once the device runs it'), 'way out: our work, backlog ITEM in BASE', or 'due: retire' (item done, landed, applied, or not known). A rule and a script read the same line.
3. Who reads it: the patrol runs it over each lab at origin/main and files what is due as a sign to the lane; a builder or keeper that lands the fix removes the marker in the same change.
4. Every other one-off keeps the home it has and the record that already names it: research material stays frozen beside its row; a test script beside its test row; a lab script that is kept and rerun goes under the lpoco roof by decisions 2026-11-17-health-checks-shell-and-rust and 2026-11-18-phone-side-pieces-under-the-roof; scratch stays scratch, and what is worth keeping lands as research material. Device-specific scripts stay in their base: walleye's tests/host (its images' checks) and build/ (its try recipes), surya's sleep/, lab/, dt/, adsp/, ui/ and tests/health.
5. Language: shell for one-offs that run commands and read their lines, rust-script for one-off analysis with numbers, timing or states - the 2026-11-17 decision stands; no Python (surya's dt/*.py are stale, not ported).

Why
: Research oneoffs-and-workarounds-measured. The one-offs that matter already have a record and a home (66 of 97 named by a row; the reused ones called by a Makefile or another script); no lab script is shared by two devices, so a common place would hold nothing in common. The workaround is the class that rots unseen: 2 live, 0 marked where they stand, and the reader today counts records as sites and calls a backlog item 'not known' - so surya's bite rule, which the author named a workaround kept in heads and briefs, has no line anyone can find or retire. Others keep helpers alive by an owner, a caller and an exit condition (kernel scripts/, git contrib/ and its 2025 sweep, Homebrew taps, Scripts to Rule Them All), not by a folder. The marker and reader exist (ideal-agent 0.3.47); extending them costs hours, a table or repo costs a schema, a migration and a second place to keep. The author asked to weigh, not to build: 'not to take my words'.

Rejected
: Nothing changes: the bite rule stays in heads and notes, the reader stays wrong on every lab (7 FAIL in workarounds-read.sh). A scripts folder in docs, or a contrib/ in lab-tools: moves research material away from the row that names it and lab scripts away from their device, holds nothing shared (0 lab scripts in two bases), and a folder alone rots (git swept contrib/ in 2025). One scripts repo, each phone base carrying a git-rhizoid rhizcut and sending generic scripts up (the author's addition, the idealkb -> docs -> base chain of decision 2026-11-18-device-layer-from-docs): nothing generic to carry today - the generic ones have homes (install-*.sh from idealkb, phone and lab tools under lpoco in lab-tools, agent scripts in ideal-agent); rhizoid v0.1.0 has status only, follow by conformance and cuttings are later steps, and the docs -> base chain it would ride is not built (graph-drift 36 FAIL); idealkb's follow.sh (#! from = DIR/) and send-up.sh could carry files now, so reconsider when a second device needs the same lab script - and try lab-tools first. A table of scripts (purpose, state, item, way out) per base or in docs: about 230 hand-kept rows that rot like the scripts, a schema change, and the state is already in the item. A header on every script: costs every script a line, most never rerun; only workarounds need the item. rust-script by default for one-offs: 227 of 230 are command-and-read plumbing, where shell is shorter and needs no build; cargo -Zscript is not stable to build on.

About
: workarounds

Research
: oneoffs-and-workarounds-measured


<a id="2026-11-19-nura-relation"></a>
### 2026-11-19-nura-relation

Brief
: Nura is recorded as one landscape row and one upstream (nura-pmaports, human-only); we owe it a README line and AGPL directions on our apk page; agents send it nothing

Project
: linux-phone-oco/docs

Date
: 2026-11-19

Decision
: Nura (formerly postmarketOS, renamed 2026-09-27) is the distribution our phones run; the relation is kept in the records that exist, not a new page or table: landscape row nura (what we take, what we leave, how we give back), upstream nura-pmaports (how: only the author himself, by Nura's AI policy), alpine-aports narrowed to Alpine's own, and the two landscape rows that aimed to contribute our tests to Nura's CI corrected. What we owe and do: one line in each lab README naming Nura and Alpine (built-on-nura-line); the apk repository's page names each package's origin, licence and source, checked in CI (apk-pages-origin-licence). What we depend on and guard: surya's base image named by hash and kept outside a tree queued for cleanup (surya-base-image-named); the Nura names lpoco relies on in one place and the base boot entry read from the phone (lpoco-nura-names-one-place). Giving back: no agent drafts anything headed to Nura - patch, test, report, comment or wiki line, not even for the author to send; our work reaches Nura through the upstreams it packages; anything direct is the author's own act (nura-give-back-by-hand). Amends the upstream-forks rule 'mail on the author's word, Assisted-by' for Nura: there it is the author's own work or nothing.

Why
: Measured on origin/main 2026-11-19: surya runs Nura v26.06 whole and lpoco hard-codes its boot names, but nothing of Nura's is redistributed, so we owe it credit, not licence duties; sxmo-utils (AGPL-3.0-only) is what we redistribute, and our page lacks the source directions its 6(d) asks. Nura forbids contributions fully or in part created by generative AI (nura-ai-policy), naming no kinds; its CoC and wiki rules reach issues and wiki text, so the only line that keeps the author clear is that agents prepare nothing for Nura. Mobian, Ubuntu and Nura itself name their parent in one line where readers meet them, plus one structured entry; our landscape and upstreams tables are that entry. The relation already lives in 45 sources, 4 landscape rows and 20 research rows: what was missing was one row saying the whole, a correct upstream, and the two gaps (credit, source directions). The author asked to keep it small.

Rejected
: A credits page or a per-project relations page in docs: duplicates landscape and upstreams, and a face page is the owner's schema; a line in each README is what derivative distributions do. A new relations table: the landscape record already holds what a project is for us. Nothing at all: leaves the upstream row pointing pmaports at Alpine, the AGPL directions missing, and two landscape rows aiming at a contribution the policy forbids. Mirroring or vendoring Nura (images, packages): costs storage and upkeep for a risk one named and kept image covers; v26.06 is already the pin. Agents preparing reports or test results for the author to file under his name: 'in part created by generative AI' covers a draft he only edits, and the CoC names using the tools; it would put his standing in Nura at risk. Joining Nura's hardware CI with our tests: the tests are AI-made, so not contributable; a farm slot is the author's own choice. Renaming every postmarketOS mention in our code and records now: source titles quote real documents, and Nura has not renamed boot-deploy's names or packages yet.

About
: nura-relation

Research
: nura-relation-how-it-stands


<a id="2026-11-19-licences-for-our-repositories"></a>
### 2026-11-19-licences-for-our-repositories

Brief
: Our code is MIT OR Apache-2.0, our device trees GPL-2.0-only OR BSD-2-Clause, our docs and data CC-BY-SA-4.0; third-party code keeps its own

Project
: linux-phone-oco/docs

Date
: 2026-11-19

Decision
: Code (lab-tools, ideal-agent, git-rhizoid, idealkb, tad tooling, and the scripts in every base): MIT OR Apache-2.0, both texts shipped as LICENSE-MIT and LICENSE-APACHE. Device trees and dts patches we write: GPL-2.0-only OR BSD-2-Clause, with SPDX headers (the kernel's own dual licence for dts). Documentation and knowledge-base data (docs, each device base's data, device-template, the software-engineering canon, the ideal-project playbook): CC-BY-SA-4.0. Every repository adds its LICENSE files, SPDX-License-Identifier headers where files carry code, a README line naming the licences, and a check in CI that keeps new files covered (REUSE-style: an SPDX header or a REUSE.toml annotation per path; REUSE lint itself is Python, so a small shell check where it does not fit). Third-party code we carry keeps its own licence: the sxmo-utils fork (AGPL-3.0-only), the kernel fork (GPL-2.0), vendored firmware or blobs as their licences say. One change per repository, by its owner.

Why
: The author's word, verbatim (through the Top Coordinator, 2026-11-19): 'Yes, as suggested' - to the suggestion above. Found by research nura-relation: no repository of ours had a LICENSE file; lab-tools' crates declared MIT OR Apache-2.0 without its text. MIT OR Apache-2.0 is the Rust ecosystem's norm; GPL-2.0-only OR BSD-2-Clause is what upstream dts files carry, so ours can go upstream as they are; CC-BY-SA-4.0 keeps shared knowledge shareable alike.

Rejected
: One licence for everything (a dts must match the kernel's terms; prose under a code licence reads poorly); GPL for our tools (the author's family is MIT OR Apache-2.0, and lpoco-ffs-acm was relicensed to match); leaving it implicit (no licence means all rights reserved, which no one can build on).

About
: bringup-steps


<a id="2026-11-19-base-distro"></a>
### 2026-11-19-base-distro

Brief
: Recommended for the author's word: stay on Nura, carry a thin device layer in our own apk repo via the conveyor; walleye starts on it; Mobian the fallback, on named triggers

Project
: linux-phone-oco/docs

Date
: 2026-11-19

Decision
: A recommendation for the author's word - moving surya's OS is his call. Stay on Nura and carry a thin device layer in our own apk repository, built, signed and published by the package conveyor. surya stays on Nura v26.06 as it runs; nothing is reinstalled. The layer is what we already carry - lab tools, sxmo-utils@lab, test kernels from grenudi/linux - plus our own kernel and device packages wherever Nura carries none, walleye's first. walleye starts on the same base: an Alpine 3.24 / Nura v26.06 userland with walleye's kernel and device packages from its lab's own repository through the conveyor, and no fork of pmaports (walleye-rootfs-on-our-layer). Each device's facts the layer packages (kernel tag and config, boot image addresses, firmware list) are kept in its lab's base as data, not only inside an APKBUILD, so a later move costs packaging, not knowledge. Mobian is the named fallback: its SM7150 family is measured off the phone first (mobian-sm7150-offphone), and a move is reconsidered when a trigger fires (base-distro-triggers): Alpine adopts an AI ban (council #697), Nura archives or drops qcom-sm7150, or Mobian ships an SM7150 image on a maintained kernel. Giving back with this pick: device work goes to the kernel (sm7150-mainline, the lists) under the author's sign-off, open on any base; Alpine aports while #697 stays open; Nura only by the author's own hand (2026-11-19-nura-relation); sxmo stays closed by SourceHut's terms whatever the base (giving-back-by-distro).

Why
: We already do not maintain an OS: for surya, Nura carries the device package, the kernel package (sm7150-mainline's tags, 7.1_rc3), the Qualcomm daemons and the UI, kept by the SoC's own mainline people; we carry a thin layer (base-distro-candidates, nura-relation-how-it-stands). Every other base would make the layer thicker, not thinner: no Arch-based, Fedora, openSUSE or NixOS distribution carries any SM7150 or MSM8998 device - on them we would carry the kernel, device, firmware, boot config, the Qualcomm daemons (AUR-only on ALARM, measured) and sxmo, which is our own phone OS. Mobian is the one real alternative for surya, but measured on 2026-11-19 its SM7150 kernel (6.18.51) and support package sit in staging only, no image is published, and the branch has been idle since 2026-09-13 - a move today trades a maintained 7.x port for an unpublished 6.18 one. What a move buys is giving back to the distribution's own packaging; our device work goes to the kernel, open on any base, and sxmo is closed by SourceHut on any base, so the gain is small today and grows only if Alpine closes too - hence that trigger. One base for both phones keeps one packaging lane (the conveyor has pacman and apk, no deb) and one set of lab tools; walleye's nearest prior art (porthole-dev's taimen pmaports work, Nura's archived msm8998 packages) is in the same shape. The author's word on the Halium route, verbatim: "no ubuntu touch its premise is stupid and in vane from the day one, they made 0 upstream contributions beside halium, and they are the one ones who use halium this day".

Rejected
: Ubuntu Touch, on the author's word (verbatim): "no ubuntu touch its premise is stupid and in vane from the day one, they made 0 upstream contributions beside halium, and they are the one ones who use halium this day". Droidian with it: the same Halium route (Android vendor kernels, surya 4.14.221), against mainline-first. Moving surya to Mobian now: reinstall with no upgrade path and the author's hands to flash; an image built from mobian-recipes' staging recipe that nobody has published or measured; the kernel back from 7.1 to 6.18 and our grenudi/linux topics rebased onto it; a deb lane the conveyor does not have; lpoco's boot names (pmos.conf, boot-deploy's title) rewritten for Mobian's boot; sxmo 1.18 packaged as a deb by us (Debian has 1.12); every surya proof measured again - roughly 25-40 agent-hours plus a witnessed flash and risk to the reference device, for a base whose SM7150 branch is idle. Kept as the fallback instead. Arch Linux ARM with our own pacman repository: healthy and generic, and the conveyor already has pacman, but its kernel drives neither SoC and the Qualcomm daemons and sxmo are AUR-only, so we would maintain the phone OS on top - the burden asked to avoid. DanctNix: Pine64 only, one maintainer, forbids LLM-written work. Manjaro ARM: without an ARM maintainer. Fedora / Pocketblue: a dormant sm7150 COPR, no device, two people; we would carry everything. openSUSE Mobile: one volunteer, neither SoC. Mobile NixOS: one maintainer, neither device (walleye dropped in 2023), forbids LLM-written work, sxmo not in nixpkgs. A fork of pmaports for walleye: a second OS tree to rebase; our own packages on Nura's binary repository need none. walleye on a different base than surya: two lanes and two sets of tools for one lab.

About
: base-distro

Research
: base-distro-candidates

Tracked by
: base-distro


<a id="2026-11-19-hardware-test-layer"></a>
### 2026-11-19-hardware-test-layer

Brief
: Recommended for the author's word: hardware tests run in a no-shell layer (the same Nura image at multi-user.target); the shell is a later layer; the sxmo fork, series and lab apk retire

Project
: linux-phone-oco/docs

Date
: 2026-11-19

Decision
: A recommendation for the author's word - what surya runs is his call, and the change is the surya keeper's. (1) Hardware tests run in a hardware-test layer with no phone shell: a tty with getty and ssh, the system services, lpoco-health and lpoco-awake, and nothing that suspends, locks or reacts to keys unless a test asks. On surya it is the image it runs now (Nura v26.06), booted from a second boot entry with systemd.unit=multi-user.target: no display manager, so no sxmo session; the sxmo entry stays beside it. Once proven, the test layer is the lab's default boot and the shell entry is chosen for shell tests. (2) The user-experience layer - sxmo, Phosh or Plasma Mobile - is a separate, later concern, tested on its own once the hardware steps pass: the bring-up steps' shell stage carries it, including each shell's own idle-suspend hold-off and its real suspend. (3) The sxmo fork (grenudi/sxmo-utils lab branch, tag lab-20261118.1, three topics), its three upstream items and the sxmo-utils@lab apk are retired: surya goes back to Nura's own sxmo-utils, lab-tools drops the packaging, the fork is archived with its history. The device profile stays upstream (1fd7822). (4) lpoco-awake stays as the lab's policy (a lab phone on USB stays awake unless a test asks), no longer a workaround for sxmo. (5) New devices' first root filesystem is the test layer: no UI package (walleye-rootfs-on-our-layer, decision 2026-11-19-base-distro). Amends 2026-11-18-upstream-forks for sxmo-utils only, and the thin layer of 2026-11-19-base-distro (it no longer carries sxmo-utils@lab).

Why
: Measured (test-layer-sxmo-cost-measured): ~70 PRs, ~13 h surya unreachable, three of the author's hands and ~17 lane-hours over a day and a night went to sxmo's suspend policy and our ways of living with it; most of the spend was our response (fork, series, apk, package swap, migration), which a layer without a shell makes unneeded. The suspend steps that matter for hardware (s2idle-cycle-returns, radios-survive-suspend, suspend-way-back) are already proven by lpoco-health's own cycle, shell-free. The same image at multi-user.target is the cheapest honest split (test-layer-landscape): no reflash, a command-line change with the lab's boot-count fallback, the shell kept for its own stage. The series has no agent path upstream: SourceHut's terms bar LLM-written content since 2026-09-10 (giving-back-by-distro). The author proposed the split on 2026-11-10 (surya-lab shell-free-base) and again on 2026-11-19: 'for hardware support tests we dont use any shells at all and use our own simple tty setup'.

Rejected
: A fresh Nura ui=console image built by pmbootstrap and flashed: the cleanest baseline, but 4-8 h, a witnessed flash and the provisioned state redone, for a split the boot entry gives at once; kept for new devices and as a later step if the entry shows leaks. Swapping the UI in place (apk del sxmo, add ui-console): loses the UX layer, no official doc, autologin and tinydm leftovers. Two root filesystems chosen by pmos.root_uuid: needs space, boot-deploy may rewrite hand entries, undocumented on phones. Keeping sxmo and taming it (lpoco-awake, gates, the fork's series): the status quo that cost the 70 PRs, a tax on every suspend test, and a series with no way upstream. initramfs-only tests (walleye's bare init, Nura CI's hook): right for boot, console and kernel stages, not for coprocessors, audio and modem on surya, which need the rootfs daemons. Phosh or Plasma Mobile as the lab's shell instead of sxmo: each brings its own idle suspend (gsd, PowerDevil) - the same problem in another form.

About
: test-layer

Research
: test-layer-sxmo-cost-measured


<a id="2026-11-19-base-distro-any-arm-base"></a>
### 2026-11-19-base-distro-any-arm-base

Brief
: Amends base-distro: any general aarch64 base will do - we keep a base-neutral device layer and no OS burden; surya stays on Nura because it carries surya's layer; walleye's base is a close call

Project
: linux-phone-oco/docs

Date
: 2026-11-19

Decision
: Amends 2026-11-19-base-distro, still a recommendation for the author's word. The base is any general aarch64 systemd distribution; a mobile distribution is not needed for what it is, only for what it carries. What we keep for each phone is a device layer (kernel and dtb, boot glue, firmware, UCM and config, the few Qualcomm daemons and phone scripts a base lacks, initramfs and image config), written base-neutral (device-facts-as-data), and we never take OS burden: no fork of a base's package tree, no patched general package to rebase, no base past its end of life. The base for a device is chosen by how much of its device layer the base carries, then by one conveyor lane for the lab, then by giving back. surya stays on Nura: Nura carries its whole layer (~13 packages, kept by the SoC's own mainline people), against ~8 small packages of ours on Debian, ~9 on Fedora, ~13 on Arch Linux ARM, plus a reinstall. walleye stays on the same base by default (Nura saves it the Qualcomm daemons, the phone scripts and the boot.img rewrite, and keeps one apk lane), but its layer is ours on every base, so its base is a close call the author may set otherwise - Debian, if he wants walleye's device layer to be something a distribution can take from us. The fallback is no longer Mobian alone but any general base: Debian first (packages most of the Qualcomm userspace, allows the author's AI-assisted work), Fedora second, Arch Linux ARM third (the pacman lane exists, the Qualcomm daemons would be ours).

Why
: The author, verbatim: "we have looked at mobile distributions but why do we even have to make such difference ? i mean cant we just use any upstream linux distro that supports arm , what holds us ? do we need to keep phone os, at least its base distribution form with some special care ? i mean, for de/shell we can craft/use whatever we like that doesnt really what makes a burdain of maintaining our own linux distribution os(btw what are the burdains, would be nice to list them exactly) ?" He is right, and the first decision counted device-layer items (a kernel that drives neither SoC, AUR-only Qualcomm daemons) as OS burden. Measured (research base-distro-device-layer): nothing a phone needs is OS burden; the kernel, boot glue, firmware, UCM, config, phone scripts, initramfs and image config are device layer on every base, ModemManager, feedbackd, callaudiod and iio-sensor-proxy are in every general base, and qrtr, rmtfs, tqftpserv, qbootctl in Debian, Fedora and Alpine. The OS burdens - toolchain, thousands of packages and their security fixes, releases and upgrades, archive infrastructure and signing, installer images, archive QA - we carry on no base. So the choice is a matter of whose hands the device layer is in: for surya, Nura's; for walleye, ours anywhere. With sxmo dropped for a bare tty test layer (decision 2026-11-19-hardware-test-layer), the hardware layer needs only what every general base packages, which removes the last tie to Alpine but does not make a move pay for surya.

Rejected
: Keeping the first framing (mobile distributions only, Arch Linux ARM and others as "carrying the OS"): it counted device layer as OS burden. Moving surya to a general base now: the same layer we get from Nura would become ~8-13 packages of ours plus a reinstall and a witnessed flash, with sxmo dropped roughly 20-30 agent-hours, for nothing Nura does not already give. Choosing walleye's base by mobile-ness: no base carries walleye, so it is chosen by cost and giving back.

About
: base-distro

Research
: base-distro-device-layer

Amends
: 2026-11-19-base-distro

Tracked by
: base-distro


<a id="2026-11-19-device-layer-declared-once"></a>
### 2026-11-19-device-layer-declared-once

Brief
: Recommended for the author's word: each phone's device layer declared once in device.toml [layer], packed per format by lpoco layer pack (nfpm), apk then deb; upstream first; base stays postponed

Project
: linux-phone-oco/docs

Date
: 2026-11-19

Decision
: A recommendation for the author's word. Each phone's device layer is described once and packed for every base; the base stays postponed, as he asked.
1. Declared once: device.toml gains [layer], typed in lpoco-manifest with its schema (decision 2026-11-18-device-manifest-schema-from-rust): the files with their kind (data, config, unit, script) and where they go under /usr, dependency tokens, the kernel (tree, tag, config fragment, dtbs), the boot method (efi-kernel-install, android-bootimg with [boot]'s addresses), the firmware method (extract-from-partitions or files), the early modules. What is device layer moves there from [[flash.overlay]]; lab-only overlays stay.
2. Packed per format by one command: lpoco layer pack --format apk|deb|rpm|archlinux writes an nfpm config and packs; the conveyor signs and publishes each format in its own lane. Generated per device, every format: file lists, dependency names through a token map in lpoco, systemd presets instead of enable scriptlets, an initramfs drop-in for each of mkinitfs, initramfs-tools, dracut and mkinitcpio from one module list, Nura's deviceinfo, /usr/lib/kernel/devicetree. Hand-kept once per base, never per device: the kernel package's scriptlet, the boot trigger where a base has none (walleye's boot.img: a kernel-install plugin, a libalpm hook on Arch; on Debian qcom-phone-utils already does it, on Nura boot-deploy), the token map's column, the conveyor lane. lpoco layer export writes Asahi's contract too - the tree and a Makefile of install targets - for a distribution that packages us natively.
3. Formats in order: apk (the lane runs; surya stays on Nura, which carries its layer), deb second (the author's leaning, and Debian allows his AI-assisted work), then rpm and archlinux when asked. The base for a device becomes which repository it installs from, chosen when its deb installs and boots - not before.
4. Upstream first, per piece: kernel drivers and dts to Linux (surya through sm7150-mainline), each base's kernel config to its kernel team, redistributable firmware to linux-firmware, OEM-signed firmware never packaged but extracted from the phone (droid-juicer, msm-firmware-loader), UCM to alsa-ucm-conf, hwdb to systemd, haptics themes to feedbackd-device-themes, walleye's boot glue to qcom-phone-utils; what an upstream takes leaves our layer. Each sent under the author's sign-off where its policy allows (giving-back-by-distro); Nura only by his own hand.
5. Bring-up: one generic step, device-layer-packaged, its helper lpoco layer pack with the format an argument - not a step or helper per format; update-applies and kernel-upgrade-keeps-steps prove it per base.

Why
: The author, verbatim: "for distro i think debian, but i would like to postpone it a bit and consider how we could work and contribute distro agnostic or something". Research device-layer-agnostic-prior-art: Asahi, the strongest prior art, keeps five distributions by one upstream source with install targets and a thin recipe per distribution, and its cost is in the hand-kept recipes (asahi-alarm's fork, Debian's unmerged patch) and the kernel fork, not in the packaging tool; its cure is upstream-first. Our layer is small and mostly files (base-distro-device-layer: surya ~8 packages on Debian; walleye's wholly ours), the facts are already typed in Rust (lpoco-manifest), and nfpm packs prebuilt files into all four formats from one config - so generating per format costs one packer, once, and a new device or format costs no recipe. surya's EFI boot glue is one data file under kernel-install (/usr/lib/kernel/devicetree), walleye's boot.img glue already exists in Debian (zz-qcom-bootimg). Postponing the base is cheap this way: the deb is built beside the apk, measured by the same test, and the move becomes a choice of repository. Cost (estimates): types 3-4 agent-hours, packer 8-12, apk via nfpm 2-3, deb lane 6-10, rpm lane 6-10, archlinux 3-5, walleye's boot trigger 4-6; a new device's [layer] 2-4. The first step settles the largest unknown cheaply: the failing test (test-layer-apk-and-deb.sh) packs surya's layer as apk and deb and shows whether nfpm's apk installs under Alpine 3.24's apk-tools.

Rejected
: Asahi's own pattern as it is - a Makefile and a hand-kept recipe per device per format (8 for two phones and four formats): its drift is what asahi-alarm's fork and Debian's unmerged patch show; its Makefile contract is kept, generated, as lpoco layer export. Native recipes generated per base and built in each base's container (systemd under mkosi, OBS): four templates and four toolchains for a quality that matters only once a distribution takes the recipe, when its packager writes it from export; kept for that day. Image-only (mkosi trees, today's flash overlays): no upgrades through the package manager and nothing a distribution can take; Nura is edge-only in mkosi. Packaging into each distribution's tree as the way to stay agnostic (Mobian's qcom-support, pmaports): that is giving back, done piece by piece where policy allows, not a description we keep. fpm (Ruby, a runtime we avoid) and melange (apk only) instead of nfpm. Choosing Debian now: the author asked to postpone; with both formats built the choice costs a repository switch later, not a repackaging. A bring-up step or helper per format: the format is an argument, the steps stay generic.

About
: agnostic-layer

Research
: device-layer-agnostic-prior-art

Scope
: lab-tools, the device bases (surya-lab, google-walleye-lab, device-template), the conveyor's use by them

Tracked by
: agnostic-layer


<a id="2026-11-19-procedures-chain-small-device-agnostic-steps"></a>
### 2026-11-19-procedures-chain-small-device-agnostic-steps

Brief
: A procedure, attended or not, is a chain of small device-agnostic library steps keyed to bring-up step ids; a lane's file only chains them with its device's values

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-19

Decision
: (1) A step is a small library function in lab-tools, keyed to a bring-up step id where one exists (boot_once, read_dmesg, check_probe(driver), wait_for_usb, ask_author, back_to_known_good); it takes its device values from device.toml or its [layer] table, never hard-coded. (2) A lane's procedure file only chains those steps with its own values; a step written in a lane is a candidate to move into the library as soon as a second device needs it. (3) One step type serves the attended runner (lpoco-attended) and the unattended bringup-step-runner, so an attended procedure and a nightly health run are the same chain. Carried by backlog lpoco-attended and bringup-step-runner.

Why
: The author, 2026-11-19, relayed verbatim by the Top Coordinator: "is test procedures are small so that they can be later on chained together and extracted into general tools that will work for any device ? do we have that reflected somewhere in our structures ?" It was only partly there: the bring-up steps with proofs from device-template, practice 20 (an action past three asks for a tool), and lpoco-attended's note to share a step type.

Rejected
: Each lane's procedure as its own program with device values inline: it cannot be chained or reused on another phone. Two step types, one attended and one unattended: the same check written twice, and a nightly run that proves something different from what the author attended.

About
: bringup-steps


<a id="2026-11-19-attended-in-bringup-library"></a>
### 2026-11-19-attended-in-bringup-library

Brief
: lpoco-attended is a module of lpoco-bringup: a lane's entry file is a rust-script list of step/check/ask_author calls over actions sh, phone, phone_root

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-19

Decision
: The runner lives in lpoco_bringup::attended (bringup/src/attended), beside the library lanes already depend on from rust-script by git tag. An entry file calls procedure(name).run(|p| { p.step(name, action)?; ... }); the library reads --dry-run, --log, --help and LPOCO_ATTENDED_DEVLAB with argenv, stops at the first failing step and names it, writes one log line per step, reaches the phone through devlab phone sh|root with the script on stdin. ask_author(to_do, to_check) waits for the line ok; any other answer stops the run and is logged.

Why
: The author: the program must read cleanly and simply at the entry file level like a simple scripted procedure; lanes already use rust-script with lpoco-bringup (examples/step.rs), so one more module costs them no new dependency and the release family no new package.

Rejected
: A new crate lpoco-attended: nine release-plz entries and changelog_include lists to keep in step, for no gain to a lane. A closure per step: the dry run could not say what a step would do, so actions are values (sh, phone, phone_root). just or bats as the runner: another tool, shell plumbing, no Rust library. xshell and dialoguer as dependencies: the run needs only std::process and one line from stdin.

About
: lpoco-attended

Research
: 2026-11-19-attended-procedure-prior-art


<a id="2026-11-19-attended-crate-free-functions"></a>
### 2026-11-19-attended-crate-free-functions

Brief
: lpoco-attended is its own crate: free functions over one Step type, a Run guard, devlab for the phone; replaces the module in lpoco-bringup

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-19

Decision
: Crate attended (lpoco-attended, tag lpoco-attended-vX.Y.Z, in the lpoco release family) as the orchestration role asked: use lpoco_attended::prelude::*; let _run = procedure(name, device); step/check(what, || closure); ask_author("do / check"); phone().sh|root; retry. A closure returns (), bool or Result; a failure ends the process with exit 1 naming the step. One Step type (kind, name, bring-up step id, closure; execute()) for this runner and the later unattended one; library steps are fns returning a Step (steps::ask first). Dry run runs no closure and phone() refuses to reach a phone. A panic is logged PANIC, never reported as a pass.

Why
: Orchestration (2026-11-19, relaying the author): the entry file reads like a simple script, the shape its lanes were told; decision 2026-11-19-procedures-chain-small-device-agnostic-steps asks for one step type for both runners. Supersedes 2026-11-19-attended-in-bringup-library, whose module is removed from lpoco-bringup (released one version, no user).

Rejected
: Keeping the module in bringup: the lanes were told a crate with this name and tag. Closures returning Result with ? (the first slice): the free-function form reads shorter. Step<'a> instead of 'static closures: not needed until an entry file wants shared locals; a lane can move or clone.

About
: lpoco-attended


<a id="2026-11-19-running-is-not-moving"></a>
### 2026-11-19-running-is-not-moving

Brief
: A lane session that shows running with no activity for over 30 min counts as stalled: the lanes waker nudges its coordinator naming it, and patrol reports it

Project
: linux-phone-oco/docs

Date
: 2026-11-19

Decision
: The lanes waker no longer skips a lane because one of its sessions is running: a session with no event for more than 30 min counts as stalled, and the waker nudges that lane's coordinator naming the session. Patrol measures the same (patrol.md item 4): sessions running but not moving, with what they wait on.

Why
: The sign, 2026-11-19: the surya builder (local_78068da9) sat about an hour at a rejected permission prompt asking how to proceed, while the lanes waker skipped surya every round because the session isRunning. Running is not moving. The Top Coordinator changed the waker's prompt and asked for this record.

Rejected
: Trusting isRunning: a session waiting at a prompt or a question is running and stuck alike. Killing a quiet session: it may be in a long build; a nudge to its coordinator, who reads its events, is the safe step.

About
: agent-folder


<a id="2026-11-19-procedures-one-shape"></a>
### 2026-11-19-procedures-one-shape

Brief
: Every device repo keeps procedures/NAME.rs (one rust-script entry each) over lpoco-attended and at most one procedures/steps crate; lpoco attended new/run/check scaffolds and runs them

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-19

Decision
: (1) Procedures live in a device repo as procedures/NAME.rs: one rust-script file each, the cargo block pinned to an lpoco-attended tag, the body a plain chain of steps that reads in one screen. (2) Steps only that device has go in one crate per repo, procedures/steps (DEVICE-steps), or none; a step a second device needs moves to lpoco-attended's library (decision 2026-11-19-procedures-chain-small-device-agnostic-steps). Device values come from device.toml, never from the procedure. (3) lpoco attended new NAME writes procedures/NAME.rs from the template (current tag, the steps crate when there is one); lpoco attended run NAME [--dry-run] [--log FILE] runs it; lpoco attended check dry-runs every procedure against the stand-in phone - the repo's CI calls it, so no lane writes a Cargo.toml, a lock or a dry-run test for a procedure. (4) surya-lab #394 (lab/attended) and google-walleye-lab #448 (tests/attended + tools/walleye-tries) move onto it.

Why
: The author, 2026-11-19: do we have that scafolding as a shared base for procedures so that future procedures doesnt have to reinvent scafolding and duplicate the code base ? Two lanes had already drifted into two shapes in a day (research procedures-one-shape); three more walleye programs and every new device follow. The look-around: just, pytest, Ansible and LAVA all keep many small units in one folder over shared helpers, run by name.

Rejected
: One crate per procedure (surya #394): a Cargo.toml, lock and dry-run test each time - the duplication asked about. cargo xtask: procedures become match arms in one binary, not files that read like scripts. just recipes or shell: the author wants Rust, no new shell logic. LAVA YAML definitions: data, not the Rust entry the author shaped. A crate for each lane's steps plus the library: two homes for the same step.

About
: bringup-steps

Research
: procedures-one-shape


<a id="2026-11-19-chip-knowledge-upstream-first-docs-indexes-by-part"></a>
### 2026-11-19-chip-knowledge-upstream-first-docs-indexes-by-part

Brief
: Chip knowledge goes upstream first, one series per chip (binding, driver, dts); docs keeps one thin product-agnostic row per part number that links up, never copies

Project
: linux-phone-oco/docs

Date
: 2026-11-19

Decision
: (1) Upstream first, each fact in the home its readers already search. A chip's driver and binding go into mainline as one series per chip: the dt-bindings patch, then the driver, then each board's dts as its own patch (through the SoC tree). Each is kept on a topic branch in our kernel fork (fork-linux) and sent in the author's name with his sign-off. Others' work is taken with its authorship kept and our changes on top. Where a series is already on the list (TAS2557, Boiano v3), we test it and reply rather than send a second driver. Other homes take the rest. A Qualcomm SoC or PMIC block's status goes to linux-msm/mainline-status by pull request. A panel goes through the panel generator and linux-panel-drivers, then to dri-devel. A firmware goes to linux-firmware only with its maker's licence; otherwise it stays on the product and only its provenance is recorded. Zephyr and U-Boot get a driver only when an MCU or bootloader user needs the part. The postmarketOS (Nura) wiki is the author's own act; agents prepare nothing for it (decision 2026-11-19-nura-relation). (2) docs keeps one thin row per part number in the chips table (ikb chip, tad q chips). The row is about the part, never a product: a phone, a board or a car carrying the same part shares one row, and products appear only as the boards met carrying it. The row holds only what none of those homes holds: compatible; how to identify the part on any board; the furthest stage its driver reached (mainline, in-review, fork, downstream, none); a link to each home; firmware provenance; quirks with their evidence; boards; the bring-up steps its procedure chains; its proofs; its tools. It never copies a binding, a register table or a driver. A chip is a subject: its research, decisions, backlog and upstream items name it in about, so tad q about --subject ID is its one page. (3) A chip's procedure is a chain of small device-agnostic library steps (docs #638, decision 2026-11-19-procedures-chain-small-device-agnostic-steps; ideal-agent #109, decision 2026-11-19-small-steps-compose). Each step takes the chip's values from its row and the board's values from device.toml. The first step is a generic presence check (lpoco-chip-check), and a check for a series' shape follows (lpoco-chip-series-check). (4) A lab that brings a chip up writes or renews the chip's row in docs in the same round as its own records; its board's values and claims stay in its own base. This is where walleye's per-chip record (decision 2026-11-19-walleye-audio-port-shape) lives.

Why
: The author, relayed verbatim by the Top Coordinator on 2026-11-19: "do we have these parts atomized and intelligable so that it can go upstream as a procedure or something to be useful for any other phone ?"; then "is there already shared base for such knowledge in the open where we can contribute upstream ?"; then "im not talking about linux phones specifically, as this is hardware level it doesnt matter for what it is for". Research chip-layer-open-homes answers this. Mainline, keyed by compatible, is the only product-agnostic shared home. The other homes key by SoC, board or device, and none holds a chip's standing across homes, chips without a driver, boards across products, firmware provenance, quirks or procedure. Until now that knowledge sat in one device's lab, where another board could not find it. walleye did not know TAS2557 is in review upstream, and porthole's two drivers came without bindings.

Rejected
: A chip wiki of our own with pages copying datasheets, registers and drivers: it drifts from upstream, nobody outside reads it, and it duplicates mainline. Keeping chip knowledge in each device's lab, as until now: another board cannot find it, and walleye missed the TAS2557 series on the list. The postmarketOS (Nura) wiki as the chip home: it is keyed by device and SoC, phones only, and closed to agent-made work. LKDDb as the layer: it is generated with no way to add to it, and it knows only chips that already have a driver. linux-hardware.org: it is keyed by PCI and USB id and does not cover DT parts. A new cross-project chip wiki started by us: it has no community, and its cost far exceeds a thin row that links up. A boards join table now: the boards text column is enough until a second lab claims chips (chip-boards-claimed-by-bases). Sending porthole's drivers as they stand: they have no binding, and the TAS2557 duplicates a series already in review.

About
: chip-layer

Research
: chip-layer-open-homes

Tracked by
: chip-layer


<a id="2026-11-19-procedure-values-from-the-named-device"></a>
### 2026-11-19-procedure-values-from-the-named-device

Brief
: A procedure names its device; lpoco-attended loads that device.toml, steps read named keys from it, a missing key fails the dry run, devlab gets the device explicitly

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-19

Decision
: Amends 2026-11-19-procedures-chain-small-device-agnostic-steps (docs #638) and 2026-11-19-procedures-one-shape (docs #646), which said values come from device.toml without saying how. (1) procedure(name, device) finds that device's device.toml (the device repo's, the one devlab --device takes) and loads it with lpoco-manifest; its existing tables are the values: [device], [boot], [health], [layer], the USB ids, kernel entries, the kept kernel and the way back, timeouts. A new key is added only where no table holds the fact, under the table it belongs to (device-layer-declared-once). (2) Library steps take a key, not a value - wait_for_usb() reads its own default key, or wait_for_usb(dev("usb.gadget")) names one - so a procedure file names no number, path or kernel name. (3) --dry-run and lpoco attended check resolve every key a procedure uses against that device.toml and fail, naming the key, before anything touches a phone. (4) phone() calls devlab with --device PATH of the procedure's device, never the device.toml found by the current folder. (5) surya-lab's consts (PMICWDT_KERNEL, WAY_BACK, STANDBY and the rest) and walleye's WALLEYE_TRY_* settings move into their device.toml.

Why
: The author, 2026-11-19: how per device values that are needed for those procedures are stored, where, and how they are supplied to run a procedure ? The Top Coordinator read lab-tools main: the device name is only a log label, steps take plain values, so lanes hard-code them; devlab picks the device.toml by the current folder. Look-around (research attended-device-values): LAVA device dictionaries, Ansible host_vars, labgrid environments - values in the target's file, target named, missing key fails early.

Rejected
: Values as arguments in the procedure: each lane writes them again and a second phone cannot reuse the file. An [attended] table of copies: the same fact in two places of device.toml. Environment variables (walleye's WALLEYE_TRY_*): invisible in the repo and unchecked before a run. devlab guessing the phone from the current folder or USB: with both phones attached, the wrong one.

About
: bringup-steps

Research
: attended-device-values


<a id="2026-11-19-procedures-reflect-and-lift"></a>
### 2026-11-19-procedures-reflect-and-lift

Brief
: Procedures start as a lane's makeshift and are lifted by a loop: lpoco attended lift lists device steps beside the library and flags near-duplicates; patrol files lift items; useful ones go upstream

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-19

Decision
: Follows 2026-11-19-procedures-chain-small-device-agnostic-steps (#638), -procedures-one-shape (#646), -procedure-values-from-the-named-device (#651) and ideal-agent #109. (1) The easy start comes first: attended-device-values, then attended-scaffold (lpoco attended new|run|check); a lane writes a makeshift step in its procedures/steps freely. (2) The reflect loop: lpoco attended lift reads every device repo's procedures/steps (the repos device-template knows) and the library, lists each step with its places, and flags near-duplicates by their bodies, not their names; two copies the same lift at once, copies that differ lift at three (the rule of three), or at two when a lane asks. (3) The round: patrol runs lpoco attended lift each round and files 'lift STEP into lpoco-attended' on the lab-tools backlog, naming the copies; the lab-tools builder lifts it keyed to a bring-up step with its values as keys, and the lanes' copies are replaced by the library step in their next change. (4) Beyond the project: a procedure or check useful to others goes upstream where others' labs run it - a probe or boot check as a Linaro test-definition or KernelCI test, a chip's bring-up as the chip's series and its row (decision 2026-11-19-chip-knowledge-upstream-first-docs-indexes-by-part); lpoco attended export (later) writes a procedure's checks as a LAVA test definition. Nothing is mailed or opened upstream without the author's word.

Why
: The author's question, 2026-11-19 (research procedures-reflect-and-lift). The rules were in place but the lift relied on someone noticing; two lanes already wrote boot_once, wait_for_usb, back_to_known_good and read_dmesg inline before the library had them.

Rejected
: Lifting by memory or by a brief's line: it held for nobody in a day. Lifting every step at its first copy: a one-device makeshift becomes library weight. Matching by name: lanes name the same step differently (wait_for_phone vs shell_answers). Our own upstream format for procedures: Linaro test-definitions and KernelCI already run board-agnostic tests in others' labs.

About
: bringup-steps

Research
: procedures-reflect-and-lift


<a id="2026-11-19-attended-steps-name-the-physical-act"></a>
### 2026-11-19-attended-steps-name-the-physical-act

Brief
: Attended steps name the physical act or observation (press_power, unplug_usb, touch, look_for, listen_for); a bench backend does it - a person today, a rig the lab declares later

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-19

Decision
: (1) lpoco-attended's ask_author is replaced by physical steps that say what is done or seen: press_power(secs), hold_button(name, secs) for volume and others, unplug_usb, replug_usb, touch(x, y), swipe(from, to), look_for(what the screen shows), listen_for(what is heard), and confirm(what to check) for the rest. ask_author stays one release as an alias of confirm, then goes. (2) A Bench trait is the seam: each physical step asks the bench; the person backend (today's default) prints the act and what to check and waits for the answer, recorded in the log. A rig backend (USB relay, servo, camera, microphone) is a later implementation of the same trait; nothing is built for it now. (3) What a bench has is data: the lab's lab.toml declares per device which acts a rig does and on which channel (relay port, servo, camera); device.toml declares the device's own facts the acts need (button names, screen size). An act no declared hardware covers falls back to the person backend; --dry-run lists who would do each act. (4) The decision about whether a step needs attending moves from the procedure to the bench: the same procedure runs attended today and unattended on a rig.

Why
: The author, 2026-11-19, relayed verbatim: "can we replace \"asking you\" with physical attendence needed or something ? in future we will automate this by having servos that will press buttons and usb relay switches , camera, microphone in one stand, so this needs you would make no sense and could be further detailed per option if one has hardware. again for consideration". Research attended-physical-steps: labgrid drivers over declared resources with a manual driver, pdudaemon, openQA needles, Tapster.

Rejected
: Keeping ask_author with free text: a rig cannot act on prose, and every procedure would need rewriting when the stand comes. Building rig backends now: no hardware yet. Declaring the rig in device.toml: the relay channel is the lab's wiring, not the phone's - a second lab would carry other wiring for the same device.

About
: bringup-steps

Research
: attended-physical-steps


<a id="2026-11-19-attended-keys-in-the-manifest"></a>
### 2026-11-19-attended-keys-in-the-manifest

Brief
: The keys attended procedures read get homes in lpoco-manifest: each fact in the table that owns it, named images in [images], a procedure's own values in [procedures.NAME]

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-19

Decision
: Completes 2026-11-19-procedure-values-from-the-named-device (docs #651): steps read keys the schema (deny_unknown_fields) refused. Homes, from walleye's list (google-walleye-lab #506): the shell's port and address pair in [connection]; adb and fastboot paths in [tools] beside lpoco; the battery floor (mV, and how it is read) in [health]; how long the device takes to answer after a boot and to come back to the known-good system (device_wait, back_wait) in [boot]; images as [images.NAME] (path relative to the device repo, sha256), with [images] dir; values only one procedure uses (window, min_window, stay, bite_wait and the like) in [procedures.NAME], a free table of named numbers and strings that the procedure's own --dry-run checks for the keys it reads. A key goes in [procedures.NAME] only when no table owns the fact; a second procedure needing it lifts it to the owning table (the reflect-and-lift rule). lpoco-attended reads them by name (dev("health.battery_floor_mv"), proc("window")).

Why
: walleye's settings move (google-walleye-lab #506, note walleye-to-orchestration-manifest-keys.md) and surya's consts move are blocked: lpoco-manifest is deny_unknown_fields and has no home for these keys; relayed by the Top Coordinator as a gap in v0.31.0's device-values work.

Rejected
: One [attended] table holding all of it: the same fact (a port, a battery floor) would sit beside its owning table, declared twice. Turning deny_unknown_fields off: a misspelt key would pass and fail only at a run. Program paths per procedure: they are the lab's tools, one [tools] table.

About
: bringup-steps

Research
: attended-device-values


<a id="2026-11-19-host-follows-releases"></a>
### 2026-11-19-host-follows-releases

Brief
: The host side becomes a conveyor: release CI attaches checked binaries, the lab host follows releases by itself in a lease-free window, and a device.toml the host cannot read cannot land

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-19

Decision
: (a) lab-tools' release CI builds the host family (lpoco, lpoco-lab/devlab, lpoco-bringup, lpoco-health, lpoco-host, lpoco-tone, lpoco-attended) for x86_64 Linux and attaches each with its sha256 to the release; lpoco host prepare downloads and checks them, compiling with cargo only when no binary fits. (b) The lab host follows releases: a lpoco-host user timer (no root) every 15 min sees a newer release, waits for a window where both keeper leases are free, installs it, runs lpoco host check (which parses every lane's device.toml with the installed tools and fails on any it cannot read), keeps the previous binaries to step back to if check fails, and lands the lab.toml pin bump itself (signed lab-host-follow) so the pin stays the record. A release needing root (udev, polkit) is not applied by the timer: it says so to orchestration. (c) A lane cannot land a device.toml the installed host cannot read: device repos' CI runs the manifest check of the version lab.toml pins (attended-ready-on-host covers the run side). Orchestration's hand step goes away; it reads the timer's log in its round.

Why
: The author, 2026-11-19, relayed verbatim: dont we have that established in conveyers for ease and egonomisy of both edit, compile run, ship, download, run and so on ? or how do we have it ? is it just me or it looks like a busy handwork that orchestrator or such are now bound to shove dust from one place to another ? The host sat at 0.24.0 while lab-tools reached 0.32.x and surya's attended run broke on it with the author at the phones (docs #666). Research host-conveyor: dist, cargo-binstall, unattended-upgrades, Renovate.

Rejected
: Keep the hand bump and prepare: it fell behind by eight releases in a day. Follow the newest release with no pin: the host's state leaves git and nobody can say what ran. Compile on the host from the timer: minutes of build per release on the lab machine while a phone may be mid-run. An agent session as the follower: a session per release for a mechanical step.

About
: bringup-steps

Research
: host-conveyor


<a id="2026-11-19-roles-read-origin-main-not-shared-clones"></a>
### 2026-11-19-roles-read-origin-main-not-shared-clones

Brief
: Roles act on origin/main, never a shared clone: the start hands the brief over whole, the guard refuses stale reads; host-clones-fresh lands as a convenience, not the fix

Project
: linux-phone-oco/docs

Date
: 2026-11-19

Decision
: What a role acts on is origin/main - read in a fresh worktree of its own or with git show origin/main:PATH - never a shared clone's working tree; the shared clones under ~/Projects are for the author and for fetching through. Three parts:
1. Delivery (ideal-agent, owner ideal-agent-builder; upstream item role-start-brief-whole): the role start hands the brief over whole from origin/main - written to a per-session file with the commit it was read at, the hook printing a pointer and staying under the app's output cap - so no agent needs the Brief: path's copy on disk.
2. Enforcement (ideal-agent; upstream item guard-refuses-stale-clone-reads): the PreToolUse guard refuses a command run in, or a file read from, a shared clone's main checkout whose HEAD is behind its local origin/main (no fetch: every worktree add already fetches through it), naming the fresh-worktree line; SHARED_CLONE_OK=1 stays the author's way past. Fail-closed, like If-Match.
3. The briefs (docs, orchestration's): phone-keeper.md makes the worktree first and runs every start command in it; surya-coordinator.md and coordinator.md start in a worktree at origin/main as walleye-coordinator.md does (backlog briefs-start-in-a-worktree); patrol counts reads of a shared clone each round (patrol-counts-shared-clone-reads); the two lane clones are put back on main once (shared-clones-back-on-main).
host-clones-fresh changes, it is not dropped: it lands as built (branch builder-host-clones-fresh, its own user timer, not folded into follow) as a convenience that keeps the author's clones and the start's fallback current, and it is not the fix; ranked after the briefs item.

Why
: Research stale-clones-where-roles-read. Six incidents in three days; today's two cost a builder its own row and a keeper a redone item while the author waited on the UFS read. The from-main brief already exists (ideal-agent 0.3.28) but reaches the agent as a 2 KB preview in 203 of 333 starts, and 200 of 333 starts then read the stale disk copy: the reading is right, its delivery is cut. Prose alone did not hold: phone-keeper.md said "never the shared clone" and 5 of 253 lane sessions still ran their picking query there. The built timer would have caught docs but not google-walleye-lab (on branch build/tad-0.7.1) nor surya-lab (detached). The world gives each worker a fresh tree or reads the ref, and enforces it fail-closed; nobody fast-forwards a tree in use (git's own prefetch avoids moving refs; git-sync swaps a symlink with one writer). The author asked how best to apprehend it: a check that refuses old state, at the one place every role passes, rather than a refresher that narrows the window.

Rejected
: The follow timer as the fix (host-clones-fresh ranked first, or folded into lpoco-host follow): leaves detached, branched and dirty clones - two of the three lane clones today, the walleye one when it bit - keeps a window of up to 15 minutes, and moves a tree others read in place; folding it into follow ties clone moves to tool installs for nothing, and it is already built on its own timer. Briefs only: they already said it; 5 of 253 sessions and 200 of 333 brief reads went to the shared clone anyway. tad refusing to answer from a checkout behind origin/main: in tad-engine, another owner's engine for every base, and narrower than the guard (it misses Read and cat of a brief); kept as a later upstream note if the guard proves too coarse. Removing the shared clones: worktrees need a parent clone and the author reads them; the guard gives the same safety. A fetch inside the guard: network in a 10-second hook, and the local origin/main is already fresh. A git-sync symlink farm: one writer and atomic swaps for readers that do not exist; the worktree per session is that shape already.

About
: agent-folder

Research
: stale-clones-where-roles-read

Tracked by
: briefs-start-in-a-worktree


<a id="2026-11-19-procedures-chain-by-named-groups"></a>
### 2026-11-19-procedures-chain-by-named-groups

Brief
: Procedures chain by named step groups, each one line inside one run with its own way back; a procedure reuses another's checklist by calling its group, not by running it as a second run

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-19

Decision
: (1) lpoco-attended gets a named group: group("boot the test image and reach the shell", [steps...]) returns one Step-like unit; a procedure writes it as one line, its steps are logged under the group's name, --dry-run lists them, --from/--until can name a group or a step in it, and groups nest. (2) A group may carry its way back - .way_back(back_to_known_good()) - which runs whatever failed after the group's start, in reverse order of entry, once per run (pytest yield fixtures, Ansible block/always). (3) Groups any device needs live in the library (first: phone_ready - gate, boot_once, wait_for_phone, shell answers - and leave_known_good); a device's own groups in its procedures/steps; the lift check covers groups like steps. (4) A procedure that needs another's checklist calls that checklist's group: the entry file stays a plain list, with one log, one lease and one way back held by the outer run. Running another procedure file as a sub-run is not offered. Follows 2026-11-19-procedures-chain-small-device-agnostic-steps and -procedures-reflect-and-lift; backlog attended-step-groups.

Why
: The author, 2026-11-19: is our procedures now easily ergonomically chainable ? or how does that work ? Today steps chain only inside one file; walleye's display, UFS and PMIC procedures each repeat the gate, boot, shell and way-back steps. Research procedures-chaining: Robot keywords, Ansible include_tasks and block/always, GitHub composite actions, pytest fixtures, LAVA test definitions in one job.

Rejected
: A procedure running another procedure file as a sub-run (GitHub's reusable workflow): a second log, lease and way back, and the phone's state handed between two runs. Copy-paste with the lift check catching it: the lift finds copies, it does not give a way to name them. Macros or a DSL: the entry file stops reading like plain Rust.

About
: bringup-steps

Research
: procedures-chaining


<a id="2026-11-19-host-lock-is-flock"></a>
### 2026-11-19-host-lock-is-flock

Brief
: The host's run lock is an flock on a file, not a pid file

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-19

Decision
: follow now and prepare now hold an flock on ~/.local/state/lpoco-host/lock; the pid written in it is for the message only.

Why
: The kernel frees it however a run ends, so no stale lock is judged; review found the pid-file takeover raced and survived a reboot.

Rejected
: pid file with takeover (race, pid reuse); lock under XDG_RUNTIME_DIR (still needs a stale rule); start time in /proc/pid/stat (more machinery).

About
: host-follows-releases


<a id="2026-11-19-way-backs-run-on-failure-only"></a>
### 2026-11-19-way-backs-run-on-failure-only

Brief
: A group's way back runs only when the run fails after one of its steps began, finished groups included; a panic or a missing device key counts as failing

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-19

Decision
: Way backs are owed from the first step run of their group, run once in reverse order of entry on any failure (error, panic, exit 2 from a missing key), never on a passing run; a group skipped whole by --from owes none; --until FIRST_PROMPT runs none.

Why
: Spec 2026-11-19-procedures-chain-by-named-groups said 'whatever failed after the start'; a panic left the phone on the test kernel in the review's scenario.

Rejected
: Running way backs on success as well (Ansible always, pytest teardown): a passing run ends where its procedure ended it, with leave_known_good as an explicit group. Dropping a finished group's way back: kept per the spec; revisit if leave_known_good makes it reboot twice.

About
: attended-step-groups


<a id="2026-11-19-settling-groups-settle-by-identity"></a>
### 2026-11-19-settling-groups-settle-by-identity

Brief
: A settling group (leave_known_good) settles the way backs of every group no longer open, by identity; open ancestors' stay owed

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-19

Decision
: Group::settling(): when its steps have all passed, owed way backs of groups that are not open any more are dropped, whatever their depth; way backs of groups still open stay; a failure inside it settles nothing.

Why
: After leave_known_good the phone is on its known good; a later failure would reboot it again (attended-way-back-settled). The reviewer found a depth-based version missed a finished group shallower than the settler.

Rejected
: Settle by depth (misses a shallower finished group). Clearing every owed way back (drops open ancestors' guarantees). Settling on the group's name leave_known_good (a flag any group can use is the general form).

About
: attended-step-groups


<a id="2026-11-19-phone-reached-by-its-declared-transport"></a>
### 2026-11-19-phone-reached-by-its-declared-transport

Brief
: A device declares how the phone is reached ([connection] transport ssh, telnet or adb, login password or none); lpoco lab and the library steps go through it

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-19

Decision
: lpoco-manifest's [connection] gets transport = ssh (default, as today) | telnet | adb and login = password (default) | none. lpoco lab phone sh|root, lpoco lab suite and the lpoco-attended steps read_dmesg, back_to_known_good and the phone() helper reach the phone through the declared transport: ssh with the password file as today; telnet on shell_address:shell_port with no password; adb by the [fastboot]/gadget serial. A device with login = none is never asked for a password: a command that needs one says 'not applicable: device.toml declares no login' and names what to run instead, so no keeper copies it as a blocker. boot_once on a device whose [boot] is fastboot boots the image from RAM (lpoco lab fastboot boot now) and waits for the gadget by its usb_id, needing no login. phone-keeper.md's start reads the suite only where the device has a login.

Why
: walleye (google-walleye-lab) has no Linux login - Android over adb, test images with a passwordless telnet shell - yet lpoco lab suite latest answers 'no password: set PHONE_PASS ...', which every walleye keeper copied into its hand-over as a blocker needing the author (PRs 504, 511, 524, 539); and boot_once, back_to_known_good and read_dmesg assume an ssh login, so walleye keeps its own helpers (notes walleye-to-orchestration-why-keepers-write-the-password-claim.md and -library-steps-need-a-login.md, 2026-11-19).

Rejected
: A brief line alone: the tool's error still reads as an instruction. Faking a login on walleye: there is no user to log in as. A separate tool per transport: the procedures would name the transport instead of the device declaring it.

About
: bringup-steps


<a id="2026-11-19-bringup-graph-cytoscape-dagre"></a>
### 2026-11-19-bringup-graph-cytoscape-dagre

Brief
: The bring-up graph is Cytoscape.js with dagre (LR), the Graph tab of the face's steps page; it opens folded and draws at most 500 nodes; ELK or a worker only for 1000+

Project
: linux-phone-oco/docs

Date
: 2026-11-19

Decision
: bin/render-pages.sh (make render, checked fresh by make verify) writes face/graph/bringup.json: steps, stages, edges (kind, group), devices and every device's step status. face/graph/graph.js draws it, as the Graph tab of the face's bring-up steps page (face/lens.toml: a tab of kind embed beside the Table; en/linux-phones/steps.html#graph), with Cytoscape.js and cytoscape-dagre at pinned versions, rankDir LR: the goal on the left, its needs to the right. A tab per device read from the devices table plus a generic tab, each its own link (#device, on the steps page too); a goal picker in each tab; nodes coloured by that device's status; hard edges solid, soft dashed, alternatives coloured by group; a click shows title, done_when, proof and guide. For a catalogue past a thousand steps (the author): it opens folded (the goal and one node per stage group), Show more opens the next rank, a search reveals a step's chain to the goal, open only hides done steps, and only the visible part is laid out; a change that would draw more than 500 nodes is refused with a message. Measured (research dagre-lays-out-the-bring-up-graph-in-0-13-s-at, a generated 1500-step fixture): folded 15 nodes 14-23 ms, one rank 138 nodes 0.13 s, two ranks 456 nodes 1.7 s, three ranks 944 nodes 9.5 s, all 1458 nodes 17-26 s; today's 91 needed steps unfold whole in 0.12-0.18 s. A full view of 1000+ steps is the point where ELK (elkjs layered) or dagre in a web worker replaces the main-thread layout; not built until wanted.
 The graph first stood alone as docs/graph.html; on 2026-11-19 it moved into the face (the author chose "Change the engine": ocoeco-engine may ship JavaScript and data for views that need it, decision 2026-11-19-views-that-need-javascript-may-ship-it there; research interactive-islands-in-static-generators): bin/face-data hands the engine face/graph/graph.js and bringup.json, the engine copies them next to the page and writes the container and the pinned libraries' script tags, the table stays the page's default and readable without JavaScript, and /tables/graph.html is a redirect to the Graph tab. Added at the author's asking: a full screen button for the graph and its panel, and a button that hides and shows the details panel (the choice kept in localStorage; a click on a step never reopens it).

Why
: The author, 2026-11-19: can our webpage render that from our database as a dynamic tree or draw that graph dynamically ? ... is it a trivial, well known method; then a sub-tab per device; then the catalogue "over a thoughthand at least". A layered (Sugiyama) layout is the known method; dagre is its small implementation, and the measurements show where it stops.
 Then (2026-11-19): is there also a way to see it fullscreen, with a button that toggles fullscreen and the info panel.

Rejected
: Mermaid generated at build: no folding, one chart per goal and device. ELK now: at 1500 steps it is the answer for a full view, but the folded page draws under 0.2 s with dagre and a full view of 1000+ steps is unreadable anyway; revisit when someone needs the whole graph at once. Compound parent nodes for stages: cytoscape-dagre does not lay them out, so stage groups are summary nodes. d3-dag: more code of ours. A server or a new build step: the site already renders from the rows.
 The standalone Jekyll page beside the face: two pages of one subject with two looks (the author chose to change the engine).

About
: bringup-steps

Research
: dagre-lays-out-the-bring-up-graph-in-0-13-s-at


<a id="2026-11-20-outgoing-items-live-in-upstream"></a>
### 2026-11-20-outgoing-items-live-in-upstream

Brief
: Every outgoing item (patch series, message, finding) lives in docs upstream/DESTINATION/ITEM/, whichever lane makes it; research keeps only material and pointers

Project
: linux-phone-oco/docs

Date
: 2026-11-19

Decision
: An outgoing item's files - patches, cover letter, SEND-NOTES, message - live in docs upstream/DESTINATION/ITEM/, where DESTINATION is the upstreams id (the list or project) and ITEM the upstream item id; the item's file field points there. Research folders keep the material behind it (measurements, candidate diffs, logs) and leave a pointer when an item moves out. Moved 2026-11-20: pmic-wdt-gen2-v1 to upstream/linux-watchdog/, the withdrawn sxmo suspend series to upstream/sxmo-devel/sxmo-suspend-series/, and walleye's board dts v0 copied to upstream/linux-arm-msm/walleye-board-dts/; lanes make later versions there.

Why
: The author looked for the walleye patches in docs' upstream folder and did not find them: 'where are those patches for upstreams for walleye ? i dont see them in the upstreams folder of docs' (through the Top Coordinator, 2026-11-20). The PMIC series sat in research/upstream-forks/ and walleye's board dts in google-walleye-lab research: two homes for one kind of thing.

Rejected
: Leaving each series in the research folder that made it: the author cannot find them, and the upstream item rows pointed at three different trees. Moving walleye's research folder out of its lab base: that is the walleye lane's repository; its next version is made in docs instead.

About
: upstream-forks


<a id="2026-11-21-login-key-is-ssh-by-declared-identity"></a>
### 2026-11-21-login-key-is-ssh-by-declared-identity

Brief
: login = key: ssh -i the declared absolute identity (mode 600), BatchMode, no password; root via key is the login itself or sudo -n

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-20

Decision
: Connection.login is password | key | none; key is for ssh only and needs identity (an absolute path on the lab machine); lpoco reads it, never creates it, refuses it missing, not a file or readable by group/others. Extends 2026-11-19-phone-reached-by-its-declared-transport.

Why
: walleye's Alpine image has a key-only sshd (orchestration, 2026-11-21); the lab key is private to the lab machine and its creation is the walleye lane's, with the author's yes

Rejected
: Login::Key { identity } enum now: schema change, left as a follow-up; relative or ~ identity paths: ambiguous cwd and home; ssh-agent: not declared in data, not reproducible

About
: connection-login-key

Research
: bringup-steps


<a id="2026-11-21-pre-boot-gates-are-argv-before-the-fastboot-boot"></a>
### 2026-11-21-pre-boot-gates-are-argv-before-the-fastboot-boot

Brief
: [kernels] pre_boot: command lines run as argv, in order, before a fastboot boot touches the phone; one failing stops the boot

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-20

Decision
: pre_boot is a list of command lines split on spaces (no shell, no quoting), run in the device's folder before boot_once checks the image or reboots the phone to the bootloader; a gate that exits non-zero or cannot start ends the step naming it and its output; it needs boot = fastboot; the dry run names the gates in the step.

Why
: walleye's UFS-off gate and battery rule were wired by hand (orchestration, 2026-11-21); with the sha check the boot becomes one declared line

Rejected
: sh -c strings (splicing, quoting); array-of-argv form now (the item's proof is strings; a quoting need can add it later); gates for the entry boot (it goes through devlab kernel try, which has its own gates)

About
: boot-once-pre-boot-gates

Research
: bringup-steps


<a id="2026-11-23-structure-folder-readme-and-map"></a>
### 2026-11-23-structure-folder-readme-and-map

Brief
: Every top-level folder of a repository has one meaning and a README.md whose first line says it; the repository README opens with a key-value header and a one-line-per-folder map

Project
: linux-phone-oco/docs

Date
: 2026-11-23

Decision
: Each top-level folder has one meaning and a README.md whose first line says it. Each repository's README.md opens with a few key: value lines (what, kept by, records in, branches), then ## Map: one line per top-level folder, and what must never be at the top. One screen. A check in each repository's CI refuses a top-level folder without a README or a Map line (dot-folders and LICENSES excepted).

Why
: 5 of ~55 top-level folders had a README; ARCHITECTURE.md, FHS and kramdown-rfc agree on a short map of coarse parts with one purpose each (structure-review-look-around).

Rejected
: A separate OVERVIEW.md or ARCHITECTURE.md (a second file to keep in step; the README is opened first); the layout as a data file rendered into the README (more machinery than one map); full Diataxis trees.

About
: self-explaining-structure

Research
: structure-review-what-is,structure-review-look-around


<a id="2026-11-23-structure-project-map"></a>
### 2026-11-23-structure-project-map

Brief
: One map for the whole project, docs/MAP.md: each repository in a line, the lab machine's folders, the kernel branches, and where each step of the flow reads and writes

Project
: linux-phone-oco/docs

Date
: 2026-11-23

Decision
: docs/MAP.md is the whole project on one screen: each repository in one line with what it holds; the lab machine's folders; the kernel repository's branches; the flow research, decision, build, phone try, record, upstream with the place each step writes. Every repository's README points to it in its header.

Why
: The author asked for 'a simple overview text note' explaining the structure; the roles could not say which of two homes was live (upstream-queue vs docs upstream/, two worktree homes).

Rejected
: The organisation's GitHub profile as the map (not on the lab machine, not landed through land); a generated map (one screen of prose is read once, in order: a file).

About
: self-explaining-structure

Research
: structure-review-what-is,structure-review-look-around


<a id="2026-11-23-structure-lab-machine-homes"></a>
### 2026-11-23-structure-lab-machine-homes

Brief
: On the lab machine: ~/Projects/linux-phone-oco holds clones only; worktrees only in ~/.local/share/agent-worktrees; run output in AGENT_BUILD

Project
: linux-phone-oco/docs

Date
: 2026-11-23

Decision
: ~/Projects/linux-phone-oco/ holds one clone per repository, on main, and nothing else: ours (docs, lab-tools, google-walleye-lab, surya-lab, device-template, sxmo-deviceprofiles, lens) and the forks we patch (sxmo-utils; linux once moved in). Every worktree lives in ~/.local/share/agent-worktrees/REPO/NAME (NAME may be ROLE/WHAT), made by ideal-agent's branch, a read-only one too; the kernel's worktrees as well, so git rerere is shared through the one clone. A worktree with uncommitted work is saved or dropped by its lane before it goes; one nobody has checked is moved into the home, not removed. A run's output goes to $AGENT_BUILD; what is kept as evidence goes into its research row's material folder, with the pointer in the same change. The one kernel clone moves from ~/Projects/surya-audio/linux to ~/Projects/linux-phone-oco/linux in one builder change that updates every path that names it or walleye-build (device.toml kernel_tree, build/, tools/, procedures/, AGENTS.md: 155 places in google-walleye-lab), between phone runs. The build areas walleye-build and surya-audio stay where they are, each with a README; device.toml [images.*] is their index.

Why
: Four roles named the same cause: a place chosen by whoever creates the thing, nothing tying it to a session or ending it. ideal-agent's branch already has one home; prune ends clean worktrees there. Objections of 2026-11-23 taken: orchestration (uncommitted worktrees; name sxmo-deviceprofiles and lens), walleye (the kernel move touches 155 paths, one change between runs), ideal-agent (kernel worktrees in the same home).

Rejected
: wt-ROLE-RUN beside the clones (no owner, never removed); ~/Projects/.worktrees (a second home again); moving the kernel clone by itself (breaks the image manifests' kernel_tree); moving the build areas now (scripts and manifests name them; 135 GB for no reader's gain).

About
: self-explaining-structure

Research
: structure-review-what-is,structure-review-look-around


<a id="2026-11-23-structure-rendered-pages-not-committed"></a>
### 2026-11-23-structure-rendered-pages-not-committed

Brief
: Rendered pages (docs/*.md of a tad base) are no longer committed; the site renders them in CI; data/ stays committed; tried first on two concurrent PRs

Project
: linux-phone-oco/docs

Date
: 2026-11-23

Decision
: A tad base commits its data/ and its sources (tables, records, queries); the pages rendered from them are made by the Pages workflow and not committed. In the same change: make verify checks that the pages render (instead of that the committed ones are fresh), and the README points readers to the site instead of docs/ on GitHub. idealkb carries it out on one base first (google-walleye-lab) and shows two PRs landed minutes apart without a replay before every base follows; if data/*.json appends still conflict, that is the next step (e.g. new rows at the end).

Why
: Every record touches a rendered page and the index counts, so two landings minutes apart conflict; walleye replayed records six times on 2026-11-22 (2026-11-22-walleye-land-regen-conflicts). Objections of 2026-11-23 taken: orchestration (verify and readers need a new place), walleye (land's regeneration did not settle data/*.json either: test before relying).

Rejected
: Hand-merging generated files; one landing session per repository; one file per row (larger than the conflict calls for); not committing data/ (it is the base).

About
: self-explaining-structure

Research
: structure-review-what-is,structure-review-look-around


<a id="2026-11-23-structure-go-is-its-own-record"></a>
### 2026-11-23-structure-go-is-its-own-record

Brief
: A keeper's go is its own append-only record an item update cannot clear; a wait names a record; the keeper's query prints the verdict and the keeper acts only on 'act now'

Project
: linux-phone-oco/docs

Date
: 2026-11-23

Decision
: A go is its own record (item, image sha256, until, by) with its own close, append-only; re-entering a backlog item cannot clear it. A wait names a record (a decision, an author's word, a go); free text such as 'waits on author' is not a wait. tad q ready --for keeper prints per item: act now (go until T), waits: RECORD, or blocked: ID. The keeper stays one lasting role per device serving its queue under its lease (practice 44); it acts only on rows whose verdict is act now. idealkb carries the records and the query; orchestration the briefs.

Why
: 2026-11-22: an item note replaced the field that carried a go window and erased it; a keeper read 'waits on author' as a block and skipped an open go. Both come from steering kept as free text in a field several writers overwrite. Objection of 2026-11-23 taken (orchestration): a keeper per item would break the lasting keeper and its lease.

Rejected
: Queue markers in notes (what failed twice); a keeper started per item (a lease and a cold start per item); messages to running keepers (lost when idle).

About
: self-explaining-structure

Research
: structure-review-what-is,structure-review-look-around


<a id="2026-11-23-structure-checks-refuse-wrong-homes"></a>
### 2026-11-23-structure-checks-refuse-wrong-homes

Brief
: Each home is held by a check owned where it runs: a layout check read from each README's Map in CI, ideal-agent's guard at tool time, ikb's records, the kernel assemble tool

Project
: linux-phone-oco/docs

Date
: 2026-11-23

Decision
: Repository: ideal-agent layout-check, run from a CI step (installed from ideal-agent; CI has no plugin), reads the README's Map as the layout's data and refuses a tracked top-level folder with no README or no Map line (dot-folders, LICENSES and untracked ones aside); idealkb lays the READMEs of its own folders (data, docs, queries, records, research). The kernel repository's topic/, backport/, wip/ and int/ are its own scheme. Tool time: ideal-agent's guard refuses a git worktree add outside ~/.local/share/agent-worktrees, and a file written under ~/Projects outside a git working tree (Write and Edit always; a shell redirect where the parse sees it - best effort) - creating or moving a clone there stays allowed (the clones timer, a first clone such as linux). Records: ikb refuses research --material outside research/ (as upstream-item --file outside upstream/), and CI checks each named path exists. Kernel: the assemble tool refuses a topic with no upstream-item row.

Why
: The one refusal that existed (upstream-item --file) ended the two homes of outgoing series; prose alone did not. Objections of 2026-11-23 taken: ideal-agent (CI has no plugin; the layout kept as data in the Map; no file under ~/Projects outside a working tree; best-effort for redirects; the kernel's scheme), orchestration (clones must still be made and moved).

Rejected
: A rule in briefs only (read once, forgotten); a cleanup job after the fact (the wrong home still happens); a separate layout file (the Map already says it).

About
: self-explaining-structure

Research
: structure-review-what-is,structure-review-look-around


<a id="2026-11-23-structure-branch-names"></a>
### 2026-11-23-structure-branch-names

Brief
: Branches in our repositories are ROLE/WHAT, one change each, deleted when they land; on 2026-11-23 the 68 left were cleared: merged deleted, others kept as archive/NAME tags

Project
: linux-phone-oco/docs

Date
: 2026-11-23

Decision
: A branch is named ROLE/WHAT (keeper/, builder/, research/, coord/, orch/, steward/), holds one change and is deleted when it lands (land does it; GitHub's automatic deletion of head branches is on in all five repositories, author's go 2026-11-23). Release branches are the release tool's; oco-data is ocoeco's. A branch whose PR merged at its tip is deleted (the PR is the pointer); any other no open item names is first kept as a tag archive/NAME. A clone shows the remote's branches only when fetched with --prune.

Why
: The clones showed 2,138 branch names; GitHub held 68 - land already deletes on merge, but nothing pruned the clones and nothing cleared branches whose PR closed unmerged. Done 2026-11-23: 11 deleted, 48 archived then deleted, 9 kept (5 oco-data, 3 open PRs, 1 named by an open item).

Rejected
: No convention (today); dated or run-id names (they say when, not what); keeping unmerged branches as branches (a tag keeps the work without crowding the list).

About
: self-explaining-structure

Research
: structure-review-what-is,structure-review-look-around


<a id="2026-11-23-structure-git-flows-run-on-rhizoid"></a>
### 2026-11-23-structure-git-flows-run-on-rhizoid

Brief
: The structure's git flows run on git-rhizoid: assemble, status, send-back and fork tracking; lab-tools keeps the record checks and the image build

Project
: linux-phone-oco/docs

Date
: 2026-11-23

Decision
: git-rhizoid (generic git, no knowledge of tad or phones) carries the git work the structure decisions need: rhizoid assemble (base + ordered list, a fresh worktree in ~/.local/share/agent-worktrees, rerere, stop at a conflict naming both, tag int/DEVICE/LIST/BASE/N with every sha in its message, a base that may be a fork commit), status over topic, backport, int and fork edges, send-back (rebase onto the target tree, format-patch --base into vN-draft/, range-diff; never signs, sends or pushes), and fork tracking: its graph file is the one place that says a fork's upstream (linux, sxmo-utils); lab.toml [clones] names folders only. rhizoid owns the list format; each lab owns its kernel/topics.toml. lab-tools' lpoco-bringup kernel assemble keeps the refusals that need records (no upstream-item row, FROMLIST subjects that disagree), then calls rhizoid; the image build stays in lab-tools and the labs. Worktree home, branch names, land and prune stay ideal-agent's.

Why
: The author asked on 2026-11-23 that the git parts run through rhizoid rather than a separately hand-rolled tool; rhizoid's concepts (a cutting: pristine tracking side and patch branches; a clean patch back) are already this layout (rhizoid coordinator's needs draft, 2026-11-23). Orchestration: forks are a fact about repositories, so their upstream belongs in rhizoid's graph.

Rejected
: The merge and tag loop inside lab-tools (a second git tool beside rhizoid); forks marked in lab.toml [clones] (two places saying one fact); rhizoid reading tad records (it stays generic).

About
: self-explaining-structure

Research
: structure-review-what-is,structure-review-look-around


<a id="2026-11-23-structure-kernel-topics-and-integration"></a>
### 2026-11-23-structure-kernel-topics-and-integration

Brief
: Kernel: one repo; topic/ITEM per upstream series on a stated tag; backport/ITEM/BASE; wip/LANE/WHAT; test kernels are tags int/DEVICE/LIST/BASE/N made by rhizoid assemble from a lab's named list

Project
: linux-phone-oco/docs

Date
: 2026-11-23

Decision
: One kernel repository, linux-phone-oco/linux (today grenudi/linux; its move into the organisation is the author's, later), one lab clone of it whose worktrees share git rerere's memory.
- topic/ITEM: one branch per upstream series, ITEM its upstream-item id without a version, on a stated mainline tag. Its home for upstreaming. A carried patch we did not write is a topic too; a workaround keeps its WORKAROUND(item) marker and the item's --local-ref names its branch.
- backport/ITEM/BASE: the same item on another base a phone runs (e.g. sm7150-mainline v7.2); topics.toml lists it without a second item.
- Sending: a version is cut by rebasing the topic onto the target maintainer tree (the subsystem's for-next; linux-next only when none fits), with plain git format-patch - b4 is the author's option, never a requirement. docs upstream/LIST/ITEM/ keeps SEND-NOTES (the --base sha, the commit that was tested), the prepared unsigned vN-draft/, and after sending vN/ from the author's signed branch, which he pushes; its tip is tagged topic/ITEM/vN. Only the author signs and sends.
- wip/LANE/WHAT: tries on any base; one that works becomes a topic.
- int/DEVICE/LIST/BASE/N: a phone's test kernel, a tag only (no int/ branch: the image names the tag), made by git-rhizoid's rhizoid assemble - called by lab-tools after the checks that need records - from a named list in the lab's kernel/topics.toml - the base, then each topic in order with what it is for and its state (known-good naming the test-run and the tested commit, or trying). A phone may have several lists (walleye: ufs-off and ufs-on, never one tag for both). The tool starts from the base every time, stops at a conflict naming the two topics, tags each result; every test kernel is built from such a tag, and [images.X] names it (kernel_tag). lab-tools refuses a topic or backport with no upstream-item row before rhizoid runs (decision 2026-11-23-structure-git-flows-run-on-rhizoid).
- A lab repository keeps kernel/topics.toml, config fragments, and its bring-up device-tree experiments that have no upstream item (applied after assembly), plus the rest of an image's recipe (ramdisk, header, modules). Its .patch series and the board .dts move to topic branches. A build script an [images.*] row names retires only when the image rebuilt from an int/ tag has the same sha256. A running phone's kernel stays pinned by commit until int/DEVICE reproduces it.

Why
: The author, 2026-11-22: 'patches could stay separate for upstreaming and at the same time there is clear and simple way of cherypicking them or something into one kernel with known working patches (like working display, with working storage) ... so that this process is not a handmade mess of wherever the builder came up with ... and its gonna be proper homes for upstreaming at the same time'. Today patches live in five forms and no list says what a test kernel holds. linux-next and qcom-next do this: a written list of topic branches merged onto a fresh tag by a tool, never edited. Objections of 2026-11-23 taken: upstreams (sign-off only in the author's clone; no b4 dependency; cut onto the maintainer tree; backports; versionless item ids), walleye (images rebuilt byte for byte before a script retires; experiment dts; UFS-on and UFS-off apart), surya (WORKAROUND markers; the running kernel pinned by commit). Amended the same day: test kernels are tags only - rhizoid assemble tags and never moves a branch, and an image names the tag, so an int/ branch has no job (rhizoid coordinator, v0.1.1).

Rejected
: A long-lived device branch with cherry-picks (test/surya-calls: nobody can say what is in it); .patch files in a lab repo (they drift); quilt, StGit, TopGit (more to learn; series files drift the same way); b4 as a requirement (Python; our tools never depend on it); topics in a second repository like qcom-next (ceremony for two phones); Linaro automerge as-is (undocumented config; the merge loop is small); a version in an item id (vN folders and tags carry it). An int/DEVICE/LIST branch moved to the newest tag (a name with no reader; one more thing to keep true).

About
: self-explaining-structure

Research
: structure-review-what-is,structure-review-look-around


<a id="2026-11-23-host-tool-release-at-pin"></a>
### 2026-11-23-host-tool-release-at-pin

Brief
: A tool of another project is pinned by repository, tag and asset, installed from its release by hash, never built

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-23

Decision
: [tools.NAME] repository/tag/asset; URL is LPOCO_GITHUB/REPOSITORY/releases/download/TAG/ASSET with .sha256 beside; stamp = tag; names of the lpoco family refused.

Why
: rhizoid's releases carry the binary and its .sha256; no cargo on the lab machine (rhizoid coordinator via orchestration).

Rejected
: cargo install from a git tag (slow, needs a toolchain); LPOCO_RELEASE_BASE reuse (wrong folder shape); hash pinned in lab.toml (follow-up).

About
: host-installs-cargo-tool-at-pin


<a id="2026-11-23-linux-phone-oco-s-rhizoid-graph-lives-in-docs-as"></a>
### 2026-11-23-linux-phone-oco-s-rhizoid-graph-lives-in-docs-as

Brief
: linux-phone-oco's rhizoid graph lives in docs as rhizoid.graph.toml, started from rhizoid's example; the attended pins are bumped through it, gated by cargo check

Project
: linux-phone-oco/docs

Date
: 2026-11-23

Decision
: docs keeps rhizoid.graph.toml at its top, the one graph rhizoid status and rhizoid bump read for linux-phone-oco: slices, the device layer, tool pins (lpoco in lab.toml, tad, lpoco-attended in each lab's steps crate with cargo check as the gate and the crate's Cargo.lock beside the pin) and forks. It starts from git-rhizoid/rhizoid's examples/linux-phone-oco.graph.toml (514d7e7) and is kept here from now on; a gate is argv from this file, so it is reviewed like code.

Why
: Decision 2026-11-23-structure-git-flows-run-on-rhizoid makes rhizoid's graph the one place for these edges but named no home; docs is the project's memory and orchestration keeps it. Read with rhizoid 0.2.4: lab.toml's lpoco and both labs' lpoco-attended pins show behind 0.43.0, the rest current.

Rejected
: The graph only in rhizoid's examples (its tests compare it with docs' research, so our pins would change its fixture); in lab-machine (it is one machine's, the graph is the project's); one graph per lab (the edges span repositories).

About
: self-explaining-structure

Research
: structure-review-look-around


<a id="2026-11-23-lpoco-attended-leaves-the-family-its-own-version"></a>
### 2026-11-23-lpoco-attended-leaves-the-family-its-own-version

Brief
: lpoco-attended leaves the family: its own version, released only when it changes; it takes lpoco-manifest by a released tag, not a path, so a manifest release does not move it

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-23

Decision
: lpoco-attended (the library the labs pin) leaves release-plz's version_group lpoco and gets its own version. First choice: a release-plz setting that stops dependent bumps, if its documentation has one. Otherwise attended depends on lpoco-manifest by its released git tag instead of the workspace path, so release-plz no longer bumps it when manifest releases; attended moves its manifest tag only when it needs something new. lpoco-host FAMILY, assets.yml and lpoco list read lpoco-attended at its own version, and the dispatcher checks it against that version.

Why
: Each family release moved lpoco-attended's tag unchanged and both labs got a bump PR (busy work, against the author's condition on pins). The builder found that leaving the group alone is not enough: release-plz bumps dependents of a released path dependency, and attended depends on manifest (lab-tools builder, docs #789).

Rejected
: Every family member depending on manifest (a manifest change would then move everything, the busy work again); taking manifest out of the family too (skews the family: lpoco NAME refuses mixed versions); a graph rule ignoring unchanged tags (hides the fault).

About
: self-explaining-structure

Research
: structure-review-look-around


<a id="2026-11-23-graph-checked-at-land-by-the-hosts-rhizoid"></a>
### 2026-11-23-graph-checked-at-land-by-the-hosts-rhizoid

Brief
: docs' graph is checked at land by the host's own rhizoid (make land-check), not in GitHub CI: no secret, no copy of the pin

Project
: linux-phone-oco/docs

Date
: 2026-11-23

Decision
: land runs a repository's make land-check, when its Makefile declares one, on the branch exactly as it is about to merge (after any rebase and land-regen), and refuses the merge on failure. No switch turns it off (lab-machine: the first LAND_CHECK=0 was removed the same day): a skipped check would be the merge that escapes. docs' land-check runs rhizoid check --graph rhizoid.graph.toml with the rhizoid installed on the lab host, the one the rhizoid-bump timer reads the graph with. No rhizoid, or one before check (0.3.9), fails and says which; it never skips. A merge outside land escapes the check: today none happen (every docs merge is land, the bump timer's --land included); if that changes, the check moves to CI.

Why
: A graph using a field the host's rhizoid does not know broke nothing only because orchestration held [[pins]] back by hand (0.3.6 refuses it). A CI job would need grenudi/lab-machine's lab.toml, which is private: a token or a visibility change, and the lab's own token has admin scopes and stays in its mode-600 file (Top Coordinator). Checking at land uses the binary that matters, even when the host lags its pin. Proposed by the Top, accepted by the rhizoid lane with its three conditions.

Rejected
: A CI job reading lab.toml with a read token (a credential to keep) or with lab-machine public (a visibility change for one file); checking against rhizoid's latest release (always new enough, so it passes the skew it exists to catch); rhizoid ignoring unknown fields (an old one would move pins it does not own).

About
: self-explaining-structure

Research
: structure-review-look-around


<a id="2026-11-23-a-check-names-its-source-as-a-row-a-doc-or-captured-text"></a>
### 2026-11-23-a-check-names-its-source-as-a-row-a-doc-or-captured-text

Brief
: A check names its source: research:ID, a .md doc, or a file under the repository's research/ folder; the dry run refuses the rest

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-23

Decision
: check_from(what, source, ..) in lpoco-attended; check() names none and fails the dry run (lpoco attended check, exit 1, the check named). A path is read through its real path inside the repository, a bounded head, a file only; captured text must start at research/; lpoco attended new writes research:ROW-ID, refused until replaced. A real run does not read the source.

Why
: ideal-agent decision 2026-11-23-a-stop-is-read-before-the-fix: two walleye runs were lost to a check typed as a stand-in. Review (programmer) found a symlink escape and 'any research component', both fixed.

Rejected
: Changing check()'s signature in place (breaks every procedure at once, no way to tell the new from the old); looking up research:ID rows in the base (the base is not this program's; stated as a limit); a Source enum parsed at construction (tidier, left for later); judging the source in a real run (a gate in CI is the dry run).

About
: attended-check-names-its-source


<a id="2026-11-23-a-try-ends-by-itself"></a>
### 2026-11-23-a-try-ends-by-itself

Brief
: A background try (load, soak, watcher) runs as a transient unit that ends by itself; a run leaves nothing running; patrol reports load nobody owns

Project
: linux-phone-oco/docs

Date
: 2026-11-23

Decision
: In linux-phone-oco's briefs (builder, phone-keeper): a try that runs in the background runs as systemd-run --user --collect -p RuntimeMaxSec=N (or stress-ng --timeout), never a bare & or nohup, and a run ends with nothing of its own still running. Patrol's host round reports a process above 50% CPU for over 30 minutes whose session ended and that is no declared unit, or a load above what running units use; it names it, never kills it. Results since 12:09 on the host, read: the 12:04 gate failure came before the load; the 13:00 one was the unit's PATH (rust-script not found), not load; the 14:00 pass under load stands; lab-tools suites that passed stand. What may be skewed is host-side timing in walleye's runs between 12:09 and about 16:40 (fastboot waits, timeouts): its lane rereads any timeout that fired then.

Why
: Twelve yes >/dev/null started by the lab-tools builder on attended-on-manifest-0-44-5 (session 49ae020f) to reproduce a flake under load were never killed and held all 12 threads for 4.5 hours until the author saw them (Top Coordinator, who killed them). Practices 6 and 10: jobs run as user units, a try falls back by itself. Nothing measured them: patrol is off and had no such line.

Rejected
: A rule to remember to kill background jobs (care instead of a mechanism); killing orphans automatically from patrol (patrol changes nothing; an orphan may be someone's live work).

About
: self-explaining-structure

Research
: structure-review-look-around


<a id="2026-11-23-image-recipes-on-nix-fixed-output-paths"></a>
### 2026-11-23-image-recipes-on-nix-fixed-output-paths

Brief
: Images named by sha256, made by TOML recipes; lpoco bringup ensure takes them from Nix's store or a file:// cache, else builds a fixed-output derivation; no Python in the sandbox

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-23

Decision
: An image is named by what it is - its declared sha256 - and made by a recipe. A recipe is TOML in the device's repository, beside the image's row (`[images.NAME] recipe = ...`): the image either derived from another image by name with parts swapped (the `image bisect` series format grown up: dtb, kernel, ramdisk, cmdline, footer), or made from parts - a kernel from an `int/` tag (tag and commit) with the lab's dts and config fragments, an initramfs spec, the header, the footer. Every input is named by content (a git commit, a file's sha256), never by a path on one host.

`lpoco bringup ensure NAME` (Rust, lab-tools) does what the author asked, on any machine with Nix: the image's Nix store path is computed from its sha256 and name (a fixed-output path); present in the store - done; else `nix copy --from` each cache the lab declares (a plain file:// directory, or ssh:// to the lab host) - done; else the recipe is built in Nix's sandbox as a fixed-output derivation whose outputHash is the declared sha256, so Nix itself refuses a build that does not equal it, and the result is copied to the cache. An image with no sha256 yet is built input-addressed and its sha256 then declared. lpoco-attended boots `[images.NAME]` through ensure, so a procedure names an image and its recipe, not a file.

Nix is used for what it already does - the content-addressed store, the sandbox, the binary cache, and the toolchain pinned by a nixpkgs commit and hash (as lab-tools' shell.nix) - and nothing else: recipes stay TOML, the image steps stay lpoco-bringup's Rust (pack, swap, initramfs build), one generic derivation in lab-tools turns a recipe into a build. No Python enters the recipe sandbox: the AVB hash footer moves from avbtool into lpoco-bringup.

Images whose kernel was built by hand (timestamp, mll@grig, a -dirty tree, the host's rolling clang) take that Image.gz as an input by sha256, imported into the cache once; a kernel built from an int/ tag from now on is built in the sandbox with KBUILD_BUILD_TIMESTAMP/USER/HOST fixed and its release named from the tag, and must pass `nix-build --check`.

Why
: The author, 2026-11-23: procedures should not be "bound to some external files of images", but point to a recipe; "if the same procedure and recepy is ran on another machine it doesnt need the image it will make it". Measured the same day (research image-recipes-how-it-stands): a Nix fixed-output path is computed from the declared sha256 alone, an unsigned file:// cache restores it for a normal user, and a derivation with that outputHash resolves without building - Nix already is "take it from a cache keyed by its hash, or build it and check it"; z21 was rebuilt byte for byte from z20 and its dtb by lpoco bringup image swap; the hand-built kernel was not reproducible from what was recorded, for want of exactly the inputs a sandbox and a pinned toolchain record. Nix is on the host (lab-machine setup/nix.sh) and pins lab-tools' shell already; recipes in TOML keep the lab's data where its tools and records read it; the image steps are lpoco-bringup's Rust already.

Rejected
: Nix whole, recipes written as Nix expressions (Mobile NixOS's way): Mobile NixOS dropped google-walleye on 2023-09-14, never had surya or sm7150, and has no AVB handling; per-image Nix expressions would put the lab's image data in a language none of our tools or records read - we take Nix's store, sandbox and pin, not its language for our data.
A thin Rust tool with its own hash-keyed directory store (the do-it-ourselves baseline): it would reinvent the store, its integrity check, its copy between machines and a sandbox, all of which Nix already gives on the host (measured: an image restored from an unsigned file:// cache by its sha256 in 0.3 s), and it would still need Nix or a container to pin the toolchain for "any machine". Kept as the fallback should fixed-output builds prove unworkable.
pmbootstrap (Nura, ex-postmarketOS): Python (practice 21), Alpine chroots, a distfiles cache only - nothing keyed by an image's inputs; its surya now boots U-Boot from boot, not our image shape.
Yocto/BitBake sstate: the right keying (inputs plus dependencies' hashes, a hash-equivalence server, mirrors over HTTP) but BitBake is Python and it is a whole distribution builder for two boot images.
Buildroot plus ccache: no output cache by design (ccache only speeds compiles); a rootfs builder.
mkosi: Python; makes disk images and UKIs, not Android boot images; no input-keyed output cache.
Bazel/Buck2 with a REAPI remote cache (and Android's Kleaf): the action-cache + CAS model is right, but the client, its rules and Kleaf bring Python and a build system for one image step; Kleaf is not fully hermetic; Buck2 has no stable release.
BuildStream: a CAS and remote assets, but Python.
Content-addressed derivations (ca-derivations), flakes, Attic: experimental or early; fixed-output paths and a file:// cache are enough and stable.
An OCI registry (ORAS) as the store: needs a registry; a later transport if the cache leaves the lab host.

About
: self-explaining-structure

Research
: image-recipes-how-it-stands


<a id="2026-11-23-ensure-pins-avbtool-and-takes-seeds"></a>
### 2026-11-23-ensure-pins-avbtool-and-takes-seeds

Brief
: image ensure is a verb of image; the recipe sandbox pins avbtool 1.4.0 by AOSP revision; hand-built inputs enter through --seed

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-23

Decision
: lpoco bringup image ensure NAME (a verb of image, beside swap) is the first slice of 2026-11-23-image-recipes-on-nix-fixed-output-paths. [images.NAME.recipe] = control (another image) + kernel/dtb/ramdisk by sha256 + cmdline. Order: store, cache, seed folder (--seed: a file whose sha256 is wanted enters the store once and is copied to the cache), else the recipe built by one generic derivation (bringup/src/ensure.nix: builds lpoco-bringup from --source or the release tag, runs image swap, outputHash = declared sha256). Until image-avb-footer-in-rust, the sandbox's avbtool is AOSP external/avb at ba2dec4b (what android-tools 37.0.0p1 vendors, byte-identical to the host's avbtool 1.4.0). A path is in the store only if nix-store --check-validity says so. Step lines go to stderr, the store path alone to stdout.

Why
: Measured 2026-11-23: nixpkgs' android-tools (35.0.2) has avbtool 1.3.0 and its footer differs from the host's 1.4.0 by one byte, so z21 built there missed the declared sha256; with the pinned 1.4.0 z21 was rebuilt from z20 and its dtb in the sandbox, equal to device.toml, then served from the store and from the cache. Nix leaves a refused build's file unregistered at the expected path, so existence is not validity.

Rejected
: nixpkgs' android-tools avbtool: 1.3.0, a different footer byte. Taking a file's existence at the path as the store holding it: a refused build leaves one. A top-level ensure verb: image verbs are the family's shape (swap, bisect).

About
: self-explaining-structure

Research
: image-recipes-how-it-stands


<a id="2026-11-23-release-tools-may-ship-an-archive"></a>
### 2026-11-23-release-tools-may-ship-an-archive

Brief
: A [tools.NAME] release pin may name a tar.gz plus the release's checksums file and the member to install; nfpm comes this way, not from Nix

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-23

Decision
: [tools.NAME] gains checksums (the release's HASH  NAME file) and member (one file of the archive). The archive's hash is the first line naming exactly it; the member, never a symlink, is installed and the tag stamped after. Landed in lab-tools #382 (main 851037e).

Why
: nfpm's releases ship nfpm_X_Linux_x86_64.tar.gz and checksums.txt (v2.49.0 captured); run against the real v2.49.0 release, lpoco-host check lists nfpm ok, v2.49.0. Test: host/tests/release_archive.rs, seen failing first.

Rejected
: Nix's nfpm: nixpkgs on the lab has 2.46.3, behind the release 2.49.0, and a second way to pin a host tool. A repackaged bare binary with a .sha256: we would republish another project's release.

About
: nfpm-on-the-lab-host


<a id="2026-11-24-one-agent-at-a-time"></a>
### 2026-11-24-one-agent-at-a-time

Brief
: One agent at a time across linux-phone-oco, no parallel agents where possible: tokens are short, quality is not traded; walleye's phone work goes first

Project
: linux-phone-oco/docs

Date
: 2026-11-23

Decision
: Binds all linux-phone-oco sessions. The author, 2026-11-24, verbatim: "keep up the work, one agent at the time, no parallel agents where possible, im low on tokens, but dont want to lose in quality of work". So: at most one lab-tools builder at a time, launched only while no walleye session is working (list_sessions first; walleye's phone work goes first); no subagent fan-outs, no reviewers or coordinators run in parallel; builders run on a lighter model with short briefs; the quality steps stay - checks, land, read back. The lanes waker runs hourly and wakes one lane only when nothing runs. For the rhizoid coordinator and the steward: this binds your lanes too - your next work waits for an idle moment rather than running beside a lane.

Why
: The author's word, relayed by the Top Coordinator on 2026-11-24: he is low on tokens and does not want quality to drop.

Rejected
: Pausing everything (he said keep up the work); cutting the quality steps to save tokens (he said not to lose quality).

About
: self-explaining-structure

Research
: structure-review-look-around


<a id="2026-11-24-plain-alpine-not-nura"></a>
### 2026-11-24-plain-alpine-not-nura

Brief
: Amends base-distro and device-layer-declared-once: the apk target is plain Alpine, not Nura; our layer carries its own boot.img trigger and firmware rule

Project
: linux-phone-oco/docs

Date
: 2026-11-24

Decision
: The apk target of a device layer is plain Alpine. Its boot.img rewrite is an apk trigger running the same script as the deb/rpm/arch hooks; its firmware is our own rule (an OpenRC service of the layer making the partitions' blobs visible to the loader); pd-mapper is the kernel's (CONFIG_QCOM_PD_MAPPER). Nura's boot-deploy, /etc/deviceinfo and the msm-firmware-loader config are not used. walleye's root filesystem is plain Alpine. surya stays on its Nura image while paused.

Why
: The author, 2026-11-24 (conversation turn-2026-11-24-why-still-nura): "Why do we still need nura i dont get it ? Dont we used alpine ?" Research plain-alpine-carries-a-phone-layer: Alpine carries the Qualcomm userspace; what Nura adds is a boot-deploy and a firmware loader we can carry in the layer with the script we already have.

Rejected
: Keeping Nura's boot-deploy/deviceinfo for the apk (a second path for one job, and a distribution we do not use); packaging msm-firmware-loader from pmaports (carrying another project's package where a layer service does).

About
: base-distro

Research
: plain-alpine-carries-a-phone-layer


<a id="2026-11-24-a-recipe-sha-is-proved-by-a-rebuild"></a>
### 2026-11-24-a-recipe-sha-is-proved-by-a-rebuild

Brief
: An image's declared sha256 is proved against its recipe by a sandbox rebuild in the lab's CI when either changes; ensure at run time still serves by sha

Project
: linux-phone-oco/docs

Date
: 2026-11-24

Decision
: lpoco bringup image ensure gets --rebuild NAME: it builds [images.NAME.recipe] in Nix's sandbox, ignoring store, cache and seed, and fails unless the output equals the declared sha256. Each lab's CI runs it for every image whose sha256 or recipe a change touches. Run-time ensure keeps its order (store, cache, seed, build), since the sha it serves was proved when it landed.

Why
: Walleye run 4 (2026-11-24): rw image 2477...b54f was built by a script whose header added walleye.booted-slot, absent from the recipe's cmdline; ensure found the sha in the store and served it, as a fixed-output path is trusted by its hash alone. The declared sha had never been the recipe's output. Proving it once, where it lands, closes that for every lab without slowing a run.

Rejected
: Rebuild on every ensure: minutes per run while the phone waits, for a proof that only changes when device.toml does. Recording provenance next to the store path: the store is shared and a script can write it too; a CI rebuild is evidence, a tag is a claim. Trusting the sha alone: the sign itself.

About
: image-ensure-in-attended

Research
: image-recipes-how-it-stands


<a id="2026-11-24-image-rebuild-runs-at-land"></a>
### 2026-11-24-image-rebuild-runs-at-land

Brief
: The image rebuild proof runs on the lab at land, through each lab's make land-check, not on hosted CI

Project
: linux-phone-oco/docs

Date
: 2026-11-24

Decision
: Each lab's Makefile land-check runs lpoco bringup image ensure --rebuild for every [images.NAME] whose sha256 or recipe the branch changes against origin/main; lab-machine's land already runs make land-check on the branch as it is about to merge and refuses on failure. lab-tools gives the selection: image ensure --rebuild --changed-since REV rebuilds only the touched images and passes when none are. Hosted CI keeps the checks it can run without the store.

Why
: Walleye's builder (google-walleye-lab #1049): hosted ubuntu-latest jobs have no Nix store or seed, and a recipe's inputs (control image, dtb, ramdisk) live only in the lab's store. land is the only way to main (practice 7) and already runs on the lab, so the gate sits where the inputs are, with no new runner or upload.

Rejected
: A self-hosted runner on the lab: it runs pull-request code on the host that holds the phones, outside the keepers' leases. Publishing the inputs as release assets: control images carry vendor files that are not ours to redistribute, and seeds are hand-built, so publishing proves nothing more. A gate only in hosted CI: it cannot run.

About
: image-ensure-in-attended

Research
: image-recipes-how-it-stands


<a id="2026-11-25-changed-since-compares-the-typed-declaration"></a>
### 2026-11-25-changed-since-compares-the-typed-declaration

Brief
: --changed-since compares typed [images] declarations (sha256, recipe, control chain), not file text, and refuses a REV it cannot read

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-25

Decision
: An image is rebuilt when its sha256 or recipe differ from the manifest at REV, when REV lacked it, or when a control it starts from (transitively) has another sha256. A REV with no or unparsable device.toml is an error, never 'nothing changed'.

Why
: A recipe names its control by name, so its own text is unchanged when the control file changes; the review reproduced a pass in that case. Failing loud keeps the gate honest.

Rejected
: Text diff of device.toml (reformatting would rebuild; control changes invisible); treating an unreadable REV as no change (a silent pass).

About
: image-rebuild-changed-since


<a id="2026-11-25-attended-export-scripts-not-judgement"></a>
### 2026-11-25-attended-export-scripts-not-judgement

Brief
: attended export writes each check's phone script as a lava-test-case; the procedure's judgement of the answer is not exported

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-25

Decision
: lpoco attended export NAME walks the procedure with --export (a dry run that runs each check closure, its phone sh|root scripts logged, never sent) and prints Lava-Test Test Definition 1.0: one lava-test-case ID --shell sh -c SCRIPT per check that sends a script; checks that send none are named in a comment. A case passes when its script exits 0; what the procedure judged of the answer (a Rust closure) stays in the procedure, and the YAML says so. Landed lab-tools #442.

Why
: Check bodies are Rust closures, so the only exportable part is what they send the phone; the device's values are already inside the scripts, read outside closures. Programmer review found the weakness (a check such as uname -r exports as always-green) and it is stated, not hidden.

Rejected
: LAVA params from [procedures.NAME]: the scripts have the values baked in, so a lab setting them would change nothing. A run step calling lpoco attended run on the phone: the procedure drives the phone from the host. Parsing Rust source for the checks: the closures are not data. Our own schema: LAVA's format is what others' labs run.

About
: attended-export

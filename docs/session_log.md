<!-- Generated from data/ by tad. Do not edit by hand. -->

# Session Log

<a id="docs-repo-created"></a>
### The docs repo: schema, style, and an honest first seed of what is actually known

Project
: linux-phone-oco/docs

Entry date
: 2026-11-04

Done
: Created linux-phone-oco/docs from text-as-data-template. Schema: devices, components, support_status (the matrix), device_sources, plus the template's backlog/session_log/sources. Adopted software-engineering-canon's RFC-like Jekyll theme verbatim (monospace, uniform heading size, definition-list field/value rendering, 72-character width) rather than inventing a new one, since it already does exactly what was asked for and is proven. Seeded one device (xiaomi-surya) and 19 components with status, citing only what was actually confirmed by search earlier in the session; everything not confirmed is marked unknown rather than guessed.

Considered
: Reusing ideal-project-playbook's concepts/relations schema for this too.

Rejected
: Concepts/relations model general, reusable PRINCIPLES with their relationships; a hardware support matrix is a different shape (a fact about one device and one component, not a principle), and forcing it into that model would be more awkward than a purpose-built pair of tables.

---


<a id="first-fastboot-probe"></a>
### The phone, for real: bootloader unlocked, product confirmed, two jobs run end to end

Project
: linux-phone-oco/docs

Entry date
: 2026-11-05

Done
: Ran the first two real jobs through lab-agent against the physical device: a read-only USB probe (0001, phone not connected at the time) and fastboot getvar all (0002, phone connected). Confirmed for real: product=surya (matches the docs repo's device id), unlocked=yes, kernel=uefi, secure=yes, serial fcbd04b4, and the full stock Android partition layout. Cross-checked against upstream: this device migrated from per-device pmaports packages to the generic qcom-sm7150 port (U-Boot + systemd-boot + EFI, March 2025), which changes the install/partition steps from the older device-specific instructions - U-Boot goes to boot, the pmOS boot image to cache, the rootfs to userdata.

Considered
: Attempting a fastboot boot or flash as part of this same session.

Rejected
: The user mentioned the device already has something called 'nuria' installed or flashed, which does not match any term found in the sm7150-mainline/postmarketOS sources searched; flashing or booting anything before that is understood risks overwriting or being inconsistent with whatever is actually there.

About
: surya-boots

---


<a id="nura-rename"></a>
### The distro is Nura now: postmarketOS renamed in September

Project
: linux-phone-oco/docs

Entry date
: 2026-11-05

Done
: Verified via search (the project's own governance document pmcr 0003, endoflife.date, and independent coverage in several languages): postmarketOS officially renamed to Nura on 2026-09-27, a post-cutoff event. Updated this repo's own prose (devices.notes, two support_status.notes) to say Nura, formerly postmarketOS, on first mention. Left untouched: source titles (they quote real external documents, written before the rename, under their real titles), and tool/package names (pmaports, pmbootstrap, the postmarketos.org and gitlab.postmarketos.org domains) - the rename announcement itself says those stay as-is while the transition completes, so rewriting them would be guessing at URLs and package names that may not have moved yet.

Considered
: Rewriting every mention of postmarketOS throughout, including source titles and URLs.

Rejected
: A source's title is a citation of a real document; it is not this repository's to edit, renamed project or not. Guessing at new URLs for domains the announcement itself says are still valid would trade a working link for an unverified one.

---


<a id="boot-confirmed-no-shell-yet"></a>
### Nura boots and is reachable on the network; no shell access without credentials

Project
: linux-phone-oco/docs

Entry date
: 2026-11-05

Done
: Rebooted the phone out of fastboot (job 0003): it is Nura, not Android, so adb does not apply at all - the real access method is SSH over a USB network interface fixed at 172.16.42.1. Confirmed (job 0004): the interface comes up and 172.16.42.1 answers ping in about 3ms, so the boot itself genuinely succeeds. Port 22 (SSH) refuses connections. Checked (job 0005) whether that meant an encrypted root filesystem waiting at a telnet unlock prompt, the standard pmOS/Nura pattern - port 23 is also refused outright, not just silent, which rules out the simple disk-unlock explanation and means neither service is enabled on this particular install.

Considered
: Trying common default usernames or passwords to get a shell.

Rejected
: Guessing credentials against a real device is not something to do unilaterally, security concerns aside from whether it would even work; the honest and correct move is to ask whoever configured this install.

About
: surya-boots

---


<a id="fresh-install-plan"></a>
### A fresh-install plan, prepared but not run: two things only the owner can answer

Project
: linux-phone-oco/docs

Entry date
: 2026-11-05

Done
: With no shell access to the existing install, the alternative is a clean reinstall. Found the pieces: U-Boot release 2025-12-02 (github.com/sm7150-mainline/u-boot), a Nura/pmOS edge build at images.postmarketos.org/bpo/edge/qcom-sm7150/, and the documented partition steps (U-Boot to boot, the decompressed boot image to cache, the rootfs to userdata). Two things block actually running it, both things only the device's owner can answer, not things to guess: (1) which panel variant this specific unit has, Huaxing or Tianma - the official wiki's own method needs adb logcat while booted into stock Android, which this phone no longer has, and picking wrong means a blank screen until reflashed with the other one; (2) whether to proceed with a destructive reinstall at all, given the existing install cannot be examined first.

Considered
: Guessing the panel variant (roughly even odds) to save a round trip.

Rejected
: Wrong is not catastrophic here (reflash fixes it) but is still avoidable, and pmbootstrap asks the installer to choose this explicitly, so the owner may simply already know which one was chosen.

About
: surya-boots

---


<a id="2026-11-09-boot-hang-and-adsp"></a>
### Boot hang found; ADSP crash loop found; lab-agent hardened

Project
: linux-phone-oco/docs

Entry date
: 2026-11-09

Done
: Audited the WCD937x patch on the lab machine (no IRQ collisions, no MMIO overlaps); proved on hardware that aoncc caused the boot hang; got SSH over USB on first boot (a preset beats Nura disable-sshd preset); found the ADSP crash loop and traced it to the sensor registry in hexagonrpcd. lab-agent: agent API, durable results, local-first monitor, GitHub budget fixes, ntfy notifications; surya-lab repo with DT audit and flash tools.

Considered
: Interrupt collisions and missing LPASS votes as the hang cause (refuted or unsupported by the audits).

Rejected
: A Python API for agents (the CLI with stable JSON is the API); a second monitor command (one command chooses local or remote).

About
: surya-boots

---


<a id="2026-11-10-stereo-and-the-picture"></a>
### Stereo speakers, shells, the grand picture, the device lab

Project
: linux-phone-oco/docs

Entry date
: 2026-11-10

Done
: Speaker stereo on surya (tas2562 slot-length fix + stereo UCM), verified by ear through PipeWire on Sxmo, Phosh and Plasma. Plasma: a saved mixer state and a tas2562 volume bug silenced the amps; found and recorded. The grand picture: tad-engine draws matrices, a 46-feature catalog against Android, iOS and Linux, the device grid, an automatic test suite whose runs are filed here, weekly feeds (the postmarketOS wiki claims, kernel work on surya), the research sorted into the orgs. The device lab: flash with the fixes built in, provisioning (packages, Wi-Fi), one phone library, an Sxmo device profile.

Considered
: Separate boards per project (labels on tasks chosen: one source of truth); a PR from the feed workflow (the org forbids it: verified data is committed instead); loosening the org policy for one feed.

Rejected
: Guessing statuses for the Linux distributions (left unknown until tests and feeds fill them); PC-side depmod when baking in a module (it made Plasma boot-loop); trusting an image by its folder name (a reference image carried an old test device tree - fingerprints now).

About
: audio-speaker

---


<a id="2026-11-10-conveyor-and-health"></a>
### The conveyor in Rust, health that watches itself, the microphone narrowed

Project
: linux-phone-oco/docs

Entry date
: 2026-11-10

Done
: devlab in lab-tools, for any phone from its manifest: reaching the phone, the safe test-kernel try (boot counting, a timeout that falls back to stock, proven live), provision, test, health and watch (a regression against everything that ever passed raises one board task; silent when well). Sound silently lost to Sxmo's loopback card as the default output: fixed by the speaker's UCM priority, and now a check. The tas2562 volume fixed (0 dB had muted the amps). sxmo-deviceprofiles repo. Board: states at a glance, waits that show themselves, mouse selection, real editing in the reply box.

Considered
: Retrying the WCD test kernel with more variations; GitHub auto-merge for releases (a workflow token's merge starts no workflows); the initramfs debug shell for unattended tries.

Rejected
: The clocks as the WCD cause (pinned on: same failure); the reset pin's mux as the cause (fixed: same failure); boot-time dyndbg for module code (it reaches only built-in code); dmesg for crash counts (a ring overwritten within minutes - the journal is complete).

---


<a id="2026-11-10-its-own-russian"></a>
### The project's own data in Russian

Project
: linux-phone-oco/docs

Entry date
: 2026-11-10

Done
: A translations table (ocoeco SPEC section 9) with this project's own feature names and categories, device parts and milestones in Russian, every row marked by machine until a person reviews it; exported through the mark, so the observatory's Russian pages read them.

Considered
: Translated columns inside the source tables.

Rejected
: That: translations never change the source; and nobody else translates this project's data.

---


<a id="2026-11-10-first-devlab-flash"></a>
### The first real devlab flash, and what a clean flash exposed

Project
: linux-phone-oco/docs

Entry date
: 2026-11-10

Done
: surya flashed from the pristine stock image by devlab flash (device tree a43d069d0a49adcd, the manifest's fixes baked in) and brought back by devlab provision: 102 GB, Firefox, the Sxmo profile, Wi-Fi, 20 of 20 checks. Two first-boot faults became the tool's job (a clock at the image's build date; a filesystem left at 2 GB on a 104 GB partition) with a new check. Then the health watch caught the audio DSP crashing on every resume - rare before the flash - which makes the old suspend crash reproducible and shows the manifest lacks a change the old system had.

Considered
: Treating the crashes as damage from the flash.

Rejected
: That: the phone's own log showed the idle suspend as the trigger; nothing was changed until the log was read.

About
: dl-safe

---


<a id="2026-11-10-its-essence"></a>
### Linux Phones tells its essence

Project
: linux-phone-oco/docs

Entry date
: 2026-11-10

Done
: Its idea written for anyone - the phone you own and do not control, a conveyor and an honest picture - and its workings: what delivers and proves each step of the paths of Linux Phones and of surya, with why we care. Three first steps of Linux Phones are left with nothing under them: nothing yet measures calls, connectivity or the daily basics on the best current Linux phone.

Considered
: Filling every step with something.

Rejected
: That: a step nothing serves should stand empty and be seen.

---


<a id="2026-11-10-idea-in-russian"></a>
### Its idea in Russian

Project
: linux-phone-oco/docs

Entry date
: 2026-11-10

Done
: The idea of Linux Phones translated into Russian in this project's own translations, by machine, for a person to correct.

---


<a id="2026-11-11-parts-measured"></a>
### Four of surya's parts no longer unknown

Project
: linux-phone-oco/docs

Entry date
: 2026-11-11

Done
: The phone's own checks were widened and its parts follow their evidence: Wi-Fi works (joined, gateway answers); Bluetooth partly (powered, hears devices; pairing untried); sensors and the fingerprint reader broken (nothing exposed - the sensor service is masked because it crashed the audio processor). Calls and messages stay unknown for a plain reason now written down: there is no SIM card in the phone. The cameras' fault is narrowed: the pipeline is there, no image sensor is bound.

Considered
: Calling Bluetooth working because it is powered.

Rejected
: That: a part works when its function was shown, not when its device appears.

About
: surya-every-part

---


<a id="2026-11-11-tad-in-rust"></a>
### tad in Rust replaces the vendored Python engine

Project
: linux-phone-oco/docs

Entry date
: 2026-11-11

Done
: This repository moved to tad in Rust: tables.toml is the authority, tad comes from its pinned release, the vendored .tad, schema.sql, load.sql and checks/ are gone. The feeds keep their SQL, now run by DuckDB's standalone binary (pinned by fingerprint) with tad checking what they write; proven to give the same rows as before, byte for byte.

---


<a id="2026-11-17-runs-gathered"></a>
### Test runs gathered, not typed

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: 9 runs of surya filed by devlab gather now (lab-tools): the 5 runs of 2026-11-10 that were never filed, and the first 4 reports the phone wrote itself with the health suite now on it.

About
: surya-tested

---


<a id="2026-11-17-the-conveyor-for-any-phone"></a>
### The conveyor for any phone

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: The phone checks its own health after every boot and every change ends with that report; gathering into this picture is one command; agents reach the phone over MCP; and a new phone's lab is now a new device.toml (linux-phone-oco/device-template).

About
: dt-any-phone

---


<a id="2026-11-17-the-face"></a>
### linux-phone's own face

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: linux-phone-oco.github.io/docs is now the Linux Phones face, drawn in this place's CI from its open database (tad) and the family as the lens gathers it; devlab files every boot's health report here by itself and the face is drawn again - proven with the run of 2026-11-16 23:45, from the phone to the page with nobody asking.

---


<a id="2026-11-17-the-organisation-set-up"></a>
### The organisation of the agents, set up

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: Four sessions at work (conveyor, bring-up, orchestration, deep-sleep research), each with a brief in prompts/; shared skills for every agent on the lab (creation-guidelines/lab-agent oco-agent/skills); a patrol every six hours checking the ways and the face; two needs of the author put on the backlog - an Android reference and a second phone.

---


<a id="2026-11-17-the-conveyor-hands-over"></a>
### The conveyor session hands over

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: Built the conveyor for any phone (the phone's own health suite, gathering through tad, support derived from results, the face drawn in CI, devlab mcp, the phone held, the device template), organised the agents (briefs in prompts/, shared skills, the patrol, land in worktrees), measured how efficiently it all runs, and handed everything to the orchestration session.

---


<a id="2026-11-10-first-real-flash"></a>
### devlab flash's first real flash

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-10

Done
: The pristine stock Sxmo image flashed to surya with devlab flash: fixes baked in, device tree a43d069d0a49adcd, the phone booted and passed all 20 checks. Two things done by hand after it became the tool's job: a fresh phone's clock is at its image's build date (certificates looked invalid) and its first boot grew the partition but left the filesystem at 2 GB - devlab provision now sets the clock and grows the system first.

Considered
: Leaving both as notes for whoever flashes next.

Rejected
: That: what must be known to use a tool belongs in the tool.

About
: dl-safe

---


<a id="2026-11-10-its-essence"></a>
### It tells its essence

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-10

Done
: Its idea written for anyone, and its workings: what delivers and proves each step of its path, and why we care. Steps that nothing serves yet are left empty, to be seen.

Considered
: Filling every step with something.

Rejected
: That: a step nothing serves is a wish, and should show.

---


<a id="2026-11-10-the-ear-in-health"></a>
### The ear in health

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-10

Done
: devlab health --hear listens as part of health: heard checks join the one baseline and regress like any other. The rule made honest rather than a second baseline: a run that did not listen is out of scope for what only listening tells. The watcher never makes a sound by itself.

Considered
: Listening after every start; a separate baseline for heard checks.

Rejected
: The first: a tone in the night. The second: two truths about one phone.

About
: dl-manual

---


<a id="2026-11-10-the-ear-on-notice"></a>
### The ear, on notice

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-10

Done
: The author corrected the withdrawal: the microphone is reliable when placed by the phone - it only was not, unannounced. The procedure is written down: notify, wait for his word, then listen. A proper rig - fixed microphone, webcam, servos - is on the backlog.

Considered
: Treating the microphone as unusable until a rig exists.

Rejected
: That: an instrument placed with care on notice is an instrument.

About
: dl-manual

---


<a id="2026-11-10-the-labs-ear"></a>
### The lab's ear

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-10

Done
: devlab hear joins what existed - the tone tool, the lab's microphone, the phone's player: the room recorded in silence, a tone played on each channel at a known volume and recorded, measured against the noise around it and the silent room. Both of surya's speakers heard on the first run. For any phone: its lab names a microphone, its manifest names the tones.

Considered
: Trusting that a loaded driver and an unmuted control mean sound.

Rejected
: That: a machine should hear it. And claiming which speaker is which - one microphone cannot tell.

About
: dl-manual

---


<a id="2026-11-11-efi-only"></a>
### Only an EFI program is offered to the bootloader

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-11

Done
: A test kernel given as Image.gz was chosen by the bootloader, counted down, and could not start - the try was lost before the kernel logged a line, and looked like 'the bootloader ignores the entry'. devlab kernel install now refuses anything that is not an EFI executable and names the right file.

Considered
: Sort keys; a stored default entry; a second boot partition - each checked on the phone and ruled out.

Rejected
: Acting on any of them before the bootloader's own record (the entry's try counter) was read.

About
: dl-safe

---


<a id="2026-11-11-efi-only-and-records"></a>
### Two refusals, and what they cost to learn

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-11

Done
: The kernel guard and the listening word, each from a mistake made today; two more steps recorded: a room of digital silence, and a try that reports its own outcome.

About
: dl-safe

---


<a id="2026-11-11-the-word-first"></a>
### The word first

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-11

Done
: A listening test now needs the explicit word that the microphone is placed, and refuses with the procedure otherwise - so the lesson of the worn microphone rests on the tool, not on memory.

Considered
: Leaving the microphone un-named as the safeguard.

Rejected
: That: a renamed file is a trick only its author remembers.

About
: dl-manual

---


<a id="2026-11-17-every-change-ends-with-health"></a>
### Every change ends with the phone's health

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-17

Done
: devlab phone reboot, kernel try and provision end with the health report of the boot they came to; proven by a reboot of surya: healthy, report brought, 3 minutes.

About
: dl-safe

---


<a id="2026-11-17-filed-by-itself"></a>
### Filed through tad, landed by itself

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-17

Done
: devlab gather now --land: one new report brought from surya, filed through tad sql into the picture, landed in surya-lab and docs in 75 s with every check passing; devlab watch now does this after every boot and says the phone's own verdict on the board.

About
: dl-reaches

---


<a id="2026-11-17-gathering-is-one-command"></a>
### Gathering is one command

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-17

Done
: devlab gather now brings the phone's reports to the lab and files every unfiled run into the picture's tables; 9 runs filed, a week of gathering by hand caught up.

About
: dl-reaches

---


<a id="2026-11-17-support-follows-the-phone"></a>
### Support status follows the phone

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-17

Done
: After filing, devlab runs every statement the picture keeps in derive/ through tad: support status is read off the latest results (broken on a failure, works on a proven pass, otherwise as judged). Proven with run 20261117-005911: filed, derived, landed - every measured part now names it.

About
: surya-tested

---


<a id="2026-11-17-the-phone-over-mcp"></a>
### The phone over MCP

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-17

Done
: devlab mcp: nine tools that let any agent run commands on the phone, move files, read and measure its health, try a kernel once and reboot - proven against surya.

About
: dl-reaches

---


<a id="2026-11-16-joined"></a>
### Joined the Open Commons Observatory

Project
: linux-phone-oco/device-template

Entry date
: 2026-11-16

Done
: The mark, the gatherer's caller and a place for this project's own records, written by ocoeco init.

---


<a id="2026-11-17-made"></a>
### The template, made

Project
: linux-phone-oco/device-template

Entry date
: 2026-11-17

Done
: Made from what was proven on surya the same day: the phone checks its own health after every boot, every change ends with that report, gathering is one command, and devlab mcp is the door for agents - all read from device.toml.

About
: dt-any-phone

---


<a id="2026-11-17-research-microphones"></a>
### Feature research: the microphones of surya and its family

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: Read the vendor bolero sources, pulpoff/linux-surya, sm7150-mainline PR 60 and the siblings (subagent sweep); found surya's mics analog and the DMIC lead closed - bring-up proved both mics meanwhile; recorded three research rows, eight sources, the decision 2026-11-17-microphones-analog-wcd-path, five steps on the backlog; quoted the reserved word by in the source and problem records (both failed for everyone); added the test named record (tests rows had been edited by hand).

Considered
: A mic-top-records check: dropped, bring-up's mic-top-hears-speaker proves more. Running checks on the phone myself: experiments are bring-up's.

Rejected
: A parallel upstream series; the DMIC/VA clock model for surya.

About
: audio-mic

---


<a id="2026-11-17-research-echo-call"></a>
### Research: calls proven by an echo call, and how the health suites are organised

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: Read the phone (read only): the modem is online on LTE, Vodafone.de, data attached; q6voiced and callaudiod installed; no voice PCM in the kernel. Found one attested German echo line (blueSIP 99701) and its tone line (99702); read pulpoff/linux-surya's call path; designed the echo-call check and the data budget; surveyed the suites (shell checks with awk Goertzels, the tone crate never on the phone, no Rust toolchain on the phone, cargo script still nightly). Decided 2026-11-17-calls-proven-by-echo-call and 2026-11-17-health-checks-shell-and-rust; backlog calls-q6voice-kernel to calls-echo-check, health-data-check, health-analysis-in-rust, health-coverage-query; wrote surya-lab's failing check call-audio-path.

Considered
: A digital loop through in-call record ports; a two-phone stand; a programmable number; rust-script on the phone; every check in Rust.

Rejected
: Python checks; sipgate's SIP-only echo; a call on every boot.

About
: modem-calls

---


<a id="2026-11-17-research-expert-agents"></a>
### Research: standing expert agents or written expertise

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: Read Anthropic's guidance (context engineering, long-running harness, agent teams, multi-agent research), Cognition, LangChain, Gas Town, ACE, MAST, Chroma, blackboard papers, Letta; recorded 11 sources, research expert-agents-written-not-standing, decision 2026-11-17-experts-written-not-standing, backlog expert-primer and briefs-end-and-route.

Considered
: Standing experts with routed questions; agent teams; subagent memory; per-domain Markdown notes; memory services; forking an expert session to consult it.

Rejected
: See the decision's rejected.

About
: expert-primer

---


<a id="2026-11-17-conveyor-health"></a>
### Analysis in Rust on the phone, and mobile data under a budget

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-17

Done
: lab-tools #57, #60, #62 and releases 0.1.2, 0.1.3, 0.1.4; surya-lab #115 and #116; devlab installed from main (the previous one kept at ~/.local/bin/devlab.before-data-budget). devlab-health 0.1.4 put on surya, and suite run 20261117-093527 was healthy, with the tone checks and mobile-data passing. The static aarch64 runner went from 528,656 to 594,192 bytes. Signs seen: land exited 1 with nothing said when GitHub refused a merge for a conflict (main had moved); release PRs' ci runs fail to start, as before; one run's earpiece recording held exact zeros (-240 dBFS) right after suite put, and two runs of the check alone passed at -22.3 dBFS.

Considered
: A telephony-layer mobile-data check gated by once_a_day, as the layer's README first said; a hand-written WAV reader in the runner.

Rejected
: See decision 2026-11-17-health-analysis-subcommands.

About
: dl-reaches

---


<a id="2026-11-17-research-idealkb"></a>
### Research: an ideal knowledge base, and docs on it

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: Read the world's practice (17 sources, kb-organisation-world), the commons' (kb-organisation-commons) and measured three typical questions on docs (kb-navigation-measured). Proposed 2026-11-17-ideal-knowledge-base, with backlog kb-about-link, kb-entry, agent-folder and idealkb-from-template. No structure changed.

Considered
: A new repository beside the template; the playbook or ideal-agent as its home; moving the database into a named subfolder; llms.txt, embeddings, a questions table.

Rejected
: All but the template grown into idealkb, the root kept as the base and only the agent folder moved - see the decision's rejected.

About
: kb-about-link

---


<a id="2026-11-17-about-link"></a>
### Every record names what it is about; one query for a subject's whole knowledge

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: First step of 2026-11-17-ideal-knowledge-base. Declared about on research, backlog, session_log and concepts, and a references rule on all five record tables; the rule found decisions' about in four spellings (11 rows) and they became plain ids. Backfilled 185 rows; records take --about; queries/about.sql answers a subject in one call (prefix words: modem, audio) and lists subjects without one; AGENTS.md says to ask it instead of reading pages. ocoeco's language (reasoning.toml) now lets a decision be about a component, feature or device, as well as a milestone, concept or backlog item. Measured again: the microphone 22 KB against 206 KB of pages, the modem 17 KB; expert-primer is done by it.

Considered
: A list-valued about (several subjects per record); full ids (linux-phone-oco/docs/milestones:x) as ocoeco writes them; mapping features to components.

Rejected
: A list: tad's references check one value, and one subject per record kept every row decidable. Full ids: tad cannot check them, and the face's badges match plain ids - the four decisions about surya-sound showed none. A feature-to-component map: a hardware record names the component (audio-mic), an ability the feature; the about query reads both by id.

About
: kb-about-link

---


<a id="2026-11-17-agent-folder"></a>
### The agent specifics in their own folder

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: prompts/bring-up.md, feature-research.md and orchestration.md moved into ideal-agent-linux-phone-oco/ (git mv, history kept), beside the phone keeper's brief; a README there lists the briefs with their ideal-agent skill and holds practice 42's domain part (one database, --about, signing and landing, the phone only by its keeper). Pointers fixed: the briefs' own, the keeper brief's, AGENTS.md, ~/.claude/scheduled-tasks/linux-phone-patrol. Rows that name prompts/ stay as they were said.

Considered
: Leaving prompts/ as a link to the folder.

Rejected
: A link: two names for one place, the overlap this folder ends.

About
: agent-folder

---


<a id="2026-11-17-idealkb-on-tad"></a>
### idealkb corrected: a layer on tad, not the template renamed

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: Recorded the author's correction (relayed by the conveyor session): tad stays a database; idealkb is a new repository that pins tad and adds the knowledge-base layer; a bare database starts with tad itself (tad init); text-as-data-template hands its pieces to both, its reasons carried over, and is retired with a pointer. Decision 2026-11-17-ideal-knowledge-base and idealkb-from-template rewritten to match. Record only: building waits for the author's word.

Rejected
: The first form, the template renamed into idealkb: a database's scaffold folded into a knowledge base.

About
: idealkb-from-template

---


<a id="2026-11-17-pixel-2-survey"></a>
### The Pixel 2 and 2 XL on the radar, from sources

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: Surveyed walleye and taimen from published sources; added devices rows with their SoC (joining the SoC families view), 21 unknown parts each with the reports in the notes, taimen's wiki claims through the wiki feed (now one page per phone), sources and research; records device, device-source, support-unknown added.

Considered
: Writing the claims by hand: the feed would delete them on its next Monday run.

About
: google-taimen

---


<a id="2026-11-17-idealkb-built"></a>
### ideal-knowledge-base built; docs its first follower

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: tad init (tad-engine #85, tad 0.7.0). grenudi/ideal-knowledge-base #1 and release 0.1.0: five generic queries tried first against docs' data, standing tables, the entry, bin/follow.sh and bin/update-pins.sh now. text-as-data-template retired (#15, archived). docs pins idealkb 0.1.0 with its own extensions named own, and AGENTS.md went from 7.9 KB to 2.1 KB.

Considered
: A declaration tad includes from another file; generic queries that know project.

Rejected
: Each fits one base and not the next (decision 2026-11-17-follow-by-pin in ideal-knowledge-base).

About
: idealkb-from-template

---


<a id="2026-11-17-summary-and-research-layers"></a>
### Summaries and research material, applied once

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: Pinned idealkb 0.3.0; docs' own about, research record and tables.toml took summaries, material and supersedes. audio-mic summarised: its answer 15.9 KB to 4.8 KB. Open Handset Commons moved to research/open-handset-commons/2026-11-10/ with its row open-handset-commons-model. Three subjects left due (summaries-due).

About
: kb-summaries

---


<a id="2026-11-17-orchestration-3-start"></a>
### Orchestration renewed: keeper start measured, try read by initramfs, phone-next

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: Took over from orchestration-how-it-stands. Measured the 12:33 scheduled keeper (45833ff5): first turn 75,649 tokens, 39 KB read in 11 results before its first act, 26 min to it; sent to ideal-agent, who notes it is not comparable to surya-keeper-2 (scheduled route, before the connector change). Most of the read was the queue asked five times (~13 KB) plus a 5 KB tad sql: added queries/phone-next.sql (one row, 0.6 KB vs 14.9 KB) and named it in phone-keeper.md's first paragraph. Landed lab-tools PR 71 (try-kernel-read-as-stock).

Considered
: A --next flag on phone-queue; rebooting to stock at the end of every try.

Rejected
: --next flag: a named query of its own says what it is and stays one word. Reboot at the end of try: the try's health is read on it and bring-up keeps working on it; saying plainly that it stays is enough.

About
: agent-folder

---


<a id="2026-11-17-lpoco-health"></a>
### lpoco-health: the one health suite

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-17

Done
: Looked around (research 2026-11-17-lpoco-health-landscape), renamed devlab-health to lpoco-health, added run-time conditions (no-sim, no-modem, no-network), switches with reasons on the phone (lpoco-health off|on|list), argenv command line, devlab suite off|on|list and MCP tools, migration of reports/ledger/marks, conveyor names (lab-tools #75). Nothing done on the phone: its put is on the phone queue.

Considered
: rust-script tests and a bundle crate; per-test binaries; package-first provisioning

Rejected
: see decision 2026-11-17-lpoco-health

About
: lpoco-health

---


<a id="2026-11-17-docs-follows-ikb-0-1-1"></a>
### docs follows ikb 0.1.1

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: docs pins idealkb 0.6.1 and takes ikb 0.1.1: IKB.md is generated (ikb page --write) and kept fresh by make verify; machine records are named in idealkb.toml. It's the first follower of ikb.

About
: ikb-recording

---


<a id="2026-11-17-walleye-lane-started"></a>
### The walleye lane started

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: Lab repository linux-phone-oco/google-walleye-lab made from device-template (manifest and mark landed, pull 1) and added as a place in docs; coordinator brief written; decisions walleye-fastboot-first and walleye-lab-repo; devlab fastboot mode asked of orchestration.

Considered
: next: walleye keeper and research sessions

About
: google-walleye

---


<a id="2026-11-17-walleye-vendor-research"></a>
### Walleye research: vendor GPL kernel, how others booted it, Android reference

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: Read walleye's (HTC 'muskie') device tree in LineageOS' wahoo kernel and kcxt's mainline tree; hardware table kept as material; read pmOS, kcxt, LKML, LineageOS, Ubuntu Touch and Halium sources for how Pixel 2 phones were booted without a display; collected public Android reference numbers; 3 research rows, 16 sources, 2 backlog items.

Considered
: A full clone of the kernel (about 1 GB) - single files read through the raw host instead.

Rejected
: Copying panel init sequences, battery profiles or firmware names into records: facts for a table only, the GPL file is named where a later port needs it.

About
: google-walleye

---


<a id="2026-11-17-walleye-mainline-research"></a>
### Pixel 2 mainline fastboot boot: the shortest honest path, from sources

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: Read kcxt/linux-wahoo (wahoo/5.17), porthole-dev/pmaports taimen-bringup (7.2.2 + 263 patches, walleye patch 0029), mainline v7.3 MSM8998 boards and drivers, Google's GPL wahoo device-tree sources, the Nura taimen page; recorded 4 research rows, 5 sources, one decision (first kernel) and 8 bring-up items with their proofs. The phone was not touched.

Considered
: Adopting porthole's kernel whole; starting from kcxt's 5.17; a display-first start; flashing the stub dtbo first.

Rejected
: All four: see decision 2026-11-17-walleye-first-kernel. Side finding: this base's make verify rewrites IKB.md with the installed ikb (one-line wording), so the file differs from main after any ikb call - not committed here.

About
: google-walleye

---


<a id="2026-11-17-briefs-restored"></a>
### The briefs' role start restored after a stale branch reverted it

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: docs 226 (walleye research), merged a minute after 230, carried the briefs as they were before 230 and reverted all eight: oco-work and OCOECO_BY came back to every start, so keepers started after it read the old start. Restored the eight briefs exactly as 230 left them (nothing else touched them since). surya-coordinator.md now says how a keeper's start reads: the three Role/Name/Also-practices lines, the brief by its path (a keeper had searched ~/Projects for phone-keeper.md, 2.4 KB), no export, no oco-work.

Considered
: Reverting 226 whole; asking the walleye research session to fix its own merge.

Rejected
: Reverting 226 whole: its research files are good and wanted. Asking its session: it may have ended, and the briefs are orchestration's.

About
: agent-folder

---


<a id="2026-11-17-1900-how-the-phone-stands"></a>
### How the phone stands

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: surya-keeper: sensors-registry-writes first try. Built hexagonrpcd of hexagonrpc PR #27 (40e5041) for aarch64 by hand, ran it once over a state copy of the registry: the DSP's write of /../sns_reg_version is outside the mapped tree and answered ENOSYS, the ADSP dropped. Phone rebooted twice (audio only came back on the second), healthy 35 pass 0 fail, kept kernel 7.1.0-sm7150-calls+, sensorspd and rootpd masked, nothing kept, state copy and binary removed.

Considered
: next: sensors-registry-writes stays open - second try needs a patch to PR #27's build: serve /../sns_reg_version as a writable file in the state root and map sns_reg_config (research 2026-11-17-pr27-registry-try); the host build tree is not kept - clone hexagonrpc and fetch pull/27/head. Expect two reboots after a crash. sleep-fastrpc-helpers still waits on it.

---


<a id="2026-11-17-ideal-agent-upstream"></a>
### ideal-agent is an upstream; briefs are a starting point

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: README of the agent folder says every brief and the author's words are a starting point (look-around-first, practice 22) and coordinators research a missing method on their own; grenudi/ideal-agent added as an upstream, how: a pull request through its owner session. With orchestration's yes.

Considered
: Free text for how items are sent (the record has a how field).

Rejected
: Editing ideal-agent from docs (its owner decides).

About
: agent-folder

---


<a id="2026-11-17-research-bringup-tools"></a>
### Research: where bring-up tools live and what they are called

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-17

Done
: Read our records (rust-toolset, device-template, health-checks-shell-and-rust, lpoco-health landscape), walleye's eight scripts and devlab; a researcher read the outside (mkbootimg, avbtool, magiskboot, abootimg-oxide, cpio, dtoolkit, pmbootstrap, lk2nd, Droidian). Recorded research bringup-tools-landscape, eight sources, decision 2026-11-17-bringup-in-lab-tools, and five backlog items (bringup-image-v0 first, with its failing test named).

Considered
: New repository; devlab subcommands; a shared shell library; porting mkbootimg/avbtool first; magiskboot as a dependency.

Rejected
: linux-phone-oco-bootstrap-helpers / lp-oco-bh, bootstrap, bootkit, bootimg, imgtool, mkboot (reasons in the decision). Nothing was built and no device touched.

About
: bringup

---


<a id="2026-11-17-research-bringup-follow"></a>
### Research: how device repositories follow and extend bringup, and what rhizoid lacks

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-17

Done
: Read idealkb's chain-follow decision and research and rhizoid's design log and backlog. Recorded research bringup-home-follow-and-rhizoid (five sources), re-recorded decision 2026-11-17-bringup-in-lab-tools with the follow, extend, send-back and rhizoid parts, added backlog bringup-pin-and-hooks and bringup-release, updated device-template-names-bringup. Filed three items on rhizoid's own backlog (git-rhizoid.github.io PR 28).

Considered
: Tools as a slice; each device a cutting; subtree or submodule; a plugin loader in the tool; waiting for rhizoid.

Rejected
: All of those, reasons in the decision. Nothing built.

About
: bringup

---


<a id="2026-11-17-walleye-rows-moved"></a>
### Walleye's rows moved to google-walleye-lab

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: google-walleye-lab #14 gave the lab its base; under the lease orchestration-move 41 backlog, 20 research, 7 decisions, 10 log and their research/ folders moved there (decision 2026-11-17-moving-a-lane), and docs lost them; the walleye coordinator brief and the walleye-keeper, walleye-research and walleye-builder launchers now read the lab's tad q phone-next / lane-next and record with ikb. surya-lab #134 gave surya its base; device-template got lane-next.

Considered
: Carrying docs #316's two unlanded rows (s0n try): left to the walleye coordinator, as they contradict what main holds.

About
: move-device-rows

---


<a id="2026-11-17-feed-device-bases"></a>
### docs pulls each device base's parts

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: devices.base field and records/device-base.sql (walleye named; surya's name waits for its rows to move: its parts.json is empty now, so naming it would turn its status unknown on the next feed); records/feed-device-parts.sql and device-parts-unknown.sql, run per device by bin/run-feeds.sh; derive-support-status leaves devices with a base alone; feeds.yml daily. make feeds pulled walleye's 21 parts, all unknown (its base says so); an unreachable base tested on a made-up base: all unknown, 'not known yet'.

Considered
: A single feed record over all bases: DuckDB aborts the statement on one 404, so the runner loops per device and falls back.

About
: feed-device-bases

---


<a id="2026-11-17-surya-rows-moved"></a>
### Surya's rows moved to surya-lab

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: In surya's standby window, under the lease orchestration-move: its 143 runs (5456 results), 20 parts (from support_status), 48 backlog, 34 research, 23 decisions and 52 log entries moved to surya-lab's own base and left docs; besides the lab's project, the docs-project research, decisions and log about surya's own parts and measurements moved too (the floor, the sensor registry, the microphone path, standby drain), method and family research stayed. The surya coordinator and keeper briefs, the surya-keeper and surya-research launchers and the waker read surya-lab (phone-next, lane-next, phone-stands) and record with ikb; phone-stands left docs; devlab gather files into the lab's base (lab-tools #82). docs' support_status for surya stays as last derived until feed-device-bases pulls the parts. The docs rows were deleted through tad sql with TAD_SQL_WRITE_OK=1, the one-time migration the guard allows (decision 2026-11-17-moving-a-lane).

Considered
: Waiting for the tad release before the move: the standby window (phone unplugged, no keeper) was the one quiet hour, so the rows were replayed with tad built from tad-engine main (references by key) and landed after the pin moved.

About
: move-device-rows

---


<a id="2026-11-17-surya-base-named"></a>
### surya's base named: docs pulls its parts

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: devices.xiaomi-surya.base = linux-phone-oco/surya-lab (record device-base), now that surya's rows and parts have moved (surya-lab #136); the feeds pull its parts as they do walleye's.

About
: feed-device-bases

---


<a id="2026-11-17-lpoco-dispatcher"></a>
### lpoco dispatcher built and landed

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-17

Done
: New workspace member lpoco (argenv, no tokio): failing tests first, then dispatch by path (beside itself, then PATH), version check against --version, list, --version, completions, man; lpoco-health gained --version; release-plz version_group for the family.

Considered
: Reading args after NAME through argenv: no, they belong to the program, so only built-ins and flags are declared.

Rejected
: A shared family tag (breaks the conveyor prefix).

About
: lpoco-dispatcher

---


<a id="2026-11-17-bringup-image-v0"></a>
### bringup image v0 built and landed

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-17

Done
: Failing proof test committed first (fixtures: kernel, ramdisk, appended dtb, walleye [boot]); measured abootimg-oxide against mkbootimg; built lpoco-bringup image info|unpack|pack|check; landed as lab-tools PR 85; main read back.

Considered
: Wrapping mkbootimg for pack (not needed); adding [boot] to devlab's reader (devlab ignores unknown tables, so the table lives in the bringup library until devlab needs it).

About
: bringup-image-v0

---


<a id="2026-11-17-rename-lab-tone"></a>
### devlab becomes lpoco-lab, tone lpoco-tone

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-17

Done
: Renamed the two packages, kept devlab and tone as second binaries of the same source, joined both to the family version and release-plz group, README note, test devlab/tests/one_program.rs. CI first failed on a clean build (the list test saw only some binaries); the test now builds the workspace's binaries first. Read back from main: devlab/Cargo.toml names lpoco-lab.

Considered
: Tiny alias bin files with include! to avoid cargo's duplicate-target warning.

Rejected
: Alias bins: more files for a warning that cargo only prints at the manifest; two [[bin]] on one path is the plain form. Rewriting devlab's clap parser to argenv here: out of this item's scope, a separate change.

About
: lpoco-rename-lab-tone

---


<a id="2026-11-17-lpoco-mcp-one-door"></a>
### lpoco mcp: one MCP door for the family

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-17

Done
: Wrote the proof test first (failed: no mcp built-in), then lpoco mcp, lab_ aliases, bringup_image_info/check tools; landed as lab-tools#87 and read back from main.

Considered
: A merging proxy over each program's own mcp; one router with prefixed names.

Rejected
: The proxy, see decision 2026-11-17-mcp-one-door-by-prefix. health has no phone-side MCP of its own: its tools stay the lab's health_* ones.

About
: lpoco-mcp-one-door

---


<a id="2026-11-17-bringup-pin-and-hooks-built"></a>
### bringup pin and hooks built

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-17

Done
: Failing tests first, then pin module, parts hook, documented library and examples/step.rs run by rust-script; CI first failed for lack of rust-script, fixed by installing it in ci.yml; landed as PR 88 and read back from main.

Rejected
: Skipping the script test without rust-script.

About
: bringup-pin-and-hooks

---


<a id="2026-11-17-bringup-release"></a>
### bringup install from tag

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-17

Done
: Wrote install_from_tag test first (failed: released 0.1.7 tags had no pin, and the tags sat on different commits). Landed release PR 84 by hand (land --release did nothing), which made 0.2.0 tags on one commit and broke bringup_refuses_wrong_pin (pin 0.2 now right). Test and fix landed in lab-tools #90 with README install section; CI green, read back from main.

Considered
: Release assets vs cargo install --git.

Rejected
: Release assets: not needed while hosts have cargo. Note: land --release exits silently without merging; merged PR 84 with gh pr merge.

About
: bringup-release

---


<a id="2026-11-17-orchestration-lpoco-roof"></a>
### Orchestration: the lpoco roof, six pieces landed

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: One builder at a time in lab-tools, each read back from main: lpoco-dispatcher (#83), bringup-image-v0 (#85), lpoco-rename-lab-tone (#86), lpoco-mcp-one-door (#87), bringup-pin-and-hooks (#88), bringup-release (#90; release v0.2.0 #84, every family tag on one commit; install by cargo install --git --tag). From piece 3 on, the builders came from the coordinator's stored launcher lab-tools-builder, ordered by rank. Along the way: docs retired its lane queries (#368, decision 2026-11-17-docs-serves-no-lane); ranks set; leftovers queued (lpoco-lab-argenv, lpoco-names-sweep, docs-phone-items-to-lanes); the launcher's first run read a stale shared clone, and the coordinator's prompt now makes fresh worktrees; a reboot stopped piece 5, which was resumed in its own session; sign land-release-silent recorded.

Considered
: Starting each builder as its own session (refused on turns started by another session; the launcher answers that).

About
: bringup

---


<a id="2026-11-17-research-lab-host"></a>
### Research: preparing the lab host from declarations (lpoco host)

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-17

Done
: Read the roof decision and its follow-ups, lab-tools (devlab provision, device reader, health/build.sh, bringup pin), lab-machine (setup, watcher unit, bin/land), lab-agent and ideal-agent's retirement decision (root-exec part 6), walleye's device.toml [host] (lab PR 54) and today's session logs (root-exec uses); measured the lab host read-only (systemd 262, groups, seat0 session, rules, modules, packages, units, ~/.local/bin). A read-only researcher read pmbootstrap, android-udev-rules, systemd's uaccess source and NEWS, nixpkgs, Ansible, LAVA and labgrid. Recorded 9 sources, research lab-host-prepare-landscape (material research/lab-host/2026-11-17/), decision 2026-11-17-lpoco-host, backlog lpoco-host (rank 1, needs build, google-walleye; the author's acceptance and the coordinator's host-tools test added) and lpoco-host-rest, research lpoco-host-how-it-stands. Nothing changed on the lab host.

Considered
: A lpoco lab host subcommand; lab-machine's scripts fed by device.toml; LAVA's static rule and root helper; a package or confext; systemd built-ins alone; a lab group first; pins in device.toml vs the lab's own lab.toml.

Rejected
: See decision 2026-11-17-lpoco-host: names labprep, hostprep, setup, provision, bootstrap, prepare, machine, env; forms above; pins in device.toml (one ~/.local/bin, tools no device owns); a hand-written udev rule meanwhile (the author waits for the tool).

About
: lpoco-host

---


<a id="2026-11-17-lpoco-host-built"></a>
### lpoco-host built and landed (lab-tools #91)

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-17

Done
: New crate host/ (lpoco-host, argenv): plan (default, changes nothing), prepare now (the printed root commands only), check. Proof tests host/tests/plan.rs: plan_grants_gadget_serial_and_changes_nothing failed first, then passed with plan_lists_host_tools_at_pins_and_installs_nothing, prepare-now, injection-refused, wide-rule and old-devlab tests. Review by programmer: fixed unvalidated codename/serial/module words (refused unless letters digits . _ -), tty open now O_NONBLOCK|O_NOCTTY, full X.Y.Z lab pin, unknown tools must be 'unknown', stage dir 0700 and removed, tests read the host's files under LPOCO_FS_ROOT, one manifest per codename (clones and worktrees of a device repo found by the glob). 51-android.rules named and kept; old devlab 0.1.0 first on PATH shown off the pin; oco-work listed as not known yet. Read plan on this lab (read-only): walleye rule + modules file new, health and host not installed, devlab 0.1.0 off the pin. Acceptance not run: prepare now belongs to whoever holds the lab with the walleye keeper.

Considered
: A udev trigger by --attr-match=serial matches only the USB device itself, not its block/tty children: a second trigger by subsystem is printed after it; to be proven by the acceptance run. lpoco-health and lpoco-host are not installed here yet (release tag needed).

Rejected
: Running prepare now here (host is shared; orchestration's boundary). Removing 51-android.rules (the author: keep it for now). Duplicate devices per worktree (first host-declaring manifest wins, conflicts named).

About
: lpoco-host

---


<a id="2026-11-17-lpoco-family-answers-help"></a>
### lpoco family answers --help

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-17

Done
: Wrote tests/help.rs per crate (failing: '--help is not a declared flag'), declared HELP (-h/--help) once with argenv in four cli.rs, usage printed from the records; landed #93 and release v0.2.2, read back from main and tag.

Considered
: A shared help crate for the family.

Rejected
: A shared crate: one 25-line fn per crate is smaller than a new release unit, and health ships to phones. Hand-written usage text: it would drift from the declaration.

About
: lpoco-host-help

---


<a id="2026-11-17-briefs-in-head-form-for-the-stored-starts"></a>
### Briefs in head form for the stored starts

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: Added patrol.md (linux-phone-patrol's round) and builder.md (lab-tools-builder, walleye-builder, keyed by Name); folded walleye-keeper into phone-keeper.md (one brief for both lanes, keyed by Name); added the lane research launchers' section to feature-research.md; README indexed them, checked against ideal-agent 0.3.27. overlay-check: all briefs under 15% (max 11%, the new ones 0-5%).

Considered
: What each of the seven stored prompts holds, line by line, so the coordinator can cut them to head plus Brief: (decision 2026-11-17-a-stored-start-is-a-head-and-a-brief).

Rejected
: One brief per launcher (two share a brief where only the place differs, keyed by Name); restating the patrol card's report shape and transcript checks in patrol.md (the card holds them).

About
: agent-folder

---


<a id="2026-11-18-lpoco-host-script-tools"></a>
### lpoco host: script tools by rev stamp

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: Landed lab-tools #95: stamp per script tool judged by rev, devices list, advice text; programmer review fixed three points (stamp only counts with the script present, rev refuses whitespace, README).

Considered
: Judging a script by content hash of the file against the clone at rev

Rejected
: Content hash: needs the clone present just to plan; teaching land and agent-env --version: owned by other repos. Dropping the version field: breaks existing lab.toml.

About
: lpoco-host-script-tools

---


<a id="2026-11-18-lpoco-lab-on-argenv"></a>
### lpoco-lab on argenv

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: Failing test first (devlab/tests/help.rs), cli.rs declaration + TREE, parse() in main.rs, programmer review answered (per-action flags, exit 2, help wins, README), landed lab-tools #98.

Rejected
: see decision

About
: lpoco-lab-argenv

---


<a id="2026-11-18-names-sweep-readme"></a>
### Names sweep: lab-tools README

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: lab-tools README commands now say lpoco lab / lpoco tone (24 commands); lpoco/tests/readme_names.rs fails on an old name starting a command; landed as lab-tools #99, read back from main; programmer review applied (cargo fmt).

Considered
: Next slices by orchestration's order: docs briefs and AGENTS.md, device-template; surya-lab and google-walleye-lab via their lane coordinators.

Rejected
: Changing real paths (~/.config/devlab, hook path, mcp add line): aliases and state dirs stay until the alias grep finds no caller.

About
: lpoco-names-sweep

---


<a id="2026-11-18-names-sweep-slices-2-3"></a>
### Names sweep: marks, docs briefs, device-template

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: lab-tools #100 (oco.toml name/title, lpoco-health service Description; test lpoco/tests/marks_names.rs, seen failing first); docs #400 (six briefs in ideal-agent-linux-phone-oco/ say lpoco lab; overlay-check passes, builder.md and devlab-watch@ left); device-template #12 (docs, comments, command lines). Each programmer-reviewed before land. surya-lab and google-walleye-lab: line lists sent to their lane coordinators, landing only what each agrees to.

Considered
: The state dirs and /usr/lib/devlab path are real paths: kept. linux-phone-keeper-waker is the coordinator's: named, not touched. Docs history rows in data/ stay.

Rejected
: A test in device-template for the sweep: it has no Rust crate, and lab-tools' tests already keep the generated names; a grep-only check there would be one that only prints.

About
: lpoco-names-sweep

---


<a id="2026-11-18-names-sweep-lanes"></a>
### Names sweep: surya-lab and google-walleye-lab

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: surya-lab #166 (8 files: AGENTS, README, comments in device.toml/idealkb/tables/phone-queue.sql/test-run.sql, research/microphone.md) and google-walleye-lab #100 (10 files) landed after each lane coordinator said yes to the exact list; phone-queue and phone-next rows identical before and after, tad check green, programmer-reviewed, read back from main.

Considered
: Remaining old names: history rows, research/**, keeper-run scripts (surya way-back.sh, sensors-install.sh, switch.sh, call-echo.sh, health shell tests; walleye tests/host, build/*.sh, init scripts), lab host files, devlab-watch@, linux-phone-keeper-waker, the tools' own help text (lpoco lab mcp --help says devlab's door).

Rejected
: Sweeping scripts the keepers run and the history: the coordinators said no, and they call the aliases which stay until a grep finds no caller.

About
: lpoco-names-sweep

---


<a id="2026-11-18-lpoco-tone-on-argenv"></a>
### lpoco-tone on argenv

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: Proof test first (red), cli.rs and main.rs on argenv, clap removed; programmer review found silent defaulting of out-of-range rate/channels, fixed with tests; landed lab-tools #101, release v0.3.1 landed (#97), read back from main.

Rejected
: Fixing zero-value panics only by recording them: refused at the edge instead (cheap).

About
: lpoco-tone-argenv

---


<a id="2026-11-18-lpoco-lab-env-through-argenv"></a>
### lpoco-lab env through argenv

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: Built lpoco-lab-env-through-argenv: DEVLAB_ROOT, LAB_AGENT, PHONE_PASS, DEVLAB_MICROPHONE, HOME read once through cli::env(); two proof tests (source scan, empty DEVLAB_ROOT exits 2); programmer review applied; landed as lab-tools #103.

Considered
: Passing &EnvIn through every function (pure core) - kept a set-once global as the readers are many.

Rejected
: Declaring defaults on the String inputs - not checked that argenv supports it; left in env_in. Per-command refusal of empty DEVLAB_ROOT - refused at parse for one rule.

---


<a id="2026-11-18-names-sweep-messages"></a>
### Names sweep: lab-tools messages

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: About 20 messages and the gather --land help said devlab; now lpoco-lab. New test names_in_messages.rs failed first, then passed; programmer review found nothing parsing the strings. Landed as lab-tools #104 (cargo fmt fixed after a failed check), read back from main.

Considered
: Next slice: guard.rs and hold.rs messages, then source comments.

Rejected
: Renaming env vars, the state dir and the 'by' default: they are interfaces and recorded values, they stay until the aliases go.

About
: lpoco-names-sweep

---


<a id="2026-11-18-suspend-irq-quiet-check"></a>
### Suite check suspend-irq-quiet

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: Built suspend-irq-quiet-check: 92-suspend-irq.sh, manifest fields suspend_irq_max and suspend_guard, test row. Proof test failed first, then 8 pass. Programmer review found: alarm not read back, no alarm clear on signals, fail-open when suspend counter or interrupts unreadable, garbled guard message, racy and hang-prone tests; all fixed. Landed as lab-tools #106, released v0.3.3, read back from main.

Considered
: A measured duration check (woke early skips).

Rejected
: A guessed default threshold: unset says not measured. Reading the watchdog directly: the guard is a manifest command, as the device owns how it is armed.

About
: suspend-irq-quiet-check

---


<a id="2026-11-18-lab-tools-builder-host-origin-main"></a>
### lpoco host reads origin/main

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: Failing test first, then device_text in lpoco-host; programmer review fixes (bounded non-prompting fetch, reasons on every fallback, differing-file note, read: line in every verb, exact git subcommand filter in tests); landed #108, released v0.3.4.

Considered
: Fetching only in plan.

About
: lpoco-host-reads-origin-main

---


<a id="2026-11-18-bringup-image-swap"></a>
### bringup image swap built and landed

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: image swap in lpoco-bringup: parts replaced in a control image, AVB hash footer rebuilt through avbtool (NONE; partition, salt, props, rollback index, hash algorithm, flags carried), what differs said. Proof test seen failing, then passing; programmer review fixed four defects (dropped footer facts, footerless size, wrong footer size, dead code). Landed lab-tools#110, read back from main; release PR 109 landed.

Considered
: a pure-Rust footer writer (no crate exists)

Rejected
: Rebuilding a signed vbmeta or multi-descriptor footer on a guess: refused with a message instead. avbtool verify_image as the test's check: it crashes looking for boot.img, so info_image is used.

About
: bringup-image-swap

---


<a id="2026-11-18-release-one-version"></a>
### release check: kinds and changelog

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: Built commit-kind workflow and release_family tests, landed in lab-tools #112, review by programmer applied; v0.3.5 release #111 landed and carries #110.

Considered
: release-plz.toml already named the workspace packages, so only the lack of a kind check remained.

Rejected
: tag-vs-changelog test (tag precedes changelog)

About
: release-plz-one-version

---


<a id="2026-11-18-changelog-completes-version"></a>
### release check accepts a completing changelog

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: Landed lab-tools #116: check-changelog.sh with tests (failing first), merge-base, per-package [package] version, quoted/spaced names; programmer review's four bugs fixed.

Rejected
: Global version-bump test (old check): a bump elsewhere excused any changelog.

About
: release-plz-one-version

---


<a id="2026-11-18-release-plz-no-loop"></a>
### release-plz stops releasing its own release commits

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: Test first (red: no release_commits), then release_commits in release-plz.toml; programmer review found no blocker; landed as lab-tools #119, read back from main.

Considered
: One release PR writing every changelog (no follow-up)

Rejected
: One release PR for all changelogs: needs release-plz to change its own PR shape, not in its config. Listing chore among released kinds: that is the loop. A chore! breaking change no longer releases (accepted; the commit-kind lists must stay in step).

About
: release-plz-one-version

---


<a id="2026-11-18-patrol-0508"></a>
### Patrol round 2026-11-18 05:08 UTC

Project
: linux-phone-oco/docs

Entry date
: 2026-11-18

Done
: Read-only round: nothing changed, no sign filed. Landings (6h): docs 20+, lab-tools, device-template, surya-lab, walleye-lab all by PR, device rows in their own bases. devlab-watch@surya-lab active; its log shows the phone not reachable (parked, expected: author power cycle, backlog surya-unreachable-after-suspend); pages build green x3; lpoco host check tool FAILs known (lpoco-host-script-tools). Walleye phone off USB, parked on author (walleye-phone-needs-hands), expected. Launcher runs of walleye-keeper and lab-tools-builder all succeeded and reported. Start weight: patrol 26339, phone-keeper 30319 highest, no budget named here so none called over. Read-weight of transcripts, other launchers' runs: not known yet.

Considered
: filing the truncated-journal lines in the watch log: they stopped at 00:58, not repeating

Rejected
: a sign on the host tool FAILs: already on a backlog item

About
: patrol-measures-the-start

---


<a id="2026-11-18-release-plz-one-pr-changelog-include"></a>
### release-plz one PR: changelog_include

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: Reproduced the missing changelogs with release-plz 0.4.3 on a fixture; test red before, green after; programmer review applied (faithful fixture, target tmpdir, isolated git config, pin). Landed as lab-tools#121, read back from main.

Rejected
: see decision

About
: release-plz-one-pr

---


<a id="2026-11-18-bisect-series-built"></a>
### bringup image bisect built

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: Proof test first, seen failing; image bisect SERIES with lz4 kernel and footerless entries; programmer review found a panic on a footer running past the image, a mangled doc line and untested miss paths: fixed and tested; landed lab-tools#123, read back from main.

Considered
: lz4_flex crate

Rejected
: deleting failed images from DIR: kept, the report line says FAIL

About
: bringup-bisect-series

---


<a id="orchestration-renewed-2026-11-18-suspend-cycle"></a>
### Orchestration renewed: phone rows in docs routed, the suspend cycle to the builder

Project
: linux-phone-oco/docs

Entry date
: 2026-11-18

Done
: Took up orchestration-2026-11-18-morning. Lab read: lpoco host check all ok at 0.4.0, land at d7a71bf (lab-machine #45/#46: land opens a new PR when the branch's earlier one is merged - the merged-branch sign is answered). docs-phone-items-to-lanes closed: all its rows done but health-suspend-cycle, which becomes a lab-tools build item (rank 1) carrying surya's hand-run way-back cycle into lpoco health; its phone proof goes to surya's queue.

Considered
: Asking the surya keeper to keep running way-back.sh by hand

Rejected
: Leaving the cycle as surya's script: it has run fifteen times and more by hand, and any phone's sleep needs it

About
: agent-folder

---


<a id="2026-11-18-health-suspend-cycle-built"></a>
### health suspend cycle built

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: Built lpoco-health suspend plan|cycle in Rust (argenv-declared): refuses without a declared way back (suspend_guard) or when it is not armed or --seconds under 5; quiets the declared wake sources (suspend_quiet) and puts them back, reads qcom_stats, suspend count, cpu idle states, wakeup sources before and after, keeps the boot's report; soc-sleeps reads that boot's cycle. Failing fixture tests first, a programmer review, its findings fixed, landed as lab-tools PR 125, released v0.4.1.

Considered
: A shell verb beside 92-suspend-irq.sh (rejected: counting and quoting belong in tested Rust); soc-sleeps reading the cycle through json_field.

Rejected
: Arming the watchdog from the verb: the device's own way back stays the device's (suspend_guard only checks it); a cycle inside the scheduled run: a keeper asks for it.

About
: health-suspend-cycle

---


<a id="2026-11-18-lpoco-host-reads-lab-toml-from-origin-main"></a>
### lpoco host reads lab.toml from origin/main

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: Failing test first (clone behind origin/main, pin 0.4.0 vs 0.4.1), then declared_text (renamed from device_text) used for lab.toml; read_lab replaced by parse_lab; programmer review: dropped dead read_lab, fixed help text. Landed #127, released v0.5.0 #128, read back from main.

Considered
: A second function for lab.toml beside device_text

Rejected
: A second function for lab.toml: two copies of the fetch/show/differs logic would drift; one rule for every declaration.

About
: host-lab-toml-from-main

---


<a id="2026-11-18-host-gadget-group-built-and-landed"></a>
### host-gadget-group built and landed

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: gadget_group in lab.toml: rule lines carry GROUP and MODE 0660 beside uaccess; check reports group and membership. Tests first (failing), review by programmer subagent found empty USER passing as member and primary gid not counted; both fixed with tests. PR 129 read back from main.

Considered
: user from USER env, membership by /etc/group list plus passwd primary gid

Rejected
: a new own group (needs the author's re-login; stays in lpoco-host-rest); reading the running session's groups (check reads the files)

About
: host-gadget-group

---


<a id="orchestration-renewed-2026-11-18-host-060"></a>
### Orchestration renewed: the lab host at 0.6.0, walleye's gadget group, docs' open PRs settled

Project
: linux-phone-oco/docs

Entry date
: 2026-11-18

Done
: lab-tools v0.5.0 (#127: lpoco host reads lab.toml from origin/main) and v0.6.0 (#129: gadget_group). lab-machine #48 pinned 0.6.0 with gadget_group users; prepare now ran 09:16 on the author's word with 4 root commands (walleye's rule GROUP users MODE 0660, reload, triggers), devlab-watch@surya-lab restarted; lpoco host check all ok at 0.6.0. docs PRs: #331 and #197 closed (their records live in surya-lab), dependabot #65 #66 #67 landed, release 0.14.0 (#366) landed with land --release. about-across-bases and derive-parts-in-base proposed to one research-lead session (one question: a device base reading a commons table it does not own).

Considered
: Doing the two design items in the orchestration session

Rejected
: An orchestrator does not hold a research lead's piece; and a session could only be proposed from a turn another session started

About
: agent-folder

---


<a id="2026-11-18-lpoco-host-check-names-undeclared-gadget-serials"></a>
### lpoco-host check names undeclared gadget serials

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: Tests first (seen failing), then gadgets_seen/undeclared_gadgets and the check line; programmer review fixed root-hub and stale-line false positives; landed as lab-tools PR 131, released 0.6.1 (PR 132), read back from main.

Rejected
: see decision 2026-11-18-host-check-reads-kernel-log-for-gadgets

About
: host-undeclared-gadget-serial

---


<a id="orchestration-renewed-2026-11-18-lpoco-host-done"></a>
### lpoco host accepted: the tty half passed on walleye

Project
: linux-phone-oco/docs

Entry date
: 2026-11-18

Done
: Recorded lpoco-host done from walleye lab PR 182 (tty, 29 banner lines as the lab user) beside PR 70 (block). Before it: lab-tools v0.6.1 (#131: host check names an undeclared gadget serial), lab-machine #49, host prepared at 0.6.1 with 0 root commands at 10:25 CET.

About
: lpoco-host

---


<a id="2026-11-18-lab-tools-builder-host-watchers"></a>
### lpoco host: watcher units

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: Built part (2) of lpoco-host-rest: devlab-watch@ user units planned, enabled and restarted by prepare; landed as lab-tools #133, read back from main.

Considered
: is-active check for linked but stopped units; writing the unit before tool steps

Rejected
: see decision 2026-11-18-host-watchers-by-lab-folder

About
: lpoco-host-rest

---


<a id="2026-11-18-lab-tools-builder-host-watch-declared"></a>
### lpoco host: watch declared by the device

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: Built host-watch-declared: [host] watch = true; failing tests first; programmer review fixed three small points; landed as lab-tools #135, released v0.7.0 (#134), both read back from main. Rollout: every lab device.toml lacks watch = true, so surya-lab must add it (its lane) before the prepare that adopts v0.7.0, else its watcher is only named, and no longer restarted on a binary change.

Considered
: stop unasked watchers

Rejected
: stopping unasked watchers silently

About
: host-watch-declared

---


<a id="2026-11-18-patrol-1108"></a>
### Patrol round 2026-11-18 11:08 UTC

Project
: linux-phone-oco/docs

Entry date
: 2026-11-18

Done
: Read-only round. Landings (6h) in docs, lab-tools, device-template, surya-lab, walleye-lab all by PR, device rows in their own bases. devlab-watch@surya-lab active, restarted 10:25 by the new watcher units, no repeating error; phone not reachable (parked, surya-lab how-the-phone-stands: autosleep, repo part landed). Pages build green x3. lpoco host check: no FAIL, walleye lines not measured (phone off USB, expected). Launcher runs of walleye-keeper, walleye-builder, lab-tools-builder, surya-keeper all succeeded since 05:08; whether each reported to its coordinator: not known yet. Signs filed: docs problems names-bringup-blocked-by-done, host-rest-blocked-by-done (stale blocked_by on done items); walleye-lab backlog walleye-stale-waits-on-done. Start weight and read-weight: not measured this round.

Considered
: waits of surya-lab naming floor-read-holders (no such item, an outside note)

Rejected
: a sign on the phone silence: expected, parked

About
: patrol-measures-the-start

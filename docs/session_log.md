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

---


<a id="2026-11-18-lpoco-host-foreign-rules-named"></a>
### lpoco host: foreign rules named

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: Built part (5): lpoco host plan/check name foreign udev rules by quoted gadget serial or MODE 0666 on live lines; landed as lab-tools #136, read back from main (223e2c3). Programmer review applied: line-based matching, comments skipped, kept and own files tested, unreadable files named.

Considered
: Scanning /usr/lib/udev/rules.d too: the vendors' own, not the admin's to judge.

Rejected
: Bare substring match over whole files: flags comments and prefixes of longer serials, misses MODE=666.

About
: lpoco-host-rest

---


<a id="2026-11-18-lpoco-host-commands-checked"></a>
### lpoco host: commands checked

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: Built part (4) of lpoco-host-rest: [host] commands in device.toml, named by plan, judged by check, never installed. Test first (seen failing), programmer review fixed: a pure commands_of (once per command, every wanting device), plan/check count from one function, stronger tests. Landed lab-tools #138, read back from main.

Considered
: Installing a missing command through root pacman: left to the author's grant (lab-agent-6).

Rejected
: Treating ~/.local/bin as PATH for commands (the host's PATH is what a program sees); a flag-dependent return value (the count is returned always).

About
: lpoco-host-rest

---


<a id="2026-11-18-patrol-measures-the-keeper-hand-off-gap"></a>
### patrol measures the keeper hand-off gap

Project
: linux-phone-oco/docs

Entry date
: 2026-11-18

Done
: patrol's brief gains a sign: a lane's ready top item with a free lease and no keeper or builder run for over one lanes-waker period, seen on surya 2026-11-18 when a finished keeper and its coordinator each waited on the other

Considered
: keeping it in patrol's memory

Rejected
: a new health-keeper role (patrol and the lanes waker already cover it); a guard in the keeper (a sign to refine the hand-off instead)

About
: patrol-measures-the-start

---


<a id="2026-11-18-host-cross-targets"></a>
### lpoco host: cross targets

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: [host] targets in device.toml: plan names, check fails a missing standard library, nothing installed (lab-tools #140). Review by the programmer found five defects before landing, all fixed with tests: early return skipped the devlab-cross fallback, target '.' always found, an empty libdir counted, rustup could auto-install from the cwd, and test gaps.

Considered
: found = rustc target-libdir with a libstd file, or the lab's devlab-cross toolchain (what health/build.sh falls back to)

Rejected
: running rustup target add from prepare (installs outside the declared plan, and the lab's separate rustup home needs nix-shell); found by directory existence alone (a leftover empty directory passes)

About
: lpoco-host-rest

---


<a id="2026-11-18-class-question-places"></a>
### Where else, in linux-phone

Project
: linux-phone-oco/docs

Entry date
: 2026-11-18

Done
: The agent folder's README names linux-phone's 'where else' for ideal-agent's class question after a fix (ideal-agent decision 2026-11-18-after-a-fix-the-class-question, #66): the other devices and their bases, lab-tools, device-template, the host's units, upstream. One line for every brief; the method stays in ideal-agent.

Considered
: A line in each brief (repeats; the README is read by every role here).

Rejected
: Restating the triggers and the three questions (overlay-check).

About
: agent-folder

---


<a id="2026-11-18-research-phone-side-pieces"></a>
### Research: phone-side pieces under one roof, their drift, and typed device declarations

Project
: linux-phone-oco/docs

Entry date
: 2026-11-18

Done
: Inventoried the phone-side pieces of surya-lab and google-walleye-lab; looked at sxmo, postmarketOS, Mobian and the kernel's wake locks; answered the author's question on typed declarations; recorded two decisions, three research rows, 14 sources, 11 backlog items unranked and three upstream questions. No phone touched; no lab-tools code changed.

Considered
: Landing the failing test as ignored: lab-tools has no such convention and the test cannot compile before its function, so its text is in the research material and the backlog proof.

Rejected
: See the two decisions' rejected.

About
: phone-side-pieces

---


<a id="2026-11-18-lpoco-host-gadget-net-name-part-6-ncm"></a>
### lpoco host: gadget net_name (part 6, NCM)

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: Built [[host.gadget]] net_name: udev names the gadget's USB network interface by serial; test seen failing first; programmer review fixed '.' and README; landed as lab-tools #142, read back from main 80c21b5.

Considered
: An NM keyfile with a static host address (needs 0600 install, NM only); NM_UNMANAGED (would break surya's host address 172.16.42.2); a systemd-networkd file.

Rejected
: NM keyfile and unmanaged: the address is the lab's own business and NCM was undefined in the row; a name by serial is the smallest thing every network manager can match.

About
: lpoco-host-rest

---


<a id="2026-11-18-lpoco-host-link-config"></a>
### lpoco host: link config for the gadget's USB network

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: Part (6b): net_address in [[host.gadget]], link file for NetworkManager or systemd-networkd chosen by what runs, plan/prepare with the verb; test first, reviewed by the programmer subagent, landed as lab-tools #144 and read back from main.

Considered
: Detecting the manager from /run markers; a per-file mode (0600 for NM keyfiles); a net_name declared twice refused.

Rejected
: A manager choice in device.toml (the host knows what runs, the device should not); a nmcli connection add call (imperative, not a file the plan can diff); carrying mode/reload on FileChange now (kept the prefix inference, small; noted as a tidy-up).

About
: lpoco-host-rest

---


<a id="2026-11-18-lpoco-host-start-a-stopped-watcher"></a>
### lpoco host: start a stopped watcher

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: lab-tools #146: prepare starts an enabled but stopped devlab-watch@ unit; proof test seen failing first; programmer review applied (fix commit title, only exit 3 = stopped).

Considered
: is-active probe in the shell, plan core stays pure with an active closure

Rejected
: treating every non-zero is-active exit as stopped: a bus failure would plan a start that fails

About
: lpoco-host-rest

---


<a id="2026-11-18-lpoco-awake-built-and-landed"></a>
### lpoco-awake built and landed

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: Failing test first (health/tests/awake.rs), then lpoco-health awake in Rust with argenv (--once declared), awake_gates in device.toml [health] -> AWAKE_GATES in health.env, unit and generic check in the package, README. Reviewed by the programmer subagent; fixed: EINVAL on unlocking a never-held lock is 'already released', an unknown gate never drops the safe default (refused only where allow-autosleep makes gates decide), a missing health.env is no gates but an unreadable one is an error, unit ExecStopPost with - and RestartSec=1, usb-awake check in 85-parts accepts either lock name. Landed as PR 148, read back from main.

Considered
: Reading bluetooth state from sysfs instead of hciconfig: no sysfs file says UP RUNNING, so hciconfig stays (as the script did), faked through PATH in the test. Enabling the unit from suite put: left to surya-awake-from-package.

Rejected
: Keeping the lock name devlab-usb and the allow file /etc/devlab-allow-autosleep: the roof names things lpoco-*; moving phones drop the old by hand (said in README). Refusing on an unknown gate always: it would drop the phone's keep-awake and bring back the USB hang.

About
: lpoco-awake

---


<a id="2026-11-18-patrol-measures-the-lab-agent-job-route"></a>
### patrol measures the lab-agent job route

Project
: linux-phone-oco/docs

Entry date
: 2026-11-18

Done
: patrol's brief gains the job route: lab-agent active and its 401/poll-error count per round, after a token kept from before a rotation failed every poll for 15 hours unseen (restarted 13:30)

Rejected
: keeping it in patrol's memory: a launcher run does not keep it

About
: patrol-measures-the-start

---


<a id="2026-11-18-upstream-forks-research"></a>
### Upstream forks: decided, three fixes written in our forks, proofs queued

Project
: linux-phone-oco/docs

Entry date
: 2026-11-18

Done
: Research lead upstream-forks-research (started by orchestration-renewed): looked around (grenudi and the org's repositories, git-rhizoid's code and design log, pmOS packaging, both lists' rules) with two read-only researchers (sxmo/pmOS, kernel watchdog), decided (2026-11-18-upstream-forks), and wrote the three fixes in the existing forks: sxmo series of 3 on topic branches with a 6-example shellspec (fails on master, passes on the series), and an RFC kernel series of 4 for the PMIC watchdog (built, checkpatch, binding validated) with its phone test script. Recorded 13 sources, 4 upstreams (linux-watchdog, fork-sxmo-utils, fork-linux, git-rhizoid), 3 research rows, 4 test rows, the upstream items (two updated to patches, qcom-wdt-armed-in-suspend superseded, three new), backlog in docs (upstream-forks, upstreams-lane, sxmo-utils-lab-apk) and the phone and build rows in the device bases (surya-lab, google-walleye-lab). Nothing pushed, nothing mailed, no phone touched.
The class (a fallback proven on one path trusted on another, surya try 4): its root here was a watchdog that cannot count where it was trusted (the APSS counter freezes in the deepest sleep) - the PMIC watchdog removes that class for the way back, once proven.

Considered
: Forks under the user grenudi; a lane per upstream project; rhizoid as the tool now; suspending through logind for the service stops; qcom-wdt kept armed upstream

Rejected
: Each with its reason in decision 2026-11-18-upstream-forks

About
: upstream-forks

---


<a id="2026-11-18-briefs-name-intents"></a>
### The briefs and items name intents, not retired routes

Project
: linux-phone-oco/docs

Entry date
: 2026-11-18

Done
: By ideal-agent decision 2026-11-18-instructions-name-intents (#72): route-check over the agent folder and open items flagged five lines and two items; orchestration.md no longer frames the work 'as lab-agent runs'; coordinator.md points to scripts/ideal-agent practices; patrol.md names the job route as retired where it checks it is gone; kernel-fork-repo and org-board name the route by intent. route-check and overlay-check pass.

Considered
: Removing the patrol's job-route check (it watches the retirement; kept, said as retired).

Rejected
: Leaving the lines to drift (walleye lost two tries to a route named in an item).

About
: agent-folder

---


<a id="2026-11-18-upstreams-lane-start"></a>
### The upstreams lane starts: lab tag, apk asked, proofs queued

Project
: linux-phone-oco/docs

Entry date
: 2026-11-18

Done
: Tagged grenudi/sxmo-utils lab as lab-20261118.1 (6432ef9) and asked orchestration to build sxmo-utils-lab-apk from it; confirmed grenudi/linux topic/pmic-wdt-wake-in-suspend at e123d3bff; asked surya-coordinator to queue surya-kernel-pmic-wdt, surya-pmic-wdt-proof and (after the apk) surya-sxmo-suspend-series, and walleye-coordinator walleye-kernel-pmic-wdt and walleye-pmic-wdt-proof; deleted deviceprofile/xiaomi-surya on the fork after checking its two profile files equal upstream 1fd7822.

Considered
: Fast-forwarding the fork's master (303c755) to upstream 1fd7822.

Rejected
: Pushing master from this lane: the guard refuses pushes to master, and a mirror refresh is not in this lane's brief; left to orchestration.

About
: upstreams-lane

---


<a id="2026-11-18-sxmo-utils-lab-apk-declaration"></a>
### sxmo-utils lab apk declaration

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: Built the lab apk declaration from Alpine's community/sxmo-utils (1.18.1-r5) in lab-tools packaging/sxmo-utils, source grenudi tag lab-20261118.1, pkgver 1.18.1_p20261118, every subpackage kept; the proof check (shell, in CI) was seen failing first, then reviewed by the programmer subagent, which found it could not fail on builddir or river - fixed - and landed as PR 157, read back from main.

Considered
: Putting the APKBUILD in the fork repository; a Rust checker (a shell check of one declaration needs no program).

Rejected
: Marking the item done: the apk is not built, signed or published, and its phone proof is not run. Copied from Alpine and left: typos in the river post-install (srmo.desktop) - for the upstreams lane.

About
: sxmo-utils-lab-apk

---


<a id="2026-11-18-sxmo-apk-deliver-blocked"></a>
### sxmo-utils lab apk delivery: blocked on the conveyor

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: Read the conveyor's alpine.yml against packaging/sxmo-utils and lab-tools' packages.yml; found two gaps (sibling source files not copied; one Pages site per repository, replaced by each run). Recorded them on the row; changed nothing in the conveyor or lab-tools.

Considered
: A second declaration plus a second job in lab-tools alone (fixes neither gap); a workflow of our own that builds and signs (copies the conveyor, against its idea: called, not copied).

Rejected
: Landing the declaration and job now: the first run would replace the lpoco-health repository on the live page and fail on the missing sources.

About
: sxmo-utils-lab-apk-deliver

---


<a id="2026-11-18-lab-tools-builder-host-install-atomic"></a>
### lpoco host: atomic install

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: Test first (old script run by bash while prepare replaces it; failed on the in-place copy), then replace_file: temp beside, fsync, rename, fsync dir; used for Copy, Stamp and the unit. Programmer review found a flaky test (text file busy on exec, shell-dependent, no deadline): fixed by running it via /bin/bash with a deadline and a release guard.

Considered
: Cargo install: left to cargo's own rename.

Rejected
: Writing in place with a lock: a reader of a shell script holds no lock. Test via exec of the fresh file: races with parallel tests (text file busy).

About
: host-install-atomic

---


<a id="2026-11-18-lpoco-host-check-names-stale-phone-side-pieces"></a>
### lpoco host check names stale phone-side pieces

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: Wrote host/tests/phone_pieces.rs first (failing), built blob_id, stale_pieces, Stale and check's print_stale_pieces in lpoco-host; landed as lab-tools PR 165, read back from main.

Considered
: Making a stale piece fail the check: it only names it, as the item asks. Naming a missing piece as its own finding.

Rejected
: My first report format (test piece / blob word): invented; review found health's 94-lab-pieces.sh writes piece-file:PATH and piece-package-NAME rows, so the parser follows those. Silent skips of unreadable lines: now an error and 'not measured'.

About
: phone-pieces-drift-named

---


<a id="2026-11-18-lab-names-stale-phone-pieces"></a>
### lab names stale phone pieces

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: lpoco-lab test/health print which phone-side piece the run's report holds off origin/main; logic moved to lpoco_host::stale_lines and shared with lpoco host check (#170).

Considered
: Printing from run_checks; judging only the report's JSON rows since phone stdout can carry noise; naming the oldest commit holding the blob.

Rejected
: Reading device.toml from the manifest dir (a --device file of another name would be misjudged): the given file path is used. Printing before the pass/fail table: now printed after.

About
: phone-pieces-drift-named

---


<a id="2026-11-18-template-research"></a>
### Research: device-template, its children and drift

Project
: linux-phone-oco/device-template

Entry date
: 2026-11-18

Done
: Asked by the author through orchestration. Read the template's, labs' and idealkb's history and PRs (no phone, no lab changed); measured drift by blob id and manifest keys; a researcher read cruft, copier, GitHub templates, actions-template-sync, Yeoman, Nix, projen, Renovate at source. Recorded research device-template-drift-measured and device-template-follow-world, decision 2026-11-18-device-template-follows-by-release, six backlog items unranked, the hand-over device-template-how-it-stands, the subject's summary, and the failing test template-drift.sh (exit 1 today) in research/device-template/2026-11-18/.

Considered
: Landing the test in device-template or a lab: neither has a failing-test convention and the labs are not this session's, so it lives in the research material and each item's proof names it. Checking device.toml's shape in the test: left to the schema decision (optional tables would give false failures).

Rejected
: Re-recording device-template-follow (orchestration's, in progress): its rank would drop; the decision is tracked by it instead.

About
: device-template

---


<a id="2026-11-18-research-bringup-steps"></a>
### Research: bring-up steps as data

Project
: linux-phone-oco/docs

Entry date
: 2026-11-18

Done
: bringup-steps-research.r1 (research lead, from orchestration). Mined google-walleye-lab (161 backlog items, 120 session logs, the bring-up order plan), surya-lab and docs' surya records, lab-tools' lpoco-bringup and lpoco-health tests (a researcher subagent), and docs' tables (components, features, feature_support, support_status, milestones, tests, the parts feed). Looked around at 22 outside sources (a researcher subagent). Drafted the tables, records, query, seed and failing test and ran them in a scratch clone of docs. Recorded 18 sources, the research, the decision, 11 backlog items unranked, the hand-over row; landed data and the material only.

Considered
: Landing the schema myself; steps as components; status typed in docs; edges as a list field; an issue tracker; per-driver probe steps; a 30-day expiry

Rejected
: Landing tables.toml, records and queries here: AGENTS.md sends them to the owner, orchestration. The rest: see the decision's rejected.

About
: bringup-steps

---


<a id="2026-11-18-host-records-the-root-files-it-installs"></a>
### host records the root files it installs

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: Built host-plan-unreadable-not-new (lab-tools #173): Seen {Absent, Text, Unreadable} in FileChange, install record, plan wording. Programmer review: two findings fixed (only PermissionDenied counts as unreadable; no diff printed for an unreadable file).

Considered
: Recording at check time (kept as host-record-from-check); a record keyed per file vs one file (one file, lines HASH DST).

Rejected
: Treating every read error as unreadable: a non-UTF-8 readable file would be called up to date unread.

About
: host-plan-unreadable-not-new

---


<a id="2026-11-18-host-record-from-check"></a>
### host: record from the share check

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: Built host-record-from-check (lab-tools #175): a passing share check records the hash of the unreadable polkit rule, unit and helper, so the next plan asks no sudo for them.

Considered
: Recording for any unreadable file with a record; gating on ok>0 only.

Rejected
: Recording over a recorded hash of other content: the probe shows some rule works, not that it is this one (reviewer finding, fixed). Recording when one of several devices failed.

About
: host-record-from-check

---


<a id="2026-11-18-rhizoid-graph-research"></a>
### Research: the repository graph, how changes travel both ways, and git-rhizoid's scope

Project
: linux-phone-oco/docs

Entry date
: 2026-11-18

Done
: Measured every edge (12; 3 by a job, 6 by hand, 5 behind); two read-only researchers surveyed subtree, submodules, josh, copybara, Android repo, Nix inputs, copier/cruft, multi-repo bots, gbp-pq/quilt/DEP-3, stgit, topgit, Yocto, Gentoo, Arch, the kernel's trees, ACK; wrote graph-drift.sh (failing, 36 FAIL); decided 2026-11-18-device-layer-from-docs superseding the template follow decision (supersedes, scope and tracked-by set with ikb set: docs' decision record lacks them - itself an instance of the own drift); reshaped the template and lab items; filed idealkb's side and rhizoid's scope as upstream items.

Considered
: Keeping the template as the layer's source; josh monorepo; copybara; porting follow.sh to rhizoid now.

Rejected
: See the decision's rejected.

About
: base-graph

---


<a id="2026-11-18-lab-tools-builder-restore-share"></a>
### Restore the per-device share

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: Cherry-picked e764ffd onto main by hand, kept #175 fs_root, fixed the plan.rs systemctl stub to follow state; landed #177, release 0.17.1.

Considered
: Reverting #165 (no: its stale-piece check stays).

Rejected
: Putting back the [0.14.2] changelog sections: the changelog check refuses a changelog changed with no version bump (they are release-plz's).

About
: restore-share-per-device

---


<a id="2026-11-18-author-yes-device-layer-and-rhizoid"></a>
### The author's yes: the device layer from docs, git-rhizoid unparked

Project
: linux-phone-oco/docs

Entry date
: 2026-11-18

Done
: The author's word, verbatim (through the Top Coordinator, 2026-11-18): 'yes, if its the best we came up with, grounded in our extensive research and consideration, which it seems it did, so yes'. It answers two questions from research base-graph: (1) decision 2026-11-18-device-layer-from-docs - the device layer moves into docs, served from device-layer/, and the template becomes an ordinary follower that keeps its made-once seed files; (2) git-rhizoid is unparked with the research's scope and order - status (passes graph-drift.sh), follow (passes idealkb's test-follow.sh exactly, keeping its three rules), send-back, forks; each replaces shell only once it passes. Following: device-layer-in-docs (idealkb v0.17.0 slice-from-prefix is out), the template builder on template-classifies-its-files then template-follows-docs, ikb items 2-4 (2 released as idealkb v0.18.0), a builder owning git-rhizoid.

About
: base-graph

---


<a id="2026-11-18-device-layer-builder"></a>
### The device layer served from docs; the template follows it

Project
: linux-phone-oco/docs

Entry date
: 2026-11-18

Done
: docs: device-layer/ (10 statements, the device part of tables.toml), generic, consumers, bin/check-device-layer.sh in make verify (#514), released as v0.17.0. device-template: devicebase.toml pins docs 0.17.0, device tables between device:begin/end, made-once list, own generic removed (#26). graph-drift.sh now reads the base's marked part (layer-follow) and compares it with docs' at the pin (layer-equal); template-drift.sh reads template, idealkb and docs. FAIL lines of graph-drift 36 -> 30; the remaining layer ones are the two labs' (no source/version in devicebase.toml, device tables not between markers: follow.sh lays nothing and ends 'the pin did not move' until they do).

Considered
: Moving the skeleton (Makefile, install-tad.sh, workflows) into device-layer/ now; one change for the template's two items instead of two.

Rejected
: The skeleton into device-layer/ this round: tad's pin job edits bin/install-tad.sh in each consumer, so a second copy in docs would be stale at the next release and revert the labs' tad pin. Making template-drift.sh follow the template's list: the list is gone, the sources' generic lists decide.

About
: device-layer-in-docs

---


<a id="2026-11-18-manifest-one-schema-built-and-landed"></a>
### manifest-one-schema built and landed

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: New lpoco-manifest crate: device.toml's tables and fields declared once, unknown ones refused by devlab, host and bringup alike, JSON Schema projected and committed; lab-tools #179. host test fixture gained the user field the schema requires.

Considered
: Optional device/connection in the shared type with each program checking what it needs; a bin with argenv to print the schema

Rejected
: Per-program structs kept beside a shared one: that is today's drift. Making connection.user optional for host: a real manifest always has it.

About
: manifest-one-schema

---


<a id="2026-11-18-phone-stages-research"></a>
### Bring-up steps, a second look: the phone beyond Linux runs

Project
: linux-phone-oco/docs

Entry date
: 2026-11-18

Done
: Mapped what research bringup-steps-landscape covered and left out, and where the world's own knowledge is thin. Four read-only researchers did the reading: our labs' phone steps, the Linux mobile projects, Android's CDD, CTS, VTS and HALs, and Qualcomm's mainline stacks. Recorded 33 sources, 2 research rows, decision 2026-11-18-bringup-steps-phone-stages-and-goal-steps, 12 stages, 80 steps, 186 edges, 6 owner backlog items (unranked) and the summary. The test daily-phone.sh caught one step that no goal needed (suspend-wakes-quiet), now fixed with an edge. In a scratch copy it passed with every step claimed and failed with one step open.

Considered
: Nested stages, a layer column, UBports' weights, CDD- or HAL-shaped stages, a prior-art table.

Rejected
: Each one adds a second tree or a copy that drifts; a goal step groups through the edges that already exist (see the decision).

About
: bringup-steps

---


<a id="2026-11-18-author-yes-bringup-steps"></a>
### The author's yes on the bring-up steps

Project
: linux-phone-oco/docs

Entry date
: 2026-11-18

Done
: The author's word, verbatim (through the Top Coordinator, 2026-11-18), after the second research (docs #526): 'yes, now it sounds about right'. It closes questions (a)-(c) at their defaults: (a) a step is one done-when with one proof, and stages are data (8 grew to 20 rows with no schema change); (b) milestones are sets of steps named by a goal step (linux-runs, daily-usable-phone, complete-phone); (c) claims never lapse by age - reliability has its own steps (days-without-reboot, kernel-upgrade-keeps-steps, cycles-repeat-clean) and proven_on records what a claim was proven on. Following: steps-contract ships in docs' device layer (the template release it waited on was replaced by decision 2026-11-18-device-layer-from-docs), then feed-device-steps, then the lanes' claim items over 106 steps.

About
: bringup-steps

---


<a id="2026-11-18-docs-builder-the-steps-contract-in-docs-device"></a>
### docs-builder: the steps contract in docs' device layer

Project
: linux-phone-oco/docs

Entry date
: 2026-11-18

Done
: Added the steps table to the device layer's marked tables part, the record step (tad r step: status of the six, a done claim carries proof and run, a not-needed claim its reason; empty strings count as absent; a refusal leaves the standing claim), the generic entry, check-device-layer.sh for five tables and bin/test-steps-contract.sh in make verify. Followed in a scratch device-template with a tagged copy of docs: tad check passes, a claim writes one row. The programmer subagent reviewed it; its findings (empty strings, refusal reasons pinned, standing claim kept, steps = 1 named in the README) are in.

Considered
: A table named step_status in the base (the item's words) against steps (the decision's): steps, so data/steps.json and the feed's name agree and step_status stays docs' pulled table. A device column in the base's table: a base is one device, as parts has none. A check in the record that the step exists: the base has no bringup_steps; the feed drops and names a claim of an unknown step.

Rejected
: A 30-day expiry of a claim (decided against); the steps = 1 line laid by the follow (the pin file is the base's own).

About
: bringup-steps

---


<a id="2026-11-18-docs-builder-feed-device-steps"></a>
### docs-builder: feed-device-steps

Project
: linux-phone-oco/docs

Entry date
: 2026-11-18

Done
: records/feed-device-steps.sql pulls each base's data/steps.json (steps = 1 in devicebase.toml) into step_status for every step docs knows; device-steps-unknown is the fallback; run-feeds.sh runs both feeds per device. bin/test-feed-device-steps.sh runs in make verify against a fake base. The programmer subagent reviewed it; its findings (a step claimed twice, the feeds' success output kept, stdin guarded, comments) are in. Tried the two research tests against a scratch copy: with the real bases both fail (every step unknown); with walleye's 26 claims in a fake base the walleye test fails only at 'not known yet' for the 80 phone-stage steps.

Considered
: Reading a missing steps.json as empty: no, a base that declares steps = 1 and has no file is not known yet, as a base that cannot be read; the first claim creates the file. A step_status row for a device with no base: not made, bringup-chain reads a missing row as unknown.

Rejected
: Carrying the dropped claims into step_status notes: they have no step row to sit on.

About
: bringup-steps

---


<a id="2026-11-18-docs-builder-bringup-chain-goal"></a>
### docs-builder: bringup-chain --goal

Project
: linux-phone-oco/docs

Entry date
: 2026-11-18

Done
: queries/bringup-chain.sql now takes --goal STEP, from the draft in research/bringup-steps/2026-11-18-phone-stages/queries; bin/test-bringup-chain-goal.sh (make verify) pins it against the hard-edge closure of bringup_step_edges for each goal.

About
: bringup-steps

---


<a id="2026-11-18-docs-builder-bringup-shape-check"></a>
### docs-builder: bringup shape check

Project
: linux-phone-oco/docs

Entry date
: 2026-11-18

Done
: bin/check-bringup-steps.sh, the shape half of daily-phone.sh, runs in make verify: stages with no step, a missing goal step, a phone step no goal needs. Tried in a scratch copy with an empty stage and a loose step: both named.

About
: bringup-steps

---


<a id="2026-11-18-docs-builder-tad-q-prior-art"></a>
### docs-builder: tad q prior-art

Project
: linux-phone-oco/docs

Entry date
: 2026-11-18

Done
: queries/prior-art.sql reads prior art by subject from research and sources (no new table, as decided); bin/test-prior-art.sh pins the row count to the sources the subject's researches cite.

About
: bringup-steps

---


<a id="2026-11-18-docs-builder-the-landscape-record"></a>
### docs-builder: the landscape record

Project
: linux-phone-oco/docs

Entry date
: 2026-11-18

Done
: records/landscape.sql and its test; the landscape gets ubports-devices, halium and android-cts, which had gone to sources.

Considered
: Naming the flag --project as the column is: ikb uses --project for the place, so --effort.

About
: bringup-steps

---


<a id="2026-11-18-docs-builder-components-for-the-phone-steps"></a>
### docs-builder: components for the phone steps

Project
: linux-phone-oco/docs

Entry date
: 2026-11-18

Done
: The component record, four components (gnss, gpu, battery, buttons) and five steps naming them, with a test (make verify) for the record and for those steps.

Considered
: A front-camera component: camera-front exists already, and no step is its first light.

About
: bringup-steps

---


<a id="2026-11-18-docs-builder-milestones-name-steps"></a>
### docs-builder: milestones name steps

Project
: linux-phone-oco/docs

Entry date
: 2026-11-18

Done
: queries/milestone-steps.sql and records/milestone.sql, tested in a scratch copy through a fake base and the feed (bin/test-milestone-steps.sh, in make verify; mutation-checked: counting only done fails the not-needed case, counting partial fails the partial case).

Considered
: Writing the result into milestones.readiness: the rung 1 to 9 is a person's judgement of the whole milestone, a step term is one of its criteria, so the query reports the terms and leaves the rung. A milestone of the labs in docs' data: the lanes' places, not landed here.

About
: bringup-steps

---


<a id="2026-11-18-bringup-steps-off-side"></a>
### Bring-up steps: the off side of a phone

Project
: linux-phone-oco/docs

Entry date
: 2026-11-18

Done
: Added the off side after the author's word that surya cannot stay off (only eOS recovery's power-off held). Seven new steps, in power unless noted: pon-reason-read, reset-types-right (PS_HOLD and the reset type vs the reboot path), charger-mode-entered, reset-state-survives, key-reset-recovers, rtc-alarm-powers-on, and alarm-wakes-from-sleep in sleep. power-off-stays-off was re-recorded with its new needs, and 22 edges were added. daily-usable-phone now also needs alarm-wakes-from-sleep and key-reset-recovers, and reaches charger-mode-entered through off-mode-charging; complete-phone needs rtc-alarm-powers-on and reset-state-survives. World gaps: a maintained charger mode, and an alarm that survives power-off. daily-phone.sh: the shape passes (daily-usable-phone needs 82 steps; tad q bringup-chain --goal daily-usable-phone agrees); every device still fails. Script: research/bringup-steps/2026-11-18-phone-stages/off-side.sh.

Considered
: The author's guess, a separate small OS or processor that shows charging while off. On Android it is the always-on PMIC, which charges, keeps the RTC and records why it powered on, plus the same kernel booted with androidboot.mode=charger, where init runs only the charger (Sailfish's act-dead mode). Linux has the pieces (the PON block, rtc-pm8xxx, PSCI SYSTEM_OFF). What is missing is the user space and the boot chain acting on the power-on reason.

Rejected
: An amendment to decision 2026-11-18-bringup-steps-phone-stages-and-goal-steps: these are more steps of the same kind, with no change of rule. New sources and research rows: the guides cite existing sources (downstream-qpnp-power-on-sm6150, ramoops-doc, sailfish-hadk-checklist, pmaports-charging-sdl-1064), and this change touches only bringup_* rows and this log while docs-builder works in docs.

About
: bringup-steps

---


<a id="2026-11-18-docs-builder-milestones-name-goal-steps"></a>
### docs-builder: milestones name goal steps

Project
: linux-phone-oco/docs

Entry date
: 2026-11-18

Done
: milestone-steps derives a goal step's status from its hard needs on the device, the way daily-phone.sh reads it; the milestone surya-daily-phone names step:daily-usable-phone@xiaomi-surya. Test extended: a fake base claims every leaf done with the UART open (ready), one open (partial, not ready), one done (partial), none (unknown).

Considered
: Storing a goal's status in step_status: a feed would then write what it computes and a base never claims; derived on read it cannot drift.

About
: bringup-steps

---


<a id="2026-11-18-oneoffs-research"></a>
### Research: one-off scripts and workaround rules

Project
: linux-phone-oco/docs

Entry date
: 2026-11-18

Done
: Measured 97 tracked one-offs, 65 try recipes, 735 scratch scripts and their fates; read the world's scripts/ and contrib/ practice; weighed a scripts folder, a scripts repo with rhizcuts, a table, nothing; decided 2026-11-18-workarounds-read-as-one; wrote the failing check research/workarounds/2026-11-18/workarounds-read.sh (7 FAIL); backlog workarounds and three steps; upstream item to ideal-agent. Signed oneoffs-research.

Considered
: One tracked place for scripts with purpose, state, item; rust-script for one-offs; one scripts repo followed by each base as a rhizcut (the author's addition); workaround rules beside scripts (the coordinator's addition).

Rejected
: A folder, a repo or a table: nothing shared to hold, records already name the scripts, and a folder alone rots; rust-script by default: the one-offs are plumbing; see the decision.

About
: workarounds

---


<a id="2026-11-18-bringup-generic-init-slice-one"></a>
### Generic bring-up init, slice one

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: lpoco-bringup initramfs init made from a new [boot.gadget] table; landed as lab-tools #183 and released 0.18.1; walleye selftest passes with the generated init in a scratch copy

Considered
: A template with @WORD@ marks filled from the manifest; the address rewritten in the template before the device's words so a serial that looks like an address is kept

Rejected
: Rewriting the finished text (first version: it changed a serial like 172.16.42.9 under --net, found in review); copying walleye's init as is (it names walleye and carries three RNDIS/ACM variants)

About
: bringup-generic-init

---


<a id="2026-11-18-gadget-words-refused-at-manifest-read"></a>
### Gadget words refused at manifest read

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: bringup-generic-init second slice: shell-word check moved from lpoco-bringup into lpoco-manifest, so device.toml refuses a bad [boot.gadget] word on read (lab-tools #185). Programmer review: tests widened to every field and character; make keeps its re-check with a unit test.

Considered
: ShellWord newtype in the manifest (stronger, but a serde type plus schema change; left open)

Rejected
: dropping the re-check in make: a BootGadget can be built without parse

---


<a id="2026-11-18-bringup-init-files-shipped-with-it"></a>
### bringup init: files shipped with it

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: lpoco-bringup initramfs files (lab-tools #186): the init's udhcpd.conf, udhcpc.script and selftest.sh made by the tool, test first, reviewed by programmer, landed and read back from main.

Considered
: One verb for the three files beside the init, versus folding them into init's output.

Rejected
: Escaping dots in the selftest grep: it would break the address rewrite, which matches the text 172.16.42.; a trailing slash fixes the prefix match instead.

About
: bringup-generic-init

---


<a id="2026-11-19-bring-up-init-the-log-window"></a>
### Bring-up init: the log window

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-19

Done
: [boot.gadget] window: a read-only mass-storage LUN the init keeps written with the kernel log (lab-tools #188), after a programmer review that found a stale-tail, a silent-failure and a weak-test defect, all fixed.

Considered
: Taking user-config-drift-named instead (the author's ask); the picking query's first lab-tools row was bringup-generic-init.

Rejected
: A window on the second (RNDIS) configuration: not needed for the lab host.

About
: bringup-generic-init

---


<a id="2026-11-19-patrol-0010"></a>
### Patrol round 2026-11-19 00:10 UTC

Project
: linux-phone-oco/docs

Entry date
: 2026-11-19

Done
: Read-only round. Landings (6h) in docs, lab-tools, device-template, surya-lab, walleye-lab all by PR, device rows in their own bases. devlab-watch@surya-lab active, a report filed at 23:07 (UNHEALTHY 2 of 85, known); 87 'Journal file ... truncated' lines in 6h from the host journal, owner lab-machine (report only). lab-agent active, 0 poll error/401 lines. Pages build: 2 success, 1 failure (#559 at 22:51), the next two green - not a sign. lpoco host check: no FAIL; surya phone pieces STALE against the last suite run, walleye not measured (phone off USB). /home 94% full, 61G free: report only. Workarounds: every due line is a backlog item the reader counts as not known (decision 2026-11-18-workarounds-read-as-one, known) or a doc placeholder. Stale waits: in-progress items all carry landings in the last day. Clones: 10 of 14 shared clones off main, read by lpoco host check (known). surya-keeper has a run since 23:03 still running; other launcher runs, per-run reports to the coordinator and read-weight on 82 transcripts: not known yet. start-weight: patrol 31608, phone-keeper 33398 the heaviest. No sign filed this round.

Considered
: a sign on the pages failure: one failure, the next run green

Rejected
: a sign on the due workarounds: already recorded by the workarounds research row

About
: patrol-measures-the-start

---


<a id="2026-11-19-shellword-newtype-for-the-gadget-words"></a>
### ShellWord newtype for the gadget words

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-19

Done
: lab-tools #190 (d06cef4): the [boot.gadget] words are a ShellWord; the re-check in make and BootGadget::check are gone; schema unchanged. Reviewed by the programmer subagent; its notes: default words now tested, Serialize kept for schemars' defaults.

Considered
: Keeping the field-naming message: left to toml's snippet.

Rejected
: A newtype with schemars's own definition (lost the defaults in the schema); a per-field check kept beside the type (two gates).

About
: bringup-generic-init

---


<a id="2026-11-18-ffs-acm-joins-lab-tools"></a>
### ffs-acm joins lab-tools

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: lpoco-ffs-acm landed (lab-tools #192, fc2a76a): walleye's FunctionFS ACM helper as a family crate, blob test seen failing first, three review fixes (SIGPIPE inherited by the shell, stop reaping, zero write).

Considered
: wiring the init to it now: needs the single-interface gadget switch and a phone to prove it

Rejected
: wiring the init without a proof on QEMU or a phone; keeping the helper only in walleye's repo (every phone would copy it)

About
: bringup-generic-init

---


<a id="2026-11-19-ffs-acm-relicensed-by-the-author"></a>
### lpoco-ffs-acm relicensed MIT OR Apache-2.0 on the author's word

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: The author's word, verbatim (through the Top Coordinator, 2026-11-19): 'Yes, match lpoco'. He holds the copyright of the FunctionFS ACM helper: it was written here for him (google-walleye-lab #52, as GPL-2.0-only) and came into lab-tools as lpoco-ffs-acm in #192. Its license field is now 'MIT OR Apache-2.0' like every lpoco crate; the crate had no SPDX headers and lab-tools no LICENSE files, so the field is the whole change. The walleye lane is asked to match its own copy or retire it for the shared crate.

About
: bringup-generic-init

---


<a id="2026-11-18-bringup-init-ffs-console-switch"></a>
### bringup init: ffs console switch

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-18

Done
: lab-tools #195: [boot.gadget] console = ffs starts the FunctionFS ACM helper from the init (tests first, programmer review: UDC wait kept, mount failure not followed by the helper, console name a placeholder).

Considered
: wait loop inside the ffs helper (it reads udc once; fixed in the init instead)

Rejected
: text replace of acm.usb0 after splicing: fragile, made a placeholder

About
: bringup-generic-init

---


<a id="2026-11-19-reference-capture-and-diff"></a>
### reference capture and diff

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-19

Done
: Built lpoco-bringup reference capture/diff (lab-tools #197): test first against walleye's UFS by-hand comparison as fixture, capture proven through a fake transport and the real script against a fake device-tree folder. Programmer review found the script exiting 1 on a normal run, an unmeasured side passing, and repeated node names colliding - all three fixed before landing; stale files after a recapture too.

Considered
: Keying lines by full path with phandle targets resolved (better, bigger: left open); a tar pull of /proc/device-tree (no tar reader in the crate; od hex over one transport call chosen).

Rejected
: Comparing text files by position (counters and ordering churn); a manifest part table for the filter words (a --match word is enough for a first slice).

About
: reference-capture-diff

---


<a id="2026-11-19-dt-check-verb-in-lpoco-bringup"></a>
### dt-check verb in lpoco-bringup

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-19

Done
: Built lpoco-bringup dt-check binding|dtbs (lab-tools #199): digest-pinned container, source read-only, output in scratch, make arguments passed as arguments not a shell string. Reviewer's defects fixed: container failure vs checker failure told apart, make options refused in --dtbs/--arch, : in a mount path refused, id checked, flag/verb mismatch refused.

Considered
: A lab-tools script instead of a verb; a bare dt-check with no verb.

Rejected
: Splicing make arguments into the sh -c string (injection); a default image tag (a later edge dtschema would change results unseen).

---


<a id="2026-11-19-research-nura-relation"></a>
### Research: how we relate to Nura

Project
: linux-phone-oco/docs

Entry date
: 2026-11-19

Done
: nura-relation-research (research-lead, for orchestration): measured what each lab place takes from Nura on origin/main, read the rename (blog 2026-09-27, PMCR 0003/0006), the AI policy (2026-02-16), the CoC and wiki rules, licences, and how Mobian, PureOS, Ubuntu and Nura name their parents; recorded research nura-relation-how-it-stands with its material, 18 sources, decision 2026-11-19-nura-relation, landscape nura (and two rows corrected), upstream nura-pmaports (alpine-aports narrowed), five open items, the summary. Nothing filed, no one contacted, no phone.

Considered
: A credits page; a relations table; mirroring Nura's images; preparing reports for the author to file.

Rejected
: All four, as the decision says: the existing landscape and upstreams records hold it, one kept image covers the risk, and anything an agent drafts for Nura falls under its ban.

About
: nura-relation

---


<a id="2026-11-19-user-config-drift-named-built-and-released"></a>
### user-config-drift-named built and released

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-19

Done
: Built [[user_config]] drift naming across manifest, devlab pieces_env, health 94-lab-pieces.sh, host stale_pieces; landed #201, released v0.22.0 (#202); programmer review applied (missing default/copy named, duplicates refused, from kept in the base).

Considered
: An enum Against{Expect,From} for the manifest instead of two Options (reviewer): kept the runtime check, schema is the same shape either way; one row type for both kinds with '-' marking no default.

Rejected
: Treating a missing user file as drift against expect: an untouched config is simply absent, the package default applies. Passing silently when the base copy is not at origin/main: a typo would hide drift forever.

About
: user-config-drift-named

---


<a id="2026-11-19-research-base-distro"></a>
### Research: which distribution our phones build on

Project
: linux-phone-oco/docs

Entry date
: 2026-11-19

Done
: Research lead base-distro-research for orchestration. Four read-only researchers in parallel (Arch family; Mobian/Fedora/openSUSE; Mobile NixOS/Ubuntu Touch/Droidian; Nura/Alpine); the lead re-measured Mobian's suites and images, ALARM/AUR/Debian/Alpine packages for the Qualcomm daemons and sxmo, and read our own rows (nura-relation-how-it-stands, giving-back-by-distro, 2026-11-18-upstream-forks, walleye-mainline-prior-art) and lab-tools' conveyor packaging. Recorded 26 sources, research base-distro-candidates and base-distro-how-it-stands, decision 2026-11-19-base-distro (a recommendation for the author's word), items base-distro, walleye-rootfs-on-our-layer, mobian-sm7150-offphone, base-distro-triggers, device-facts-as-data, unranked. Mid-task the author's turn, relayed by orchestration, verbatim: "no ubuntu touch its premise is stupid and in vane from the day one, they made 0 upstream contributions beside halium, and they are the one ones who use halium this day" - Ubuntu Touch dropped, Droidian named in one line as the same route. Orchestration also relayed the upstreams coordinator's giving-back view (giving-back-by-distro), built on rather than redone.

Considered
: A Mobian move for surya now; Arch Linux ARM with our own pacman repository (the conveyor has pacman); Mobile NixOS as a flake overlay; a pmaports fork for walleye; Mobian for walleye only.

Rejected
: Each in decision 2026-11-19-base-distro's rejected: a thicker layer than today (ALARM, Fedora, openSUSE, NixOS), an unpublished idle 6.18 port (Mobian now), the Halium route on the author's word, two bases for one lab.

About
: base-distro

---


<a id="2026-11-19-author-shell-stays"></a>
### The author: existing shell stays as it is

Project
: linux-phone-oco/docs

Entry date
: 2026-11-19

Done
: The author's word, verbatim (through the Top Coordinator, 2026-11-19): 'i dont think its necessary, too much work.. if we dont rely on it much i say we leave them as is for now'. It reverses the shell-to-Rust migration of ideal-agent 0.3.56 for existing scripts: shell-past-glue-into-rust is closed in docs and lab-tools, and the surya and walleye lanes close theirs (walleye's AGENTS.md line from lab PR 336 comes out). Practice 21 stays for new work: a new script with logic starts in Rust.

About
: bringup-steps

---


<a id="2026-11-19-research-test-layer"></a>
### Research: a hardware-test layer with no phone shell

Project
: linux-phone-oco/docs

Entry date
: 2026-11-19

Done
: Research lead test-layer-research (for orchestration, on the author's words): measured sxmo's cost across surya-lab, docs and lab-tools (episodes, ~70 PRs classified, phone-down hours, lane-hours); looked around with one read-only researcher (Nura ui=console/none, tinydm, logind, hardware CI, Phosh/Plasma idle) and at walleye's bare init; recommended the split (decision 2026-11-19-hardware-test-layer), recorded 12 sources, 3 research rows, the test test-layer-quiet and 10 unranked items. No phone touched, no lab repository changed.

Considered
: A fresh ui=console image; an in-place UI swap; two root filesystems; keeping sxmo tamed; initramfs-only tests; Phosh or Plasma as the lab shell.

Rejected
: All but the boot entry at multi-user.target, for the reasons in the decision; changing surya-lab's own queue (its keeper and coordinator take the surya items on the author's word).

About
: test-layer

---


<a id="2026-11-19-base-distro-any-arm-base"></a>
### Base distro amended: any general aarch64 base, a device layer not an OS

Project
: linux-phone-oco/docs

Entry date
: 2026-11-19

Done
: On the author's question, relayed by orchestration, verbatim: "we have looked at mobile distributions but why do we even have to make such difference ? i mean cant we just use any upstream linux distro that supports arm , what holds us ? do we need to keep phone os, at least its base distribution form with some special care ? i mean, for de/shell we can craft/use whatever we like that doesnt really what makes a burdain of maintaining our own linux distribution os(btw what are the burdains, would be nice to list them exactly) ?" Read Nura's sm7150 device, soc-qcom, firmware and UCM packages on pmaports main and the phone userspace across Debian, Arch, AUR, Fedora, Alpine on Repology; listed each item as device layer or OS burden; counted the layer per base; read test-layer's rows. Recorded research base-distro-device-layer, decision 2026-11-19-base-distro-any-arm-base (amends 2026-11-19-base-distro), 5 sources; how-it-stands and the walleye item updated.

Rejected
: Superseding the first decision whole: its surya recommendation and items stand; only the framing and walleye's base change, so an amendment.

About
: base-distro

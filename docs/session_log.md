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


<a id="2026-11-10-the-ear-withdrawn"></a>
### What the ear heard is withdrawn

Project
: linux-phone-oco/docs

Entry date
: 2026-11-10

Done
: The microphone was the author's earphones, worn on his head, moving with him. The claim that a machine heard both speakers is taken out of the idea; the working stays, waiting for a microphone fixed in place.

Considered
: Keeping the claim with a caveat.

Rejected
: That: evidence from an instrument that moves is not evidence.

About
: dl-manual

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


<a id="2026-11-11-cameras-understood"></a>
### The cameras' fault, understood

Project
: linux-phone-oco/docs

Entry date
: 2026-11-11

Done
: Both cameras stay broken, but for a stated reason and with a way in: nothing describes the sensors; the wiring of seven slots is known from the vendor's kernel; the models are not.

Considered
: Naming sensor models from reports.

Rejected
: That: hearsay until a chip answers.

About
: camera-rear

---


<a id="2026-11-11-microphone-nearly"></a>
### The microphone's chain, nearly whole

Project
: linux-phone-oco/docs

Entry date
: 2026-11-11

Done
: For the first time the test kernel brought the whole microphone chain up to the codec; one timeout stands between it and a sound card. Measured: the right channel is the bottom speaker.

Considered
: Booting again without reading the bootloader's record.

Rejected
: That: three wrong theories cost three reboots.

About
: audio-mic

---


<a id="2026-11-11-the-codec-comes-up"></a>
### The microphone codec comes up

Project
: linux-phone-oco/docs

Entry date
: 2026-11-11

Done
: One SoundWire data pin was muxed to the wrong function by the audio pin driver; corrected against the phone's own Android kernel, the codec initialises and joins the sound card.

Considered
: Clock and power-management theories.

Rejected
: Guessing.

About
: audio-mic

---


<a id="2026-11-11-recording-tries"></a>
### The microphone: the route is set, the stream does not start

Project
: linux-phone-oco/docs

Entry date
: 2026-11-11

Done
: In the test kernel the main-microphone route sets cleanly; starting a recording fails as the TX SoundWire bus loses the codec when it is reshaped for the stream. Power management ruled out. Next: the bus and port parameters, against the phone's Android kernel.

Considered
: Keeping the bus awake.

Rejected
: That as the answer.

About
: audio-mic

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


<a id="2026-11-17-deep-sleep-researched"></a>
### Deep sleep researched: the path chosen and measured where it starts

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: The first feature research (prompts/feature-research.md), signed research-deep-sleep. surya read without a change: s2idle only, OS-initiated PSCI, the SoC's sleep counters readable, no suspend yet in a measured boot, CX collapse and AOSS sleep at 0, the audio DSP never asleep, the deepest cluster state never entered. Six research rows (how Qualcomm reaches its floor, what blocks it, the SM7150 cluster parameters against surya's own tables, waking for calls, the other ways, surya measured), the decision with four ways rejected, six steps on the backlog each with its proof, a deep-sleep part with surya's row unknown, and the check soc-sleeps in lab-tools' suite. docs now shares its research and sources tables.

About
: deep-sleep

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


<a id="2026-11-10-the-ear-withdrawn"></a>
### What the ear heard is withdrawn

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-10

Done
: The microphone was the author's earphones, worn on his head: its distance from the phone changed as he moved. The levels measured, the difference seen between the two speakers, and the passes themselves cannot be relied on. The heard checks are out of the baseline and the lab's microphone is un-named until one is fixed in place; the tool stays, proven to work mechanically.

Considered
: Keeping the results with a caveat.

Rejected
: That: evidence from an instrument that moves is not evidence, and a later failure would have looked like the phone getting worse.

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


<a id="2026-11-17-health-on-the-phone"></a>
### The phone checks its own health after every boot

Project
: linux-phone-oco/lab-tools

Entry date
: 2026-11-17

Done
: devlab-health, a static Rust runner, with generic checks in postmarketOS's test shape, put on surya by devlab suite put now; after a reboot it ran by itself and said healthy (29 pass, 4 in known gaps). Landscape read first: the package conveyor will carry it as an Alpine package; agent access's plan carries devlab's MCP door.

Date
: 2026-11-17

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


<a id="2026-11-10-flashed-by-devlab"></a>
### Flashed by devlab; the shell flash script retired

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-10

Done
: surya flashed from the pristine stock image by devlab flash and brought back by devlab provision, all 20 checks passing; flash.sh removed, as planned once devlab had done a real flash. A new check, root-fills-its-partition: the first boot had left the system at 2 GB on a 104 GB partition.

Considered
: Keeping flash.sh as a fallback.

Rejected
: That: two ways to flash drift apart; the shell original stays in git history.

About
: dl-safe

---


<a id="2026-11-10-heard"></a>
### Both speakers heard - then withdrawn

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-10

Done
: With the author's EarPods as the lab's microphone, devlab hear played a 1000 Hz tone on each speaker and heard both: left at -24.0 dBFS, right at -29.2 dBFS, each over 70 dB above the silent room. The tones are in the manifest. Observed, not judged: the right read 5 dB quieter - the microphone's place or the speakers themselves; one measurement cannot say. WITHDRAWN the same day: the microphone was worn by the author and moved; neither the levels nor the 5 dB difference can be relied on.

Considered
: Calling the 5 dB a fault.

Rejected
: That, on one measurement from one position.

About
: audio-speaker

---


<a id="2026-11-10-its-idea"></a>
### The lab's idea, told for anyone

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-10

Done
: What this lab is - one particular phone, everything true of it written down, experiments that fall back by themselves - as a piece of writing for a reader who knows nothing of it.

Rejected
: A list of files.

---


<a id="2026-11-10-suspend-crash-found"></a>
### The suspend crash found: a FastRPC helper attached at suspend

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-10

Done
: After the flash the audio DSP died on every suspend attempt (the attempts abort at once: the USB link cannot go idle). Found by experiment, one change at a time: not a first-boot effect (9 of 9 on the second boot), not the sensor proxy (15 of 15 without it), but hexagonrpcd's RootPD helper - 0 of 8 without it, and 0 of 9 on a clean boot with it masked, all 21 checks passing. Masked in the manifest, so every flash has it. The check's resume counter, which always said 0, rewritten in awk and checked against a boot with 24.

Considered
: A hand-made change the manifest lacked; a first-boot effect; the sensor proxy; a stream left open.

Rejected
: All four, each by its own measurement. The old 'rare' crash was the same one: there the helper died with the first crashes and stayed down.

About
: deep-sleep

---


<a id="2026-11-10-the-ear-withdrawn"></a>
### What the ear heard is withdrawn

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-10

Done
: The microphone was the author's earphones, worn on his head: its distance from the phone changed as he moved. The levels measured, the difference seen between the two speakers, and the passes themselves cannot be relied on. The heard checks are out of the baseline and the lab's microphone is un-named until one is fixed in place; the tool stays, proven to work mechanically.

Considered
: Keeping the results with a caveat.

Rejected
: That: evidence from an instrument that moves is not evidence, and a later failure would have looked like the phone getting worse.

About
: dl-manual

---


<a id="2026-11-10-usb-flapping"></a>
### The USB link no longer flaps

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-10

Done
: Reported by the author: the phone kept reconnecting on his PC (26 USB disconnects in 5 minutes on the lab machine). On USB a suspend cannot complete, and the shell retried every 12 seconds, each attempt dropping the link. A small service holds a kernel wake lock while the port is connected to a host - independent of any shell - baked in by the manifest, with a check. Known before, never written down: it is now.

Considered
: Changing the shell's suspend hook.

Rejected
: That: a fix inside one shell does not hold under another, or under none.

About
: deep-sleep

---


<a id="2026-11-11-more-measured"></a>
### More of the phone, measured

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-11

Done
: Eight of the phone's twenty parts stood as unknown. The checks now also ask: is Wi-Fi joined and does the gateway answer; is Bluetooth powered and does it hear anything; is there a SIM and is the modem ready; does the kernel expose a headset-jack detector, a fingerprint reader, any motion or light sensor, any image sensor behind the camera pipeline. All read-only.

Considered
: Marking parts as working from a device node alone.

Rejected
: That: there and set up is what a machine can prove; the rest are witnessed tests.

About
: surya-every-part

---


<a id="2026-11-11-port-table-cleared"></a>
### The port table cleared; a boot spent on a missing tool

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-11

Done
: The TX bus's port layout and timings match mainline sm8250 and the vendor's layout for the ports in use - not the cause. A boot to dump the SoundWire registers found this kernel has no SoundWire debugfs.

Considered
: Seven ports against the vendor's five as the cause.

Rejected
: That, after comparing the ports actually used. And booting before checking the tool exists - a lesson: check the instrument first.

---


<a id="2026-11-11-the-cameras-understood"></a>
### Why the cameras are dark, and the way in

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-11

Done
: Read from the phone and from sources, changing nothing: the camera pipeline and its control buses work; the phone's description lists no sensor. The vendor's kernel yields the wiring of seven sensor slots but no model names. Written up with the wiring table and a four-step way in (research/cameras.md).

Considered
: Describing the sensors from the models reported for this phone elsewhere.

Rejected
: That: hearsay. A chip should say what it is, on its own bus, before a driver is bound to it.

About
: camera-rear

---


<a id="2026-11-11-the-codec-comes-up"></a>
### The microphone codec comes up

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-11

Done
: Traced the codec's timeout to a bus clash on the microphone-side SoundWire bus, and that to one pin muxed to the wrong function in the audio pin driver (and one more on the receive side), read against the phone's own Android kernel. Corrected and rebuilt: the codec initialises and the sound card is made with it. Recording through it is next.

Considered
: The macros' autosuspend; the upstream revert (it gives no reason).

Rejected
: Guessing at clock fixes.

About
: audio-mic

---


<a id="2026-11-11-the-microphone-frontier"></a>
### The microphone's chain, nearly whole

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-11

Done
: Booted the microphone test kernel (after finding the earlier tries had been given a gzip kernel): for the first time everything up to the codec came up; the card fails on one timeout. Measured which speaker is the bottom one. Saw a boot with no sound card and recorded it.

Considered
: Theories about the bootloader.

Rejected
: Acting before reading the bootloader's own record.

About
: audio-mic

---


<a id="2026-11-11-the-modem-with-a-sim"></a>
### The modem with a SIM

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-11

Done
: The SIM is seen and ready (1&1). The modem stays shutting-down and refuses to go online, even after a reboot; it loops on one file through tqftpserv, ending each read itself. One theory - a missing read-write directory - was checked and is wrong: the directory exists.

Considered
: A missing directory.

Rejected
: That: the program's own paths showed it exists.

About
: modem-data

---


<a id="2026-11-11-the-recording-map"></a>
### The map to a first recording

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-11

Done
: Listed the codec's recording side in the test kernel and read how the phone's own Android build routes its main microphone; the names match closely. Found that the kernel branch's pin driver differs from the tested tree - the fix is to be ported, not pasted.

Considered
: Pasting the table change into the branch.

Rejected
: That: the branch's driver is not the one that was tested.

About
: audio-mic

---


<a id="2026-11-11-two-recording-tries"></a>
### Two recording tries

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-11

Done
: The main-microphone route from the phone's Android build sets cleanly in the test kernel; the capture stream fails when it starts - the TX bus loses the codec exactly when it is reshaped for the stream. Ruled out power management. Measured the audio processor's once-a-second handover signal.

Considered
: Keeping the bus awake.

Rejected
: That as the answer: it changed nothing.

About
: audio-mic

---


<a id="2026-11-17-health-on-the-phone"></a>
### surya checks its own health after every boot

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-17

Done
: The manifest says what surya is expected to have ([health]: its sound card, three signal processors and what rests on each, the known boot warnings and failed unit with their reasons, and four known gaps - fingerprint, sensors, both cameras); its amplifier checks moved to tests/health/base. devlab suite put the suite on the phone; after a reboot it ran by itself and said healthy: 29 pass, 4 in known gaps, 1 not measured (no SIM card seen: the modem reports sim-missing).

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


<a id="2026-11-17-telegram-provision"></a>
### Telegram at provisioning: telegram-desktop, held by Alpine v3.24

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-17

Done
: The author asked for a Telegram client at provisioning as firefox is. Alpine ships one Telegram client for aarch64, the official telegram-desktop (no tdlib, no libpurple Telegram plugin for chatty, no Kotatogram); it went into provision/packages.txt (surya-lab #108). Installing it on the phone failed: v3.24 community ships 6.8.5-r0 linked to libada.so.3 while ada is now 4.0, so apk cannot resolve it even after apk update. devlab provision installs the list in one apk add, so the line would have failed firefox and i2c-tools too; it now waits there as a comment (surya-lab fix right after #108). Edge has 7.4.4-r0 rebuilt against libada.so.4. Nothing was installed or changed on the phone.

Considered
: Installing telegram-desktop from the edge repository for one package: it would pull edge libraries into a v3.24 system that another session is testing audio on.

Rejected
: chatty with a Telegram plugin: no such plugin is packaged. Keeping the line live: it breaks the whole package list.

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


<a id="2026-11-17-1000-how-the-phone-stands"></a>
### How the phone stands

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-17

Done
: Hand-over from the bring-up session (2026-11-17, ~10:00 UTC) to the phone keeper. RUNS: kernel 7.1.0-sm7150-calls+ is the KEPT default (boot entry pmos-calls.conf, blessed); built from linux-phone-oco/linux branch test/surya-calls = tas2562 fixes + PR3 (LPI SoundWire pin mux) + PR5 (SoundWire controllers at 0x62ed/0x62ef, no DCODEC vote) + PR4 (WCD9375 reset: active-low, gpio mux, no sleep state) + PR6 (capture through swr2 DAI 1) + PR7 (q6voice from pulpoff/linux-surya). The proven microphone-only kernel (pmos-mic, 7.1.0-sm7150-mic+) is still installed as a fallback; stock (7.1.0-rc3-sm7150) boots after 3 bad boots. The old /lib/modules/7.1.0-rc3-sm7150-wcd belongs to a removed experiment and can go. HEALTHY: the last runs say healthy, 37-39 pass, 4 known gaps (fingerprint, sensors, both cameras). WORKS, proven by the phone itself: speakers (stereo), earpiece (= the top TAS2564 speaker; the WCD9375 EAR amplifier is silent), both microphones (bottom ADC1, top ADC2 at INP3) through the UCM profile, mobile data (Vodafone.de LTE; tqftpserv 1.3 from Alpine edge, a gsm connection with no APN), SMS (texts its own number, telephony layer, daily), calls both ways (q6voice, Voice Call UCM verb, q6voiced on PCM 0,6, devlab-call-uplink, daily call-echo to blueSIP's echo line +49 89 721010 99701 - its announcement lasts ~19 s). MUST NOT BE UNDONE: the VoiceMMode1 TX Topology 69488 set in the HiFi verb at boot (the DSP builds its voice processor once, at the first call of a boot; a call set up with the default 0x10F71 keeps the uplink silent until a reboot); the codec node has no sleep pin state (ASoC holds it in reset otherwise); /etc/modprobe.d/devlab-pd-mapper.conf (loads qcom_pd_mapper before the ADSP; without it ~1 boot in 5 has no sound card); tqftpserv@edge (1.1.1 keeps the modem in shutting-down); the SIM's own number lives only in ~/.config/devlab/xiaomi-surya/own-number and /etc/devlab/private/own-number - never in a repository. Test sounds are -6 dBFS at 20% (the author: soft). The SIM is in slot 2 (slot 1: no ATR). Never read /sys/kernel/debug/gpio or the LPI pinctrl at 62b40000 (manifest hazards).

Considered
: next: (1) headphones and the headset mic: need a headset plugged in and the author listening (verify-headphone-mic-earpiece; the jack detector exists since the WCD fixes). (2) upstream, waiting for the author to send: upstream-queue linux/sm7150-wcd 0001-0004 (sm7150-mainline), the tas2562 pair, upstream-alpine-tqftpserv, upstream-pd-mapper-order; q6voice is out of tree (sdm845-mainline) - its upstreaming is not ours yet. (3) the kernel is not yet a package: the kept kernel lives only on the phone's boot partition; a reflash returns stock until it goes through the package conveyor (device.toml carries the userspace side: UCM, q6voiced conf, call-uplink, pd-mapper, tqftpserv@edge, the mobile connection). (4) the deep-sleep steps, sensors, off-state charging, as the queue orders.

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


<a id="2026-11-17-1145-how-the-phone-stands"></a>
### How the phone stands

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-17

Done
: Keeper phone-keeper-20261117-1135: ran sensors-and-the-mask on the kept kernel 7.1.0-sm7150-calls+ (stays the kept default). Result: DSP still writes (temp.json, sns_reg_version) and crashes with only sensorspd unmasked; undone, rebooted, healthy 37 pass 0 fail. Sleep items need the devlab suspend verb (lab-tools health-suspend-cycle, not yet built) so they were not taken; no suspend was tried by hand.

Considered
: next: sleep-measured-once needs the devlab suspend-cycle verb first (lab-tools, soft_connect + wake locks released + rtcwake, counters read before and after); sensors-registry-writes needs a hexagonrpcd build with state-copy writes (a package, then one probe). Must not be undone: sensorspd and rootpd stay masked; configs mtimes restored.

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


<a id="2026-11-17-1225-how-the-phone-stands"></a>
### How the phone stands

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-17

Done
: Keeper surya-keeper, 2026-11-17. Phone runs the kept kernel 7.1.0-sm7150-calls+ (default; the one-shot dtb with cluster parameters 0x41002244/0x4100c244 was tried once and is gone), healthy 37 pass 0 fail after a reboot. Deep sleep: the first measured suspend cycles (5, by hand: research/deep-sleep/2026-11-17/) show soc-sleeps = fail and the real cause of no sleep so far: the suspend ends at once on the wake-armed, storming serial IRQ 157 (qcom_geni_serial 88c000); and Bluetooth dies across a suspend and hangs the resume, a reboot recovers. sleep-measured-once and sleep-wake-source are done.

Considered
: next: sleep-wake-uart (disable the serial's wakeup and find why it storms), with sleep-bt-resume (rfkill/stop bluetooth before suspend) in the same cycle; then repeat the cycle on the kept kernel for a real number, then sleep-cluster-params on the prepared dtb (decompile /boot/dtbs-calls/qcom/sm7150-xiaomi-surya-huaxing.dtb, sed the two values, dtc, devlab kernel try calls --dtb). Must not be undone: sensorspd and rootpd stay masked. Cycle method: put the script on the phone and run it with systemd-run, never nohup; never read /sys/power/wakeup_count with a wake lock held (it blocks); read sleep length from the RTC, not date or dmesg.

About
: deep-sleep

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


<a id="2026-11-17-sim-removed-skips"></a>
### SIM out: the four SIM checks skip

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-17

Done
: Added no_sim to the health suite's lib.sh (ModemManager: sim-missing or no SIM object); modem-registered and mobile-data (lab-tools #73, released as devlab-health 0.1.6) and call-echo and sms-loopback (surya-lab #123) now say 'skip: no SIM card'. The SIM check sits before once_a_day, so a skip does not use up the day. Put the suite, rebooted once: modem-registered, mobile-data, call-echo, sms-loopback all skip; 35 pass, 5 fail (only the known gaps), 5 skip. The support status of calls, SMS and data stays 'works'.

Considered
: Detecting the missing SIM per check (the checks already skipped on 'modem state failed', but under that wording and, for the echo call, after the day was marked).

Rejected
: A manifest flag 'sim = false' (a state to keep true by hand; the modem says it itself).

About
: sim-removed-skips

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

---


<a id="2026-11-17-way-back-decided"></a>
### Deep sleep's way back: decided before the next suspend

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-17

Done
: Looked around (research 2026-11-17-surya-way-back-inventory): the stock qcom_wdt is stopped in late suspend, so it would not have rescued the first hang; ramoops (4 MiB) and a settable RTC exist. Decided (2026-11-17-deep-sleep-way-back): a patched qcom_wdt module that stays armed through sleep, the RTC set, the log from ramoops; built it for the running kernel (vermagic matches), wrote sleep/way-back.sh and sleep/build-wdt.sh.

Considered
: Timed reboot, USB awake, pstore alone, a kernel rebuild, serial console.

Rejected
: See the decision.

About
: deep-sleep

---


<a id="2026-11-17-way-back-proven"></a>
### The way back proven; the Bluetooth-blocked hang reproduced and recovered

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-17

Done
: Built and installed the patched qcom_wdt (updates/, stock behaviour until enabled); sleep/way-back.sh verbs check/install/enable/fuse/defuse/collect/cycle. Idle fuse, a probe through a real s2idle entry and the one measured cycle (BT blocked, 15 s) all ended with the watchdog resetting the phone and the phone booting by itself; the cycle hung at suspend entry as before. pstore is empty after a bite; the journal keeps the marker.

Considered
: A longer fuse (the watchdog counts 32 s at most), setting the RTC (not settable).

Rejected
: ramoops as the log (does not survive the reset).

About
: deep-sleep

---


<a id="2026-11-17-1350-how-the-phone-stands"></a>
### How the phone stands

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-17

Done
: Keeper surya-keeper-3, 2026-11-17. Phone on the kept kernel 7.1.0-sm7150-calls+, healthy after a clean reboot (only the 5 known gaps fail; the SIM is out: modem-registered, mobile-data, call-echo, sms-loopback skip 'no SIM card'; calls/SMS/data stay 'works'). Deep sleep's way back is built and proven (decision 2026-11-17-deep-sleep-way-back, research 2026-11-17-way-back-measured): sleep/way-back.sh in surya-lab (verbs check/install/enable/fuse/defuse/collect/cycle) with the patched qcom_wdt in updates/ (acts as stock until enabled; keep_armed_in_suspend, enable per cycle); the watchdog is 30 s at most, so a cycle sleeps at most 15 s. Idle fuse, probe through a suspend entry and the one measured cycle all reset the phone by the watchdog and it came back with no hands. The cycle (Bluetooth rfkill-blocked) hung at suspend entry again: no 'PM: suspend entry' line, suspend_stats 0/0; with Bluetooth on s2idle ends in 2-3 s on IRQ 157. pstore is empty after a bite, the persistent journal (synced before the arm) is the log. The PMIC RTC cannot be set. After a bite the amp 0x4c read silent: reboot once cleanly after a bite.

Considered
: next: sleep-wake-uart as one change, with way-back.sh cycle SLEEP as the way back: Bluetooth unblocked but the wakeup of serial@88c000 off (or hci_uart/btqca unbound before the suspend) so IRQ 157 cannot end s2idle and the BT UART is not half-powered; then 'cycle 15' (the script blocks Bluetooth itself: add a verb or a flag for the unblocked variant first). Put the script on the phone with devlab phone put and run it with systemd-run (never nohup). After any try that ends in a bite: one clean reboot, read the health. Must not be undone: sensorspd and rootpd stay masked.

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


<a id="2026-11-17-1500-sleep-wake-uart"></a>
### sleep-wake-uart: the wake found (irq 158) and turned off; a cycle of 15 s that lasts, the SoC still not asleep

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-17

Done
: Looked first: mainline serial_core/qcom_geni_serial/hci_qca read (research 2026-11-17-qca-uart-wake-across-suspend). Traced one short cycle with Bluetooth up: the wake is irq 158 (GPIO 41, the UART RX wake pin, '88c000.serial:wakeup'), not 157. Added way-back.sh cycle SLEEP bt-on (serial power/wakeup off for the cycle, restored after; qcom_stats before/after, RTC-measured sleep, hci0 check). Tests: cycle 5 bt-on twice and cycle 15 bt-on once, all three woke by the RTC alarm (RTC 7, 7, 17 s), the watchdog defused each time, hci0 scanning after, no bite, no reboot needed. Counters from the SoC after the 15 s cycle: cxsd 0, aosd 0, ddr 0, adsp 0 (as before); soc-sleeps fails: 'suspended, yet the SoC never reached its lowest state: cxsd 0, aosd 0; suspends this boot: 7; processors never asleep: adsp; wake locks: devlab-usb'. Whether the cluster low-power states were entered in these cycles: not known yet (cpuidle residency not read in way-back).

Considered
: Rejected for the wake: rfkill block, unbinding hci_uart/btqca, a device-tree change, a udev rule now (decision 2026-11-17-serial-wakeup-off).

About
: deep-sleep

---


<a id="2026-11-17-1500-how-the-phone-stands"></a>
### How the phone stands

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-17

Done
: Keeper surya-keeper-4, 2026-11-17. Phone on the kept kernel 7.1.0-sm7150-calls+, booted once (up since about 13:45), 7 s2idle suspends this boot, no watchdog bite, no reboot after them; Bluetooth up and scanning; the serial's power/wakeup is back to enabled. Suite after: 35 pass, 6 fail, 4 not measured - the fails are the known ones (fingerprint reader, two image sensors, sensors, proximity) and soc-sleeps; SIM checks skip. Deep sleep: the wake is solved (irq 158, the UART RX pin; way-back.sh cycle SLEEP bt-on), the SoC still does not collapse CX or AOSS: qcom_stats cxsd 0 and aosd 0 after a 15 s cycle, adsp 0 against about 200 for the compute DSP and the modem. sleep-wake-uart and sleep-bt-resume are done (bt-resume: not seen in 3 cycles of at most 15 s). Sensorspd and rootpd stay masked.

Considered
: next: sleep-adsp-awake (rank 1 now): reboot without soundwire_qcom.stay_awake=1 (a one-shot test kernel cmdline through devlab kernel try), then cycle 15 bt-on and read qcom_stats adsp, cxsd, aosd; then find the LPASS vote that holds the audio DSP up. After that sleep-cluster-params on the prepared dtb (decompile /boot/dtbs-calls/qcom/sm7150-xiaomi-surya-huaxing.dtb, sed 0x41002244 and 0x4100c244, dtc, devlab kernel try calls --dtb) and a cycle 15 bt-on. Cycle method: sh /var/tmp/way-back.sh cycle 15 bt-on as a systemd-run unit with StandardOutput=file:, after devlab phone put sleep/way-back.sh; read the RTC, not date or dmesg; a bt-on cycle also records qcom_stats. Not read yet: cpuidle residency per state across a cycle (add to way-back.sh stats if the cluster question needs it).

---


<a id="2026-11-17-1530-lpoco-health-on-the-phone"></a>
### lpoco-health put on the phone

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-17

Done
: Built devlab from lab-tools main (the installed binary predated #75), ran suite put now, run, list and gather now. Found and fixed the old lib.sh path in 8 device checks; moved one empty report aside; gathered 19 reports into tests/results and filed 6 runs. Health reads as before: 35 pass, 6 fail, 4 not measured, SIM checks skip. The installed devlab (/home/mll/.local/bin/devlab, 14:13) is older than main: not replaced here; runs used wt-k4-labtools/target/release/devlab.

About
: deep-sleep

---


<a id="2026-11-17-1540-how-the-phone-stands"></a>
### How the phone stands

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-17

Done
: Keeper surya-keeper-4, 2026-11-17 (end). Phone on the kept kernel 7.1.0-sm7150-calls+, one boot (up since about 13:45), 7 s2idle suspends this boot, no watchdog bite. The suite is now lpoco-health on the phone (put 14:10, 21 checks, /usr/bin/devlab-health kept as an alias, old reports moved to /var/lib/lpoco-health): 35 pass, 6 fail, 4 not measured - SIM checks skip; the fails are fingerprint, two image sensors, motion-and-light, proximity-reads and soc-sleeps (cxsd 0, aosd 0, adsp never asleep). Deep sleep: the wake is solved (irq 158, the UART RX pin; way-back.sh cycle SLEEP bt-on keeps Bluetooth up with the serial's wakeup off for the cycle; 3 cycles ended by the RTC alarm, hci0 up); the SoC does not yet collapse CX or AOSS. Sensorspd and rootpd stay masked. The installed devlab in /home/mll/.local/bin (14:13) is older than lab-tools main: use a build of main (cargo build --release -p devlab in a lab-tools worktree) for suite put, list, off, on.

Considered
: next: sleep-adsp-awake (rank 1): reboot without soundwire_qcom.stay_awake=1 (devlab kernel try, one-shot cmdline), then sh /var/tmp/way-back.sh cycle 15 bt-on as a systemd-run unit with StandardOutput=file: (devlab phone put sleep/way-back.sh first; it is on the phone now), read adsp, cxsd, aosd. Then sleep-cluster-params on the prepared dtb. Note: devlab suite put uses the lab as main has it, so a change to the checks must land before put. Open: gather stops on a 0-byte report (one was moved to /var/lib/lpoco-health/empty-reports/).

---


<a id="2026-11-17-1550-lpoco-health-v017"></a>
### lpoco-health v0.1.7 put on the phone

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-17

Done
: Built devlab from lab-tools main (v0.1.7), suite put now, suite run: 35 pass, 6 fail, 4 not measured as before, the SIM checks skip 'no SIM card', the eight audio and call checks pass again with the old and new lib.sh paths both present; gather now filed 20 runs. soc-sleeps is the one failing check that matters (cxsd 0, aosd 0).

About
: deep-sleep

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


<a id="2026-11-17-sleep-adsp-awake-first-try"></a>
### sleep-adsp-awake: first try

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: Baseline cycle without stay_awake (the kept kernel has none): adsp 0. Built the macros' hw-vote release (rx, tx, va), tried once as 7.1.0-sm7150-calls-idle with the patched qcom_wdt: healthy, cycle adsp 0. Stopped services live: no change. Phone back on the kept kernel, healthy.

Considered
: Linux holds CX through the UARTs (pm_genpd_summary); the LPI pinctrl also votes LPASS_HW_MACRO.

Rejected
: Polling the phone during a cycle: it hung the phone once (author reset it).

About
: deep-sleep

---


<a id="2026-11-17-1620-how-the-phone-stands"></a>
### How the phone stands

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: Keeper surya-keeper-5, 2026-11-17 (end). Phone on the kept kernel 7.1.0-sm7150-calls+, healthy (35 pass, 0 fail, 5 known gaps, 5 not measured, no SIM), after one clean reboot from the try kernel 7.1.0-sm7150-calls-idle (installed as pmos-idle; remove with devlab kernel remove idle if not wanted). sleep-adsp-awake: the kept kernel has no stay_awake; the macros' hw-vote release did not change adsp (0), cxsd 0, aosd 0; patch and notes in research/deep-sleep/2026-11-17/. A cycle polled over ssh hung the phone once (author reset it): start the cycle as a systemd-run unit with StandardOutput=file: and leave the phone alone for 3 minutes (ssh answers slowly for about a minute after resume). Linux itself holds CX through the active UARTs (pm_genpd_summary: 88c000.serial, a88000.serial).

Considered
: next: sleep-adsp-awake stays in-progress: read the DSP side before more LPASS code (the ADSP's sensors PD, call audio q6voiced/pd-mapper, remoteproc glink channels, what other subsystem votes for it); a useful awake-idle probe is qcom_stats adsp count without suspending. Also sleep-cluster-params on the prepared dtb. Open: a try kernel needs its own release name (make LOCALVERSION=-NAME, no autoconf rebuild) and the patched qcom_wdt built as module name qcom_wdt in updates/ (way-back.sh refuses otherwise); ocoeco manual wrote rows without project (fixed by hand in PR 218): a gap in ocoeco for repositories whose tables require project.

About
: deep-sleep

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


<a id="2026-11-17-keeper-6-adsp-floor"></a>
### sleep-adsp-awake: the DSP side read, two floor tests

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: Read the DSP and the others' votes awake; two measured cycles with adsp stopped, then adsp+cdsp+modem stopped (adsp-floor.sh): cxsd/aosd/ddr 0 both times. Phone rebooted once cleanly, suite 35 pass 0 fail. Recorded research, decision 2026-11-17-adsp-is-not-the-floor, backlog.

Considered
: A trace of the rpmh sleep set: no rpmh trace events in this kernel.

About
: deep-sleep

---


<a id="2026-11-17-1650-how-the-phone-stands"></a>
### How the phone stands, keeper surya-keeper-6 end

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: Keeper surya-keeper-6, 2026-11-17 (end). Phone on the kept kernel 7.1.0-sm7150-calls+, rebooted once cleanly after the floor tests (about 15:42), healthy 35 pass, 0 fail, SIM checks skip; no watchdog bite. sleep-adsp-awake: two measured cycles with the audio DSP stopped, then adsp+cdsp+modem stopped: cxsd, aosd, ddr 0 both - the DSP is not what holds the SoC (research 2026-11-17-adsp-stopped-cx-aosd-ddr-stay-0, decision 2026-11-17-adsp-is-not-the-floor, script research/deep-sleep/2026-11-17-adsp-floor/adsp-floor.sh). The PSCI cluster domain reached its deepest state (S2) in the cycle. Sensorspd and rootpd stay masked.

Considered
: next: sleep-cluster-params (now rank 1): redo the cycle on the prepared dtb (devlab kernel try calls --dtb cp.dtb; one-shot), adsp-floor.sh keep OUTDIR as the cycle with summaries before and after. Then the UARTs' CX vote (cycle with both UARTs closed) and the rpmh sleep set (no trace events in this kernel: not known yet how to read it). sleep-adsp-awake keeps only: does the ADSP firmware fill its own qcom_stats entry (not known yet).

About
: deep-sleep

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


<a id="2026-11-17-1650-how-the-phone-stands"></a>
### How the phone stands

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-17

Done
: Keeper surya-keeper-7: phone on the kept kernel 7.1.0-sm7150-calls+ (the cp.dtb try booted once, healthy 35 pass 0 fail; since then the kept dtb again after the next reboot). 8 cycles 15 bt-on on cp.dtb: real 15 s s2idle, cluster S2 0x4100c244 used, cxsd/aosd/ddr 0. Tracing was left on in ftrace (reset by reboot).

Considered
: next: sleep-cluster-params waits on a deeper decision (what holds AOSS/CX/DDR is unknown); candidates: owner of the SH0 x=1,y=3 sleep vote, qcom_aoss prevent_* knobs, XO/VRM votes, USB gadget, display RSC. Then sleep-wake items.

---


<a id="2026-11-17-floor-research"></a>
### Why the SoC floor is not reached: researched

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: Read the recorded cycles, qcom_stats and apps_rsc in the tree; two researchers on mainline/other SoCs and downstream/observed SM7150; ranked six holders; chose subtraction; nine backlog items with proofs.

Considered
: S2RAM, other cluster values, a smp2p sleepstate port, a downstream power-mode port.

Rejected
: Anything touching the phone: it is the keeper's.

About
: deep-sleep

---


<a id="2026-11-17-1800-how-the-phone-stands"></a>
### How the phone stands

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-17

Done
: Keeper-8: phone on the kept kernel 7.1.0-sm7150-calls+, rebooted after the sensors probe, healthy 35 pass 0 fail (5 known gaps). sensorspd and rootpd masked as before, config mtimes restored, nothing kept from the probe. sleep-fastrpc-helpers could not be measured: the probe (research 2026-11-17-sensorspd-probe-still-writes) shows the DSP still writes temp.json and sns_reg_version with the configs current, 7 ADSP crashes in 25 s and the audio card gone until reboot.

Considered
: next: sensors-registry-writes (rank 3, needs phone): build hexagonrpcd with write support limited to a state copy of the registry (hexagonrpc PR #27 commits 40e5041, or the -S state dir of #19, or the #29 patch) for aarch64 musl, seed the copy from the package, serve sns_reg_version, one try per boot; reboot after any try that crashes the ADSP. No hexagonrpc source tree is on the lab yet. Then sleep-fastrpc-helpers (measure sensors after a resume with sensorspd stopped). Also: sleep-cluster-params waits on a deeper decision (research session).

About
: deep-sleep

---


<a id="2026-11-17-1730-keeper9-floor-read-holders"></a>
### floor-read-holders: what is on before a cycle

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-17

Done
: Read cmdline, clk, regulator, icc, genpd, cpuidle, wakeup_sources, qcom_stats at idle and before way-back.sh cycle 15 bt-on (baseline: cxsd/aosd/ddr 0, modem moves 2137->2147, cdsp 60 fixed). No clk_ignore_unused/pd_ignore_unused (floor-no-ignore-unused closed). remoteprocs hold bi_tcxo xo; cx/mx at 256 from the two serials; usb, ufs, wcn3998 rails on; rpmh bb/rf, camera, gpu, video not held. Late-suspend contents not known yet.

Considered
: next: floor-dsps-never-started (module_blacklist=qcom_q6v5_pas, one try, cycle 15 bt-on). Sensors item skipped: helper crash-loops the ADSP.

About
: deep-sleep

---


<a id="2026-11-17-1810-keeper9-dsps-never-started"></a>
### floor-dsps-never-started: the DSPs are not the holder

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-17

Done
: One-shot dtb with adsp/cdsp/modem remoteprocs disabled on the kept kernel: cycle 15 bt-on cxsd/aosd/ddr 0 -> 0; soc-sleeps fail (wake lock devlab-usb); no-processor-crashes pass. DSP-vote hypothesis retired. Phone falls back to the kept dtb at the next boot.

Considered
: next: floor-wlan-off, then floor-udc-unbound (devlab-usb wake lock), floor-sh0-owner, floor-aoss-knobs.

About
: deep-sleep

---


<a id="2026-11-17-1840-keeper9-wlan-off"></a>
### floor-wlan-off: WLAN is not the holder

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-17

Done
: Phone back on the kept dtb after the no-DSP try. ath10k unloaded, cycle 15 bt-on: cxsd/aosd/ddr 0 -> 0, cdsp 60 -> 60. Phone on the kept kernel, healthy as before (wlan returns at the next boot).

Considered
: next: floor-udc-unbound, floor-sh0-owner, floor-aoss-knobs.

About
: deep-sleep

---


<a id="2026-11-17-1900-keeper9-udc-unbound-stuck"></a>
### floor-udc-unbound stalled the phone: a step that can drop USB keeps the watchdog armed

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-17

Done
: Unbound a6f8800.usb from dwc3-qcom-legacy, ran way-back.sh cycle 15 bt-on, rebound: the lab link did not return (no usb interface, 172.16.42.1 silent 10+ min), WLAN still unloaded from the previous item. The cycle defuses the watchdog on return, so nothing reset the phone: the author's hands (hold power) are needed. Cycle result unread in /var/tmp/k9u.out on the phone: not known yet.

Considered
: Lesson: any step that can drop the only link (UDC unbind, WLAN unload) must leave the watchdog ARMED (way-back.sh fuse 30, not defused) so the phone resets itself, and must not rely on a rebind to bring the gadget back. Next after the reboot: read /var/tmp/k9u.out first, then floor-sh0-owner / floor-aoss-knobs; floor-udc-unbound stays open until measured.

About
: deep-sleep

---


<a id="2026-11-17-1950-keeper9-udc-and-aoss"></a>
### floor-udc-unbound and floor-aoss-knobs measured

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-17

Done
: UDC unbound: cxsd/aosd/ddr 0 -> 0 (result survived in /var/tmp/k9u.out, phone healthy after the hard reboot: 35 pass 0 fail). aoss knobs: cx/ddr writes time out, 'ucore did not ack channel': the QMP link to the AOP is dead, counters 0 -> 0. Holders subtracted so far with no change: DSPs, WLAN, USB.

Considered
: next: floor-aop-qmp-no-ack (new, read only first), floor-sh0-owner, floor-suspend-late-dump.

About
: deep-sleep

---


<a id="2026-11-17-surya-research-sh0-aop"></a>
### SH0 and AOP QMP researched

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: Read bcm-voter, sm7150/sm8150/sc7180/sdm845 icc tables, qcom_aoss and the three DTs in the kernel-rc3 tree; found SH0 is keepalive-by-design and the sleep residual a consumer tag; chose DT subtraction; queued phone items.

Considered
: QMP-first, late-suspend dump kernel, keepalive patch, firmware-latch reading

Rejected
: QMP-first and the dump kernel: more build for what one dtb answers; keepalive patch: hides the consumer. Nothing on the phone was touched.

About
: deep-sleep

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


<a id="2026-11-17-1815-keeper10-sh0-owner"></a>
### floor-sh0-owner: uart8 is not the SH0 owner

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-17

Done
: Read icc_summary; two one-shot dtbs on the kept kernel. Tags ACTIVE_ONLY: ignored (geni-se forces ALWAYS). uart8 disabled: cycle 15 bt-on, sleep flush still has SH0 x=1,y=3; counters 0 -> 0. Phone rebooted to the kept dtb, healthy 35 pass 0 fail.

Considered
: next: floor-sh0-qup-tags by driver unbind not DT tag (BT UART 88c000 with bt off; i2c/spi QUPs; crypto), or a late-suspend dump (floor-suspend-late-dump) to see who holds SH0; SH0 may not come from an icc consumer.

About
: deep-sleep

---


<a id="2026-11-17-1820-how-the-phone-stands"></a>
### How the phone stands

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-17

Done
: Kept kernel 7.1.0-sm7150-calls+ on the kept dtb, rebooted after the uart8 tries, healthy 35 pass 0 fail (5 known gaps). Nothing kept from the tries.

Considered
: next: floor-sh0-qup-tags (by driver unbind, BT-off cycle), sensors-registry-writes (rank 3), sleep-fastrpc-helpers. sleep-cluster-params waits on a deeper decision.

About
: deep-sleep

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


<a id="2026-11-17-1940-surya-keeper-sh0-bt"></a>
### floor-sh0-owner: BT-blocked cycle

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-17

Done
: One cycle 15 with BT blocked on the kept kernel: phone reset by the watchdog, no reading; rebooted, healthy except Wi-Fi (saved SSID out of range, lab AP renamed). Nothing kept.

Considered
: next: SH0 looks by-design; a deeper decision on holders (clocks/GDSC/counter validity) or floor-suspend-late-dump

About
: deep-sleep

---


<a id="2026-11-17-1945-how-the-phone-stands"></a>
### How the phone stands

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-17

Done
: Kept kernel 7.1.0-sm7150-calls+ on the kept dtb, rebooted by the watchdog after a BT-blocked cycle; suite 33 pass 6 fail (5 known gaps + Wi-Fi: the saved SSID is out of range, the lab AP shows another name). Nothing kept from the try.

Considered
: next: floor-sh0-owner is at a turning point (deeper decision), sensors-registry-writes, sleep-fastrpc-helpers

About
: deep-sleep

---


<a id="2026-11-17-2010-surya-research-validity"></a>
### floor-research-validity answered

Project
: linux-phone-oco/docs

Entry date
: 2026-11-17

Done
: Read qcom_stats.c, bcm-voter.c, dwc3-qcom.c, the Qualcomm sleep-current guide, the Odin 2 s2idle report; recorded research, decision, 3 backlog items. Nothing on the phone touched.

Considered
: ranked: read entry (trace, IRQ rate) before more subtraction

Rejected
: more SH0 owner-hunting, debug kernel first, calling counters broken

About
: deep-sleep

---


<a id="2026-11-17-1900-floor-entry-trace"></a>
### Floor: the suspend entry read

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-17

Done
: floor-entry-trace: one way-back cycle 15 bt-on traced; the sleep set is flushed by the last CPU (7) just before cluster-sleep-2 (0x4100b244); one wake IRQ (RTC alarm); floor-irq-quiet dropped; soc-sleeps still fails (cxsd/aosd/ddr 0)

Considered
: next: the holder is not the entry; look at what the AOP or a master holds (floor-sh0-owner stays paused, standby current as arbiter); deeper decision for the coordinator

---


<a id="2026-11-17-1905-how-the-phone-stands"></a>
### How the phone stands

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-17

Done
: Nothing changed on the phone: kept kernel 7.1.0-sm7150-calls+, last suite (18:51) as at the previous hand-over. The only queue item, sleep-standby-current, needs the author to unplug USB for an hour (and Android booted for its number); marked as waiting for him.

Considered
: next: floor-sh0-owner (turning point), sensors-registry-writes, sleep-fastrpc-helpers; standby current once he can unplug

---


<a id="2026-11-17-2010-how-the-phone-stands"></a>
### How the phone stands

Project
: linux-phone-oco/surya-lab

Entry date
: 2026-11-17

Done
: Kept kernel 7.1.0-sm7150-calls+ and kept dtb, stock services as before (sensorspd and rootpd still masked); one try of a patched hexagonrpcd ran sensorspd 150 s with 0 ADSP crashes and showed accelerometer, light, proximity, compass; transient units stopped, suite 35 pass 6 fail 4 not measured (known gaps, deep-sleep soc-sleeps lists adsp never asleep).

Considered
: next: sensors-without-crash (make the patched daemon lasting: build, state root, drop-in, unmask, across suspend), sleep-fastrpc-helpers, floor-sh0-owner (turning point)

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

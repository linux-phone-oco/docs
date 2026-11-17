<!-- Generated from data/ by tad. Do not edit by hand. -->

# Backlog

<a id="first-real-boot"></a>
### Boot the current sm7150-mainline kernel on the phone via lab-agent and record dmesg + audio card list

Project
: linux-phone-oco/docs

Status
: open

Note
: The first real job: proves the whole lab-agent loop end to end on real hardware, and gives a verified baseline instead of secondhand notes.

Opened
: 2026-11-04

Needs
: phone

Device
: xiaomi-surya

About
: surya-boots


<a id="kernel-fork-repo"></a>
### Fork sm7150-mainline/linux into linux-phone-oco and wire it into lab-agent's build/boot jobs

Project
: linux-phone-oco/docs

Status
: open

Opened
: 2026-11-04

About
: surya-boots


<a id="custom-matrix-render"></a>
### A custom render.py that draws support_status as a real device x component matrix, not one page-section per row

Project
: linux-phone-oco/docs

Status
: open

Note
: The generic engine renders it as plain rows for now (it has no reason to detect this shape specially); a matrix is much easier to scan at a glance once there is more than one device.

Opened
: 2026-11-04


<a id="verify-headphone-mic-earpiece"></a>
### Verify headphone, mic and earpiece status directly on hardware instead of relying on the secondhand pmaports note

Project
: linux-phone-oco/docs

Status
: open

Note
: The source only confirms mic/earpiece are broken as a group; headphone output specifically was never separately confirmed one way or the other.

Opened
: 2026-11-04

Needs
: phone

Device
: xiaomi-surya

Rank
: 60

About
: audio-mic


<a id="off-state-charging"></a>
### The phone cannot stay off: shutdown and a charger both boot pmOS

Project
: linux-phone-oco/docs

Status
: open

Note
: Seen 2026-11-09. poweroff in pmOS boots pmOS again. The same shutdown from the EOS recovery on the phone stays off, until a charger is plugged in; then pmOS boots instead of Android-style off-mode charging (battery on screen, system off). So the hardware can stay off; pmOS or the boot chain does not. Not diagnosed. After the audio work.

Opened
: 2026-11-09

Waits
: the decision of a feature research session: the author has hard ones researched first (2026-11-17)

Needs
: phone

Device
: xiaomi-surya

Rank
: 20

About
: charging


<a id="adsp-sensor-crash-loop"></a>
### The ADSP crashes every 13-25 s, restarting audio each time

Project
: linux-phone-oco/docs

Status
: done

Note
: Cause found 2026-11-09 by tracing every request the ADSP makes (a verbose hexagonrpcd build on the phone): the sensors service (hexagonrpcd -s) attaches the ADSP sensor process, whose registry init re-reads the sensor configs and needs to write (temp.json); hexagonrpcd refuses all writes, the firmware asserts (SNS_REG_INIT) and the whole ADSP restarts, taking audio with it. No registry state fixes it (packaged, or the phone own from persist, readable, with the version marker - which hexagonrpcd also never serves: a real gap, patch drafted). Fix in place on the phone: hexagonrpcd-adsp-sensorspd masked. Result: 0 ADSP crashes across three boots and many minutes, the POCO X3 sound card up at about 12 s, playback without crashes. Trade-off: no ADSP sensors, which did not work anyway. Next: propose upstream (do not start sensorspd on surya until registry writes are supported; serve sns_reg_version in hexagonrpcd); see sensors-registry-writes. Settled 2026-11-11: fixed by masking the audio processor's helper services (hexagonrpcd rootpd, sensorspd).

Opened
: 2026-11-09

About
: sensors


<a id="wcd937x-dt-aoncc"></a>
### WCD937x device tree: drop aoncc, clock the VA macro from q6afecc

Project
: linux-phone-oco/docs

Status
: done

Note
: The boot hang (RCU stalls) with the WCD937x patch is the aoncc clock controller at 0x03380000, an SM8250 address with nothing near it in the SM7150 tree: with only aoncc disabled the phone boots (2026-11-09). Without aoncc the VA macro has no mclk, so the macros, SoundWire and the sound card stay deferred. Fix as SM8250 does: no aoncc, VA macro mclk from q6afecc. Audit tools and results in linux-phone-oco/surya-lab and on linux-phone-oco/linux#1. Settled 2026-11-11: in linux-phone-oco/linux pull request #1; the codec comes up.

Opened
: 2026-11-09

About
: audio-mic


<a id="audio-cold-boot-race"></a>
### One cold boot came up without audio services

Project
: linux-phone-oco/docs

Status
: done

Note
: With the sensors service off, one boot (2026-11-09) never announced the ADSP audio services, so no sound card until the ADSP was restarted by hand. Not reproduced in two further valid cold boots (audio services about 0.1-0.2 s after the ADSP, card present). Watch for it; if it recurs, check whether the in-kernel pd-mapper was loaded before the ADSP booted.

2026-11-17: no longer rare - 3 of 8 boots that night (stock and test kernels alike) came up with the ADSP running but no audio services, so no sound card; restarting remoteproc0 (stop, start) brought the card back each time. The speaker's support is only as good as this; a fix, or at least a recovery at boot, is next after the microphone - or before it if it keeps recurring.

2026-11-17, read from the phone's journal (bring-up): in a bad boot the ADSP comes up but the APR audio services (aprsvc:service:4:3/4/7/8) are never added; in a good boot they appear 0.2 s after 'remote processor adsp is now up'. In the bad boot they appeared only right after the manual ADSP restart. So the protection-domain up notification (PDR, through the in-kernel PD mapper) never arrived. qcom_pd_mapper is a module nothing depends on (lsmod: used by 0), so it can load after the ADSP has booted. Next: load qcom_pd_mapper before the remoteprocs (modules-load.d through the device manifest, or the initramfs), count bad boots over twenty reboots before and after; then the kernel fix (pas depending on the PD mapper) for upstream.

2026-11-17 trial (bring-up): with /etc/modprobe.d/devlab-pd-mapper.conf on the phone (softdep qcom_q6v5_pas pre: qcom_pd_mapper) 13 of 13 boots came up with the sound card, against 8 failing of 42 health runs before. Other distributions do the same (omarchy puts qcom_pd_mapper in the initramfs for Snapdragon laptops). Next: twenty more boots, then carry the file in device.toml's flash overlays with its reason, and the kernel-side fix (the remoteproc driver depending on the PD mapper) for upstream.

Done 2026-11-17 (bring-up): 21 of 21 boots with the sound card since the PD mapper loads before the remoteproc driver; surya's device.toml now carries lab/devlab-pd-mapper.conf to /etc/modprobe.d in every flash. The kernel-side form for upstream is backlog upstream-pd-mapper-order.

Opened
: 2026-11-09

About
: surya-sound


<a id="upstream-tas2562-slot-length"></a>
### Upstream: tas2562 sets the I2S slot length from the sample width

Project
: linux-phone-oco/docs

Status
: open

Note
: Kernel patch on linux-phone-oco/linux branch fix/tas2562-i2s-slot-length (one commit, compiles for arm64, verified on surya as a module built from the exact v7.1_rc3 source). Send to sm7150-mainline and to ALSA upstream (alsa-devel, the TAS2562 maintainers), signed off by the user. Branch fix/tas2562-i2s-slot-length pushed to linux-phone-oco/linux 2026-11-10 (it had stayed local); patch 0001 in the upstream queue.

Opened
: 2026-11-09

About
: audio-speaker


<a id="upstream-ucm-surya-stereo"></a>
### Upstream: stereo speaker UCM profile for surya

Project
: linux-phone-oco/docs

Status
: open

Note
: surya-lab ucm/Xiaomi/surya/HiFi.conf: two channels, top amplifier (0x4d) left, bottom (0x4c) right. For alsa-ucm-conf (Xiaomi/surya), once the kernel fix is accepted or at least posted.

Opened
: 2026-11-09

About
: audio-speaker


<a id="try-shells"></a>
### Try every mobile shell with working sound

Project
: linux-phone-oco/docs

Status
: open

Note
: Switched in place with surya-lab ui/switch.sh (postmarketOS UI packages, tinydm for all; no reflash, the sound fixes stay). Phosh: runs, stereo verified by ear 2026-11-09. Next: Plasma Mobile, GNOME Mobile; Sxmo was the starting shell. Settled 2026-11-11: parked until the shells are cut and sound is complete.

Opened
: 2026-11-09

Needs
: phone

Device
: xiaomi-surya


<a id="microphone"></a>
### Microphone: check, and make it work

Project
: linux-phone-oco/docs

Status
: done

Note
: 











Taken up 2026-11-17 by the bring-up session, as the weakest link the data shows: audio-mic and audio-earpiece are both broken and two milestones rest on them (surya-sound, and the calls of surya-phone and lp-calls-and-messages), while the other broken parts (cameras, fingerprint, sensors) rest only on every-part and the modem waits for a SIM card. Where it stands (surya-audio/wcd-boots, 2026-11-11): with the LPI pin-mux fix (pins 19 and 23: swr_tx_data and swr_rx_data at their right function index) the WCD9375 enumerates on both SoundWire buses, binds, and the card POCO X3 is made with the codec's controls. Capture then fails at prepare: the TX SoundWire master (62ed0000) reads nothing back from the codec (swrm_wait_for_rd_fifo_avail read underflow, reading DPN_PortCtrl of port 1, addr 0x102), so Program transport params fails with -5 - also with the bus and codec held awake. Next: a health check that records from the main microphone and fails until it hears a signal (test first), then the read-back on the TX bus: compare the TX data pins and the controller's read settings with the vendor kernel and sibling SoCs (sm6150, sm7125).

2026-11-17, night (bring-up): the check mic-records runs after every boot (a known gap until it passes). In one-off test kernels the cause narrowed: about a millisecond after the sound card registers, the WCD9375 drops off both SoundWire buses at once and is never enumerated again, so the capture's port setup gets no answer. Ruled out: the clock-stop resume path, runtime suspend, headset detection, and any traced register write, supply or GPIO in that window. Lead: our device tree's active reset pin state drives the active-low reset low, where the vendor's drives it high. Next: a try with the reset's active state output-high, logging the bus-level SoundWire writes at card registration. Full record: surya-lab research/microphone.md.

2026-11-17, later (bring-up): the drop is explained and fixed - ASoC puts idle components into their sleep pin state, and the codec's sleep state held its reset low (traced to snd_soc_bind_card). Fixed on linux-phone-oco/linux PR #4 (with the SoundWire pin-mux fix as PR #3), both queued in upstream-queue for sm7150-mainline, waiting for the author to send. With it the codec stays attached and capture prepares, but delivers exact zeros. The built-in microphones are digital mics (TX DMIC1-3); this DSP rejects the VA capture port, so they go through the TX macro. Next: why the TX decimators deliver zeros (register sequence against the vendor's tx-macro), then the DMIC route. Tests use no sound louder than the author allows (lab-tools test-sound-level-setting).

2026-11-17, ~04:40 UTC (bring-up): THE MICROPHONE WORKS, on a test kernel built from branches (linux-phone-oco/linux test/surya-mic). The last fault: the capture link used the TX SoundWire controller's playback DAI (swr2 0); capture through DAI 1 (PR #6, found in pulpoff/linux-surya, a mainline surya tree on Mobian whose device tree also confirmed tonight's other fixes). surya's microphones are analog (ADC1 bottom, ADC2 top). Proof decided by the phone: surya's check mic-hears-speaker plays a 1 kHz tone at -6 dBFS and 20% volume (the author heard it: 'nice and soft') and finds it 57 dB above the noise - pass. All four fixes queued in upstream-queue for sm7150-mainline, waiting for the author. Next: the proven kernel as the phone's default (lab-tools kernel-promote, asked of the conveyor) so audio-mic leaves the known gaps and the face keeps works; then the top mic (ADC2), the headset mic, a UCM capture profile, and the earpiece through the WCD EAR PA.

Correction (2026-11-17, bring-up): where this item and research/microphone.md (steps 10, 11, 14) speak of surya's built-in microphones as digital mics, that reading came from the vendor's QRD reference board and is wrong for surya: its microphones are analog, WCD9375 ADC1 (bottom) and ADC2 via INP3 (top), both proven by mic-hears-speaker. The DMIC path is dropped (research decision 2026-11-17-microphones-analog-wcd-path). The kept kernel records with both on every boot; audio-mic left surya's known gaps. Queue from the research, in order: mic-ucm-capture, mic-held, mic-upstream, mic-dmic-dropped.

Done 2026-11-17: both microphones work on the kept kernel, proven every boot by mic-hears-speaker and mic-top-hears-speaker; audio-mic works on the face. Upstream patches queued (upstream-queue linux/sm7150-wcd).

Opened
: 2026-11-09

Needs
: phone

Proof
: mic-hears-speaker

About
: audio-mic


<a id="org-board"></a>
### A board for linux-phone-oco

Project
: linux-phone-oco/docs

Status
: open

Note
: The user's idea: a shared board for the org, like lab-agent's. Later.

Opened
: 2026-11-09


<a id="phosh-usb"></a>
### Under Phosh the PC loses the phone over USB

Project
: linux-phone-oco/docs

Status
: open

Note
: After switching to Phosh (2026-11-09) the PC showed no USB device for the phone, so no SSH over USB; the user saw the same before, in an earlier Phosh try. Unclear yet: Phosh changing the USB gadget, or the cable (EarPods were being plugged in that evening). To check: lsusb on the PC and the gadget state on the phone (via wifi or the console) while in Phosh.

Opened
: 2026-11-09

Needs
: phone

Device
: xiaomi-surya


<a id="plasma-silent"></a>
### Plasma Mobile: speakers silent, the chain playing

Project
: linux-phone-oco/docs

Status
: done

Note
: Plasma Mobile (fresh Nura image, sound fixes applied on the phone): speakers were silent with the whole chain playing. Two causes, both confirmed: (1) the image restores a saved mixer state with both amplifiers' digital volume at 0 = -110 dB; (2) a tas2562 driver bug: setting the Digital Volume Control changes only the driver's cache, the chips (page 2, 0x0c-0x0f) stay at -110 dB. Writing 0x40000000 straight into both chips with i2cset made sound work: the user heard YouTube in Firefox, 2026-11-10. Not persistent: after a power-off the restore and the driver bug bring the silence back. Needed: the driver fix (upstream-tas2562-volume), and until then a boot-time step that writes the volume into the chips. Root cause found and fixed 2026-11-10: the tas2562 driver's maximum volume (0 dB) read past the end of its lookup table, which muted the amps; with two more faults (the latch byte written first, resume skipping bytes). Fixed module installed and proven on the phone by I2C reads; every flash bakes it in. Listen on Plasma when it is next run.

Opened
: 2026-11-10

About
: audio-speaker


<a id="upstream-tas2562-volume"></a>
### Upstream: tas2562 digital volume writes do not reach the chips

Project
: linux-phone-oco/docs

Status
: open

Note
: See plasma-silent. Reproduce: set the Digital Volume Control, read page 2 registers 0x0c-0x0f live with i2cget. Then a driver fix (write through, or restore on power-up) and a report. Fixed 2026-11-10 (three faults: write order, a short and corrupt table, the defaults table): linux-phone-oco/linux PR #2, branch fix/tas2562-volume; patch 0002 in ~/Projects/linux-phone-oco/upstream-queue/linux on the lab machine - to send with the slot-length patch when the user decides.

Opened
: 2026-11-10

About
: audio-speaker


<a id="upstream-sxmo-profile"></a>
### Upstream: the Sxmo device profile for surya

Project
: linux-phone-oco/docs

Status
: done

Note
: Written and in use (2026-11-10): both panel variants, values from a running Sxmo, shellcheck clean; Sxmo loads it (SXMO_DEVICE_NAME=xiaomi,surya-huaxing, scale 3). Kept on linux-phone-oco/sxmo-utils, branch deviceprofile/xiaomi-surya; the patch waits in ~/Projects/linux-phone-oco/upstream-queue/sxmo-utils on the lab machine. sxmo-utils takes patches by mailing list (sourcehut) - to send signed off by the user, when the user decides. Until then surya-lab provisioning installs it.

Sent 2026-11-17 04:25 UTC by the author, signed off by him, with git send-email (plain text; the first try through the Gmail connector was refused by lists.sr.ht for its HTML part): '[PATCH sxmo-utils] deviceprofiles: add xiaomi,surya (POCO X3 NFC)', rebased on upstream master eb237fe, in the list archive lists.sr.ht/~mil/sxmo-devel. Review comments are watched there; replies in his name need his word.

Opened
: 2026-11-10

About
: sx-upstream


<a id="adsp-suspend-crash"></a>
### The audio DSP crashes right after resume from suspend

Project
: linux-phone-oco/docs

Status
: done

Note
: Trigger found 2026-11-10, one change at a time: with hexagonrpcd's RootPD helper (a FastRPC client) attached, the audio DSP dies on every suspend attempt - 24 of 24 (fatal error EX:kernel:0x0:IST46:0x132:PC=0xf0049be4, about 30 ms after the attempt; the attempts abort at once because the USB link cannot go idle). Without the helper: 0 of 8, and on a clean boot with it masked 0 of 9, all checks passing; sound does not need it. Not a first-boot effect, not the sensor proxy, no stream open. The earlier "rare" crash (2 of 28, both early in a boot) was the same one: there the helper died with the first crashes and stayed down. Fixed in the lab: hexagonrpcd-adsp-rootpd masked in the device manifest, baked in at every flash. Still open, for upstream: why an attached FastRPC client makes the DSP assert across a suspend attempt (the kernel's fastrpc and remoteproc suspend handling, or hexagonrpcd), and why the helper restarts after each crash on a fresh system. Settled 2026-11-11: fixed with the same masks and the awake service.

Opened
: 2026-11-10

About
: deep-sleep


<a id="device-template"></a>
### A device template: the conveyor any phone's support is built on

Project
: linux-phone-oco/docs

Status
: open

Note
: Asked for 2026-11-10: the conveyor as a repo of its own, so anyone can bring support to another phone with the same conveyors, CI, tests, tad page and automatic integration into the grand picture; surya is the first instance, not the mould.

Design. (1) linux-phone-oco/device-template, a GitHub template repository: Use this template makes <vendor>-<codename>-lab. (2) device.toml, one manifest per device - codename, SoC, compatible strings, panel variants, image sources, how to reach the phone - read by every script; no script edited per device. (3) Generic machinery, generalized from surya-lab: the phone library (USB or Wi-Fi, commands on stdin), flashing with built-in fixes, provisioning (packages, Wi-Fi from private files), switching shells, device-tree audits, an upstream queue with send commands generated by get_maintainer.pl. (4) Tests as small independent checks, one file each declaring its component and what it needs, so a device runs the checks that apply; results as JSON lines with a versioned schema. (5) Device-independent analysis in linux-phone-oco/lab-tools (Rust): tone (speaker tests microphone) first. (6) Onboarding conveyor: a lab-tools command reads a running phone (compatible, inputs, outputs, sound devices) and fills device.toml - and from the same facts generates the Sxmo device profile. (7) Each device repo publishes its own tad data (support status, test runs, wiki claims) with CI that validates it and renders its page. (8) Integration: a feed in linux-phone-oco/docs discovers device repos by a GitHub topic and pulls their published tables, so a new device appears in the devices table and the support grid (tad draws device x component as a matrix) with no hand edits. (9) Conventions in AGENTS.md: explicit intent for state changes, lists as arguments, secrets outside repos, fingerprints before trusting images. (10) Proof: surya-lab re-based onto the template as its first instance - still 18 of 18 through it. Landscape read 2026-11-10 (see the landscape table): build on what exists - device.toml derives from postmarketOS deviceinfo; tests take the shape of pmOS's initramfs CI tests and use bootrr for driver probes; the lab aims to be a CI-tron-compatible setup and surya a device under test in pmOS's hardware farm; flashing leans on pmbootstrap. 

2026-11-17: made - linux-phone-oco/device-template (a GitHub template): a lab is device.toml, tests/health, tests/results and its records; every tool is devlab's. Proven on surya the same day: the phone checks its own health after every boot (devlab-health, a static Rust runner, generic checks in postmarketOS's test shape, [health] in the manifest, known gaps measured but not ill health), every change devlab makes ends with that report, devlab gather now files the runs here (9 runs filed, a week of filing by hand caught up), devlab mcp is the door for agents. Open: surya-lab re-based onto it, a second phone through it, device.toml read off a running phone, the Alpine package through the package conveyor.

Opened
: 2026-11-10

About
: dt-any-phone


<a id="rust-toolset"></a>
### The device toolset in Rust, for any phone

Project
: linux-phone-oco/docs

Status
: open

Note
: Asked for 2026-11-10: tooling must not be tied to surya - surya is the test subject; the work is a conveyor for any phone, built as one Rust toolset (rust-script for small scripts) as we go, informed by existing projects (postmarketOS tooling first). Plan: one CLI in linux-phone-oco/lab-tools reading the device manifest (device.toml): phone (find over USB or Wi-Fi, run commands with no quoting layer), kernel install/try/log/remove (the safe test-kernel boot proven on surya 2026-11-10: one try by boot counting, a stalled initramfs saves its log and reboots into stock), provision, test (the checks, results as versioned JSON lines), tone. Port surya-lab's shell tools one at a time behind tests; surya-lab shrinks to data and a manifest - the first step of device-template. Read first, as reference and to reuse conventions: pmbootstrap (flasher, initfs, sideload, ci), postmarketos-mkinitfs hooks, pmaports CI and testing. 

2026-11-17: devlab grew suite (put, run, latest), gather, mcp; every reboot, kernel try and provision ends with the phone's health. tests/to-docs.sh (filing through tad's Python) is replaced by devlab gather.

Opened
: 2026-11-10


<a id="check-crash-on-resume"></a>
### The check counts crashes on resume wrongly

Project
: linux-phone-oco/docs

Status
: done

Note
: The check's pattern used \| in sed, which the phone's BusyBox sed does not have: it matched nothing and always counted 0. Rewritten in awk alone - a crash between "suspend entry" and two seconds after "suspend exit" - and checked against a boot that had 24.

Opened
: 2026-11-10

About
: deep-sleep


<a id="usb-flapping-on-suspend"></a>
### The phone kept reconnecting on the host's USB

Project
: linux-phone-oco/docs

Status
: done

Note
: On USB a suspend cannot complete (the link cannot go idle): each attempt aborts at once, and a shell that suspends when idle retried every 12 seconds, each time dropping the link - 26 USB disconnects in 5 minutes on the lab machine. Fixed independently of any shell: a service holds a kernel wake lock while the port is connected to a host (devlab-usb-awake, baked in by the device manifest), with a check.

Opened
: 2026-11-10

About
: deep-sleep


<a id="shell-free-base"></a>
### A shell-free base for hardware tests

Project
: linux-phone-oco/docs

Status
: open

Note
: Proposed by the author after a day of faults that a shell's policy turned into loops: test the base - sound, modem, suspend, storage - on a console-only system, with no desktop or shell deciding when things happen, as the reference; then test each shell as a layer on top, so a failure points at one or the other. The lab's checks already run without a display; the image and the conveyor are to follow. 

2026-11-17: the phone's health suite is layered - base checks first (hardware and system, no shell in the way), then the shell's - and each report line says its layer; on surya the base passes whole (29 of 29 outside the known gaps) under Sxmo. The console-only image is still to come.

Opened
: 2026-11-10

Needs
: phone

Device
: xiaomi-surya


<a id="tty-first-shell"></a>
### The author's TTY-first shell

Project
: linux-phone-oco/docs

Status
: open

Note
: His own shell for Linux, mobile first and at home on a desktop: built from nothing, on the best existing parts or their reimplementation in Rust. It starts as the raw console the lab's agent uses for the shell-free base, and grows from there. Not started; recorded so it is not forgotten.

Opened
: 2026-11-10


<a id="support-from-results"></a>
### Support status read off the suite's results

Project
: linux-phone-oco/docs

Status
: done

Note
: derive/support-status.sql: broken on a failing latest run, works on a passing test that proves the part works, otherwise judged; tried beside the hand-written status - naive reading disagreed on 8 of 19, the rule with proofs agrees on all 19. devlab runs every derive/*.sql after filing, so a regression turns its part broken on the face by itself. Next: the witnessed tests (heard, seen) filed the same way, so works can be proven for more parts than wifi.

Opened
: 2026-11-17

About
: surya-tested


<a id="gaps-on-the-face"></a>
### Known gaps shown as gaps on the face, not as failures

Project
: linux-phone-oco/docs

Status
: done

Note
: The phone's own verdict leaves out the known gaps (surya: fingerprint, sensors, both cameras - healthy, 4 in known gaps), but test_runs counts them as failed, so every bar on the Tests page carries red. A run's row should say its gaps apart (a gaps count, read from the report's verdict or the manifest's [health] gaps), and the face draw them in their own colour.  Done 2026-11-17 (orchestration): test_runs has a gaps column - failures in the manifest [health] gaps, counted apart from failed as the phone verdict counts them (devlab gather files it so; the runs filed before were counted again with surya gaps); the engine draws them in their own colour on the Tests page (ocoeco-engine #60), and a run with only gap failures is a run that works.

Opened
: 2026-11-17

About
: surya-tested


<a id="android-reference"></a>
### What Android does on the same phone, measured once and kept

Project
: linux-phone-oco/docs

Status
: open

Note
: The project's goal is phones as good as Android; the face says it from tests that prove parts present or working, but nothing measures 'as good'. ArtCraft keeps reference corpora an oracle compares against (photocraft-corpus: Photoshop's own renders). For a phone: on stock Android (MIUI) on a surya - a second one, or this one by the author's choice - measure what the suite can also measure on Linux: sleep current over an hour screen-off, wake-up latency for a call, speaker and microphone levels, sensor readings, Wi-Fi throughput, boot time. Kept as reference data beside the results; the face then draws each part against its Android figure. Needs the author: which phone runs Android for it.

Opened
: 2026-11-17


<a id="a-second-phone"></a>
### A second phone in the lab

Project
: linux-phone-oco/docs

Status
: open

Note
: One phone serialises everything that changes it: four sessions now share surya, and devlab holds the phone so that changes queue. A second phone doubles what can be tried at once and proves the device template (device-template dt-second-phone). Best: another SM7150 phone (a second surya, or a sibling such as the Redmi Note 9 Pro / Poco M2 Pro on sm7125) so the bring-up work carries over; it could also carry the Android reference (android-reference). Needs the author: the purchase and its place on the lab's USB. 

2026-11-17: the author - not now. The one phone stays shared, changes queued by devlab's hold; not to be asked again until the author raises it.

Opened
: 2026-11-17

About
: dt-any-phone


<a id="sleep-measured-once"></a>
### Deep sleep measured once: the SoC's own counters across one suspend

Project
: linux-phone-oco/docs

Status
: done

Note
: Done 2026-11-17 by surya-keeper: one cycle by hand, soc-sleeps = fail (cxsd 0, aosd 0, adsp never asleep, cluster S2 never entered). Research 2026-11-17-surya-first-s2idle-cycle. The phone woke after 2.4 s, not 60: sleep-wake-source is next. Still wanted from lab-tools: the cycle as a devlab verb (health-suspend-cycle).

Opened
: 2026-11-17

Needs
: phone

Proof
: soc-sleeps

Rank
: 1

About
: deep-sleep


<a id="sleep-wakes-for-calls"></a>
### Waking from deep sleep for calls and messages

Project
: linux-phone-oco/docs

Status
: open

Note
: On the floor reached above: the modem's IPCRTR glink wakeup enabled (/sys/bus/rpmsg/devices/4080000.remoteproc:glink-edge.IPCRTR.-1.-1/power/wakeup), ModemManager's quick suspend/resume quieting the modem before suspend, and Sxmo's post-wake hook putting the phone back to sleep when the wake was not a call or a message (as postmarketOS does on the OnePlus 6; still reported unreliable there, pmaports 4989). Needs a SIM card - the author's hands. Proven by: a witnessed test wakes-for-call, to be entered in tests (a call to the sleeping phone rings within 5 s; an SMS sent to it arrives), and soc-sleeps passing in the same boot.

Opened
: 2026-11-17

Needs
: phone

Device
: xiaomi-surya

Proof
: wakes-for-call

Rank
: 6

About
: deep-sleep


<a id="devlab-mcp"></a>
### devlab mcp: the phone for any agent

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: devlab mcp (rmcp 3.10, stdio): run, put, get, health_report, health_run, kernel_install, kernel_try, kernel_status, reboot - each the function the command line calls; nothing but the protocol on standard output (what the functions said is returned, their talk goes to standard error). Proven 2026-11-17 against surya by a raw MCP exchange: initialize, the 9 tools listed, health_report with the phone's own verdict, kernel_status, run as root.

Opened
: 2026-11-17

About
: dl-reaches


<a id="flash"></a>
### Flashing

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: devlab flash did its first real flash (2026-11-10): the pristine stock image, the manifest's fixes baked in, the device tree fingerprinted (a43d069d0a49adcd), the phone back with all 20 checks passing.

Opened
: 2026-11-10

About
: dl-safe


<a id="gaps-counted-apart"></a>
### A known gap counted apart from a failure, when a run is filed

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: devlab gather files each run test_runs row with gaps: failures in the manifest [health] gaps, counted apart from failed, as the phone own verdict counts them (docs gaps-on-the-face). Columns are named in the insert, so the table order may change without a filing breaking. Proven 2026-11-17 by filing run 20261117-013421 again into a copy of docs: 25 pass, 4 failed, 5 in gaps, 1 skipped - as the backfill counted it.

Opened
: 2026-11-17

About
: surya-tested


<a id="gather-once-quiet"></a>
### Gathered once the phone is quiet, landed again if main moved

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Measured 2026-11-17 (conveyor session): in about 2 h the watch gathered 5 times and 2 landings failed, other sessions having landed in docs and surya-lab meanwhile; each boot cost two PRs, two CI rounds and a Pages build. Now the board hears the verdict at once, but gathering waits until the phone has gone 15 minutes without a new boot (a run of kernel tries is one landing per place), and a landing that does not go through closes its own PR and branch and is tried again from main as it then is, 3 times in all; what is still unfiled is filed in the next quiet period.

Opened
: 2026-11-17

About
: dl-reaches


<a id="guard-stop-unlanded"></a>
### A turn does not end with unlanded changes

Project
: linux-phone-oco/lab-tools

Status
: open

Note
: A Stop hook (devlab guard stop) that refuses to end a turn while a place the session worked in holds changes not landed: the places are read off the transcript (the cwd of its Bash calls and the files it edited), each checked with git status and its branch against origin/main. Waits on: telling what the session worked in from the hook input alone, cheaply.

Opened
: 2026-11-17


<a id="guard-the-ways"></a>
### The ways, held for agents: devlab guard

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Claude Code hooks on the lab call devlab guard: PreToolUse refuses git push to main, python/pip, and ssh/scp/sftp/rsync/sshpass to a phone address devlab has met (each manifest leaves its addresses in the state); SessionStart prints lab-agent guide and the inbox. Proven by replaying each event to the built binary (refused with exit 2 and the reason; a branch push, ls, grep python allowed) and by unit tests of each shape (sudo, env, timeout, xargs, sh -c, $(...), lab-agent root-exec).

Opened
: 2026-11-17


<a id="health"></a>
### Health, after every boot

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: devlab test, health, watch: regressions raise one board task.

Opened
: 2026-11-10

About
: dl-reaches


<a id="health-after-change"></a>
### Every change ends with the health report

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Every change devlab makes ends with the phone's health: phone reboot and kernel try wait for the report the new boot writes by itself (the test kernel's boot is measured like any other), provision runs the suite at once; the verdict is said, the report brought to the lab's tests/results, and the command fails when the phone is unhealthy. Proven 2026-11-17 by a reboot of surya: back, then healthy (29 pass, 4 in known gaps) and the report brought, 3 minutes in all. kernel try uses the same step and is not yet proven live. A change made by hand through phone sh/root has no step to end: devlab suite run, or the MCP door's health tool.

Opened
: 2026-11-17

About
: dl-safe


<a id="health-apk"></a>
### devlab-health as an Alpine package

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Done 2026-11-17: surya takes the suite from its Alpine package. devlab suite put now (lab-tools #51) adds lab-tools' signed repository and key to the phone once, installs or upgrades devlab-health, and takes away the files devlab once put by hand; the phone's own checks and health.env stay devlab's; --runner FILE still copies an unreleased runner to try it. Proven on surya: devlab-health-0.1.0-r0 installed from https://linux-phone-oco.github.io/lab-tools/alpine/v3.24/lab-tools, apk owns the runner, every generic check and the units, the timer runs /usr/lib/systemd/system/devlab-health.timer, and the suite ran healthy: 30 pass, 4 in known gaps, 0 fail. Left: the systemd units in a -systemd subpackage, as postmarketOS keeps them (abuild warns).

Opened
: 2026-11-17

About
: dl-upstream


<a id="health-carry-old-checks"></a>
### The checks surya-lab ran from the lab, carried into the suite

Project
: linux-phone-oco/lab-tools

Status
: open

Note
: surya-lab tests/automatic/checks.sh retired on 2026-11-17 (its decision 2026-11-17-the-lab-s-own-conveyor-retires); four of its checks are not yet in the phone suite: bt-sees-devices (a 6 s bluetoothctl scan; skip when none answers - generic, 70-bluetooth.sh), modem-ready for modem-calls and modem-sms as well as modem-data (the modem state once a SIM is in - generic, 60-modem.sh), the audio DSP crashes that came with a suspend counted apart (awk between PM: suspend entry and 2 s after exit - generic, 30-processors.sh), and speaker-stereo (the HiFi__Speaker sink is 2ch - surya own, tests/health, bring-up). The retired file is in surya-lab history before that decision.

Opened
: 2026-11-17

About
: surya-tested


<a id="health-gather"></a>
### Gathering is one command

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: devlab gather now: the phone's reports into the device lab's tests/results, every unfiled run into docs' test_results and test_runs. Proven 2026-11-17: 5 reports brought from surya, 9 runs filed (5 from 2026-11-10 never filed by hand; one run spoiled by a check of mine that could not write was taken out everywhere). Next: a device lab keeps its runs as its own data once the language gives a test run a shared shape (ocoeco sign a-test-run-has-no-shared-shape).

Opened
: 2026-11-17

About
: dl-reaches


<a id="health-on-phone"></a>
### The phone checks its own health after every boot

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: devlab-health (static Rust runner, health/) and the generic checks: storage, kernel (oops, new warnings, processor crashes, failed units), signal processors, sound cards, Wi-Fi, modem, Bluetooth, display and input, the other parts, then the shell's sound output; a phone's own checks and expectations from its manifest ([health]); known gaps measured but not ill health. Proven on surya 2026-11-17: put by devlab suite put now, the phone ran it by itself 120 s after a reboot and said healthy: 29 pass, 4 in known gaps, 1 not measured, 0 fail.

Opened
: 2026-11-17

About
: dl-reaches


<a id="health-suspend-cycle"></a>
### One controlled suspend and wake in the suite

Project
: linux-phone-oco/lab-tools

Status
: open

Note
: An RTC wake alarm suspend, as postmarketos-test-suspend does, with the processor crash count before and after. Wait: the phone holds a wake lock on USB (devlab-usb-awake) and a phone that does not wake needs hands - prove one cycle by hand on surya first.  2026-11-17, from the deep-sleep research (docs decision 2026-11-17-deep-sleep-measured-s2idle; docs backlog sleep-measured-once is its first use): the cycle also reads the SoC's own counters before and after - /sys/kernel/debug/qcom_stats (cxsd, aosd, ddr, and adsp, cdsp, modem), suspend_stats, the cluster domain's idle states (pm_genpd power-domain-cluster) and every wakeup source's count - so one cycle says whether the SoC reached its floor and, if not, which processor stayed up and what woke it. On USB it can only work with the gadget let go for the length of the sleep (soft_connect) and the lab's and the shell's wake locks released; reach and read back over USB after the RTC wake. Once a cycle has run in a boot, the check soc-sleeps (base/90-sleep.sh) turns from skip to pass or fail in that boot's report.

Opened
: 2026-11-17

Needs
: phone

Device
: xiaomi-surya

About
: deep-sleep


<a id="hear"></a>
### The lab's ear

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: devlab hear and devlab health --hear work: a tone on each channel, recorded through the lab's microphone, measured against the silent room; heard checks join the one baseline when listened for. Its first results on surya were withdrawn - the microphone was being worn. It counts when the microphone has been placed by the phone, on notice.

Opened
: 2026-11-10

About
: dl-manual


<a id="hear-asks-first"></a>
### devlab hear asks for the word first

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: devlab hear and devlab health --hear refuse without --placed, and say the procedure: tell the microphone's keeper, wait for their word. The lab's microphone can stay named: nothing plays by accident.

Opened
: 2026-11-10

About
: dl-manual


<a id="hear-fixed-microphone"></a>
### The microphone, placed on notice

Project
: linux-phone-oco/lab-tools

Status
: open

Note
: The microphone can be relied on when it is placed by the phone. Before any listening test the agent notifies its keeper and waits for his word; only then is the test run, with --placed, and counted. The tool refuses otherwise.

Opened
: 2026-11-10

About
: dl-manual


<a id="hear-phone-mic"></a>
### The phone's own microphone, heard the same way

Project
: linux-phone-oco/lab-tools

Status
: open

Note
: The lab plays a tone, the phone records it: the instrument for the long-open microphone work. And a second lab microphone, to tell left from right.

Opened
: 2026-11-10

About
: audio-mic


<a id="hear-quiet-hours"></a>
### Listening by itself, at decent hours

Project
: linux-phone-oco/lab-tools

Status
: open

Note
: The watcher stays silent: a tone after every start could sound at night. For it to listen unasked the lab needs to say when sound is welcome.

Opened
: 2026-11-10

About
: dl-manual


<a id="hear-room-silence"></a>
### A room of exact zero means the microphone did not record

Project
: linux-phone-oco/lab-tools

Status
: open

Note
: Right after a reboot the room recorded at -240 dBFS (digital silence) and the tones still passed. devlab hear should refuse in that case.

Opened
: 2026-11-11

About
: dl-manual


<a id="kernel"></a>
### Safe test kernels

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: devlab kernel: one try by boot counting, a timeout that falls back to stock.

Opened
: 2026-11-10

About
: dl-safe


<a id="lpi-debugfs-hangs"></a>
### Never read LPASS pins through debugfs while LPASS is idle

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Found by the bring-up session, 2026-11-17: reading /sys/kernel/debug/gpio and the LPASS LPI pinctrl debugfs on surya while the LPASS clocks were off stalled the bus; the phone hung until a person held power. A guard for agents: devlab phone root (and the MCP door) could refuse or warn on those paths, or the health suite never touch them. Recorded in surya-lab research/microphone.md.  2026-11-17 (orchestration): devlab now refuses, saying why, any command it carries to the phone (phone sh|root, the MCP door) that names a path in the manifest [[hazard]] list; the hand-written ssh it might go around is refused by the lab hooks (devlab guard). Next: surya-lab device.toml names its hazards (bring-up: /sys/kernel/debug/gpio and the LPI pinctrl debugfs under 62b40000), then the item is done.

Done 2026-11-17: devlab refuses any command it carries to the phone (phone sh|root, the MCP door) that names a path in the manifest's [[hazard]] list (orchestration, lab-tools main). surya's device.toml names /sys/kernel/debug/gpio and /sys/kernel/debug/pinctrl/62b40000 with why (bring-up, surya-lab main). Learned since: the hang came from the old 32-pin LPI driver of the WCD test kernels mapping the sensor DSP's pins; the branch driver (pinctrl at 62b52000) reads safely.

Opened
: 2026-11-17

About
: dl-safe


<a id="manual-tests"></a>
### Half-manual tests

Project
: linux-phone-oco/lab-tools

Status
: open

Note
: Sequential tests with an observer - a person now, a rig later.

Opened
: 2026-11-10

About
: dl-manual


<a id="phone"></a>
### Reaches the phone

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: devlab phone: USB or Wi-Fi, no quoting layer, boot ids.

Opened
: 2026-11-10

About
: dl-reaches


<a id="pmos-conventions"></a>
### Built on postmarketOS's conventions

Project
: linux-phone-oco/lab-tools

Status
: open

Note
: device.toml from deviceinfo; tests in the shape of pmOS's initramfs CI; bootrr.

Opened
: 2026-11-10

About
: dl-upstream


<a id="provision"></a>
### Provisioning

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Packages, files by {compatible}, Wi-Fi; the shared connection undone by a guard. It sets a fresh phone's clock and grows its system to fill its partition first.

Opened
: 2026-11-10

About
: dl-safe


<a id="rig"></a>
### A proper rig

Project
: linux-phone-oco/lab-tools

Status
: open

Note
: Asked for by the author, for the future: a microphone fixed in place, a webcam that sees the screen, servos that press the buttons and touch the glass - so the tests that need a hand, an eye or an ear can run by themselves, for any phone.

Opened
: 2026-11-10

About
: dl-manual


<a id="suite-put-runner-default"></a>
### suite put: find the runner by itself

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Done 2026-11-17 (lab-tools PR 72): devlab suite put now --runner (no file) builds devlab-health with health/build.sh in the lab-tools devlab was built from and copies it with that tree's checks; --runner FILE as before. The lab's devlab is now built from ~/Projects/linux-phone-oco/lab-tools at main, so that tree lasts. Not yet put on the phone by it: the keeper's to do on its next suite put.

Opened
: 2026-11-17

About
: dl-reaches


<a id="test-sound-level-setting"></a>
### Test sounds at a level the manifest sets - quiet by default

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Asked by the author, 2026-11-17 (~03:00 local): 'please use quieter sound for tests, asap' and 'there should be a setting in the test suite'. The bring-up session had played a full-scale speaker-test sine through surya's speakers at night. devlab hear plays at a hard-coded LEVEL = -12 dBFS with the sink set to 60%. Wanted: one setting in device.toml, e.g. [hear] level_dbfs (default -40) and volume (default 25%), read by devlab hear and written into the phone's /etc/devlab/health.env (TEST_TONE_DBFS, TEST_VOLUME) so any check that plays a sound - the coming microphone-hears-speaker test first - uses it; nothing in the suite plays louder. The analysis already measures SNR, so a quiet tone near the phone's own microphone is enough. 

2026-11-17: done (conveyor, at the author's urgent word through bring-up): [hear] level_dbfs (default -40) and volume (default 25, percent) in device.toml; devlab hear plays at them, never above 0 dBFS or 100%, and restores the phone's volume after; devlab suite put writes TEST_TONE_DBFS and TEST_VOLUME into the phone's health.env, and the suite's lib.sh tells every sound-playing check to use them.

Opened
: 2026-11-17

About
: dl-manual


<a id="try-kernel-read-as-stock"></a>
### kernel try: a try whose release equals the test kernel's is read as stock

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Done 2026-11-17 (lab-tools PR 71): where LoaderEntrySelected is empty, devlab kernel try reads the booted entry off the running cmdline's initrd=initramfs-NAME, and the release only where neither says; Booted says the phone stays on the try until the next reboot. Installed on the lab (old at ~/.local/bin/devlab.before-try-initrd).

Opened
: 2026-11-17

About
: dl-safe


<a id="try-reports-outcome"></a>
### kernel try reports what came back

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: devlab kernel try reports what the try came to, said by the phone after a new boot answers: booted, not chosen, stopped early, or timed out with its log. Proven 2026-11-11: booted the microphone kernel in 81 s.

Opened
: 2026-11-11

About
: dl-safe


<a id="adsp-handover-loop"></a>
### The audio processor signalling handover every second

Project
: linux-phone-oco/surya-lab

Status
: open

Note
: Measured in the test kernel: 'Handover signaled, but it already happened' once a second from 11 s after boot (54 by 65 s), with or without audio. Also seen in a stock boot's crash memory. Likely an interrupt wired to the wrong signal of the audio processor; compare its interrupt mapping with the Android kernel.

Opened
: 2026-11-11

Needs
: phone

Device
: xiaomi-surya


<a id="camera-identify-slots"></a>
### Ask each camera slot what it is

Project
: linux-phone-oco/surya-lab

Status
: open

Note
: The first step of the cameras: a test device tree that only powers a slot (supplies, clock, reset), booted once as the second entry; then the chip's identity register read over its control bus. Turns reported sensor models into facts.

Opened
: 2026-11-11

Needs
: phone

Device
: xiaomi-surya

Proof
: image-sensor

Rank
: 70

About
: camera-rear


<a id="image-sensors"></a>
### Image sensors: described, then identified, then seen

Project
: linux-phone-oco/surya-lab

Status
: open

Note
: Known (research/cameras.md): the pipeline and all three control buses are bound; no sensor is described, which alone is why the cameras are dark. The vendor's kernel gives the wiring of seven sensor slots - bus, lanes, supplies, pins, clock - and names no model. Next: power one slot at a time in a test device tree and ask the chip for its identity; describe fully what this kernel already has a driver for; a frame.

Opened
: 2026-11-11

Needs
: phone

Device
: xiaomi-surya

Proof
: image-sensor

Rank
: 71

About
: camera-rear


<a id="mic-capture"></a>
### Sound recorded through the microphone

Project
: linux-phone-oco/surya-lab

Status
: done

Note
: 



































































Two tries on 2026-11-11 in the test kernel. The Android route sets cleanly (TX DEC0 MUX=SWR_MIC, TX SMIC MUX0=ADC0, TX_AIF1_CAP Mixer DEC0, ADC1_MIXER, ADC1, MultiMedia2 Mixer TX_CODEC_DMA_TX_3) and the card's routing wires mic bias to AMIC1-3. Starting the capture stream fails: the TX SoundWire bus can no longer read from the codec (read underflow at DPN_PortCtrl of port 1; 'Program transport params failed'), so no recording is made. Not power management: the same with the bus, macros and codec kept awake. Next lead: the moment of failure is when the bus is reshaped for the stream - compare the TX controller's frame and port parameters with the phone's Android kernel. Compared with the Android kernel: the TX bus's port layout and timings match (ports 2-5 as on sm8250 mainline and the vendor), so not the port table. The first read of a port register (DP1 PortCtrl) at stream prepare fails while hundreds of codec register accesses worked at init. Next: trace the bus's transfers (dynamic debug on the SoundWire bus and the qcom controller, or a kernel with SoundWire debugfs - this one has none). Parked 2026-11-12: the lab-agent redesign after the 2026-11-11 incident comes first; resume from the next step above (order: open-commons-observatory decision 2026-11-12-the-redesign-first).

Done 2026-11-17 (bring-up): sound is recorded through both microphones on the kept kernel and through the UCM profile; proven by mic-hears-speaker and mic-top-hears-speaker. See docs backlog microphone and mic-ucm-capture.

Opened
: 2026-11-11

About
: audio-mic


<a id="mic-codec-init-timeout"></a>
### The microphone codec times out at initialisation

Project
: linux-phone-oco/surya-lab

Status
: done

Note
: Solved 2026-11-11: the audio pin driver muxed gpio19 (TX SoundWire data) to function 1 and gpio23 (RX data) to 3, where the phone's own Android kernel has 3 and 2. With both corrected the TX bus no longer clashes, the codec initialises and the sound card is made with the codec on it. The clocks going to 0 were a consequence, not the cause.

Opened
: 2026-11-11

About
: audio-mic


<a id="modem-shutting-down"></a>
### The modem stays in shutting-down and will not go online

Project
: linux-phone-oco/surya-lab

Status
: done

Note
: 





































































The modem stays in shutting-down from boot with the SIM in. tqftpserv 1.1.1 is installed; its read-write base is /tmp/tqftpserv and exists (an earlier note said a directory was missing - wrong: it checked the wrong paths). The loop: the modem writes /readwrite/lctoem.tmp, reads it back with rsize=0 seek=0, and itself ends the transfer at once - the option handling the Fairphone fix (pmaports !4747) changed. Next: compare tqftpserv 1.1.1 with upstream's rsize and seek handling, look at what the modem wrote, then one try with a fixed build. No calls, messages or data without the author's word.

Done 2026-11-17: tqftpserv 1.1.1 never wrote the modem's short state files; tqftpserv 1.3 from Alpine edge (tqftpserv@edge, provisioned) brought the modem online, Vodafone.de LTE. Research modem-online-tqftpserv.

Opened
: 2026-11-11

Needs
: phone

About
: modem-data


<a id="needs-a-sim"></a>
### A SIM card in the phone

Project
: linux-phone-oco/surya-lab

Status
: done

Note
: Inserted by the author on 2026-11-11: the card is seen (1&1, present and ready).

Opened
: 2026-11-11

Waits
: the author

About
: modem-data


<a id="no-sound-card-boots"></a>
### Boots that come up without the sound card

Project
: linux-phone-oco/surya-lab

Status
: done

Note
: 







































































On 2026-11-11 one stock boot had no phone sound card: the audio processor ran with no crash, but its service channel (APR) never appeared, so no audio driver loaded. A reboot restored it. Next: a run of reboots to measure how often.

Done 2026-11-17: the ADSP sometimes booted before qcom_pd_mapper was loaded; device.toml now carries lab/devlab-pd-mapper.conf (softdep qcom_q6v5_pas pre: qcom_pd_mapper) to every flash - 21 of 21 boots with the sound card. Upstream form: docs upstream-pd-mapper-order.

Opened
: 2026-11-11

Needs
: phone

Proof
: sound-card

About
: surya-sound


<a id="port-lpi-fix-to-branch"></a>
### Port the pin fix to the microphone kernel branch

Project
: linux-phone-oco/surya-lab

Status
: done

Note
: 








































































The tested tree came from the phone's v7.1-rc3 source plus upstream's WIP; linux-phone-oco/linux's microphone branch has the audio pin driver laid out differently (no LPI_PINGROUP entries for pins 18-23 in that form). Port the fix deliberately, rebuild from the branch, boot it, and only then add it to pull request #1.

Done 2026-11-17: linux-phone-oco/linux PR 3 (fix/sm7150-lpass-lpi-swr-data-mux), in the kept kernel, queued as upstream-queue linux/sm7150-wcd/0001.

Opened
: 2026-11-11

Needs
: phone

About
: audio-mic


<a id="telephony-checks"></a>
### Telephony in the test suite

Project
: linux-phone-oco/surya-lab

Status
: done

Note
: 











































































devlab checks: modem registered; mobile data (download a small file over the mobile connection); a call to the number in ~/.config/devlab/call-to, confirmed through the inbox (half-manual) or by a stand (automatic). First the modem must leave shutting-down.

Done 2026-11-17: surya-lab tests/health/telephony/ has sms-loopback and call-echo (once_a_day); mobile-data is the generic suite's telephony check.

Opened
: 2026-11-11

Needs
: phone

About
: modem-calls


<a id="dt-made"></a>
### The template, made from what surya proved

Project
: linux-phone-oco/device-template

Status
: done

Note
: device.toml with every section devlab reads (connection, provision, flash, health) and what to change; tests/health for a phone's own checks; tests/results for its reports; AGENTS.md conventions; CI for its scripts; its mark. Every tool is devlab's, reading the manifest - nothing is copied.

Opened
: 2026-11-17

About
: dt-any-phone


<a id="dt-onboard"></a>
### device.toml read off a running phone

Project
: linux-phone-oco/device-template

Status
: open

Note
: devlab reads a running phone (compatible, sound cards, signal processors, inputs) and proposes its device.toml, [health] included - the onboarding step of the device-template design (linux-phone-oco/docs backlog device-template, point 6).

Opened
: 2026-11-17

About
: dt-any-phone


<a id="dt-second-phone"></a>
### A second phone through the template

Project
: linux-phone-oco/device-template

Status
: open

Note
: The proof that surya is not the mould: a second postmarketOS phone's lab made by Use this template, reaching healthy with only its device.toml filled.

Opened
: 2026-11-17

About
: dt-any-phone


<a id="dt-shell-switch"></a>
### Switching the phone shell, a word of devlab

Project
: linux-phone-oco/device-template

Status
: open

Note
: surya-lab ui/switch.sh switches the shell in place (postmarketOS UI packages, tinydm session, reboot, then the shell, DSP and speaker checked); nothing in it is surya own. As devlab shell switch NAME now, it serves every lab, held and ending with the health report.

Opened
: 2026-11-17

About
: dt-any-phone


<a id="dt-surya-from-template"></a>
### surya-lab re-based onto the template

Project
: linux-phone-oco/device-template

Status
: done

Note
: surya-lab keeps scripts the template no longer needs (lib/phone.sh, tests/run.sh, tests/to-docs.sh, tests/automatic/checks.sh, flash/, provision/provision.sh): each one retires once devlab does its work, its reasons carried first (Chesterton's fence). Done when surya-lab holds only data a template-made lab holds.  Done 2026-11-17 (orchestration, surya-lab #81): lib/phone.sh, tests/run.sh, tests/automatic/checks.sh, tests/to-docs.sh and flash/flash-dtb.sh retired, each reason carried first (surya-lab decision 2026-11-17-the-lab-s-own-conveyor-retires; the four checks not yet in the suite on lab-tools health-carry-old-checks); ui/switch.sh reaches the phone through devlab. What surya-lab still holds beyond the template is its own hardware work (dt/, adsp/, patches/, ucm/, research/ - data a template-made lab holds too), the USB wake lock (dt-usb-awake) and the shell switch (dt-shell-switch).

Opened
: 2026-11-17

About
: dt-any-phone


<a id="dt-usb-awake"></a>
### The lab's USB wake lock, carried by devlab

Project
: linux-phone-oco/device-template

Status
: open

Note
: Every lab phone on USB needs devlab-usb-awake (a suspend attempt drops the link); surya carries it as its own overlay. It belongs to devlab, written at flash for any phone.

Opened
: 2026-11-17

About
: dt-any-phone


<a id="more-devices"></a>
### More phones

Project
: linux-phone-oco/sxmo-deviceprofiles

Status
: open

Note
: Profiles for other devices, made the same way.

Opened
: 2026-11-10

About
: sx-more


<a id="surya-hand-check"></a>
### Checked by hand

Project
: linux-phone-oco/sxmo-deviceprofiles

Status
: open

Note
: Buttons verified by a person; vibration still to check (the first half-manual test). Settled 2026-11-11: checked by hand once; next: checked by the conveyor as scenes (agent access).

Opened
: 2026-11-10

Needs
: phone

Device
: xiaomi-surya

About
: sx-surya


<a id="surya-profile"></a>
### surya's profile

Project
: linux-phone-oco/sxmo-deviceprofiles

Status
: done

Note
: Both panel variants; Sxmo loads it; scale 3.

Opened
: 2026-11-10

About
: sx-surya


<a id="surya-upstream"></a>
### surya's profile upstream

Project
: linux-phone-oco/sxmo-deviceprofiles

Status
: done

Note
: In sxmo-utils master as 1fd7822 (sxmo-profile-patch landed).

Opened
: 2026-11-10

About
: sx-upstream


<a id="kernel-promote"></a>
### devlab kernel: make a proven test kernel the phone's default

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Done 2026-11-17 (orchestration, lab-tools kernel-keep): devlab kernel keep NAME now rewrites the test kernel's entry to sort ahead of stock with 3 tries and systemd-bless-boot no longer masked; its first good boot is blessed and it stays the default, 3 bad boots in a row put stock back by themselves, the initramfs timeout still guards each boot; devlab kernel unkeep NAME now gives the default back to stock. Proven on surya: kept mic, rebooted - back on 7.1.0-sm7150-mic+ by default, systemd-bless-boot marked the boot good (entry now pmos-mic.conf), healthy with mic-records and mic-hears-speaker passing. Not yet seen: a second reboot staying on the blessed entry, and a bad kept kernel falling back (the counting is the same systemd-boot counting the tries rest on). Sign: kernel remove finds modules by a release ending in -NAME, so the release 7.1.0-sm7150-mic+ would leave its modules behind.

Opened
: 2026-11-17

About
: dl-safe


<a id="mic-ucm-capture"></a>
### Capture through the sound server: a UCM profile for both mics, the headset mic when plugged

Project
: linux-phone-oco/docs

Status
: done

Note
: 















































































































































































First step of decision 2026-11-17-microphones-analog-wcd-path. Every check so far sets the mixer with amixer; an application records through PipeWire/PulseAudio, which needs UCM. Step: a capture side for surya's UCM beside its stereo speaker profile (upstream-ucm-surya-stereo): a Mic device (bottom: TX DEC0 MUX=SWR_MIC, TX SMIC MUX0=ADC0, ADC1 switches, TX_AIF1_CAP Mixer DEC0, MultiMedia2 Mixer TX_CODEC_DMA_TX_3), the top mic as a second channel (DEC1 from ADC2, ADC2 MUX=INP3) or its own device, and Headset Mic (ADC2 MUX=INP2, MIC BIAS2) on jack detection; gains from the passing checks (ADC1 Volume 18, TX_DEC0 Volume 104), pulpoff's README for the call side (top mic for the uplink: less speaker echo). Proof: mic-hears-speaker made to record from the sound server's default source with no amixer, passing; the headset mic stays unknown until a person plugs one (verify-headphone-mic-earpiece).

2026-11-17 05:16 UTC (bring-up): both microphones through the sound server, no mixer set by hand. surya-lab ucm/Xiaomi/surya/HiFi.conf has SectionDevice Mic (bottom, ADC1, priority 10000 - above Sxmo's loopback card) and TopMic (ADC2 at INP3, 9950), gains ADC 18, DEC0 104; PulseAudio makes them two card profiles, HiFi (Mic, Speaker) the default. Proof: surya's mic-hears-speaker now records the default source and the TopMic profile with parecord - bottom heard at -23.0 dBFS against -89.5, top at -32.4 against -94.6, both pass. Left: the Headset Mic (ADC2 at INP2, mic bias 2, on jack detection) - needs a headset plugged in and the author's word.

Done 2026-11-17: both microphones through the sound server (UCM Mic, TopMic). The headset mic needs a headset plugged in and the author: carried by verify-headphone-mic-earpiece.

Opened
: 2026-11-17

Needs
: phone

About
: audio-mic


<a id="mic-upstream"></a>
### Upstream: surya's capture joins sm7150-mainline PR 60

Project
: linux-phone-oco/docs

Status
: open

Note
: sm7150-mainline/linux PR 60 (davinci, open since 2026-08) already carries the swr_tx_data mux, the TX wakeup IRQ, the port numbering and the capture DAI 1. Step: review and test it on surya, comment with surya's findings (ADC2 needs its own port, <2 3 4 5>, as pulpoff found; the codec node without pin states, linux-phone-oco/linux PR 4; the SoundWire addresses, PR 5), and send surya's device tree on top once it lands, through upstream-queue. Proof: the surya patches merged in sm7150-mainline, and a kernel built from it passes mic-hears-speaker and mic-top-hears-speaker.

Opened
: 2026-11-17

About
: audio-mic


<a id="mic-dmic-dropped"></a>
### Keep the DMIC experiment out: surya has no digital mics

Project
: linux-phone-oco/docs

Status
: done

Note
: 

























































































Bring-up's experiment commits (DMIC pins at mux 1, TX DMIC routing, VA DMIC clocks on a module switch, clock pins without output-high) answered a question surya does not ask: its mics are analog (research microphones-are-analog). Step: keep them out of every branch that goes to the conveyor or upstream; the pin table's DMIC functions (mux 1 against the table's 2, the 'gpi26' spelling) are still worth fixing upstream as their own patch, for boards that have DMICs. Proof: test/surya-mic and the PRs carry no EXPERIMENT commit, and the mic checks still pass.

Done 2026-11-17 (bring-up): the DMIC experiment (pin table swap, DMIC routes, the VA DMIC clock switch) lived only as experiment commits on the local test branch and in surya-audio/patches; they were dropped before test/surya-mic was pushed, and none is in a pull request or the upstream queue.

Opened
: 2026-11-17

About
: audio-mic


<a id="mic-held"></a>
### The microphones held across boots

Project
: linux-phone-oco/docs

Status
: done

Note
: 



























































































The mic kernel is the phone's default (devlab kernel keep) and audio-mic is out of surya's known gaps (surya-lab #102, bring-up). Left: show that it holds. Proof: mic-hears-speaker and mic-top-hears-speaker pass in three consecutive boots of the kept kernel; a boot without audio services (audio-cold-boot-race) would show here.

Done 2026-11-17 (bring-up): three reboots in a row on the kept kernel (health 05:21, 05:24, 05:27 UTC), each healthy with mic-records, mic-hears-speaker and mic-top-hears-speaker passing.

Opened
: 2026-11-17

About
: audio-mic


<a id="earpiece"></a>
### Earpiece: through the WCD9375's EAR amplifier, proven by the top microphone

Project
: linux-phone-oco/docs

Status
: done

Note
: Taken up 2026-11-17 (bring-up), after the microphones work on the kept kernel. The earpiece is driven by the WCD9375's EAR amplifier (pulpoff/linux-surya: MultiMedia3 -> RX_CODEC_DMA_RX_0 -> RX macro RX0 -> INT0 -> codec RX1 -> RDAC3_MUX RX1 -> EAR_RDAC -> EAR PA), not by the two TAS amplifiers. Tried on the phone: the whole path powers on in DAPM (RX INT0_1 MIX1, RX1, RDAC3_MUX, RDAC3, EAR_RDAC, EAR PGA, EAR all On), EAR_PA Volume at its loudest (+6 dB), class-H mode set (CLS_H_LOHIFI), and with pulpoff's qcom,rx-channel-mapping <1 2 1 1 2 1 1 2> too - yet a 1 kHz tone (-6 dBFS, RX digital -20 dB) is not found by the top microphone next to the earpiece. Next: ask the author whether the earpiece is heard at all (a witnessed check), compare the RX SoundWire port programming during playback with pulpoff's (regmap and SoundWire debug), and read pulpoff's earpiece route if published. The rx-channel-mapping change is on local branch dt/surya-wcd-rx-channel-map, not pushed until it proves something. Proof when done: a mic-hears-earpiece check in surya's suite (works).

Done 2026-11-17 (bring-up), with the author's ear: the WCD9375's EAR amplifier makes no sound at all (he heard nothing with his ear on the earpiece, twice) - on surya it is not connected to anything one hears. The earpiece is the top speaker: the TAS2564 at 0x4d (the left channel of the stereo pair), which the author heard from the earpiece slot. surya-lab ucm/Xiaomi/surya/HiFi.conf now has SectionDevice Earpiece (conflicting with Speaker): the top amplifier takes both channels mixed (LeftRightDiv2) at -18 dB, the bottom one silent. Proof decided by the phone: surya's check earpiece-heard plays a soft tone as a mono stream through the Earpiece and the top microphone finds it 50 dB above the noise - pass. pulpoff/linux-surya's note that the earpiece is the WCD EAR PA does not hold on this phone (the Huaxing variant at least).

Opened
: 2026-11-17

About
: audio-earpiece


<a id="kernel-remove-keeps-shared"></a>
### kernel remove never takes modules another kernel boots with

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Asked by bring-up, 2026-11-17: its ear try is the same 7.1.0-sm7150-mic+ build as the kept mic kernel, so removing ear could have taken the default kernel's modules. Now install says the release in the entry (# devlab release, a comment the bootloader skips) and remove keeps the release's modules when the running kernel is it, another entry boots with it, another entry does not say its release, or a package owns them; the kept kernel is not removed at all. Proven by a test that runs the removal under sh in a fake boot tree (lab-tools kernel.rs); on surya, mic and ear were installed before entries said their release, so removing ear removes its own files only.

Opened
: 2026-11-17

About
: dl-safe


<a id="kernel-try-dtb"></a>
### A device-tree change is one boot: kernel try --dtb

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Asked by bring-up, 2026-11-17: a device-tree experiment on the kept kernel took unkeep, a stock reboot, try and keep again. devlab kernel try NAME --dtb FILE now boots installed kernel NAME's kernel, initramfs and modules once with the new device tree (entry NAME-dt, one try, sorted ahead of the kept kernel, never blessed, its release said so remove keeps the modules), and a try is judged by the entry the bootloader says it booted (LoaderEntrySelected, read on surya) rather than by the release's name, which two entries can share. Proven by tests and by running the entry script in a fake boot tree; not yet tried live (the phone's experiments are bring-up's).

Opened
: 2026-11-17

About
: dl-safe


<a id="upstream-pd-mapper-order"></a>
### Upstream: the ADSP must not boot before the in-kernel PD mapper

Project
: linux-phone-oco/docs

Status
: open

Note
: Found 2026-11-17 on surya (bring-up): remoteproc's qcom_common only adds an auxiliary pd-mapper device when it prepares a remote processor; qcom_pd_mapper is a module that udev loads later, so on about one boot in five the ADSP asks for its domains before the mapper answers and its audio PD never comes up (no APR services, no sound card). Worked around in the device lab with 'softdep qcom_q6v5_pas pre: qcom_pd_mapper' (21 of 21 boots good); other distributions put qcom_pd_mapper in the initramfs (omarchy, Snapdragon laptops). Next: check lore for an existing fix; otherwise a patch (a MODULE_SOFTDEP in qcom_q6v5_pas or qcom_common, or making the mapper built-in where remoteproc is), queued for the author; and for postmarketOS, qcom_pd_mapper in the SM7150 initramfs modules.

Opened
: 2026-11-17


<a id="kernel-orphan-modules"></a>
### Modules no entry boots with, taken away

Project
: linux-phone-oco/lab-tools

Status
: open

Note
: Seen 2026-11-17: removing bring-up's ear try proved remove keeps shared modules (it removed ear's entry only; mic stays). Left on surya: /lib/modules/7.1.0-rc3-sm7150-wcd, from the wcdswr experiment removed before entries said their release. Wanted: devlab kernel prune now - remove the modules of every release that no entry says it boots with, that is not running and that no package owns, saying each; once mic is reinstalled or its entry says its release (until then an unmarked entry keeps every release, as remove does).

Opened
: 2026-11-17

About
: dl-safe


<a id="telegram-at-provisioning"></a>
### Telegram client at provisioning: uncomment telegram-desktop in provision/packages.txt

Project
: linux-phone-oco/surya-lab

Status
: open

Note
: Alpine v3.24 telegram-desktop 6.8.5-r0 needs libada.so.3, gone with ada 4.0; edge 7.4.4-r0 is rebuilt. Check with: echo apk add --simulate telegram-desktop | devlab phone root. When it passes, uncomment the line and apk add it on the phone.

Opened
: 2026-11-17

Waits
: Alpine v3.24 rebuilding telegram-desktop against ada 4 (libada.so.4)


<a id="calls-q6voice-kernel"></a>
### Calls 1: q6voice and the VoiceMMode1 link in surya's kernel

Project
: linux-phone-oco/docs

Status
: done

Note
: First step of 2026-11-17-calls-proven-by-echo-call. On linux-phone-oco/linux, a branch with q6voice (q6mvm, q6cvs, q6cvp, the voice DAI) from sdm845-mainline and pulpoff/linux-surya's SM7150 changes (CVD 2.3 from the CVP version, codec DMA ports, zeroed command buffer, start in prepare), and in surya's device tree the APR voice services and a hostless VoiceMMode1 link; merged into a test branch over test/surya-mic and tried by devlab kernel try. Proof: surya-lab's check call-audio-path passes (the VoiceMMode1 PCM, 'TERT_MI2S_RX Voice Mixer VoiceMMode1', 'VoiceMMode1 Capture Mixer TX_CODEC_DMA_TX_3', q6voiced); it fails today.

Done 2026-11-17 (bring-up): pulpoff/linux-surya's c314b3bdf cherry-picked onto test/surya-mic as test/surya-calls (linux-phone-oco/linux PR #7), CONFIG_SND_SOC_QDSP6_Q6VOICE=m; the VoiceMMode1 link is PCM 0,6 here. Kernel 7.1.0-sm7150-calls+ is the kept default; call-audio-path passes.

Opened
: 2026-11-17

About
: modem-calls


<a id="calls-voice-ucm-uplink"></a>
### Calls 2: UCM Voice Call, TX topology 0x10F70, the 1-channel uplink capture

Project
: linux-phone-oco/docs

Status
: done

Note
: In surya-lab ucm/: a Voice Call verb (earpiece and speaker, bottom mic; 'VoiceMMode1 TX Topology' 0x10F70), and a small service that runs a 1-channel capture on TX_CODEC_DMA_TX_3 for as long as ModemManager has an active call (pulpoff's surya-call-uplink), writing it to a file when the echo check asks. Proof: with no call, alsaucm lists the verb and setting it sets the routes (a base check); the call itself is proven by calls-first-call.

Done 2026-11-17 (bring-up): surya-lab has the Voice Call verb (ucm/Xiaomi/surya/VoiceCall.conf, listed by ucm/conf.d/sm8250/POCO-X3.conf) with Earpiece, Speaker and Mic; PulseAudio dropped the verb until its MultiMedia1 and MultiMedia2 routes were in it too (it test-opens the devices' PCMs). q6voiced reads /etc/conf.d/q6voiced (card 0, PCM 6); devlab-call-uplink keeps a 1-channel capture on MultiMedia3 during a call. The TX topology 0x10F70 is now set in the HiFi verb at boot: the DSP builds its voice processor once, at the first call, with whatever topology is set then - a first call placed before the switch kept the uplink silent for every later call until a reboot.

Opened
: 2026-11-17

Waits
: calls-q6voice-kernel

About
: modem-calls


<a id="calls-first-call"></a>
### Calls 3: the first supervised call - tone line, then echo line

Project
: linux-phone-oco/docs

Status
: done

Note
: With the author's word (2026-11-11-modem-read-only-first), the bring-up session calls +49 89 721010 99702 (blueSIP's tone line) and then +49 89 721010 99701 (blueSIP's echo) through mmcli, 20 s each, recording the uplink capture. Settles: whether the lines answer from this SIM, whether VoLTE or GSM carries the call, the round-trip delay, the downlink level at the mic. If the echo line is dead, the fallback is the SIM's own mailbox (record, then play back by DTMF). Proof: a tone found in the recording of the tone-line call, and the played pattern found again a round trip later in the echo call.

Done 2026-11-17 (bring-up), with the author's word: blueSIP's tone line answered from this SIM and its 1004 Hz tone reached the microphone through the earpiece at -9.9 dBFS, 78 dB above the noise (the downlink works). The echo line plays an announcement of about 19 s first (the author heard it; tones played before it ends are not echoed), then echoes at once: a 1500 Hz burst at 20 s came back round after round, losing 6-7 dB a second (-14.9, -21.9, -28.9 ... dBFS) - the uplink works.

Opened
: 2026-11-17

Waits
: calls-voice-ucm-uplink; the author's word

About
: modem-calls


<a id="calls-echo-check"></a>
### Calls 4: call-echo, the daily automatic echo call

Project
: linux-phone-oco/docs

Status
: done

Note
: A telephony-layer check in surya-lab tests/health (generic in lab-tools once a second phone calls): skip as unknown without modem, SIM, registration, voice, call-audio-path, a number in the manifest, or with today's call already made (a stamp under /var/lib/devlab/health); else call the echo line, play three tones (800, 1300, 1900 Hz, 200 ms, 300 ms apart) quietly on the loudspeaker, record the uplink capture, hang up within 25 s, and let 'devlab-health call echo' find the pattern twice at one delay of 150-1500 ms, 15 dB above the noise. Proof: its pass is the works test for modem-calls (docs' tests row call-echo, works).

Done 2026-11-17 (bring-up): surya-lab tests/health/shell/call-echo.sh, once a day: Voice Call profile before dialing, the echo line, 20 s for the announcement, a 1 s 1500 Hz tone on the earpiece, the microphone recorded through the call; devlab-health tone find looks 1-2 s after the tone ended. First run: pass, the echo at -48.4 dBFS against -81.2 dBFS of noise. About 30 s of a landline call a day.

Opened
: 2026-11-17

Waits
: calls-first-call

About
: modem-calls


<a id="health-analysis-in-rust"></a>
### devlab-health tone make|find on the phone, the awk Goertzels retired

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Done 2026-11-17 (conveyor-health): devlab-health is a multi-call binary. tone make|find links lab-tools' tone crate (its clap command a feature now; one WAV reader shared by tone, devlab hear and the runner), lab-tools #57, released 0.1.2. surya's microphone-hears and earpiece checks call it instead of awk (surya-lab #115); lib.sh's json_field reads its JSON. Static aarch64 runner: 528,656 -> 594,192 bytes (+64 KiB, +12%). On surya, 20261117-092300 and 093527 both healthy, with the same verdicts as the awk runs: earpiece -22.1 dBFS (awk -22.4), mics about 5 dB higher under the Hann window. speaker-stereo has no Goertzel (its awk only parses pactl). Next on it: call echo.

Opened
: 2026-11-17

About
: dl-reaches


<a id="health-coverage-query"></a>
### A coverage query: each device's parts with no test proving works

Project
: linux-phone-oco/docs

Status
: done

Note
: Done 2026-11-17 (orchestration): queries/coverage.sql - tad q coverage [--device D] lists every part of a device whose work no test on that device proves, with its best proof (present or none), its status and the tests that measure it. On xiaomi-surya it lists 14: fastboot with no test at all; modem-calls, modem-sms, nfc, bluetooth, audio-headphone, audio-speaker, the display, touch, haptics, the cameras, fingerprint and sensors proven present only.

Opened
: 2026-11-17

About
: surya-tested


<a id="calls-audio-q6voice"></a>
### Call audio both ways: q6voice, with the uplink from the microphone

Project
: linux-phone-oco/docs

Status
: done

Note
: Researched (research call-audio-on-surya) and decided (2026-11-17-calls-proven-by-echo-call); the work continues as calls-q6voice-kernel, calls-voice-ucm-uplink, calls-first-call and calls-echo-check.

Opened
: 2026-11-17

About
: modem-calls


<a id="health-data-check"></a>
### The mobile-data check made generic, counting its bytes against a budget

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Done 2026-11-17 (conveyor-health): telephony/10-mobile-data.sh in the generic suite (lab-tools #60, fixed by #62 to measure the data bearer and never IMS), with devlab-health data plan|spent keeping the month's ledger (/var/lib/devlab/health-data) and the manifest's [health] data_budget_mb (250 MB by default; surya says it, surya-lab #116, whose own base/mobile-data.sh retired). On surya with 0.1.4 (run 20261117-093527, healthy): the week's run downloaded 5 MB at 1.2 MB/s, 5.40 MB moved; a plain run downloads 100 kB and moves 118 kB; with a 1 MB budget it skips with 'the month's budget is spent: 5.5 of 1 MB'.

Opened
: 2026-11-17

About
: modem-data


<a id="sms-loopback"></a>
### SMS: the phone texts itself and receives it, after every boot or daily

Project
: linux-phone-oco/docs

Status
: done

Note
: Opened 2026-11-17 (bring-up), with mobile data working (Vodafone.de network, a 1&1 SIM). A check sends a short SMS from the phone to its own number with mmcli and waits for it to arrive - proving modem-sms works without messaging anyone else. The number is kept in a private file on the lab machine (~/.config/devlab/xiaomi-surya/own-number, mode 600), never in a repository. Cost: one SMS a run; daily rather than every boot.

Done 2026-11-17 (bring-up): the author gave the number; it lives in ~/.config/devlab/xiaomi-surya/own-number on the lab and /etc/devlab/private/own-number on the phone (root only), in no repository. surya-lab tests/health/base/sms-loopback.sh sends a unique token to the phone's own number and finds it within 90 s - in ModemManager, or in Sxmo's own log, because Sxmo takes each incoming SMS, shows it and deletes it from ModemManager (the first try missed it for that reason; the author saw the SMS pop up). It clears its own pop-up. First pass: received in 3 s. At most one SMS a day; other runs repeat that day's result.

Opened
: 2026-11-17

Waits
: the SIM's own phone number (the SIM does not store it)

About
: modem-sms


<a id="upstream-alpine-tqftpserv"></a>
### Upstream: tqftpserv >= 1.2 in Alpine v3.24-stable

Project
: linux-phone-oco/docs

Status
: open

Note
: Found 2026-11-17 on surya (bring-up): Alpine v3.24 (postmarketOS v26.06) ships tqftpserv 1.1.1, which never writes the modem's short state files, so SM7150/SM7125 modems never come online and their SIMs read as missing (pmaports #4441). Edge has 1.3 (fixed upstream in 9ef11c0); surya takes it from edge as tqftpserv@edge until then. To send: an aports merge request (or a backport request on the 3.24-stable branch) upgrading tqftpserv to 1.3, citing pmaports #4441 and this phone's result (online, LTE, data on the next boot).

Opened
: 2026-11-17

Waits
: the author: a request to Alpine is made in his name

About
: modem-data


<a id="expert-primer"></a>
### A domain's expert primer: one named query that shows a fresh session everything docs knows of a component - research, decisions, backlog, tests, sources, support status, its how-it-stands row

Project
: linux-phone-oco/docs

Status
: done

Note
: Done 2026-11-17 by kb-about-link: tad q about --subject COMPONENT is the primer - status, research (its how-it-stands row once written with --about), decisions, open work, log, tests and the sources cited.

Opened
: 2026-11-17


<a id="briefs-end-and-route"></a>
### Briefs say when a session ends and how questions route: hand-over into the domain's how-it-stands row, end before compaction, ask the record, then the live owner directly, then a consult

Project
: linux-phone-oco/docs

Status
: open

Note
: Decision 2026-11-17-experts-written-not-standing. Next: orchestration edits prompts/bring-up.md, feature-research.md and orchestration.md; the first how-it-stands rows are audio-mic's and deep-sleep's, moved from the side-session notes.

Opened
: 2026-11-17


<a id="health-telephony-layer"></a>
### The telephony layer: checks that cost something, at most once a day

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Per decision 2026-11-17-health-checks-shell-and-rust, asked by bring-up for surya's SMS loopback and mobile data: devlab-health 0.1.1 runs a third layer after base and shell, telephony (a call, an SMS, mobile data), and lib.sh's once_a_day NAME lets such a check run once on a day and skip with 'ran today' after; devlab suite put carries a lab's tests/health/telephony/. Released by release-plz, published and installed on surya.

Opened
: 2026-11-17

About
: modem-calls


<a id="suite-put-from-main"></a>
### suite put puts the lab as its main has it

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Seen 2026-11-17 (orchestration's own slip): suite put run in a surya-lab clone 40 commits behind main put old checks and a known gap main had left (audio-mic) onto the phone, until the suite was put again from main. Now suite put reads the lab's manifest and checks from devlab's own clone at main (state places-put); --here takes the clone's, to try a check before it lands. Proven: run from the stale clone, it put main's 19 checks.

Opened
: 2026-11-17

About
: dl-reaches


<a id="reports-not-in-clones"></a>
### A change's health report stays on the phone until the watch files it

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Seen by bring-up 2026-11-17: a suite run from its worktree brought the phone's reports into that worktree and they rode along in a landing. devlab no longer brings reports into the clone a command runs from (after a reboot, a try, a suite run, or through the MCP door); the watch gathers every report into devlab's own clone and lands it, the only way in. devlab gather now (without --land) still writes into the lab it is asked to, by its name. Proven: a suite run from the shared surya-lab clone left its tests/results as it was.

Opened
: 2026-11-17

About
: dl-reaches


<a id="kb-about-link"></a>
### Every record names what it is about, checked: an about field on research, backlog, session_log and concepts (decisions has one, free text in four spellings), one references rule to components, features, milestones and devices, backfilled; and the query about SUBJECT

Project
: linux-phone-oco/docs

Status
: done

Note
: Done 2026-11-17: about on research, backlog, session_log and concepts beside decisions, one references rule per table (components, features, milestones, devices, backlog); 11 drifted spellings in decisions caught by the rule and set to plain ids (the face's milestone badges match plain ids; ocoeco's language now lets a decision be about a component, feature or device too); 185 rows backfilled - every research row, most backlog and log rows; the rest are about the project as a whole. tad q about --subject X: the microphone in 22 KB (pages: 206 KB), the modem in 17 KB, the subjects in 1.3 KB. Next: kb-entry.

Opened
: 2026-11-17


<a id="agent-folder"></a>
### The agent specifics of linux-phone-oco in their own folder, ideal-agent-linux-phone-oco/: prompts/ moved there with git mv, the domain part of practice 42 beside them, extending ideal-agent

Project
: linux-phone-oco/docs

Status
: done

Note
: Done 2026-11-17: prompts/ moved with git mv into ideal-agent-linux-phone-oco/ beside phone-keeper.md, with a README holding practice 42's domain part and the table of briefs; pointers fixed in the briefs, the keeper brief, AGENTS.md and the patrol's scheduled task. ideal-agent's own wording (the project's prompts/) is its owner's - told.

Opened
: 2026-11-17


<a id="gps-measurable"></a>
### GPS: a component and a failing test, so location can be measured

Project
: linux-phone-oco/docs

Status
: open

Note
: The author, 2026-11-17: lp-connected needs the feature gps, but components has no GPS row, so nothing can measure it. Add the component and a failing test first; on SM7150 location comes through the modem (QMI LOC / ModemManager location). Then research the way.

Opened
: 2026-11-17

Waits
: the decision of a feature research session: the author has hard ones researched first (2026-11-17)

Needs
: phone

Device
: xiaomi-surya

Proof
: gps-fix

Rank
: 30


<a id="bt-pairing"></a>
### Bluetooth pairs and carries audio: from partial to works

Project
: linux-phone-oco/docs

Status
: open

Note
: The author, 2026-11-17: bluetooth is partial (controller and powered pass). A works test: pair with a device the lab keeps, carry audio or a file; witnessed where a person must confirm.

Opened
: 2026-11-17

Needs
: phone

Device
: xiaomi-surya

Proof
: bt-pairs

Rank
: 40


<a id="volte-and-emergency"></a>
### VoLTE and emergency calls, to finish calls and messages

Project
: linux-phone-oco/docs

Status
: open

Note
: The author, 2026-11-17: confirm first whether today's working calls go over VoLTE (Germany has switched 3G off; read the modem's call and IMS state during the daily echo call). Emergency calls are proven without dialling an emergency number: the modem's emergency number list and its readiness, never a real 112 call.

Opened
: 2026-11-17

Needs
: phone

Device
: xiaomi-surya

Proof
: volte-call

Rank
: 50


<a id="sensors-and-the-mask"></a>
### Sensors probe: the registry kept current, sensorspd alone unmasked

Project
: linux-phone-oco/surya-lab

Status
: done

Note
: Probe done 2026-11-17 (keeper-8, research 2026-11-17-sensorspd-probe-still-writes): with the configs at mtime 1230768000 the DSP still writes temp.json and sns_reg_version through hexagonrpcd (refused) and crashed 7 times in 25 s; the audio card needed a reboot. Not kept: sensorspd masked again, mtimes restored. The proof (proximity-reads) did NOT pass; per this item the way turns to sensors-registry-writes, which now carries the work.

Opened
: 2026-11-11

Needs
: phone

Proof
: proximity-reads

Rank
: 10

About
: sensors


<a id="sensors-without-crash"></a>
### Sensors kept: the probe's state in every flash, three boots without an ADSP crash

Project
: linux-phone-oco/surya-lab

Status
: open

Note
: Decided 2026-11-17 (research-sensor-hub, decision 2026-11-17-sensors-registry-kept-current). After sensors-and-the-mask passes: carry its state in device.toml - the configs at mtime 1230768000 (a flash step or a tmpfiles 'z'/touch at boot, since apk sets the package's mtime on every upgrade) and hexagonrpcd-adsp-sensorspd out of [flash] mask (its reason comment updated; rootpd stays masked); remove 'sensors' from [health] gaps. Proven by three boots in a row with motion-and-light and proximity-reads passing, no-processor-crashes passing and the microphone and call checks unchanged. Then upstream (sensors-upstream).

Opened
: 2026-11-11

Waits
: sensors-registry-writes: the DSP still writes with its configs current (probe 2026-11-17)

Needs
: phone

Device
: xiaomi-surya

Proof
: motion-and-light

Rank
: 11

About
: sensors


<a id="sensors-proximity-in-calls"></a>
### Proximity blanks the screen at the ear in a call

Project
: linux-phone-oco/docs

Status
: open

Note
: Decided 2026-11-17 (research-sensor-hub, decision 2026-11-17-sensors-registry-kept-current). After sensors-without-crash. The sensor is surya's stk3a5x infrared one (not ultrasonic: nothing in the microphones or earpiece). Read it through iio-sensor-proxy (monitor-sensor --proximity) near and far; find how the shell on the phone (Sxmo) does its in-call proximity lock and make it read iio-sensor-proxy rather than an IIO sysfs file - a sxmo-deviceprofiles or sxmo-utils change for SSC phones; check the panel's calibration (huaxing 2.0, tianma 1.0 in the configs). Proven by proximity-reads after every boot, and once witnessed: in a call (call-echo), the author's hand over the top of the screen blanks it and lifting it brings it back.

Opened
: 2026-11-17

Needs
: phone

Device
: xiaomi-surya

Proof
: proximity-reads

Rank
: 12

About
: proximity


<a id="sensors-registry-writes"></a>
### Fallback: hexagonrpcd serves a writable sensor registry

Project
: linux-phone-oco/docs

Status
: open

Note
: Decided 2026-11-17 (research-sensor-hub, decision 2026-11-17-sensors-registry-kept-current). Only if sensors-and-the-mask shows the DSP writing even with every config matching. Then: hexagonrpcd with write support limited to a state copy of the registry (hexagonrpc #27's commits at 40e5041, or the -S state directory of #19, or the #29 patch), built for the phone, sns_reg_version served beside the registry, the copy seeded from the package; one probe as in sensors-and-the-mask. A restart loop at start can leave the sensor PD unusable until reboot (#19): one try per boot. Results go to hexagonrpc #19/#29 as SM7150 data. The 2026-11-09 draft that served sns_reg_version was not kept anywhere in the lab.

Opened
: 2026-11-09

Needs
: phone

Device
: xiaomi-surya

Proof
: motion-and-light

Rank
: 3

About
: sensors


<a id="sensors-upstream"></a>
### Sensors upstream: configs at the vendor mtime, SM7150 data to hexagonrpc

Project
: linux-phone-oco/docs

Status
: open

Note
: Decided 2026-11-17 (research-sensor-hub, decision 2026-11-17-sensors-registry-kept-current). After sensors-without-crash. Offer: firmware-xiaomi-surya (sm7150-mainline) and pmaports install the sensor configs at mtime 1230768000 (or hexagonrpcd reports a fixed mtime for served configs), which may also end davinci's ADSP loop (#3871, #4674); a comment on hexagonrpc #19/#29 with surya's finding; iio-sensor-proxy !409 confirmed on SM7150. Messages upstream go out in the author's name: his word first.

Opened
: 2026-11-17

About
: sensors


<a id="kb-entry"></a>
### AGENTS.md is the one entry: under 3 KB, an orientation table from typical question to the command that answers it, tad statements for the rest, never read data/ or docs/ to answer; CLAUDE.md is @AGENTS.md; editing recipes move to CONTRIBUTING

Project
: linux-phone-oco/docs

Status
: done

Note
: Done 2026-11-17: AGENTS.md is 2.1 KB - two lines, linux-phone's own questions and idealkb's generic part (the orientation table, the rule never to read data/ or docs/); the editing recipes are in CONTRIBUTING.md; CLAUDE.md is @AGENTS.md. Measured again in kb-navigation-remeasured: the modem question 0.2 KB, the microphone 15.9 KB as csv (91 KB in box format: compact output is idealkb's backlog compact-query-output).

Opened
: 2026-11-17


<a id="idealkb-from-template"></a>
### grenudi/ideal-knowledge-base: a new repository that pins tad's release and adds the knowledge-base layer - the file-or-table rule, the about link, the generic queries (about, next, find, recent), the short AGENTS.md entry and the standing tables (backlog, session_log, decisions, research); with tad init in tad for a bare database, and text-as-data-template retired with a pointer once its reasons are carried over

Project
: linux-phone-oco/docs

Status
: done

Note
: Done 2026-11-17: tad init in tad 0.7.0 (tad-engine decision 2026-11-17-tad-init); grenudi/ideal-knowledge-base made and released 0.1.0 (public, oco-project, its own tad base: concepts, decisions, research with 18 sources, backlog, log); text-as-data-template's reasons carried into both and the template retired (archived) with a pointer; docs follows idealkb 0.1.0 (decision 2026-11-17-docs-follows-idealkb). What is left is idealkb's own backlog: tad q next in grenudi/ideal-knowledge-base.

Opened
: 2026-11-17


<a id="bring-up-brief-light"></a>
### The bring-up brief over budget (13.3 KB, budget 8 KB): its detail behind summaries and queries

Project
: linux-phone-oco/docs

Status
: done

Note
: Done 2026-11-17 (orchestration): bring-up folded into phone-keeper.md (5.7 KB) and bring-up.md left as a pointer (0.4 KB); the keeper's first paragraph is its whole start - purpose and the exact commands (phone-stands, phone-queue --format csv, about --subject S, devlab suite latest) - and the rest is read only when a step names it. start-weight: phone-keeper 29.4 -> 26.2 KB, bring-up 38.2 -> 21.0 KB. orchestration, feature-research and the README point to the keeper.

Opened
: 2026-11-17

About
: agent-folder


<a id="start-weight-on-the-face"></a>
### The start weight per role, a number on the face

Project
: linux-phone-oco/docs

Status
: open

Note
: Housekeeping (ideal-agent practice 45) measures the bytes a fresh session reads per role (scripts/start-weight). Next: a table or named record for the measurement (role, bytes, date), filed by the patrol, and a line per role on the face beside its budget.

Opened
: 2026-11-17

About
: agent-folder


<a id="patrol-measures-the-start"></a>
### The patrol measures the start weight each run and files bring-up-brief-light-like items when over budget

Project
: linux-phone-oco/docs

Status
: done

Note
: Done 2026-11-17 (orchestration): the linux-phone-patrol round measures the start with ideal-agent's scripts/start-weight on docs at main each run, and files one backlog item about agent-folder when a role or part is over the budget of keep-the-start-light; its leftover ocoeco note problems step for lab-agent signs is gone (said in its report instead).

Opened
: 2026-11-17

About
: agent-folder


<a id="kb-summaries"></a>
### A summary over many records, and research kept aside, from idealkb 0.3.0

Project
: linux-phone-oco/docs

Status
: done

Note
: Done by summary-and-research-layers on 2026-11-17: pin 0.3.0; docs' own about, research record and tables.toml take summaries, material and supersedes; audio-mic summarised (15.9 KB to 4.8 KB); Open Handset Commons moved into research/open-handset-commons/2026-11-10/.

Opened
: 2026-11-17


<a id="summaries-due"></a>
### Write the summaries tad q about shows as due: deep-sleep, dl-reaches, sensors

Project
: linux-phone-oco/docs

Status
: open

Note
: On 2026-11-17, after audio-mic's: deep-sleep 15.7 KB in 17 records, dl-reaches 10.9 KB in 15, sensors 11.3 KB in 10. Each is written by the session that next records into it, or its keeper at hand-over (tad r summary --about S --says ...). tad q about shows which are due.

Opened
: 2026-11-17

Proof
: tad q about shows none of them as summary due

About
: kb-summaries


<a id="sleep-wake-source"></a>
### Why the first s2idle woke after 2.4 s, not 60

Project
: linux-phone-oco/docs

Status
: done

Note
: Answered 2026-11-17: IRQ 157, the serial at 88c000 (research 2026-11-17-surya-s2idle-wakes-at-once); the fix is sleep-wake-uart.

Opened
: 2026-11-17

Proof
: soc-sleeps

Rank
: 2

About
: deep-sleep


<a id="sim-removed-skips"></a>
### Checks that need the SIM skip, not fail, while it is out

Project
: linux-phone-oco/surya-lab

Status
: done

Note
: Done 2026-11-17 (lab-tools #73 no_sim helper, surya-lab #123): with the SIM out, modem-registered, mobile-data, call-echo and sms-loopback say 'skip: no SIM card' (before the once-a-day stamp, so a skip costs nothing). After one reboot on devlab-health 0.1.6: 35 pass, 5 fail (the known gaps: fingerprint, sensors, cameras), 5 skip; calls, SMS and data stay 'works' at their last real measurement.

Opened
: 2026-11-17

Needs
: phone

About
: surya-tested


<a id="sleep-way-back"></a>
### A way back from a suspend that may not return: the watchdog kept armed through sleep

Project
: linux-phone-oco/surya-lab

Status
: done

Note
: Done 2026-11-17 (surya-lab sleep/way-back.sh, build-wdt.sh, patches/qcom-wdt-keep-armed-in-suspend.patch; patched module in updates/ on the phone, acts as stock until 'enable'): idle fuse, probe through a suspend and the hanging cycle all reset the phone by the watchdog and it came back with no hands. Next: sleep-wake-uart with the cause of the hang: see 2026-11-17-way-back-measured.

Opened
: 2026-11-17

Needs
: phone

About
: deep-sleep


<a id="sim-removed-skips"></a>
### Checks that need the SIM skip, not fail, while it is out

Project
: linux-phone-oco/docs

Status
: done

Note
: Done 2026-11-17 (lab-tools #73), then moved onto the phone: lpoco-health detects no-sim at every run (conditions/10-modem.sh) and reports 'skip: no SIM card'; the SIM's state is no longer kept in docs. History: session log 2026-11-17-sim-removed-skips, decision 2026-11-17-lpoco-health.

Opened
: 2026-11-17

Needs
: phone

About
: surya-tested


<a id="sleep-wake-uart"></a>
### Suspend ends at once: the serial's interrupt 157 is a wake source and a storm

Project
: linux-phone-oco/docs

Status
: done

Note
: 2026-11-17 (surya-keeper-4): done. The wake was irq 158, the UART's RX wake pin, armed by the serial's power/wakeup; way-back.sh cycle SLEEP bt-on turns it off for the cycle with Bluetooth unblocked. 3 cycles (5, 5, 15 s) ended by the RTC alarm, hci0 up and scanning after (decision 2026-11-17-serial-wakeup-off). What it did not do: soc-sleeps still fails (cxsd 0, aosd 0), so the SoC did not reach its lowest state.

Opened
: 2026-11-17

Proof
: soc-sleeps

Rank
: 2

About
: deep-sleep


<a id="sleep-bt-resume"></a>
### Bluetooth dies across a suspend and hangs the resume

Project
: linux-phone-oco/docs

Status
: done

Note
: 2026-11-17 (surya-keeper-4): not seen again. With Bluetooth unblocked and the serial's wakeup off, 3 cycles of 5-15 s resumed in time and hci0 scanned afterwards (no tx timeout, no QCA retries in dmesg). The earlier hang came with the wakeup on or Bluetooth blocked; only these 3 cycles are counted, nothing longer than 15 s.

Opened
: 2026-11-17

Proof
: soc-sleeps

Rank
: 3

About
: deep-sleep


<a id="lpoco-health"></a>
### lpoco-health: the one health suite on the phone, with switches and run-time detection

Project
: linux-phone-oco/lab-tools

Status
: in-progress

Note
: Landed 2026-11-17: lab-tools #75, #77 (compat names), package default (next); put on surya by the keeper, runs gathered (docs #213). Open: the surya-lab checks call the new names (keeper repointing); then drop the devlab-health compat names; try the first switch on the phone (lpoco-health off TEST --reason ...); upstream: revisit when pmOS has system tests.

Opened
: 2026-11-17

About
: lpoco-health


<a id="ikb-recording"></a>
### Record into docs with ikb: one command per record, one page (IKB.md)

Project
: linux-phone-oco/docs

Status
: done

Note
: docs follows idealkb 0.6.1 and ikb 0.1.1; IKB.md generated, kept fresh by make verify; machine records named in idealkb.toml.

Opened
: 2026-11-17


<a id="devlab-fastboot-mode"></a>
### devlab reaches a phone over fastboot (walleye speaks nothing else until Linux runs)

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Done 2026-11-17 (lab-tools PR 79, device-template fastboot-serial): device.toml [fastboot] serial + writes (false unless said); devlab fastboot state | getvar NAME | boot now BOOT.IMG | reboot now [--bootloader], by serial, held, nothing written; lease and hold already per codename. devlab flash names its serial and refuses without writes = true; the guard refuses raw fastboot but devices/getvar/help. Read on the lab: devlab fastboot state on google-walleye (product walleye, unlocked yes, slot-count 2, current-slot a). Wanted next: google-walleye-lab's device.toml gets [fastboot] serial = FA81N1A00790 (its own lab's change). boot now not yet tried on walleye: no boot image yet.

Opened
: 2026-11-17

About
: google-walleye


<a id="android-reference-walleye"></a>
### Measure Android on the Pixel 2 before anything is flashed

Project
: linux-phone-oco/google-walleye-lab

Status
: in-progress

Note
: Measured read-only 2026-11-17 (research android-reference-walleye-measured): build, sensors, battery, boot time, audio config. Left: sleep current (needs a meter, radios stated), audio levels (tone source and microphone), boot time from power on

Opened
: 2026-11-17

About
: android-reference


<a id="surya-fastboot-serial"></a>
### surya's fastboot serial in its manifest, read from fastboot

Project
: linux-phone-oco/surya-lab

Status
: open

Note
: devlab flash now refuses surya until surya-lab device.toml says [fastboot] serial and writes = true (lab-tools PR 79, decision 2026-11-17-fastboot-by-serial-writes-by-manifest). Next time surya sits in its bootloader, read fastboot devices (likely dc21014b, its soc0 serial 3693150539 in hex - not yet read from fastboot), then add [fastboot] serial and writes = true with the decision that allows flashing surya.

Opened
: 2026-11-17

Needs
: phone

Device
: xiaomi-surya

About
: dl-safe


<a id="upstream-records"></a>
### Upstream work is kept as records: upstreams and upstream_items (idealkb 0.8), the upstream-* items headed in them

Project
: linux-phone-oco/docs

Status
: in-progress

Note
: Seeded 2026-11-17: six upstreams, nine items (sxmo profile sent; tas2562 x2, WCD series, UCM, pd-mapper, tqftpserv, PR 60 comment as drafts); patches and messages copied into upstream/UPSTREAM/ITEM/. Next: the author's word moves a draft to ready; the surya coordinator writes the deep-sleep upstream plan as items. upstream-queue/README stays a copy until it is retired.

Opened
: 2026-11-17


<a id="walleye-dtbo-overlay-id"></a>
### Find out which dtbo overlay id walleye's bootloader needs before a mainline kernel boots

Project
: linux-phone-oco/google-walleye-lab

Status
: open

Note
: The taimen bootloader refuses a kernel unless dtbo holds an overlay with id 2704 (kcxt-dtbo-wahoo-mainline); walleye's id is not known. Read it without writing: from the stock dtbo (Android booted, or the factory image - decision needed, proprietary download). Research: google-walleye-how-others-booted.

Opened
: 2026-11-17

About
: google-walleye


<a id="walleye-usb-uart-cable"></a>
### USB-C debug UART cable for walleye (no display): decide on 'fastboot oem uart enable' first

Project
: linux-phone-oco/google-walleye-lab

Status
: open

Note
: pmOS wiki lists the Android Debug Cable as tested with walleye. The oem command's effect (RAM flag or persistent) is not known, so it counts as a change to the phone: a decision first. Needs the author's hands for the cable. Research: google-walleye-how-others-booted.

Opened
: 2026-11-17

About
: google-walleye


<a id="walleye-kernel-dts"></a>
### Build v7.3 with a minimal msm8998-google-walleye.dts

Project
: linux-phone-oco/google-walleye-lab

Status
: done

Note
: Built 2026-11-17: dt/msm8998-google-walleye.dts (lab PR 3) + v7.3 + build/walleye.config; counted: dtb builds, no dtc warning at W=1 from our file, msm-id 292/131073 (0x124/0x20001), 0 bootargs/stdout-path, Image.gz 15038692 bytes. Run: build/build-kernel.sh via oco-agent. Next: the keeper's one fastboot boot; UFS/display/touch stay off.

Opened
: 2026-11-17

Proof
: make qcom/msm8998-google-walleye.dtb builds with no dtc warning from our nodes, the dtb holds msm-id 0x124/0x20001 and no /chosen/bootargs, and Image.gz builds (test to write in lab-tools: walleye-dtb-check)

About
: google-walleye


<a id="walleye-initramfs-usb-gadget"></a>
### Initramfs that brings up a USB gadget (ACM console + RNDIS/ECM) and telnet/ssh on 172.16.42.1

Project
: linux-phone-oco/google-walleye-lab

Status
: in-progress

Note
: Built (build/initramfs, busybox 1.36.1 static arm64, 1148576 bytes gz). Proven under x86_64 QEMU with dummy_hcd (build/selftest-initramfs.sh): gadget binds, lease 172.16.42.2, ping and telnet command answered on 172.16.42.1, ttyGS0 exists. NOT proven on arm64: qemu-system-aarch64 is not installed here, so the arm64 busybox and the real UDC first run on the phone try. No ssh yet (telnet only; dropbear is a later piece).

Opened
: 2026-11-17

Proof
: In QEMU aarch64 with dummy_hcd the initramfs creates the gadget and answers on its address (test: walleye-initramfs-gadget-qemu)

About
: google-walleye


<a id="walleye-debug-without-display"></a>
### Reach a hung or crashed walleye without a display: warm reset, pstore, UART

Project
: linux-phone-oco/google-walleye-lab

Status
: open

Note
: ramoops at 0xa1810000/0x200000, qcom_wdt.arm_on_probe=1, watchdog.open_timeout=300, reboot=w (porthole); the Pixel debug cable is not in the lab.

Opened
: 2026-11-17

Waits
: walleye-first-fastboot-boot

Needs
: phone

Device
: google-walleye

Proof
: after a deliberate panic the next boot lets the keeper read the panic log from /sys/fs/pstore (test: walleye-pstore-panic)

About
: google-walleye


<a id="walleye-ufs-readonly"></a>
### UFS probes and the partitions are listed, read-only

Project
: linux-phone-oco/google-walleye-lab

Status
: open

Note
: Enable ufshc + ufsphy with the vcc/vccq rails from the wahoo dtsi; mount nothing, write nothing; this is also the way to read walleye's own boot.img header.

Opened
: 2026-11-17

Waits
: walleye-first-fastboot-boot

Needs
: phone

Device
: google-walleye

Proof
: lsblk in the initramfs lists the UFS LUNs and by-name partitions without a write (test: walleye-ufs-lsblk)

About
: google-walleye


<a id="walleye-display-s6e3fa5"></a>
### Display: Samsung S6E3FA5 command-mode panel through DPU/DSI

Project
: linux-phone-oco/google-walleye-lab

Status
: open

Note
: No mainline driver; start from the out-of-tree S6E3FA5 driver (OnePlus 5) and porthole's sw43402 cmd-mode work for the DPU side; init sequence from the GPL downstream dtsi; reset gpio94, TE gpio10 (walleye) - the panel and its rails are walleye's own.

Opened
: 2026-11-17

Waits
: walleye-ufs-readonly (not required) / walleye-first-fastboot-boot; a person witnesses the first light

Needs
: phone

Device
: google-walleye

Proof
: the DRM connector is connected and a test pattern is seen by a person (test: walleye-display-pattern)

About
: google-walleye


<a id="walleye-touch-rmi4"></a>
### Touch: Synaptics RMI4 on blsp1_i2c5 (0x20, irq gpio125, reset gpio89)

Project
: linux-phone-oco/google-walleye-lab

Status
: open

Note
: Mainline rmi_i2c driver; supplies pm8998 l6 and l28; xd boards add a pmi8998 power gpio - which board revision the lab phone is, is not known.

Opened
: 2026-11-17

Waits
: walleye-first-fastboot-boot

Needs
: phone

Device
: google-walleye

Proof
: evtest shows touch events from the RMI4 device when the panel is touched (test: walleye-touch-events)

About
: google-walleye


<a id="walleye-bootimage"></a>
### Boot image: header v0, base 0, kernel 0x8000, ramdisk 0x1000000, tags 0x100, page 4096, dtb appended

Project
: linux-phone-oco/google-walleye-lab

Status
: in-progress

Note
: Four images, 17 checks each, 0 failed: a,b as before; c,d = a,b with os_version 8.1.0 / patch level 2020-01 (4 header bytes differ). sha256 in ~/Projects/walleye-build/images/SHA256SUMS. Header v0 fits walleye per public sources (walleye-bootimage-header-public); stock header still unread. Untried: the dtbo overlay id (walleye-dtbo-overlay-id) and an AVB footer.

Opened
: 2026-11-17

Waits
: walleye's stock boot.img header (android-reference-walleye) to confirm the offsets

Proof
: unpack_bootimg of the result shows the offsets and cmdline, the dtb is inside the kernel blob, size is under the phone's max-download-size (test: walleye-bootimg-unpack)

About
: google-walleye


<a id="walleye-spec-records"></a>
### A spec record: what the observer learned, with evidence kind, file, hash, command

Project
: linux-phone-oco/docs

Status
: open

Note
: Wanted before the first part that needs clean-room observation (display panel init is the likely first). Ask the ikb session to add a spec record (fields from research 2026-11-17-cleanroom-agents); first trial on a part surya already solved. Not needed for the first kernel.

Opened
: 2026-11-17

About
: google-walleye


<a id="sleep-adsp-awake"></a>
### The audio DSP sleeps when nothing plays

Project
: linux-phone-oco/docs

Status
: in-progress

Note
: 2026-11-17 keeper-6: two floor tests (adsp stopped; adsp+cdsp+modem stopped) still gave cxsd 0, aosd 0, ddr 0 - the DSP is not what holds the SoC (research 2026-11-17-adsp-stopped-cx-aosd-ddr-stay-0). Left here only: does the ADSP firmware fill its own qcom_stats entry (not known yet). The cause of no CX/AOSS sleep is on the Apps/AOSS side: next is sleep-cluster-params.

Opened
: 2026-11-17

Waits
: a deeper decision: what on the Apps/AOSS side holds CX and AOSS (sleep set, cluster parameter, the UARTs' CX vote) is unknown

Proof
: soc-sleeps

Rank
: 3

About
: deep-sleep


<a id="sleep-cluster-params"></a>
### surya's own cluster sleep parameters in its device tree

Project
: linux-phone-oco/docs

Status
: in-progress

Note
: 2026-11-17 keeper-7: cycle 15 bt-on on the cp.dtb (0x41002244, 0x4100c244) 8 times: a real 15 s s2idle (RTC alarm wake), cluster S2 entered, cxsd/aosd/ddr 0 (research 2026-11-17-cluster-params-clean-yet-no-collapse). The parameters are not the blocker. Untried: the SH0 residual's owner, qcom_aoss prevent_* knobs, XO/VRM votes, USB gadget, display RSC.

Opened
: 2026-11-17

Waits
: a deeper decision: WHAT holds CX, AOSS and DDR with an apps side that looks clean (cluster S2 used, CX/MX 0, sleep set zero but SH0 x=1,y=3) is unknown

Needs
: phone

Device
: xiaomi-surya

Proof
: soc-sleeps

Rank
: 2

About
: deep-sleep


<a id="devlab-fastboot-boot-reads-slots"></a>
### devlab fastboot boot reads the slot variables before and after a try and says what changed

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Done 2026-11-17 by lab-tools PR 80 (d510232), recorded there as fastboot-slots-told: devlab fastboot boot now reads current-slot and slot-unbootable/successful/retry-count of a and b before and after, says where the phone went and what changed; state reads them; set-active gated by [fastboot] slot_switch. Installed on the lab.

Opened
: 2026-11-17

Needs
: phone

Device
: google-walleye

Proof
: a test that fails when devlab reports a slot change as only refused

About
: google-walleye


<a id="floor-read-holders"></a>
### Read what is held before and at a cycle: cmdline, clocks, regulators, icc, genpd

Project
: linux-phone-oco/docs

Status
: done

Note
: Done 2026-11-17 (keeper-9): read at idle and before way-back.sh cycle 15 bt-on, research/deep-sleep/2026-11-17-floor-holders/README.md; what is held inside late suspend is not known yet (floor-suspend-late-dump).

Opened
: 2026-11-17

Needs
: phone

Proof
: soc-sleeps

About
: deep-sleep


<a id="floor-dsps-never-started"></a>
### Boot with the DSPs never started, then cycle 15 bt-on

Project
: linux-phone-oco/docs

Status
: done

Note
: Done 2026-11-17 (keeper-9): DSPs never started (remoteproc nodes disabled in a one-shot dtb), cycle 15 bt-on: cxsd/aosd/ddr 0 -> 0, soc-sleeps fails, processors never asleep: none. No DSP vote is the holder. research/deep-sleep/2026-11-17-floor-dsps-never-started/README.md

Opened
: 2026-11-17

Needs
: phone

Proof
: soc-sleeps

About
: deep-sleep


<a id="floor-no-ignore-unused"></a>
### Drop clk_ignore_unused / pd_ignore_unused if the cmdline has them

Project
: linux-phone-oco/docs

Status
: done

Note
: Closed 2026-11-17 (keeper-9): the cmdline has no clk_ignore_unused or pd_ignore_unused (floor-read-holders), nothing to drop.

Opened
: 2026-11-17

Waits
: floor-read-holders

Needs
: phone

Proof
: soc-sleeps

About
: deep-sleep


<a id="floor-wlan-off"></a>
### Cycle with WLAN unloaded

Project
: linux-phone-oco/docs

Status
: done

Note
: Done 2026-11-17 (keeper-9): ath10k_snoc/core unloaded, cycle 15 bt-on: cxsd/aosd/ddr 0 -> 0. WLAN is not the holder. research/deep-sleep/2026-11-17-floor-wlan-off/README.md

Opened
: 2026-11-17

Needs
: phone

Device
: xiaomi-surya

Proof
: soc-sleeps

About
: deep-sleep


<a id="floor-udc-unbound"></a>
### Cycle with the USB controller unbound

Project
: linux-phone-oco/docs

Status
: done

Note
: Done 2026-11-17 (keeper-9): UDC a6f8800.usb unbound, cycle 15 bt-on: cxsd/aosd/ddr 0 -> 0. USB is not the holder. The rebind did not bring the lab link back (needed a hard reboot). research/deep-sleep/2026-11-17-floor-udc-unbound/README.md

Opened
: 2026-11-17

Needs
: phone

Device
: xiaomi-surya

Proof
: soc-sleeps

About
: deep-sleep


<a id="floor-aoss-knobs"></a>
### Write the qcom_aoss prevent_* knobs to off, then cycle

Project
: linux-phone-oco/docs

Status
: done

Note
: Done 2026-11-17 (keeper-9): knobs written 0 before cycle 15 bt-on: cx/ddr writes time out, 'ucore did not ack channel': the QMP link to the AOP is dead, so the knobs settle nothing; counters 0 -> 0. research/deep-sleep/2026-11-17-floor-aoss-knobs/README.md

Opened
: 2026-11-17

Needs
: phone

Device
: xiaomi-surya

Proof
: soc-sleeps

About
: deep-sleep


<a id="floor-suspend-late-dump"></a>
### A debug kernel that dumps held votes in late suspend

Project
: linux-phone-oco/docs

Status
: open

Note
: Only if the reads above leave the holder open: a debug patch (builder) with a pm notifier / syscore op that prints clk enable counts, regulator use counts and icc votes at dpm_suspend_late, out of tree; the keeper installs it as a kernel try and reads dmesg after the cycle.

Opened
: 2026-11-17

Waits
: floor-read-holders and the subtractions above

Needs
: phone

Device
: xiaomi-surya

Proof
: soc-sleeps

About
: deep-sleep


<a id="health-soc-sleeps-ddr"></a>
### soc-sleeps also reads ddr and says which rung is missing (lab-tools)

Project
: linux-phone-oco/docs

Status
: open

Note
: No phone. In lab-tools health/suite/checks/base/90-sleep.sh: read ddr Count and the DDR LPM stat too, and name the rung reached (cluster S2 usage, cxsd, aosd, ddr). Today a pass needs cxsd or aosd and the detail lacks ddr and the cpuidle usage; the check stays failing after a suspend until the floor is reached - it is the feature's failing test.

Opened
: 2026-11-17

Proof
: soc-sleeps

About
: deep-sleep


<a id="fastboot-slots-told"></a>
### fastboot boot says where the phone went and the slots' flags; set-active gated

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Done 2026-11-17 (lab-tools PR 80, d510232), asked by walleye-coordinator after research walleye-first-fastboot-boot-tries: boot now reads current-slot and slot-unbootable/successful/retry-count of a and b before, watches up to 3 min (back in fastboot, Android adb 18d1:4ee7, Linux USB network), says what the flags became once back in fastboot; fastboot's own exit is no longer the verdict. state reads the flags (walleye now: current b, a unbootable). devlab fastboot set-active now SLOT, metadata only, refused unless [fastboot] slot_switch = true (by a recorded decision; walleye's stays false). Installed on the lab.

Opened
: 2026-11-17

About
: dl-safe


<a id="sleep-fastrpc-helpers"></a>
### FastRPC helpers stopped across suspend; the sensors back

Project
: linux-phone-oco/docs

Status
: open

Note
: 2026-11-17 keeper-8: the probe of sensors-and-the-mask (research 2026-11-17-sensorspd-probe-still-writes) shows the DSP still writes the registry with the configs current - crash-loop at start, so there is nothing to measure across a suspend until hexagonrpcd serves writes (sensors-registry-writes). Plan when sensors are up: measure whether they keep streaming after a resume with sensorspd stopped by its Conflicts=suspend.target; restart it after resume (unit WantedBy=suspend.target, After=) only if not; rootpd stays masked; way-back.sh cycle 15 bt-on, one change at a time. Proof: after a measured sleep in one boot, motion-and-light, soc-sleeps and no-processor-crashes pass.

Opened
: 2026-11-17

Waits
: sensors-registry-writes: with the helper unmasked the DSP crash-loops at start (probe 2026-11-17), so the sensors cannot be up to measure across a suspend

Needs
: phone

Device
: xiaomi-surya

Proof
: motion-and-light

Rank
: 4

About
: deep-sleep


<a id="commons-only"></a>
### docs holds only what helps every device; each device has its own open base; docs derives progress from them

Project
: linux-phone-oco/docs

Status
: in-progress

Note
: Decided 2026-11-17 (decision 2026-11-17-commons-and-device-bases; research and reasons in grenudi/ideal-knowledge-base: commons-and-unit-bases-world). The parts below are for the owners named; the umbrella closes when the data has moved and docs shows derived status only.

Opened
: 2026-11-17


<a id="feed-device-bases"></a>
### docs pulls each registered device base's parts over HTTPS in CI and derives support_status; stale or missing shows as not known yet

Project
: linux-phone-oco/docs

Status
: open

Note
: Owner: docs / orchestration. devices gets a base field (the repository), a feed record validates the pulled table against the template's contract, feeds.yml runs it. Never copies a device's queue, tries or measurements. Waits on device-template-base.

Opened
: 2026-11-17

Waits
: device-template-base

About
: commons-only


<a id="move-device-rows"></a>
### Move device rows to the device bases: backlog, research, decisions, log by device and project, test_runs and test_results

Project
: linux-phone-oco/docs

Status
: open

Note
: Owner: docs / orchestration, with each device's keeper. Select by the device field (docs 260) and by project surya-lab, google-walleye-lab; replay by record with ids kept, never merge JSONL; a cross-reference to a docs concept is written docs:ID. test_results (1.3 MB of docs' 2.0 MB) goes first. Waits on device-template-base.

Opened
: 2026-11-17

Waits
: device-template-base

About
: commons-only


<a id="launchers-per-device"></a>
### Lane launchers and briefs work in the device repository and ask its own base (tad q next, phone-queue); docs' lane-next stays for the general queue

Project
: linux-phone-oco/docs

Status
: open

Note
: Owner: roles session / orchestration. Follows move-device-rows; until then lane-next --device stays.

Opened
: 2026-11-17

Waits
: move-device-rows

About
: commons-only


<a id="about-across-bases"></a>
### How a device row names a docs component or feature: the about rule works within one base

Project
: linux-phone-oco/docs

Status
: open

Note
: Open: proposal is docs:ID in text and a local components list in the device base seeded from docs; decide with the first device base. Owner: idealkb (ikb) with docs.

Opened
: 2026-11-17

About
: commons-only


<a id="device-template-base"></a>
### device-template gets a tad base: tables.toml following idealkb, the parts contract (status, evidence, date), next and phone-queue queries, ikb

Project
: linux-phone-oco/docs

Status
: done

Note
: Landed 2026-11-17 (linux-phone-oco/device-template #4, read back from main): data/ (12 empty tables), tables.toml (own: backlog + needs/proof/rank, devices, parts, test_runs, test_results), idealkb 0.9.1 pin with machine = test-run, devicebase.toml (template date, parts = 1: the contract docs validates), records backlog/backlog-status/backlog-needs/part/device/test-run, queries phone-queue/phone-next/parts (no --device: the base is the device), CI tad.yml (check + canon/render fresh), Makefile, README/AGENTS. device.toml untouched. surya-lab and google-walleye-lab are not changed: their keepers take it with move-device-rows. Next: feed-device-bases reads data/parts.json of each base against parts = 1.

Opened
: 2026-11-17

About
: commons-only


<a id="gather-into-device-base"></a>
### devlab gather files a device's runs and results into its own base

Project
: linux-phone-oco/lab-tools

Status
: open

Note
: Decision 2026-11-17-commons-and-device-bases: test_runs/test_results belong to each device's base (device-template #4 has the tables and the test-run record). devlab gather (and devlab's tad record test-run) still files into docs. When move-device-rows has moved a device's rows, devlab files that device's into its lab repository's base (the manifest's folder), and docs pulls them (feed-device-bases). Orchestration's.

Opened
: 2026-11-17

Waits
: move-device-rows

About
: commons-only


<a id="walleye-load-error-why"></a>
### What the Pixel 2's bootloader dislikes in our boot image (Load Error), found from public sources, then the image variants to try

Project
: linux-phone-oco/google-walleye-lab

Status
: done

Note
: Answered: research walleye-load-error-how-it-stands, decision 2026-11-17-walleye-load-error-control-first; steps walleye-loaderror-* (stock-ids, variants-build, control, variants-try, dtbo-stub).

Opened
: 2026-11-17

Needs
: research

Device
: google-walleye

Proof
: a recommended image recipe, each step cited, and the next 2-3 variants to build (research row), consistent with the tries recorded in walleye-first-fastboot-boot-tries*

About
: google-walleye


<a id="walleye-loaderror-stock-ids"></a>
### Read walleye's stock boot header and dtb ids (qcom,board-id, pmic-id, msm-id) from a public LineageOS walleye build, host only

Project
: linux-phone-oco/google-walleye-lab

Status
: done

Note
: Recorded in research walleye-stock-ids-recorded; control image at ~/Projects/walleye-build/control/boot.img (sha256 48dbc55c...7468), dtbo.img beside it (fb09009b...b8f6).

Opened
: 2026-11-17

Needs
: build

Device
: google-walleye

Proof
: walleye-stock-ids-recorded: research row naming the header fields and the dtb's board-id/pmic-id/msm-id, each with the file hash

About
: google-walleye


<a id="walleye-loaderror-variants-build"></a>
### Build variants e,f: blueline recipe (second 0, os word 0) and e plus the stock board-id/pmic-id in the dts; check-bootimg counts both

Project
: linux-phone-oco/google-walleye-lab

Status
: done

Note
: Built, lab PR 6 on main: ~/Projects/walleye-build/images/boot-e.img 112ab284...2daf and boot-f.img 7a42e5bd...461a (sha256 in images/SHA256SUMS; a-d unchanged). e = a with the command line cut to earlycon+console (second_offset 0 is a no-op: mkbootimg already writes second 0); f = e + qcom,board-id <8 0> (stock has none). os word 0.

Opened
: 2026-11-17

Needs
: build

Device
: google-walleye

Proof
: check-bootimg.sh passes for e and f and counts board-id/pmic-id in f

About
: google-walleye


<a id="walleye-loaderror-control"></a>
### Control try: fastboot boot of a public walleye stock-format image (LineageOS recovery or TWRP) with devlab's before/after slot report

Project
: linux-phone-oco/google-walleye-lab

Status
: done

Note
: proven by research walleye-control-e-f-tries: control, e and f all Load Error, flags unchanged

Opened
: 2026-11-17

Needs
: phone

Device
: google-walleye

Proof
: walleye-fastboot-boot-control: devlab report shows the phone left fastboot (18d1:4ee0 gone for 90 s polls) or Load Error, recorded either way as a research row

About
: google-walleye


<a id="walleye-loaderror-variants-try"></a>
### Try e then f (one at a time) with fastboot boot, after the control, with before/after slot report

Project
: linux-phone-oco/google-walleye-lab

Status
: done

Note
: proven by research walleye-control-e-f-tries: control, e and f all Load Error, flags unchanged

Opened
: 2026-11-17

Needs
: phone

Device
: google-walleye

Proof
: walleye-fastboot-boot-variants: each image's outcome recorded as research; success is a USB id other than 18d1:4ee0 appearing (our gadget) for e or f

About
: google-walleye


<a id="walleye-loaderror-dtbo-stub"></a>
### dtbo_b stub with overlay id for walleye - only if the control boots and e,f still end in Load Error

Project
: linux-phone-oco/google-walleye-lab

Status
: open

Note
: A write to the phone: needs the author's word and the way back first (stock dtbo from the LineageOS zip read in walleye-loaderror-stock-ids, flashed back with fastboot flash dtbo_b). Overlay id for walleye is not known: read from the stock dtbo table, not guessed (kcxt's 2704 is for taimen).

Opened
: 2026-11-17

Waits
: the author's word (a write to the phone)

Needs
: phone

Device
: google-walleye

Proof
: walleye-dtbo-stub-boot: after the stub, fastboot boot of e or f leaves fastboot; stock dtbo flashed back and its hash equals the one from the zip

About
: google-walleye


<a id="floor-research-sh0-aop"></a>
### Research: who holds the SH0 x=1,y=3 sleep vote, and why the AOP does not ack QMP

Project
: linux-phone-oco/docs

Status
: done

Note
: Answered 2026-11-17-sh0-and-aop-research; decision 2026-11-17-sh0-owner-by-tag; phone items floor-sh0-owner, floor-sh0-qup-tags, floor-aop-qmp-no-ack.

Opened
: 2026-11-17

Needs
: research

Device
: xiaomi-surya

About
: deep-sleep


<a id="floor-sh0-owner"></a>
### Find who holds the SH0 x=1,y=3 sleep vote and drop it

Project
: linux-phone-oco/docs

Status
: open

Note
: Paused 2026-11-17 by decision 2026-11-17-floor-read-the-entry: read the entry first (floor-entry-trace), then decide whether the SH0 owner hunt resumes.

Opened
: 2026-11-17

Needs
: phone

Device
: xiaomi-surya

Proof
: soc-sleeps

Rank
: 15

About
: deep-sleep


<a id="floor-sh0-qup-tags"></a>
### If SH0 stays: the other TAG_ALWAYS QUP and crypto consumers, one per cycle

Project
: linux-phone-oco/docs

Status
: open

Note
: One-shot dtb per change: the serial toward SLAVE_LLCC (sm7150.dtsi ~1259), then the crypto engine (~460), then the rest of the QUP ALWAYS paths; each judged by the sleep-set flush and soc-sleeps. Skip when floor-sh0-owner removes SH0.

Opened
: 2026-11-17

Waits
: floor-sh0-owner

Needs
: phone

Device
: xiaomi-surya

Proof
: soc-sleeps

About
: deep-sleep


<a id="floor-aop-qmp-no-ack"></a>
### Why the AOP does not ack QMP sends (qcom_aoss_qmp c300000)

Project
: linux-phone-oco/docs

Status
: open

Note
: Lower rank (research 2026-11-17-sh0-and-aop-research: node equals sm8150/sc7180, serves only the aoss knobs, hypothesis 5). Read only: dump msgram descriptor and mailbox words (magic, version, mcore/ucore states, offset/size) before and after a send; count the AOP irq 389; trace aoss_send/aoss_send_done; whether the AOP changes the length word. Then one change at most. Not known yet: downstream irq-reg-base.

Opened
: 2026-11-17

Waits
: floor-sh0-owner

Needs
: phone

Device
: xiaomi-surya

Proof
: soc-sleeps

About
: deep-sleep


<a id="device-template-follow"></a>
### How a device repository takes later changes of device-template beyond idealkb's generic files

Project
: linux-phone-oco/docs

Status
: in-progress

Note
: Decided 2026-11-17 (idealkb decision 2026-11-17-chain-follow-by-slice): the same pin-and-follow slice as idealkb, not a fork, subtree or Copier. Done: device-template lists what it gives (generic) and ships idealkb and itself as upstreams in its base. Next: device-template releases (release-please) and idealkb's follow-source-from-pin (update-pins reading its source from the pin file); then surya-lab and google-walleye-lab follow it with move-device-rows. Improvements go back as upstream items (PRs). rhizoid's missing slice mode is on git-rhizoid's backlog (slice-consumption).

Opened
: 2026-11-17

About
: commons-only


<a id="walleye-control-on-slot-a"></a>
### The control boot.img again with slot a active (the state of the very first tries)

Project
: linux-phone-oco/google-walleye-lab

Status
: done

Note
: proven by devlab's before/after slot report and fastboot text: control refused (Load Error) on slot a; phone back on b

Opened
: 2026-11-17

Needs
: phone

Device
: google-walleye

Proof
: devlab's before/after slot report and the phone's full fastboot text for the control on slot a; then the phone back to current b, a recoverable

Rank
: 1

About
: walleye-first-fastboot-boot


<a id="walleye-first-fastboot-boot"></a>
### First fastboot boot of the walleye kernel: the phone leaves fastboot and its gadget answers

Project
: linux-phone-oco/google-walleye-lab

Status
: in-progress

Note
: Six images and the official LineageOS control all refused with Load Error: the cause is the phone's state or what fastboot boot needs, not our image (walleye-control-e-f-tries). A dtbo/vbmeta write stays the author's.

Opened
: 2026-11-17

Waits
: walleye-boot-refused-why (research), walleye-control-on-slot-a

Needs
: phone

Device
: google-walleye

Proof
: lsusb on the host shows the gadget within 60 s of fastboot boot and ssh/telnet to 172.16.42.1 answers (test: walleye-gadget-up)

About
: google-walleye


<a id="walleye-load-error-first-state"></a>
### Restore the first state: boot Android on slot a to completion, adb reboot bootloader, control once

Project
: linux-phone-oco/google-walleye-lab

Status
: done

Note
: proven by devlab fastboot state: control accepted from restored first state (walleye-first-state-control-accepted); after the author's power-cycle Android booted on slot a, adb reboot bootloader, fastboot reachable, slot a active and successful

Opened
: 2026-11-17

Needs
: phone

Device
: google-walleye

Proof
: devlab's before/after slot report (a successful yes before the try) and the fastboot text of the control try, accepted (phone leaves fastboot) or refused; the phone back on a bootable slot

Rank
: 1

About
: walleye-first-fastboot-boot


<a id="walleye-load-error-restart-host"></a>
### If refused: cold restart, then the same try on the same slot, with host checks

Project
: linux-phone-oco/google-walleye-lab

Status
: open

Note
: Only when the first-state try is refused. Power off fully (not fastboot reboot), start into the bootloader, record fastboot --version and that the phone is on a direct USB port; the control once; the phone back on its start slot.

Opened
: 2026-11-17

Waits
: walleye-load-error-first-state

Needs
: phone

Device
: google-walleye

Proof
: devlab's before/after slot report and the fastboot text of one control try after the cold restart, with the fastboot version and port in the log; the phone back on its start slot

About
: walleye-first-fastboot-boot


<a id="walleye-load-error-uart"></a>
### Read the bootloader's own reason for Load Error over the Android Debug Cable (UART)

Project
: linux-phone-oco/google-walleye-lab

Status
: open

Note
: The bootloader logs the reason to the serial console; the Nura wiki names the Pixel 2 Android Debug Cable. Hands needed; the phone itself is not changed.

Opened
: 2026-11-17

Waits
: the author's debug cable

Needs
: phone

Device
: google-walleye

Proof
: a captured serial log of one refused control try that names the failing step (LoadImageAndAuth, dtbo, vbmeta or other), attached to a research row

About
: walleye-first-fastboot-boot


<a id="walleye-boot-refused-why"></a>
### Why the Pixel 2's bootloader refuses even LineageOS's official boot.img from memory (Load Error), and what makes fastboot boot work on it

Project
: linux-phone-oco/google-walleye-lab

Status
: done

Note
: Answered in research walleye-boot-refused-why-how-it-stands and decision walleye-load-error-vector; next phone items: walleye-load-error-first-state, then walleye-load-error-restart-host, walleye-load-error-uart

Opened
: 2026-11-17

Needs
: research

Device
: google-walleye

Proof
: a research row naming the cause or the ranked causes with sources, and the next experiments each with its way back; consistent with the tries in walleye-control-e-f-tries

About
: walleye-first-fastboot-boot


<a id="walleye-own-images-first-state"></a>
### Our images e, then b, by fastboot boot from the first state (Android booted on slot a, then adb reboot bootloader)

Project
: linux-phone-oco/google-walleye-lab

Status
: done

Note
: proven by devlab fastboot boot now: e and b accepted from the first state, neither started, slot flags unchanged; see walleye-own-images-e-b-first-state

Opened
: 2026-11-17

Needs
: phone

Device
: google-walleye

Proof
: devlab's before/after slot report and the phone's full fastboot text for each; lsusb polling (by the manifest serial, not VID:PID: surya's gadget 18d1:d001 is on the same host) shows whether a Linux gadget of ours appears (lsusb on the host within 60 s, 172.16.42.1 answering: test walleye-gadget-up)

Rank
: 1

About
: walleye-first-fastboot-boot


<a id="fastboot-found-by-serial-or-port"></a>
### fastboot: a phone out of fastboot found by its serial or USB port, else gone from USB

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Done 2026-11-17 (lab-tools PR 81, f904196), asked by walleye-coordinator: after a boot try devlab took surya's postmarketOS gadget (18d1:d001) and a shared address for walleye's Linux while walleye had left USB. Now only a USB device carrying the phone's serial, or one on the USB port it sat on in fastboot (remembered at STATE/CODENAME/usb-port), answers for it; ping and vendor:product alone are gone; nothing found after three minutes is said as gone from USB, needing hands. Installed. Sign: walleye's manifest shares surya's USB address 172.16.42.1 - when Linux runs on both, devlab phone must tell them apart (by interface/port), not by address.

Opened
: 2026-11-17

About
: dl-safe


<a id="walleye-vendor-gadget-try"></a>
### fastboot boot the repacked control from the first state; does the gadget answer?

Project
: linux-phone-oco/google-walleye-lab

Status
: in-progress

Note
: tried twice, Load Error; gadget-up fails

Opened
: 2026-11-17

Waits
: walleye-vendor-gadget-image,walleye-gadget-up-check

Needs
: phone

Device
: google-walleye

Proof
: walleye-gadget-up passes (phone enumerates by serial, 172.16.43.1 answers) and the slot report shows what changed

About
: walleye-first-fastboot-boot


<a id="walleye-vendor-kernel-facts"></a>
### From the running vendor kernel, read the facts our dts guesses (read-only)

Project
: linux-phone-oco/google-walleye-lab

Status
: open

Note
: In the gadget shell: /proc/cmdline, /proc/iomem (ramoops, cont-splash framebuffer), /proc/device-tree qcom,msm-id/board-id/pmic-id, dmesg, dwc3/USB mode, regulators and clocks in use, /sys/fs/pstore, last_kmsg; copy out with the gadget network. Record as a research row with the files in material/.

Opened
: 2026-11-17

Waits
: walleye-vendor-gadget-try

Needs
: phone

Device
: google-walleye

Proof
: a research row walleye-vendor-kernel-facts with cmdline, ramoops region and ids, checked against the dts (test: walleye-gadget-up passes during the read)

About
: walleye-first-fastboot-boot


<a id="walleye-bootstrap-method"></a>
### The best-known way to bootstrap an Android phone to mainline almost from zero, compared with what the walleye lane did

Project
: linux-phone-oco/google-walleye-lab

Status
: done

Note
: Done 2026-11-17: research walleye-bootstrap-method-how-it-stands, decision 2026-11-17-walleye-vendor-kernel-first; next walleye-vendor-gadget-image, walleye-gadget-up-check, then walleye-vendor-gadget-try.

Opened
: 2026-11-17

Needs
: research

Device
: google-walleye

Proof
: a research row with sources, a comparison, a decision with what was rejected: landed

About
: google-walleye


<a id="floor-research-validity"></a>
### Research: is SH0 x=1,y=3 the blocker at all - counter validity, clocks/GDSC, late-suspend state

Project
: linux-phone-oco/docs

Status
: done

Note
: Answered by research 2026-11-17-floor-research-validity and decision 2026-11-17-floor-read-the-entry; phone items floor-entry-trace, floor-irq-quiet; build item suspend-irq-quiet-check.

Opened
: 2026-11-17

Needs
: research

Device
: xiaomi-surya

About
: deep-sleep


<a id="walleye-try-g-43"></a>
### Try image g (e at 172.16.43.1) by fastboot boot

Project
: linux-phone-oco/google-walleye-lab

Status
: open

Note
: g is e with the initramfs on 172.16.43.1; sha256 cc3cc1affad447e87ded0f20ebefe76c08e0dfa0270a797401513963b7f895a3 (~/Projects/walleye-build/images/SHA256SUMS). From the first state, devlab fastboot boot now ~/Projects/walleye-build/images/boot-g.img, watch 90 s. Same try as e; only the ramdisk address differs. No writes. Lower priority than the bisect s1-s3 (e and b never start, so g and h cannot differ from them until the bisect says why).

Opened
: 2026-11-17

Needs
: phone

Device
: google-walleye

Proof
: walleye-gadget-up: after devlab fastboot boot now IMAGE the phone leaves fastboot, lsusb shows our gadget (1d6b:0104, walleye-first-boot) within 60 s and 172.16.43.1 answers ping and telnet; devlab's before/after slot report and the fastboot text kept

About
: walleye-initramfs-usb-gadget


<a id="walleye-try-h-43"></a>
### Try image h (b at 172.16.43.1) by fastboot boot

Project
: linux-phone-oco/google-walleye-lab

Status
: open

Note
: h is b (LineageOS offsets) with the initramfs on 172.16.43.1; sha256 3090bbcdbb17bb8c719ee75560f06c9047804ac55d4a072a94b0b2eaf812ce19. After g; same steps. No writes. Also built, not queued: i = f at 172.16.43.1 (5fdcd4ca...bae0a4).

Opened
: 2026-11-17

Waits
: walleye-try-g-43

Needs
: phone

Device
: google-walleye

Proof
: walleye-gadget-up: after devlab fastboot boot now IMAGE the phone leaves fastboot, lsusb shows our gadget (1d6b:0104, walleye-first-boot) within 60 s and 172.16.43.1 answers ping and telnet; devlab's before/after slot report and the fastboot text kept

About
: walleye-initramfs-usb-gadget


<a id="walleye-initramfs-address-43"></a>
### walleye's gadget initramfs answers on 172.16.43.1, not surya's 172.16.42.1

Project
: linux-phone-oco/google-walleye-lab

Status
: done

Note
: Landed google-walleye-lab #8, #9 (main 4eb1a74). g=e, h=b, i=f with the ramdisk built NET=43; check-bootimg 22 ok each; a-f sha256 identical to before; QEMU selftest PASS at 42 and 43. Tries queued: walleye-try-g-43, walleye-try-h-43.

Opened
: 2026-11-17

Needs
: build

Device
: google-walleye

Proof
: images g and h (e and b with the initramfs address changed, nothing else) built, checked by the same check-bootimg, SHA256SUMS updated; images a-f byte-identical to before

About
: walleye-initramfs-usb-gadget


<a id="walleye-bisect-stock-to-ours"></a>
### Bisect from the accepted control to our image: stock kernel+dtb with our initramfs, then one part of ours at a time

Project
: linux-phone-oco/google-walleye-lab

Status
: done

Note
: Built and checked on the lab (google-walleye-lab #10, main 01f9138): ~/Projects/walleye-build/bisect/boot-s{0,0n,1,2,3}.img, SHA256SUMS there. s1 ramdisk=ours (172.16.43.1) 3f658748...; s2 kernel=ours as lz4 frame 0bb339b4...; s3 dtb=ours 14d95ef5...; extras s0 (stock parts repacked with footer, 859f0153...; differs from the control in 53 bytes: header id + footer digest) and s0n (no footer/padding, the shape of a-i, 46b575c7...). Try order for the keeper: s0n or s0 first only if the tool chain is in doubt, then s1, s2, s3. Differences stock vs ours: see build/README.md in the lab (no AVB footer/32 MiB pad, os word 0 vs 15.0.0/2026-11, gzip vs lz4 frame kernel, 51 KB dtb with no bootargs vs 376 KB with, cmdline, gzip vs xz ramdisk).

Opened
: 2026-11-17

Needs
: build

Device
: google-walleye

Proof
: images s1..s3 built by a script from control/boot.img's own parts (unpack_bootimg) with exactly one part swapped each, check-bootimg ok, hashes in SHA256SUMS; the keeper's tries then show which swap makes the bootloader stop at 'Booting OKAY'

About
: walleye-first-fastboot-boot


<a id="walleye-try-bisect-s1"></a>
### Try bisect image s1 (ramdisk = ours) by fastboot boot from the first state

Project
: linux-phone-oco/google-walleye-lab

Status
: done

Note
: no start, fell back to a; see walleye-try-s1-s2-s3

Opened
: 2026-11-17

Needs
: phone

Device
: google-walleye

Proof
: walleye-gadget-up for s1; for s2, s3, s0n: the phone leaves fastboot (starts) or stays at 'Booting OKAY', recorded

About
: walleye-first-fastboot-boot


<a id="walleye-try-bisect-s2"></a>
### Try bisect image s2 (kernel = ours (lz4 frame)) by fastboot boot from the first state

Project
: linux-phone-oco/google-walleye-lab

Status
: done

Note
: no start, fell back to a

Opened
: 2026-11-17

Needs
: phone

Device
: google-walleye

Proof
: walleye-gadget-up for s1; for s2, s3, s0n: the phone leaves fastboot (starts) or stays at 'Booting OKAY', recorded

About
: walleye-first-fastboot-boot


<a id="walleye-try-bisect-s3"></a>
### Try bisect image s3 (dtb = ours) by fastboot boot from the first state

Project
: linux-phone-oco/google-walleye-lab

Status
: done

Note
: accepted, not started, stays in fastboot

Opened
: 2026-11-17

Needs
: phone

Device
: google-walleye

Proof
: walleye-gadget-up for s1; for s2, s3, s0n: the phone leaves fastboot (starts) or stays at 'Booting OKAY', recorded

About
: walleye-first-fastboot-boot


<a id="walleye-try-bisect-s0n"></a>
### Try bisect image s0n (stock parts without AVB footer (control of the footer)) by fastboot boot from the first state

Project
: linux-phone-oco/google-walleye-lab

Status
: open

Note
: ~/Projects/walleye-build/bisect/boot-s0n.img (sha in bisect/SHA256SUMS); see walleye-bisect-stock-to-ours. Per try as walleye-own-images-first-state; answer = does the phone leave fastboot, and does 172.16.43.1 answer (s1). No writes.

Opened
: 2026-11-17

Needs
: phone

Device
: google-walleye

Proof
: walleye-gadget-up for s1; for s2, s3, s0n: the phone leaves fastboot (starts) or stays at 'Booting OKAY', recorded

About
: walleye-first-fastboot-boot


<a id="walleye-vendor-gadget-image"></a>
### Repack the control boot.img with our gadget initramfs (kernel, dtb, cmdline untouched)

Project
: linux-phone-oco/google-walleye-lab

Status
: done

Note
: Done: ~/Projects/walleye-build/images/vendor-gadget.img (= bisect s1), sha256 3f6587480d1f53fde918de8ebeef67641245e4ee7cbf9704e787075314f3b4e4, 44 bisect checks ok (lab #10, #11). Control header, os word 15.0.0/2026-11, cmdline and AVB footer kept; ramdisk ours at 172.16.43.1 (gzip). Next: walleye-vendor-gadget-try.

Opened
: 2026-11-17

Needs
: build

Device
: google-walleye

Proof
: check-bootimg counts the repack: kernel/dtb/cmdline/offsets byte-equal to the control, ramdisk is ours (test: walleye-vendor-gadget-image-built)

About
: walleye-first-fastboot-boot


<a id="walleye-gadget-up-check"></a>
### Write the failing check walleye-gadget-up in the lab's tests/health

Project
: linux-phone-oco/google-walleye-lab

Status
: done

Note
: Done: google-walleye-lab tests/host/gadget-up.sh (host-side: the phone cannot run it; GADGET_WAIT=90 waits). Finds the gadget by our strings (serial walleye-first-boot, product 'Pixel 2 walleye (mainline)'), not VID:PID nor the fastboot serial; then ping and telnet on the manifest address. Run with the phone in fastboot: 'fail ... no USB device with our gadget strings', exit 1.

Opened
: 2026-11-17

Needs
: build

Device
: google-walleye

Proof
: the check exists in google-walleye-lab/tests/health, runs, and fails with the phone in fastboot (test: walleye-gadget-up)

About
: walleye-first-fastboot-boot


<a id="floor-entry-trace"></a>
### Read the suspend entry: RSC sleep flush, last-CPU idle state, IRQ delta (no kernel change)

Project
: linux-phone-oco/docs

Status
: done

Note
: Decision 2026-11-17-floor-read-the-entry. One cycle: way-back.sh cycle 15 bt-on, watchdog armed (BT-blocked cycles reset). Before and after: /proc/interrupts, every cpuN/cpuidle/stateN usage+time, pm_genpd idle_states of the cluster domain, wakeup_sources, suspend_stats, all qcom_stats nodes. During: tracefs events rpmh (rpmh_send_msg), power:cpu_idle, power:suspend_resume. Record a research row with: (1) is rpmh_send_msg state=sleep written after the last CPU_PM_ENTER, and its addr/data list; (2) the last CPU's idle state; (3) interrupts/s by source over the 15 s. Proven by: soc-sleeps stays the failing test; this item is done when the research row holds those three facts (not known yet until then).

Opened
: 2026-11-17

Needs
: phone

Device
: xiaomi-surya

Proof
: soc-sleeps

Rank
: 1

About
: deep-sleep


<a id="floor-irq-quiet"></a>
### Silence what wakes the CPUs in suspend, one source per cycle

Project
: linux-phone-oco/docs

Status
: open

Note
: Only if floor-entry-trace shows interrupts through the cycle (Odin 2 was held by an SD-controller IRQ storm of ~30/s, armada#274). Take the top source from the delta, quiet it by a runtime step (driver unbind with the watchdog armed, or irq mask), one per cycle, judged by way-back.sh cycle 15 bt-on: the interrupt count falls and soc-sleeps is read again. Proven by: suspend-irq-quiet (below 50 interrupts in the suspended 15 s) passing, then soc-sleeps read.

Opened
: 2026-11-17

Waits
: floor-entry-trace

Needs
: phone

Device
: xiaomi-surya

Proof
: suspend-irq-quiet

About
: deep-sleep


<a id="suspend-irq-quiet-check"></a>
### Suite check suspend-irq-quiet: interrupts across one suspended cycle stay under a threshold (lab-tools)

Project
: linux-phone-oco/docs

Status
: open

Note
: A generic check in lab-tools health/suite/checks/ with its row in docs tests (ikb test): reads /proc/interrupts before and after one 15 s s2idle cycle and fails above the threshold, printing the top three sources. Fails today if floor-entry-trace shows a storm; threshold set from that reading, not guessed (not known yet).

Opened
: 2026-11-17

Needs
: build

Device
: xiaomi-surya

Proof
: suspend-irq-quiet

About
: deep-sleep


<a id="floor-research-aop-view"></a>
### Research: what the AOP sees on the sleep flush; standby current as the arbiter

Project
: linux-phone-oco/docs

Status
: done

Note
: Answered by research 2026-11-17-floor-aop-view-and-standby and decision 2026-11-17-standby-current-is-the-arbiter; phone items floor-genpd-rows-and-regulators, floor-usb-runtime-pm, floor-standby-current-cycle

Opened
: 2026-11-17

Needs
: research

Device
: xiaomi-surya

About
: deep-sleep


<a id="sleep-standby-current"></a>
### Standby current measured beside Android's

Project
: linux-phone-oco/docs

Status
: open

Note
: How much the floor saves, in milliamps: the fuel gauge's current over an hour asleep off USB (current_now and the charge counter, since they can disagree), on mainline and, as the number to match, on the phone's own Android or Ubuntu Touch - observed behaviour only. Proven by: a test standby-current entered in tests, passing under a threshold set from Android's measured number. Keeper 2026-11-17: cannot be taken without hands (the hour off USB); soc-sleeps also still fails, so a mainline number now is the not-at-floor one.

Opened
: 2026-11-17

Waits
: the author: unplug the phone from USB for an hour (devlab cannot cut USB power; on USB the phone stays awake); Android's number needs the phone booted into its own Android

Needs
: phone

Device
: xiaomi-surya

Proof
: soc-sleeps

About
: deep-sleep


<a id="floor-genpd-rows-and-regulators"></a>
### Read all power-domain idle_states rows and regulator_summary users across one way-back cycle 15 bt-on (read-only)

Project
: linux-phone-oco/docs

Status
: open

Note
: Settles why the cluster S2idle column is 0 (wrong row/domain or a path that did not count) and lists the rails that stay on in suspend. Write the output into the cycle log. Watchdog armed.

Opened
: 2026-11-17

Needs
: phone

Device
: xiaomi-surya

Proof
: soc-sleeps

About
: deep-sleep


<a id="floor-usb-runtime-pm"></a>
### Allow USB runtime PM (power/control auto on the HS PHY and the dwc3 controller) for one cycle and read counters and current

Project
: linux-phone-oco/docs

Status
: open

Note
: pmaports#4846: lowers draw slightly and keeps USB from holding CX. Needs the lab link to survive: keep the watchdog armed, one change per cycle.

Opened
: 2026-11-17

Needs
: phone

Device
: xiaomi-surya

Proof
: soc-sleeps

About
: deep-sleep


<a id="floor-standby-current-cycle"></a>
### Standby current: battery-only suspended cycle of 10 minutes, charge_counter delta over time

Project
: linux-phone-oco/docs

Status
: open

Note
: Needs the cable out for the window (the witness's hands) or the fuel gauge's discharge read while charging is held off; the RTC wakes the phone and the cycle log is read after. Pass: under 15 mA average; the number is recorded beside Droidian miatoll 9 mA. Same measure as sleep-standby-current.

Opened
: 2026-11-17

Needs
: phone

Device
: xiaomi-surya

Proof
: standby-current

About
: deep-sleep

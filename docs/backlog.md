<!-- Generated from data/ by tad. Do not edit by hand. -->

# Backlog

<a id="kernel-fork-repo"></a>
### Fork sm7150-mainline/linux into linux-phone-oco and wire it into the lab's build and boot route (devlab)

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
: The user's idea: a shared board for the org, like the one the retired lab-agent kept. Later.

Opened
: 2026-11-09


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
: done

Note
: 2026-11-18: built and released in lab-tools v0.4.1 (PR 125): lpoco-health suspend plan|cycle, manifest [health] suspend_guard (way back) + suspend_quiet, soc-sleeps reads the boot's cycle; 10 fixture tests of the verb + 3 of soc-sleeps. The phone cycle on surya (soc-sleeps skip to pass/fail) is surya-lab's queue: set suspend_quiet in surya's device.toml to the serial wakeup file, put the suite with lpoco lab suite put now, run lpoco-health suspend cycle --seconds 15.

Opened
: 2026-11-17

Needs
: build

Device
: xiaomi-surya

Proof
: fixture tests of the verb (plan with no phone, counters parsed before/after, refuses without a declared way back); then one cycle on surya through surya-lab's queue, the report's soc-sleeps turning from skip to pass or fail

Rank
: 1

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


<a id="commons-only"></a>
### docs holds only what helps every device; each device has its own open base; docs derives progress from them

Project
: linux-phone-oco/docs

Status
: in-progress

Note
: Both lanes record only in their own base (google-walleye-lab #15, surya-lab #136; docs #353, #360); docs pulls their parts daily (feed-device-bases, #355; surya's base named #361) and the face reads them. Left: derive-parts-in-base, about-across-bases, device-template-follow.

Opened
: 2026-11-17


<a id="feed-device-bases"></a>
### docs pulls each registered device base's parts over HTTPS in CI and derives support_status; stale or missing shows as not known yet

Project
: linux-phone-oco/docs

Status
: done

Note
: Landed. Surya: when its rows have moved to surya-lab (data/parts.json non-empty), run: tad r device-base --device xiaomi-surya --base linux-phone-oco/surya-lab in the same change; until then docs keeps typing/deriving its status.

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
: done

Note
: Both lanes moved: walleye (google-walleye-lab #15, docs #353) and surya (surya-lab, docs, 2026-11-17); rule: decision 2026-11-17-moving-a-lane.

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
: done

Note
: Done in the moves: the walleye and surya coordinator briefs, phone-keeper.md, the walleye-keeper/research/builder and surya-keeper/research launchers and the waker work in the lab repository and ask its base (phone-next, lane-next --needs, phone-stands; ikb to record); docs' lane-next stays for general rows (needs --device).

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
: done

Note
: devlab gather files into the lab's own base when it has a devicebase.toml (same test-run record; filed() and derivations from the lab; land lands the lab alone); --docs keeps the old path; the output says where it filed. lab-tools #82, devlab rebuilt into ~/.local/bin. Dry check on a scratch walleye base: run filed, test_runs/test_results rows present.

Opened
: 2026-11-17

Waits
: move-device-rows

About
: commons-only


<a id="device-template-follow"></a>
### How a device repository takes later changes of device-template beyond idealkb's generic files

Project
: linux-phone-oco/docs

Status
: in-progress

Note
: Route changed by decision 2026-11-18-device-layer-from-docs: device bases follow the device layer from docs (device-layer-in-docs), the template is a follower (template-follows-docs), the labs follow docs (surya-follows-template, walleye-follows-template). Proof: graph-drift.sh layer lines ok.

Opened
: 2026-11-17

About
: commons-only


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


<a id="bringup"></a>
### bringup: the host tool that makes a device's first boot images (boot image pack, unpack, swap, check; initramfs)

Project
: linux-phone-oco/lab-tools

Status
: open

Note
: Decided 2026-11-17 (decision 2026-11-17-bringup-in-lab-tools): lpoco-bringup, a workspace member of lab-tools run as 'lpoco bringup' under one roof - the lpoco dispatcher (lpoco-dispatcher), one pin, one release - Rust with argenv, wrapping mkbootimg/avbtool and crates for cpio, compression and dtb. Replaces walleye's eight build/check scripts; device facts in device.toml [boot]. Steps: lpoco-dispatcher, bringup-image-v0, -swap, -initramfs, -pin-and-hooks, -release, lpoco-rename-lab-tone, lpoco-mcp-one-door. Next: lpoco-dispatcher with bringup-image-v0.

Opened
: 2026-11-17

About
: bringup


<a id="bringup-image-v0"></a>
### bringup image info|unpack|pack|check for header v0, packed byte for byte as mkbootimg

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Landed in lab-tools PR 85 (https://github.com/linux-phone-oco/lab-tools/pull/85): crate lpoco-bringup (lib+bin, argenv, family version 0.1.7, release-plz version_group), image info|unpack|pack|check for header v0, [boot] from device.toml; proof bringup-pack-matches-mkbootimg green (pack equals mkbootimg byte for byte, check fails a wrong ramdisk offset and passes the right one). Decision 2026-11-17-bringup-image-header-layer. Next, own items: swap, initramfs, pin-and-hooks, release; the device template's [boot] table with CHANGE values.

Opened
: 2026-11-17

Needs
: build

Device
: google-walleye

Proof
: bringup-pack-matches-mkbootimg

About
: bringup


<a id="bringup-image-swap"></a>
### bringup image swap: one part of a control image replaced, the AVB hash footer kept, and what differs said

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Built and landed (lab-tools#110): lpoco-bringup image swap CONTROL --out IMG [--ramdisk|--kernel|--dtb|--cmdline]; proof bringup_swap_s0_reproduces_control passes. Bisect series and lz4 kernel are bringup-bisect-series.

Opened
: 2026-11-17

Blocked by
: bringup-image-v0

Needs
: build

Device
: google-walleye

Proof
: bringup-swap-s0-reproduces-control

Rank
: 8

About
: bringup


<a id="bringup-initramfs"></a>
### bringup initramfs build: a reproducible newc cpio, the gadget address as a variable, xz or gzip by the device

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Replaces build-initramfs.sh. Test: from the walleye spec (busybox, /init, udhcpd.conf, device nodes) the archive is byte for byte what the kernel's gen_init_cpio -t 0 makes, then compressed with the codec the device names (xz for the 4.4 kernel, gzip otherwise; fixed settings, same bytes twice). The NET=43 rewrite becomes a variable in the template (172.16.{net}.1, the ECM MAC byte) and a build that leaves the old address behind fails. Crates: cpio, flate2, xz2. The QEMU self-test stays shell until a second device needs it.
Done 2026-11-18: lab-tools #114 (lpoco-bringup initramfs build), byte-identical to gen_init_cpio -t 0 against the real oracle, 6+ tests, programmer-reviewed; built by lab-tools-builder, landed by orchestration once main was green again (release #113 added host's missing 0.3.5 changelog).

Opened
: 2026-11-17

Needs
: build

Device
: google-walleye

Proof
: bringup-cpio-matches-gen-init-cpio

Rank
: 9

About
: bringup


<a id="device-template-names-bringup"></a>
### The device template names bringup and ships a [boot] table in device.toml

Project
: linux-phone-oco/device-template

Status
: open

Note
: AGENTS.md says where a device's first-boot images are made (lab-tools bringup, followed by pin, never a scripts folder of its own, never an edit of the tool); device.toml gets [boot] in pmOS deviceinfo's words and [tools] bringup = pin, every value marked CHANGE; a bringup hooks folder with an example; data/upstreams.json seeded with a lab-tools upstream beside idealkb and device-template (tad q upstreams shows it); idealkb's update-pins learns the [tools] line. Proof: a fresh lab made from the template runs 'bringup image check' on a stock boot.img with the manifest alone, and the weekly pin bump opens a pull request when bringup releases.

Opened
: 2026-11-17

About
: bringup


<a id="bringup-pin-and-hooks"></a>
### bringup follows by pin and extends by hooks: [tools] version check, manifest-named step hooks, a library API a rust-script can use

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Landed in lab-tools PR 88 (squash on main). Proof bringup-refuses-wrong-pin: bringup/tests/pin_and_hooks.rs (pin refusal, matching pin, parts hook changes ramdisk, failing/missing hook stops) and rust_script_step.rs (rust-script example through the library); cargo test --workspace passed in CI. Library docs cover pack, check, pin, hooks; there is no swap yet (not built), so none is documented.

Opened
: 2026-11-17

Blocked by
: bringup-image-v0

Needs
: build

Device
: google-walleye

Proof
: bringup-refuses-wrong-pin

Rank
: 3

About
: bringup


<a id="bringup-release"></a>
### bringup is released by release-plz (a bringup-vX.Y.Z tag) and installs on a lab host from the tag

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Done: cargo install --git --tag per package, proven by bringup-installs-from-tag against 0.2.0 (lab-tools #90, read back from main f4e55b0).

Opened
: 2026-11-17

Blocked by
: lpoco-dispatcher

Needs
: build

Device
: google-walleye

Proof
: bringup-installs-from-tag

Rank
: 4

About
: bringup


<a id="derive-parts-in-base"></a>
### A device base derives its parts' measured fields from its own runs (a derive-parts record that devlab gather runs)

Project
: linux-phone-oco/device-template

Status
: open

Note
: After the move a device's runs are filed into its own base, while parts.measured/measured_run were derived by docs from docs' test_results (derive-support-status) and only seeded at the move. Without a derive in the base, parts.measured stays as seeded. Needs which test proves what of a part (docs' tests table is general): the base reads it, or carries the proof per test. devlab gather already runs every derive-* record of the place it files into.

Opened
: 2026-11-17

About
: commons-only


<a id="lab-tools-family-names"></a>
### devlab takes the family name (lpoco-...) when device repositories install it, keeping devlab as another name

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Superseded 2026-11-17 by the one-roof decision: the rename is lpoco-rename-lab-tone, behind lpoco-dispatcher.

Opened
: 2026-11-17

Waits
: devlab first pinned or installed by a device repository

About
: bringup


<a id="lpoco-dispatcher"></a>
### lpoco: the dispatcher - lpoco NAME runs lpoco-NAME, one version for the family, list and completions

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Landed in lab-tools PR 83 (https://github.com/linux-phone-oco/lab-tools/pull/83): lpoco NAME runs lpoco-NAME, refuses mixed versions, list/--version/completions/man from the argenv declaration, one family version (decision 2026-11-17-lpoco-family-version). Proof: tests lpoco_runs_subcommand_by_path, lpoco_refuses_mixed_versions in lpoco/tests/dispatch.rs. Next: lpoco-rename-lab-tone, bringup-image-v0.

Opened
: 2026-11-17

Needs
: build

Device
: google-walleye

Proof
: lpoco-runs-subcommand-by-path

About
: bringup


<a id="lpoco-rename-lab-tone"></a>
### devlab becomes lpoco-lab (lpoco lab), tone lpoco-tone; the old names stay as other names

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Landed in lab-tools #86: packages lpoco-lab and lpoco-tone, second [[bin]] keeps devlab and tone running the same code; one family version 0.1.7 (release-plz version_group). Proof lpoco-lab-and-devlab-are-one-program: devlab/tests/one_program.rs (identical --help and --version for both names; lpoco list shows lab, health, tone, bringup at one version). Next: sweep the ~450 references in small changes.

Opened
: 2026-11-17

Blocked by
: lpoco-dispatcher

Needs
: build

Device
: google-walleye

Proof
: lpoco-lab-and-devlab-are-one-program

Rank
: 1

About
: bringup


<a id="lpoco-mcp-one-door"></a>
### lpoco mcp: one MCP server for the family, every subcommand's tools under its name, old names kept

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: done: lab-tools#87; proof lpoco-mcp-lists-every-family-tool (lpoco/tests/mcp.rs) green; read back from main

Opened
: 2026-11-17

Blocked by
: lpoco-rename-lab-tone

Needs
: build

Device
: google-walleye

Proof
: lpoco-mcp-lists-every-family-tool

Rank
: 2

About
: bringup


<a id="docs-phone-items-to-lanes"></a>
### Open docs items that need a phone go onto that phone's own queue (its base), or say they wait for a phone

Project
: linux-phone-oco/docs

Status
: done

Note
: Done 2026-11-18 (orchestration-renewed): devlab-fastboot-boot-reads-slots, floor-dsps-never-started, floor-read-holders, floor-no-ignore-unused, mic-ucm-capture, microphone and sleep-measured-once are done; health-suspend-cycle keeps its build part (needs=build, rank 1) and its phone proof goes to surya-lab's queue through the surya coordinator.

Opened
: 2026-11-17

About
: commons-only


<a id="lpoco-lab-argenv"></a>
### lpoco-lab's command line declared once with argenv (devlab's clap moves over)

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: landed lab-tools #98 (a365eb2), read back from main; proof devlab/tests/help.rs. Left: declared env still read by std::env::var in flash/provision/watch/phone/hear/device (route through the contract); 'lpoco-lab help X' gone; tone still on clap.

Opened
: 2026-11-17

Needs
: build

Device
: google-walleye

Rank
: 2

About
: bringup


<a id="lpoco-names-sweep"></a>
### The old names (devlab, tone, devlab-health, the MCP tool names) swept to lpoco ones in small changes, the aliases kept until the sweep ends

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Left by lpoco-rename-lab-tone (lab-tools #86): ~450 references across AGENTS.md, READMEs, briefs, device.toml comments, launchers, devlab-watch@ units and scripts still say devlab or tone. Sweep one repository per change after lpoco-mcp-one-door lands; the second [[bin]] aliases go only when a grep across linux-phone-oco finds no old name in use.
Built with the programmer subagent's review (ideal-agent:programmer) before landing; nothing that needs the author's hands or a root rule change (the coordinator, 2026-11-18).
2026-11-18: slices landed and read back: lab-tools #99, #100; docs #400; device-template #12; surya-lab #166 (9 files, the lane's yes); google-walleye-lab #100 (10 files, the lane's yes). Left, staying as they are on purpose: history rows and research; the keeper-run and try/build scripts in both labs (the lanes said no); lab host files and devlab-watch@ (the lab's, through lpoco-host). Left to build: lab-tools' own source strings and comments (~340 refs) and lpoco lab mcp --help ('devlab's door'). The devlab and tone aliases stay while the scripts call them.
Done 2026-11-18 (orchestration): lab-tools #104 made the messages tell the reader to type lpoco-lab (kept so by a test). What still says devlab in lab-tools stays on purpose: internal names - temp dirs, the 10-devlab.preset file written onto phones (renaming it changes phone state), the ~/.config/devlab and state paths, DEVLAB_* variables; 78 source comments; the README line 'devlab's door'. Count on main at 44a3948: 44 strings, 78 comments, none of them a command a reader types. The devlab and tone aliases stay while the lanes' scripts call them. Removing the aliases is its own item, when a grep finds no caller.

Opened
: 2026-11-17

Needs
: build

Device
: google-walleye

Rank
: 6

About
: bringup


<a id="devlab-tone-on-argenv"></a>
### devlab and tone declare their command lines with argenv, not clap

Project
: linux-phone-oco/lab-tools

Status
: open

Note
: Practice 43: a program on clap moves to argenv when it is next changed; devlab changed 2026-11-17 (lab-tools 71, 72, 79, 80, 81) and still parses with clap, as does tone; lpoco-health already moved. Each subcommand and env var (DEVLAB_ROOT, LAB_AGENT, --device) declared once; completions and man from the declaration; behaviour unchanged, the 59 devlab tests and the guard's still pass. Write it through ideal-agent's programmer subagent (write-code-by-the-canon), reviewed before land. Orchestration's.

Opened
: 2026-11-17

About
: dl-reaches


<a id="lpoco-host"></a>
### lpoco host: the lab host prepared from the lab's and each device's declarations - udev access for gadget serials, host modules, the host's own tools at their pins; plan by default, prepare now to change

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Done 2026-11-18 (orchestration-renewed): both acceptance halves passed on walleye as the lab user, no root. Block: walleye lab PR 70. Tty: walleye lab PR 182 - banner2 from slot b, gadget 1d6b:0104 SerialNumber walleye-first-boot (kernel log 10:26:47 CET), /dev/ttyACM0 root:users 0660 with the uaccess ACL, a plain cat read 2805 bytes, 29 WALLEYE-BANNER lines, banner-check passed. It took lpoco 0.6.0's gadget_group (lab-tools #129, lab-machine #48) and the banner image writing its declared serial (the earlier walleye-banner serial never matched the rule; lpoco host check names such a serial since 0.6.1, #131). The rest of the host stays on lpoco-host-rest.

Opened
: 2026-11-17

Waits
: the tty half of the acceptance: walleye's pk5l (the mainline ACM shell; on the vendor kernel the ACM console is parked, decision 2026-11-17-walleye-ffs-console-parked), then the walleye keeper opens /dev/ttyACM0 as the lab user

Device
: google-walleye

Proof
: host/tests/plan.rs plan_grants_gadget_serial_and_changes_nothing (first, failing); then plan_lists_host_tools_at_pins_and_installs_nothing; acceptance: lpoco host prepare now on the lab, then the walleye keeper reads /dev/sda and /dev/ttyACM0 as the lab user

About
: lpoco-host


<a id="lpoco-host-rest"></a>
### lpoco host, the rest: lab group for headless, watcher units, cross targets, host commands, foreign rules named, NCM

Project
: linux-phone-oco/lab-tools

Status
: open

Note
: 2026-11-18, lab-tools-builder: part (2b) done (lab-tools #146, main 9b0cd88): an enabled devlab-watch@ unit that is not running (systemctl --user is-active exits 3) is started by prepare; plan names it. Proof: host/tests/plan.rs an_enabled_but_stopped_watcher_is_started_and_a_running_one_is_left (seen failing first). Open: a probe that cannot run proposes nothing, silently. 2026-11-18, lab-tools-builder: part (6b) done (lab-tools #144, main 74c8b29): device.toml [[host.gadget]] net_address = "a.b.c.d/n" (IPv4 CIDR, needs net_name; a net_name twice in one device refused) adds the host's address on the phone's USB net as a link config for the manager the host runs, detected from /run: NetworkManager keyfile /etc/NetworkManager/system-connections/NAME.nmconnection (mode 0600, then nmcli connection reload) when /run/NetworkManager exists, else systemd-networkd /etc/systemd/network/70-NAME.network (then networkctl reload) when /run/systemd/netif exists, else plan names that none runs and writes nothing. Planned in the diff, written only by prepare now. Proof: host/tests/plan.rs a_named_usb_network_gets_the_hosts_link_config_in_the_format_of_the_manager_it_runs_and_only_with_the_verb (seen failing first: unknown field net_address). Limits: the NM directory is root-only, so an existing keyfile is unreadable to the lab user and is rewritten at each prepare (same content); manager and mode are inferred from the destination prefix in root_commands/file_mode, not carried on FileChange (reviewer's tidy-up). Earlier: parts (2),(3),(4),(5),(6 stable name) done (#133,#140,#138,#136,#142). Open: lab group for headless (lab.toml gadget_group exists, not defaulted); a linked but stopped devlab-watch@ unit is not restarted; lab-machine setup/devlab-watch.sh to remove once prepare ran on the lab; health/build.sh could read targets from the declaration; devlab could use the stable name/address once a device declares one; no device declares net_address yet, so no lab proof on a phone.

Opened
: 2026-11-17

Needs
: build

Device
: xiaomi-surya

Proof
: per part, a plan test from fixtures that lists it and changes nothing without the verb; this run: part (2), devlab-watch@ user units planned for every device found, lab-machine setup/devlab-watch.sh named as replaced

Rank
: 9

About
: lpoco-host


<a id="lpoco-host-help"></a>
### lpoco-host --help prints its usage (argenv), as ikb and land do

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Landed in lab-tools #93, released as lpoco-v0.2.2: --help and -h print the usage (arguments and environment read from the argenv declaration) in lpoco, lpoco-host, lpoco-bringup, lpoco-health; lpoco-tone and devlab already did (clap). Proof: help_prints_the_usage_and_exits_0 in each crate's tests/help.rs, failing first. Unblocks the lpoco-host acceptance: install 0.2.2.

Opened
: 2026-11-17

Needs
: build

Device
: google-walleye

Proof
: lpoco-host-help-prints-usage

Rank
: 1

About
: bringup


<a id="lpoco-host-script-tools"></a>
### lpoco host finds script tools (land, agent-env, oco-work) by rev and says what it found, and the devices glob takes a list

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Seen writing lab.toml (lab-machine #36): plan says land 'found not found' and oco-work 'not installed' though both are in ~/.local/bin, since scripts print no --version and a script pin needs version (0.1.0 set as a label, rev is the real pin), so check fails for both. devices is one glob, so the clones are named [gs]*-lab. The land pin clones the private grenudi/lab-machine over https, which needs credentials. Failing test first: a fixture script tool pinned by rev is found on PATH and judged by its rev (a stamp the install writes, or the content hash), not by --version; devices accepts a list. Or land and agent-env learn --version (owners: lab-machine, ideal-agent).
Also (2026-11-17, orchestration): plan read the shared google-walleye-lab clone, detached at an old commit without [host], and so planned no udev rule at all. A device declaration read from a working clone drifts with that clone; read it from the repository's origin/main (git show after a fetch), or say which commit was read and how far it is behind.
Also: the off-the-pin advice for devlab and tone says to put ~/.cargo/bin before ~/.local/bin, but lpoco-host installs the family with --root ~/.local, so the advice should say to reinstall into ~/.local and remove any copy that shadows it.
Done 2026-11-18 (lab-tools #95, read back): script tools are judged by a rev stamp (~/.local/share/lpoco-host/rev-NAME, written by prepare now), not by --version; devices takes a list of globs; the off-the-pin advice says to reinstall into ~/.local. Proof host/tests/plan.rs. Left over: lpoco-host-reads-origin-main; the land pin clones the private grenudi/lab-machine over https and needs credentials. (Status set by orchestration: docs #393 meant to set done but landed without it.)

Opened
: 2026-11-17

Needs
: build

Device
: google-walleye

Proof
: lpoco-host-finds-script-tools

Rank
: 1

About
: bringup


<a id="lab-devlab-to-pin"></a>
### The lab's devlab (and tone) move from 0.1.0 in ~/.local/bin to the family pin 0.2.1, between surya keeper runs

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Done 2026-11-17 23:12 in the surya lane's window (keeper idle, lease released): the 0.1.0 copy is kept as ~/.local/bin/devlab-0.1.0; lpoco-lab and lpoco-tone are cargo-installed at lpoco-v0.2.1 with --root ~/.local; devlab-watch@surya-lab was restarted and is active; lpoco host check shows devlab, tone and the family at 0.2.1 (agent-env and land still FAIL: lpoco-host-script-tools). devlab --version now prints lpoco-lab 0.2.1. cargo warns that devlab/src/main.rs and tone/src/main.rs are each in two bin targets; harmless, gone when lpoco-names-sweep ends the aliases.

Opened
: 2026-11-17

About
: bringup


<a id="lpoco-host-reads-origin-main"></a>
### lpoco host reads each device declaration from origin/main, or names the commit read and how far behind it is

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Landed lab-tools #108 (15c7a7c), released v0.3.4. Proof: host test reads_each_device_from_origin_main_and_names_how_far_behind (seen failing first). version of script tools documented as label only.

Opened
: 2026-11-18

Needs
: build

Device
: google-walleye

Proof
: lpoco-host-reads-device-from-origin-main

Rank
: 7

About
: bringup


<a id="lpoco-tone-argenv"></a>
### lpoco-tone's command line declared once with argenv (the last clap in the family)

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Landed in lab-tools #101, released in v0.3.1 (#97). Proof lpoco-tone-help-from-argenv: lab-tools tone/tests/help.rs, red first, 5 tests pass; programmer review fixed (out-of-range/zero rate and channels).

Opened
: 2026-11-18

Needs
: build

Device
: google-walleye

Proof
: lpoco-tone-help-from-argenv

Rank
: 4

About
: bringup


<a id="lpoco-lab-env-through-argenv"></a>
### lpoco-lab reads its declared environment through the argenv contract, not std::env::var

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Landed in lab-tools #103 (fd1163d): the five declared env vars are read once in cli.rs; proof lpoco-lab-env-read-once seen failing, then green. Known: a non-UTF-8 HOME counts as unset; empty DEVLAB_ROOT exits 2 for every command.

Opened
: 2026-11-18

Needs
: build

Device
: google-walleye

Proof
: lpoco-lab-env-read-once

Rank
: 5

About
: bringup


<a id="suspend-irq-quiet-check"></a>
### Suite check suspend-irq-quiet: interrupts across one suspended cycle stay under a threshold

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: From surya-lab's backlog (floor research; the surya coordinator asked orchestration's builder, 2026-11-18). A generic check in lab-tools health/suite/checks/ with its row in docs tests (ikb test): reads /proc/interrupts before and after one 15 s s2idle cycle and fails above the threshold, printing the top three sources. The threshold comes from the manifest's [health] (set from floor-entry-trace's reading); unset, the check says not measured, never a guessed number. It suspends only with an RTC wake alarm set and the watchdog armed (phone-keeper.md's rule, surya-lab log 2026-11-18-sign-defused-watchdog); if either cannot be had, it skips saying why. The builder writes and tests it off the phone; putting it on the phone is the keeper's.
Built 2026-11-18: lab-tools #106 (v0.3.3), proof health/tests/suspend_irq_quiet.rs, made-up files only, not run on a phone. Left for the surya keeper: set suspend_irq_max (from floor-entry-trace) and suspend_guard (the way-back.sh check command) in surya's [health] and put the check on the phone; until both are set it skips. (Status set by orchestration: #412 meant to set done, but ikb backlog-status with --project linux-phone-oco/lab-tools matched no row and said nothing; the record now refuses that.)

Opened
: 2026-11-18

Needs
: build

Device
: xiaomi-surya

Proof
: suspend-irq-quiet

Rank
: 5

About
: deep-sleep


<a id="bringup-bisect-series"></a>
### bringup bisect FILE: a declared series of swaps (walleye's s0, s0n, s1, s2, s3), and the lz4 frame kernel part

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Built and landed (lab-tools#123, 0bb6fdf on main): lpoco-bringup image bisect SERIES --out DIR; a TOML series (control, [[image]] name/kernel/dtb/ramdisk/cmdline/lz4/footer), each image counted against the control; proof bringup_bisect_runs_declared_series passes. Not done: walleye's own series file and retiring build-bisect.sh/check-bisect.sh in google-walleye-lab (walleye side); a real stock control not yet run through it; the family release follows release-plz.

Opened
: 2026-11-18

Needs
: build

Device
: google-walleye

Proof
: bringup-bisect-runs-declared-series

About
: bringup


<a id="release-plz-one-version"></a>
### Every release of the lpoco family bumps the version and tags what landed: no changelog-only release under an existing version

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: landed lab-tools #116 and #119; proof: release-tags-every-change, release_plz_ignores_its_own_release_commits (lpoco/tests/release_family.rs). release-plz.toml release_commits lists feat|fix|perf|refactor|docs|test|build|ci, so its own 'chore: release' commit opens no next release PR. Main's changelog test was green again after #117. Not yet seen live: release PR #118 (v0.3.7, opened before the fix) is still open and unmerged; after it merges no further release PR should open - the orchestration reads that back.
Live read-back 2026-11-18 (orchestration): landed release #118 (v0.3.7), then its follow-up #120. Main CI green after #120, and no release PR open 3 minutes later. The loop is gone (#119). The split is not: #118 again left bringup and host changelogs to a follow-up, and main was red between the two. Queued as release-plz-one-pr.

Opened
: 2026-11-18

Needs
: build

Device
: google-walleye

Proof
: release-tags-every-change

Rank
: 1

About
: bringup


<a id="release-plz-one-pr"></a>
### A family release is one release PR that writes every member's changelog; main never red between two

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: landed lab-tools#121; proof test a_release_where_one_member_changed_writes_every_changelog. Next release PR is the real read-back.

Opened
: 2026-11-18

Needs
: build

Device
: google-walleye

Proof
: release-pr-writes-every-changelog

Rank
: 1

About
: bringup


<a id="host-lab-toml-from-main"></a>
### lpoco host reads lab.toml from lab-machine's origin/main, as it reads each device.toml

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Done 2026-11-18: lab-tools #127 (released v0.5.0, #128). lpoco host reads lab.toml through the same declared_text as device.toml: origin/main, rev named, differing working file ignored. Proof: host/tests/plan.rs reads_lab_toml_from_origin_main_and_ignores_a_working_file_that_differs (seen failing on 0.4.0 pins, then passing; 12 plan tests pass).

Opened
: 2026-11-18

Needs
: build

Device
: xiaomi-surya

Proof
: a plan test from a fixture clone whose working lab.toml is behind origin/main: the plan reads origin/main's pins and says which rev it read, the working file ignored

Rank
: 1

About
: lpoco-host


<a id="host-gadget-group"></a>
### lpoco host gives each declared gadget node a group the lab user already holds, so access does not wait on the seat's uaccess ACL

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Landed in lab-tools PR 129 (main 6530e82): lab.toml gadget_group adds GROUP and MODE 0660 to each gadget rule line; check says the group and that the lab user is in it (list or primary gid). Proof: host/tests/plan.rs rule-line, check and primary-gid tests, seen failing first. Next: release (release-plz PR not open yet), then add gadget_group = "users" to lab-machine/lab.toml (its owner) and run lpoco host prepare now; then walleye's next z try reads /dev/ttyACM0 as the lab user.

Opened
: 2026-11-18

Needs
: build

Device
: google-walleye

Proof
: a plan test from fixtures: the rule line carries GROUP and MODE 0660 from lab.toml beside TAG+=uaccess; check says which group and that the lab user is in it; then walleye's next z try reads /dev/ttyACM0 as the lab user (walleye lab's queue)

Rank
: 2

About
: lpoco-host


<a id="host-undeclared-gadget-serial"></a>
### lpoco host check names a gadget that enumerated with a serial no device declares

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Done in lpoco-host 0.6.1 (lab-tools PR 131/132): proof tests check_names_a_gadget_that_enumerated_with_a_serial_no_device_declares and check_does_not_report_a_gadget_whose_serial_a_device_declares. Not yet run on the lab against a live log; pin the lab to 0.6.1 by prepare now.

Opened
: 2026-11-18

Needs
: build

Device
: google-walleye

Proof
: a check test from a fixture kernel log: a 1d6b gadget with SerialNumber walleye-banner while device.toml declares walleye-first-boot is reported (device, serial seen, serial declared, when); a declared one is not

Rank
: 1

About
: lpoco-host


<a id="host-watch-declared"></a>
### lpoco host watches only the devices whose device.toml asks to be watched

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Landed lab-tools #135, released v0.7.0 (#134), read back from main. Open for others: surya-lab device.toml needs [host] watch = true before the lab's prepare.

Opened
: 2026-11-18

Needs
: build

Device
: google-walleye

Proof
: a plan test from fixtures: a device with [host] watch = true gets its devlab-watch@ instance enabled; one without it gets none, and an enabled instance of a device that no longer asks is named in the plan (never stopped silently); surya-lab's device.toml declaring watch = true is the lane's change, read from origin/main

Rank
: 1

About
: lpoco-host


<a id="phone-side-pieces"></a>
### Phone-side pieces under the roof: carried by the lab-tools package, named by token in device.toml, a stale copy named by lpoco host check

Project
: linux-phone-oco/lab-tools

Status
: open

Note
: Decision 2026-11-18-phone-side-pieces-under-the-roof. Steps: phone-pieces-drift-named (its failing test first), health-reports-pieces, lpoco-awake; then surya-awake-from-package on the phone. The manifest's one schema is manifest-one-schema (decision 2026-11-18-device-manifest-schema-from-rust).

Opened
: 2026-11-18

Needs
: build

Device
: xiaomi-surya

Proof
: host/tests/phone_pieces.rs check_names_a_stale_phone_piece and check_names_a_package_off_its_pin_and_passes_a_current_phone pass; acceptance: on the lab, lpoco host check names no stale piece of surya while surya holds the wake lock from the package, with no /usr/local/bin/devlab-usb-awake

About
: dt-any-phone


<a id="phone-pieces-drift-named"></a>
### lpoco host check names a stale phone-side piece, from the phone's last gathered report

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Landed in lab-tools PR 165 (7b4a36a): lpoco host check names a stale or missing phone-side piece and a package off the pin, from the device's newest tests/results/*.jsonl at origin/main. Proof: host/tests/phone_pieces.rs (3 tests, seen failing first, now pass). Not built: lpoco lab naming the same at every change's end - see phone-pieces-drift-in-lab.

Opened
: 2026-11-18

Needs
: build

Device
: xiaomi-surya

Proof
: host/tests/phone_pieces.rs check_names_a_stale_phone_piece, check_names_a_package_off_its_pin_and_passes_a_current_phone (to write, failing first)

Rank
: 6

About
: phone-side-pieces


<a id="health-reports-pieces"></a>
### lpoco-health reports what lab pieces the phone holds: each package's version and each declared file's git blob id

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Done: lab-tools PR 150 (feat(health): lab-pieces check reports each declared file's blob id and package version), read back from main; released with the family after 0.12.1. The phone's report is proven once surya-awake-from-package puts the suite on surya. Next: phone-pieces-drift-named reads it.

Opened
: 2026-11-18

Needs
: build

Device
: xiaomi-surya

Proof
: health/tests/pieces_report.rs under LPOCO_HEALTH_ROOT: a made-up phone with one declared file and one package reports both rows with the blob id git hash-object gives for that file (to write)

Rank
: 5

About
: phone-side-pieces


<a id="lpoco-awake"></a>
### The lab phone's keep-awake as lpoco-health awake: a unit in the package, gates named by device.toml, its generic check

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Landed lab-tools PR 148 (3ac4c46): lpoco-health awake [--once], unit lpoco-awake.service and check 93-awake.sh in the package, [health] awake_gates in devlab. Proof health/tests/awake.rs (4 tests, seen failing first). Not yet on a phone: surya-awake-from-package enables the unit, retires the hand copy and moves /etc/devlab-allow-autosleep to /etc/lpoco/allow-autosleep; suite put does not enable the unit. Release PR from release-plz not seen yet.

Opened
: 2026-11-18

Needs
: build

Device
: xiaomi-surya

Proof
: health/tests/awake.rs under LPOCO_HEALTH_ROOT: the lock written always; with allow-autosleep, released when the UDC state is not configured and held again when the gate reports unsafe (to write); acceptance: surya-awake-from-package

Rank
: 4

About
: phone-side-pieces


<a id="manifest-one-schema"></a>
### device.toml declared once in Rust: one manifest crate all lpoco programs read, unknown fields refused everywhere, its JSON Schema projected per release

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: 2026-11-18, lab-tools-builder: done (lab-tools #179, main 20e99da). lpoco-manifest crate holds device.toml's types once, deny_unknown_fields everywhere; devlab Device::parse, host parse_device and Boot::parse read it; draft-07 schema projected to manifest/device.schema.json (lpoco-manifest schema). Proof: manifest/tests/schema.rs a_misspelled_table_is_refused (seen failing first against devlab's Device), schema_is_current, every_lab_manifest_validates (surya, walleye, template fixtures). Review follow-ups, open: validate fixtures against the schema with a draft-07 validator; schema marks device/connection optional but devlab requires them; fixtures are copies that drift from the lab repos (read the real ones in CI); host::parse_device still re-reads values by hand and bringup/src/pin.rs reads [tools] loosely; manifest/CHANGELOG.md is hand-written; device-template file with every field's doc beside it not made.

Opened
: 2026-11-18

Needs
: build

Device
: xiaomi-surya

Proof
: manifest/tests/schema.rs a_misspelled_table_is_refused ([[flash.overlays]] refused - fails against today's devlab Device), schema_is_current (the committed schema equals the projection), every_lab_manifest_validates (surya, walleye and template fixtures) (to write, the first failing first)

Rank
: 7

About
: phone-side-pieces


<a id="bringup-generic-init"></a>
### The bring-up init under lpoco bringup: configfs gadget (ECM, ACM, mass storage window), DHCP, shell and the FunctionFS ACM console, from the device's data

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Done (orchestration, 2026-11-19): the generic init is shipped in seven slices - lab-tools #183, #185, #186, #188, #190, #192, #195 (released through v0.21.0): [boot.gadget] init and files, the read-only log window, ShellWord, lpoco-ffs-acm (MIT OR Apache-2.0 on the author's word) and console = "ffs". Walleye's selftest-initramfs.sh passed with the generated init in a scratch copy. The adoption is walleye-init-from-roof (walleye's lane); the lab-tools leftovers are bringup-init-finish.

Opened
: 2026-11-18

Needs
: build

Device
: google-walleye

Proof
: google-walleye-lab build/selftest-initramfs.sh (QEMU, dummy_hcd) passes with the init lpoco bringup makes from walleye's device.toml and none of walleye's own init files (to adapt)

Rank
: 8

About
: phone-side-pieces


<a id="surya-awake-from-package"></a>
### surya keeps awake by the package's lpoco-awake: the hand copy and its overlay gone

Project
: linux-phone-oco/surya-lab

Status
: open

Note
: By the keeper: suite put brings the package with the awake unit; disable devlab-usb-awake.service, remove /usr/local/bin/devlab-usb-awake and its unit; surya-lab drops the two [[flash.overlay]] entries, the enable entry and tests/health/base/autosleep-off.sh in the same change.

Opened
: 2026-11-18

Blocked by
: lpoco-awake

Needs
: phone

Device
: xiaomi-surya

Proof
: the generic awake check passes across a reboot, lpoco host check names no stale piece of surya, and no suspend loop for an hour on USB (dmesg PM: suspend entry count 0)

About
: phone-side-pieces


<a id="surya-manifest-schema"></a>
### surya's device.toml names the pinned schema and its CI checks it

Project
: linux-phone-oco/surya-lab

Status
: open

Note
: One #:schema line at the top, pinned to the lpoco release surya follows; a CI step validates (lpoco lab manifest check or taplo lint).

Opened
: 2026-11-18

Blocked by
: manifest-one-schema

Needs
: build

Device
: xiaomi-surya

Proof
: surya-lab CI fails a branch whose device.toml misspells a table, and passes main

About
: phone-side-pieces


<a id="walleye-manifest-schema"></a>
### walleye's device.toml names the pinned schema and its CI checks it

Project
: linux-phone-oco/google-walleye-lab

Status
: open

Note
: As surya-manifest-schema.

Opened
: 2026-11-18

Blocked by
: manifest-one-schema

Needs
: build

Device
: google-walleye

Proof
: google-walleye-lab CI fails a branch whose device.toml misspells a table, and passes main

About
: phone-side-pieces


<a id="walleye-init-from-roof"></a>
### walleye's boot images take the init lpoco bringup makes; its own init variants retire

Project
: linux-phone-oco/google-walleye-lab

Status
: open

Note
: Its gadget serial, address and functions move to device.toml [boot]; build/initramfs*/ and build/ffs-acm* stay in history.

Opened
: 2026-11-18

Blocked by
: bringup-generic-init

Needs
: build

Device
: google-walleye

Proof
: build/selftest-initramfs.sh passes with the roof's init; the next keeper boot shows the gadget serial walleye-first-boot

About
: phone-side-pieces


<a id="template-manifest-schema"></a>
### The template's device.toml is the generated one, naming the pinned schema, and its CI checks it

Project
: linux-phone-oco/device-template

Status
: open

Note
: A new phone's lab then gets completion, hover and the check from its first commit; the header's claim that unknown fields are refused becomes true.

Opened
: 2026-11-18

Blocked by
: manifest-one-schema

Needs
: build

Device
: google-walleye

Proof
: device-template CI validates device.toml against the schema of the pinned release

About
: phone-side-pieces


<a id="device-template-idealkb-0-14"></a>
### device-template follows idealkb 0.14.0 (pinned at 0.9.1)

Project
: linux-phone-oco/device-template

Status
: done

Note
: Done 2026-11-18: device-template main pins idealkb 0.14.0 (PR #17, build: ideal-knowledge-base 0.14.0, landed by the idealkb update-pins run while this item was in work; read back: idealkb.toml version 0.14.0, installer pins ikb 0.6.1, tad and check workflows green on 7a49c83, make verify passes twice with nothing rewritten). tables.toml already had the 0.14 fields; only its generic-part comments differ from 0.14.0's, left as the base's own. PR #16 (the same bump, left open by update-pins as 'base changed a generic file') is superseded and still open.

Opened
: 2026-11-18

Needs
: build

Device
: google-walleye

Proof
: idealkb.toml pins 0.14.0 and the base's verify (tad check, make verify) passes on main


<a id="surya-lab-idealkb-0-14"></a>
### surya-lab follows idealkb 0.14.0 (pinned at 0.9.1)

Project
: linux-phone-oco/surya-lab

Status
: done

Note
: Done by idealkb's update-pins: surya-lab PR 221 (build: ideal-knowledge-base 0.14.0) merged; 220 closed as superseded.

Opened
: 2026-11-18

Needs
: build

Device
: xiaomi-surya

Proof
: idealkb.toml pins 0.14.0 and the base's verify (tad check, make verify) passes on main


<a id="google-walleye-lab-idealkb-0-14"></a>
### google-walleye-lab follows idealkb 0.14.0 (pinned at 0.9.1)

Project
: linux-phone-oco/google-walleye-lab

Status
: done

Note
: Done by idealkb's update-pins: google-walleye-lab PR 213 (build: ideal-knowledge-base 0.14.0) merged; 212 closed as superseded.

Opened
: 2026-11-18

Needs
: build

Device
: google-walleye

Proof
: idealkb.toml pins 0.14.0 and the base's verify (tad check, make verify) passes on main


<a id="upstream-forks"></a>
### Our own forks of each upstream we patch: fixes worked and proven there, carried until upstream takes them, mailed as working patches by the author

Project
: linux-phone-oco/docs

Status
: in-progress

Note
: Decision 2026-11-18-upstream-forks. Forks live under grenudi (grenudi/sxmo-utils, grenudi/linux; transferred from the org); three fixes written on topic branches (sxmo series of 3, kernel RFC series of 4), each waiting on its phone proof; the author's word on each mail.

Opened
: 2026-11-18


<a id="upstreams-lane"></a>
### Start the upstreams lane: one lane coordinator for the forks and every outgoing series

Project
: linux-phone-oco/docs

Status
: in-progress

Note
: Lane coordinator upstreams-coordinator started 2026-11-18. Forks: grenudi/sxmo-utils (mirror of sr.ht ~mil/sxmo-utils), grenudi/linux (fork of sm7150-mainline/linux). Where each series stands: sxmo series of 3 (lab 6432ef9, tagged lab-20261118.1 for the apk) - apk asked of orchestration (lab-tools sxmo-utils-lab-apk), then surya-lab surya-sxmo-suspend-series; kernel RFC of 4 (grenudi/linux topic/pmic-wdt-wake-in-suspend e123d3bff) - surya-lab surya-kernel-pmic-wdt then surya-pmic-wdt-proof (also blocked by surya-unreachable-after-try4), google-walleye-lab walleye-kernel-pmic-wdt then walleye-pmic-wdt-proof; both asked of surya-coordinator and walleye-coordinator. Retired: deviceprofile/xiaomi-surya deleted on the fork (its profile files equal upstream 1fd7822). Not done: the fork's master is 303c755, behind upstream 1fd7822 (a push to master is refused by the guard; left to orchestration). Next: on each proof's pass, prepare the exact send (format-patch, cover letter, get_maintainer; kernel with Assisted-by: LLM and the author's Signed-off-by) for the author's word through the Top Coordinator. 2026-11-18 walleye (google-walleye-lab PR 236, image z9): the PMIC watchdog bit 20 s after arming, but the bite powered the phone off rather than restarting it, so a hand power cycle was needed. Walleye decision 2026-11-18-walleye-no-pmic-bite-until-reset-type; research lab PR 238. The series writes S2_CTL=0x07 (hard reset) once at probe, with no S2 EN clear, wait or read-back. The kernel series is not mailable until a fix makes the bite restart; that fix joins the series as a patch of its own. The wake-in-suspend half still waits on walleye suspending at all. 2026-11-18 the sxmo lab apk is out (lab-tools PRs 168/169/172, docs #499): sxmo-utils 1.18.1_p20261118-r0 and 18 subpackages are in the lab-tools aarch64 index, built from lab-20261118.1. surya-sxmo-suspend-series asked of surya-coordinator (install as sxmo-utils@lab; proofs suspend-retry-backs-off, sensors-after-suspend). For each new lab tag on grenudi/sxmo-utils, this lane also pushes the matching sxmo-utils-v tag in lab-tools by hand, which starts the apk build. 2026-11-18 ~17:50Z: surya went silent (no USB, no address) after the sxmo-utils@lab install (surya-lab surya-silent-after-sxmo-apk). The sxmo series is held, with no mail, until the keeper's reading is in. The lane's packaging read: the NM and polkit rootfs files equal Alpine 3.24 r4's (sha512); post-install scripts only print; udev rules unchanged since 1.18.1. Differences: -common no longer pulls modemmanager, mmsd-tng or vvmd (edge r5 layout); scripts are master 1fd7822, 51 commits beyond 1.18.1, plus ours. Sent to surya-coordinator. Hold lifted 2026-11-18: surya-lab PR 262 read the silence as a cable event (usb0 carrier down 15:36-17:47Z, the author had unplugged it; no suspend or reboot). ModemManager and sxmo-utils@lab are installed, NetworkManager did not take usb0, and the suite is healthy (44 pass, 0 fail, 6 not measured: no SIM). The sxmo series is not implicated. Next: surya's attended suspend proofs (suspend-retry-backs-off, sensors-after-suspend) with the fuse armed; on a pass, the send is prepared for the author's word. 2026-11-18: walleye parked its PON register items (lab PR 272). The lane researched the reset type itself (research pmic-wdt-reset-type) and added kernel patch 5/5, f5bb57d27 on grenudi/linux: set the S2 type with S2 disabled, then read it back. Surya was asked to build its kernel from f5bb57d27 and to read S2_CTL before an attended bite. research/upstream-forks/2026-11-18/patches/linux still holds the 4-patch export: it is regenerated at send time. 2026-11-18 surya's PON read (surya-lab PR 269, kernel at e123d3bff, before /dev/watchdog0 was opened): S2_CTL 0x856 = 0x07, S2_CTL2 0x857 = 0x00 (S2 not enabled at rest), 0x85a = 0x07. So on pm6150 the type write lands even without 5/5. Surya's attended bite tests the type itself; a restart there clears the gen2 path on pm6150. Walleye's 'written while S2 runs' cause stays open for walleye. Next: surya rebuilds at f5bb57d27 with dyndbg, then the attended read and bite. 2026-11-18 18:55Z surya on f5bb57d27 (pmicwdt+ #4, dyndbg on): probe OK; firmware's original S2_CTL = 0x01 (warm reset); the driver set 0x07 and the read-back passed. So 5/5 works on pm6150 (not yet bitten). Hazard sent to surya-coordinator: on this kernel the PMIC wdt is /dev/watchdog0, and surya-lab sleep/way-back.sh hardcodes watchdog0 as the APSS fuse, so the fuse would arm the device under test. way-back.sh should pick by identity (surya-lab's to fix); pmic-wdt-way-back.sh already does. 2026-11-18 18:57Z surya's PMIC bite RESTARTED the phone (pass: pmic-wdt-bites on pm6150; surya-lab PR 276). Finding: S2 stays enabled across the bite restart, so the next boot (calls+, no pm8916_wdt) looped every ~35 s until a full power-off from eOS recovery (surya-lab PR 278). Added patch 6/6, 8b2283da3: stop on reboot and unregister (LLVM W=1 and checkpatch clean, untested on hardware). A bite itself can't be cleared by a driver: after a bite, the next boot must carry pm8916_wdt. Rule suggested to surya; the cover letter must say it. Series at 6 patches; still to prove: pmic-wdt-wakes-in-suspend (surya), and walleye's bite on 8b2283da3 (parked). 2026-11-19: inventory of what we carry (docs #566): nothing is mailable without the author's SoB; nearest are tas2562 slot length, PMIC wdt gen2, walleye dts (dt checks: #568, #573, #576). The clk.c boot warning is cleared from the series: display-side, item dsi-pll-lock-failed-sm7150 (#594). sxmo series WITHDRAWN: SourceHut's terms bar LLM-written content (#580); author's yes to 2026-11-19-hardware-test-layer (#586); grenudi/sxmo-utils archived, surya back on Nura's sxmo-utils; no longer waiting on surya's sxmo proofs; the author may send his own patches by hand. Still held: PMIC wdt series, for pmic-wdt-wakes-in-suspend (surya) and walleye's bite at 8b2283da3 (parked). dt-check: lab-tools v0.22.1, image publish pending. 2026-11-19 05:40: PMIC wdt gen2 v1 prepared on next-20261118 (docs #604, research/upstream-forks/2026-11-19/pmic-wdt-gen2-v1/ with SEND-NOTES): 6 patches, fixes first (reset type with S2 disabled, Fixes 066951ca33ce; stop on reboot), binding with pm6150+pm8998 fallback, gen2 driver, pm8998 and pm6150 dts nodes; suspend patch and wakeup-source left for a later series. W=1, checkpatch (only SoB missing), dt_binding_check and CHECK_DTBS with nodes enabled: clean. Assisted-by dropped (next rejects it); disclosure sentence in each changelog and the cover letter. Waits on: the author's re-author + SoB and his word; walleye's test of patch 1 on PM8998 is the one hardware gap the cover letter names. The old 4-patch export of 2026-11-18 is removed. 2026-11-19: the author on gen2 v1: "Yes, test first" - unsent until a Pixel 2 bite with patches 1 and 2 shows a restart (walleye queues it attended for his next lab visit); then the cover letter's testing paragraph is updated and it goes back to him.

Opened
: 2026-11-18

About
: upstream-forks


<a id="sxmo-utils-lab-apk"></a>
### sxmo-utils from our fork as a lab apk: an APKBUILD forked from Alpine's, all subpackages, source the fork's lab tag, signed, installed as sxmo-utils@lab

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Declaration landed (lab-tools PR 157); built, signed and published by the package conveyor 2026-11-18 (see sxmo-utils-lab-apk-deliver): sxmo-utils 1.18.1_p20261118-r0 and every subpackage at https://linux-phone-oco.github.io/lab-tools/, installed in a clean Alpine 3.24 aarch64. Not done here: installing it on surya as sxmo-utils@lab (nothing on a phone from this session); the phone proof suspend-retry-backs-off waits on that install.

Opened
: 2026-11-18

Needs
: build

Device
: xiaomi-surya

Proof
: suspend-retry-backs-off

About
: upstream-forks


<a id="host-install-atomic"></a>
### lpoco host prepare installs each tool by writing a new file and renaming it into place

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Landed in lab-tools #162 (read back from main): prepare writes each tool, rev stamp and watcher unit beside the old file, fsyncs, renames over it (replace_file in host/src/main.rs). Proof: host test a_script_running_while_prepare_replaces_it_finishes_with_its_old_text, seen failing first. Cargo installs land by cargo's own temp-and-rename, not covered by a test.

Opened
: 2026-11-18

Needs
: build

Device
: xiaomi-surya

Proof
: a host test: a script tool being run while prepare replaces it finishes with its old text (the new file is renamed over, never written in place); cargo installs likewise land by rename

Rank
: 5

About
: lpoco-host-rest


<a id="test-bisect-parallel-flake"></a>
### bringup_bisect_runs_declared_series fails in a parallel workspace run, passes alone

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: 2026-11-19, lab-tools-builder: cause found: the test ran 'lz4 -dc' on the frame plus the appended dtb behind it; lz4 1.11.1 exits 34 (ERROR_frameType_unknown) on that trailing garbage and under load wrote 0 bytes to stdout. Seen failing first (diagnostic run 1 of the loop: 0 bytes, status 34, 246-byte kernel). Fixed (lab-tools #241, main d44af06): the test cuts the dtb off before decoding and asserts lz4 succeeds. Proof: cargo test -p lpoco-bringup --test bisect 30 runs in a row, cargo test --workspace 20 runs in a row at default parallelism, all passed.

Opened
: 2026-11-18

Needs
: build

Device
: google-walleye

Proof
: cargo test --workspace passes 20 runs in a row with default parallelism

Rank
: 4

About
: bringup


<a id="test-hold-parallel-flake"></a>
### hold::tests::the_phone_is_held_by_one_change_at_a_time fails in a parallel workspace run, passes alone

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: 2026-11-19, lab-tools-builder: the 20-in-a-row proof is reached with the bisect flake fixed (#241, main d44af06): cargo test --workspace 20 runs in a row, default parallelism, all passed.

Opened
: 2026-11-18

Needs
: build

Device
: xiaomi-surya

Proof
: cargo test --workspace passes 20 runs in a row with default parallelism

Rank
: 4


<a id="sxmo-utils-lab-apk-deliver"></a>
### Build, sign and publish the sxmo-utils lab apk as the sxmo-utils@lab repository

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Delivered 2026-11-18. Conveyor v1.2.1 (v1 moved; PRs conveyor 19, 20): alpine.yml copies the APKBUILD's whole folder, keeps the live repository's other packages in the one signed APKINDEX, derives the front page and verify from it, installs the APKBUILD's makedepends in the signing container before the key, and refuses a deploy that would lose a live package; its own test (tests/alpine/run.sh, CI job alpine) runs the steps on two fixture packages. lab-tools PRs 168 (packaging/sxmo-utils/conveyor.toml, second packages job, tag sxmo-utils-v1.18.1_p20261118 pushed by hand), 169 (APKBUILD build()), 172 (restored 168/169 after #170 put the files back). Proof: lab-tools Packages run 44322521483: 19 packages verified against the committed key, https://linux-phone-oco.github.io/lab-tools/ offers lpoco-health 0.15.1 and sxmo-utils 1.18.1_p20261118-r0 (every subpackage listed), both installed in a clean Alpine 3.24 aarch64 from the page's own lines. Next: the phone takes it (apk add sxmo-utils from that repository tagged @lab) - the phone proof suspend-retry-backs-off.

Opened
: 2026-11-18

Needs
: build

Device
: xiaomi-surya

Proof
: suspend-retry-backs-off

Rank
: 4

About
: sxmo-utils-lab-apk


<a id="phone-pieces-drift-in-lab"></a>
### lpoco lab names a stale phone-side piece at every change's end, from the report it reads back

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: 2026-11-18, lab-tools-builder: done (lab-tools #170, main 27bd466). lpoco-lab test and health name a stale phone piece after the run, from the report just read back, judged by lpoco_host::stale_lines (shared with lpoco host check). Proof: host/tests/phone_pieces.rs the_lab_names_a_piece_off_main_from_the_report_it_reads_back (seen failing first) and the_lines_name_a_package_off_its_pin. Not tested end to end against a phone: devlab's wiring (health.rs name_stale_pieces) has no test of its own. Note: the commit named is now the oldest holding the stale blob (changes host check output). Report-name ordering checked: names are YYYYMMDD-HHMMSS, so the greatest sorts newest.

Opened
: 2026-11-18

Needs
: build

Device
: xiaomi-surya

Proof
: a test in lab-tools lpoco/tests (to write, failing first): after a change the lab output names a piece off main

Rank
: 6

About
: phone-pieces-drift-named


<a id="host-plan-unreadable-not-new"></a>
### lpoco host records each root file it installs, so plan reads an unreadable one as up to date

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: 2026-11-18, lab-tools-builder: done (lab-tools #173, main a4d4a3e). prepare records the git blob id of each root file it installs in ~/.local/state/lpoco-host/installed (lines 'HASH DST'), after every root command succeeded; plan reads a file under a folder the lab user may not enter (PermissionDenied) by that record: up to date when it matches, else planned as an install and worded 'unreadable, not known yet', never '(new)'. Proof: host/tests/plan.rs a_root_file_the_lab_user_cannot_read_is_judged_by_the_hash_recorded_at_its_last_install (seen failing first). Not done, now host-record-from-check: the lab has no record until the next prepare, so the first plan on it still names 50-lpoco.rules 'not known yet' and the first prepare reinstalls it (one sudo); a passing lpoco host check does not write the record; plan does not tie 'up to date' to the share check passing. The test assumes the suite does not run as root (mode 000 does not stop root).

Opened
: 2026-11-18

Needs
: build

Device
: xiaomi-surya

Proof
: host plan tests from fixtures: (1) a root file under an unreadable directory, whose staged content hashes to the hash recorded at its last install, is planned up to date with 0 root commands; (2) changed staged content is planned as a root install; (3) with no record, it is named as unreadable and not known, never '(new)'; (4) prepare now records the hash after each root install it runs

Rank
: 5

About
: lpoco-host-rest


<a id="template-classifies-its-files"></a>
### device-template names every file it has: generic (followed) or made-once (laid at creation); the skeleton followed, the hardware files left to idealkb

Project
: linux-phone-oco/device-template

Status
: done

Note
: Landed in device-template #26: made-once names the 18 seed files; every other file is followed from idealkb (its generic at the pin) or docs (device-layer/, v0.17.0); its own generic list is gone. The skeleton (Makefile, bin/install-tad.sh, the workflows, .gitignore, tests/health/README.md) stays made-once for now: moving it into docs' device-layer/ needs tad's pin job (tad-engine consumers) to keep a second copy of bin/install-tad.sh current. Proof: research/device-template/2026-11-18/template-drift.sh TEMPLATE IDEALKB DOCS says ok for classified and one-source.

Opened
: 2026-11-18

Proof
: docs research/device-template/2026-11-18/template-drift.sh device-template ideal-knowledge-base: its classified and one-source lines say ok (today 18 unclassified files, 3 with two sources)

About
: device-template


<a id="template-releases"></a>
### device-template releases by release-please from v0.1.0, and a lab's devicebase.toml names the release it follows

Project
: linux-phone-oco/device-template

Status
: done

Note
: Closed, not done: decision 2026-11-18-device-layer-from-docs supersedes the route - the template releases nothing and is followed by nothing; docs' release carries the device layer and update-pins follows docs (device-layer-in-docs, template-follows-docs).

Opened
: 2026-11-18

Blocked by
: template-classifies-its-files

Proof
: gh release list -R linux-phone-oco/device-template shows v0.1.0, and template-drift's pin line reads it for a lab pinned to it

About
: device-template


<a id="template-drift-in-ci"></a>
### template-drift's classified check runs in the template's CI; the labs' checks are graph-drift's (docs, daily)

Project
: linux-phone-oco/device-template

Status
: open

Note
: Reshaped again: template-drift.sh now reads the template, idealkb and docs (TEMPLATE IDEALKB DOCS) and keeps classified and one-source; the lab checks are graph-drift's. To run in the template's CI it needs clones or tags of idealkb and docs at the template's two pins (git fetch of the two repositories' tags); the check itself can be the same script, seeded as a made-once file or kept in docs and run from there.

Opened
: 2026-11-18

Blocked by
: template-classifies-its-files

Proof
: a test PR to the template adding an unclassified file fails its CI with a line naming it

About
: device-template


<a id="template-followed-by-update-pins"></a>
### The hourly update-pins moves a lab's template pin as it moves idealkb's: the template lists its consumers, each bump lands through the lab's CI

Project
: linux-phone-oco/device-template

Status
: done

Note
: Closed, not done: decision 2026-11-18-device-layer-from-docs supersedes the route - the template releases nothing and is followed by nothing; docs' release carries the device layer and update-pins follows docs (device-layer-in-docs, template-follows-docs).

Opened
: 2026-11-18

Waits
: grenudi/ideal-knowledge-base item follow-source-from-pin (follow.sh and update-pins read their source from the pin file)

Blocked by
: template-releases

Proof
: the first template release after v0.1.0 reaches surya-lab and google-walleye-lab as one bot PR each, landed by their CI, with template-drift exit 0 after

About
: device-template


<a id="surya-follows-template"></a>
### surya-lab follows docs' device layer and device-template's skeleton files: devicebase.toml names source = linux-phone-oco/docs and a version, its list copy gone, check.yml and tests/health/README.md taken

Project
: linux-phone-oco/surya-lab

Status
: done

Note
: Done: surya-lab PR 258 - devicebase.toml pins linux-phone-oco/docs 0.17.0, device markers in tables.toml; read back from main. Left for the lane: surya-lab still carries the template's old root 'generic' file (walleye removed its copy in PR 267).

Opened
: 2026-11-18

Blocked by
: device-layer-in-docs

Needs
: build

Device
: xiaomi-surya

Proof
: research/base-graph/2026-11-18/graph-drift.sh: layer-pin, layer-owner, layer-follow ok for surya-lab

About
: device-template


<a id="walleye-follows-template"></a>
### google-walleye-lab follows docs' device layer: devicebase.toml names source = linux-phone-oco/docs and a version, its list copy gone, its rust job in its own workflow, stale PR 208 closed

Project
: linux-phone-oco/google-walleye-lab

Status
: done

Note
: Done: google-walleye-lab PR 267 - devicebase.toml pins linux-phone-oco/docs 0.17.0, device tables between the device markers, the old generic list gone, checks passing; read back from main.

Opened
: 2026-11-18

Blocked by
: device-layer-in-docs

Needs
: build

Device
: google-walleye

Proof
: research/base-graph/2026-11-18/graph-drift.sh: layer-pin, layer-owner, layer-follow ok for google-walleye-lab

About
: device-template


<a id="bringup-steps"></a>
### Bring-up steps as data: every step that makes Linux run on a machine, generic in docs, each device's status claimed in its own base, a guidebook and helpers made from it

Project
: linux-phone-oco/docs

Status
: open

Note
: Decided 2026-11-18-bringup-steps-generic-in-docs-status-in-each-base (research bringup-steps-landscape). The pieces are the items about bringup-steps, unranked for the author.

Opened
: 2026-11-18

Blocked by
: bringup-steps-schema,bringup-steps-seed,feed-device-steps,walleye-steps-claimed

Proof
: research/bringup-steps/2026-11-18/bringup-chain-walleye.sh passes in docs: tad q bringup-chain --device google-walleye lists walleye's steps in order, each proven one with its proof and run, none unknown (fails today: no query bringup-chain)

About
: commons-only


<a id="bringup-steps-schema"></a>
### The bring-up step tables in docs: bringup_steps, bringup_step_edges, step_status, the records bringup-step and bringup-edge, and the query bringup-chain

Project
: linux-phone-oco/docs

Status
: done

Note
: Landed: tables bringup_stages (the stage list as rows, so it changes with ikb bringup-stage and no schema change), bringup_steps, bringup_step_edges, step_status (declared only; a feed fills it); records bringup-step, bringup-edge (refuses a cycle, a self-edge, a group mixing hard and soft), bringup-stage; query bringup-chain [--device] with a computed ready/waits. Reviewed by the programmer subagent (group-name collision, UNION for the depth walk, stage tie, device guard fixed). tad check: 37 tables; make verify twice clean. Test research/bringup-steps/2026-11-18/bringup-chain-walleye.sh: was 'no query bringup-chain'; with the schema and seed it gets 26 steps in order and fails only for lack of claims (walleye kernel-reaches-init is unknown, not done): walleye-steps-claimed and feed-device-steps make it pass.

Opened
: 2026-11-18

Proof
: tad check passes with the three tables; tad r bringup-edge refuses an edge that closes a cycle; tad q bringup-chain answers with no device (every status unknown)

About
: bringup-steps


<a id="bringup-steps-seed"></a>
### Seed the generic steps: 26 steps and 37 edges from walleye's real chain, surya's road checked against it

Project
: linux-phone-oco/docs

Status
: done

Note
: Landed: 8 stages, 26 steps and 37 edges recorded through ikb bringup-stage, bringup-step and bringup-edge (research/bringup-steps/2026-11-18/seed.sh, rerunnable). tad q bringup-chain lists 26 steps in order: stock-measured, stock-facts-read, slot-state-known and initramfs-gadget-emulated at depth 0, bootloader-unlocked at 1 (a soft need on stock-measured: an unlock may wipe the stock system), health-suite-runs last at 12; every status unknown until a base claims. Stages are rows of bringup_stages (prepare, boot, console, kernel, power, storage, userspace, lab), the draft awaiting the author's word: change them with ikb bringup-stage, no schema change. tad check passes; make verify twice clean.

Opened
: 2026-11-18

Blocked by
: bringup-steps-schema

Proof
: tad q bringup-chain lists 26 steps, bootloader and stock steps at depth 0, health-suite-runs last; tad check passes

About
: bringup-steps


<a id="steps-contract"></a>
### The steps contract in the template: a steps table, the record step, contract steps = 1 in devicebase.toml, data/steps.json empty, in the template's followed files

Project
: linux-phone-oco/device-template

Status
: done

Note
: Done: docs 0.18.0 carries the contract (device-layer/ steps table, records/step.sql, generic); the hourly follow landed it at 21:01-21:02 CET in device-template, surya-lab and google-walleye-lab (each at docs 0.18.0, tad check passes, tad r step writes one row, a status outside the six is refused; verified on main in a fresh clone). docs' feed reads data/steps.json from a base that says steps = 1. Each base still needs that one line in its own devicebase.toml (the pin file is never laid) with its first claim: the lanes' items walleye-steps-claimed and surya-steps-claimed.

Opened
: 2026-11-18

Blocked by
: bringup-steps-schema

Proof
: in the template, tad check passes with an empty steps table; tad r step --step shell-on-console --status done --proof X --run Y writes one row and refuses a status outside the six

Rank
: 1

About
: bringup-steps


<a id="feed-device-steps"></a>
### Pull each device base's steps into step_status: records/feed-device-steps.sql and a device-steps-unknown fallback in bin/run-feeds.sh

Project
: linux-phone-oco/docs

Status
: done

Note
: Landed: records/feed-device-steps.sql, device-steps-unknown.sql, run-feeds.sh runs both per device, bin/test-feed-device-steps.sh in make verify (fake base of the device layer alone: claim read, unclaimed unknown, invalid unknown with why, claimed twice counts once, unknown step's claim dropped and named, no steps = 1 and unreadable base unknown with why). Against the real bases today (no data/steps.json, no steps = 1) every step reads unknown, 'could not be read (HTTP 404 on data/steps.json)'. Run against a fake walleye base with its 26 claims (claims-walleye.sh through tad r step): bringup-chain-walleye.sh passes its order, count and six proven-step checks and fails at the last, 'walleye steps not known yet' - the 80 steps of the phone stages (plus linux-runs) that walleye's base does not claim. daily-phone.sh passes its shape half and fails for every device, 77 of 77 steps not done, until the base claims.

Opened
: 2026-11-18

Blocked by
: bringup-steps-schema,steps-contract

Proof
: run against a base without steps = 1, every step of that device is unknown with the reason; against google-walleye-lab after its claims, research/bringup-steps/2026-11-18/bringup-chain-walleye.sh passes

Rank
: 2

About
: bringup-steps


<a id="walleye-steps-claimed"></a>
### walleye claims its bring-up steps in its own base, from its records

Project
: linux-phone-oco/google-walleye-lab

Status
: open

Note
: The 26 claims are written out in research/bringup-steps/2026-11-18/claims-walleye.sh, each run a record of google-walleye-lab (its tad r step-claim lines are tad r step here, without --device and --updated). Data only; no phone. The contract is in the base (docs 0.18.0): add steps = 1 to devicebase.toml, claim with tad r step (done needs --proof and --run; not-needed needs --notes). The test research/bringup-steps/2026-11-18/bringup-chain-walleye.sh passes its order, count and six-proof checks with those 26 claims and still fails at 'steps not known yet': the base must claim every step of the chain (80 more, the phone stages and linux-runs), even as open or not-needed.

Opened
: 2026-11-18

Blocked by
: steps-contract,walleye-follows-template

Needs
: build

Device
: google-walleye

Proof
: research/bringup-steps/2026-11-18/bringup-chain-walleye.sh passes in docs after make feeds

About
: bringup-steps


<a id="surya-steps-claimed"></a>
### surya claims its bring-up steps in its own base, from its records (its road: a booting distribution, the image steps not-needed)

Project
: linux-phone-oco/surya-lab

Status
: open

Note
: The claims are listed in research/bringup-steps/2026-11-18/README.md (Surya's path); PMIC and charger stay unknown until measured. The contract is in the base (docs 0.18.0, records/step.sql): add steps = 1 to devicebase.toml, claim with tad r step (a done claim needs --proof and --run; not-needed needs --notes), then docs' feed reads data/steps.json at the next daily run (make feeds). Check: sh research/bringup-steps/2026-11-18-phone-stages/daily-phone.sh xiaomi-surya in docs.

Opened
: 2026-11-18

Blocked by
: steps-contract,surya-follows-template

Needs
: build

Device
: xiaomi-surya

Proof
: tad q bringup-chain --device xiaomi-surya in docs shows health-suite-runs done with run 2026-11-17-1550-lpoco-health-v017, and no step unknown but pmic-bound and charger-online

About
: bringup-steps


<a id="bringup-guidebook"></a>
### The guidebook rendered from the steps: docs/guidebook.md by make render, a chapter per stage, each step's done-when, needs, proof, helper or gap, guide, and a column per device

Project
: linux-phone-oco/docs

Status
: done

Note
: Landed 2026-11-18 (PRs 548, 551, 554): docs/guidebook.md rendered by make render from the steps (bin/render-pages.sh, bin/guidebook.jq), 113 steps in 20 chapters with needs and enables off the edges and world gaps marked; the devices side by side is the face's steps view (bin/face-steps, lens view steps), the front page's Bring-up steps and Bring-up guide tabs lead to both and the tables; tests bin/test-bringup-pages.sh, test-face-steps.sh, test-face-guide.sh in make verify. A column per device stays in the face view, not in the guidebook.

Opened
: 2026-11-18

Blocked by
: bringup-steps-seed

Proof
: make verify fails when docs/guidebook.md is stale against the rows, and the page lists the 26 steps in bringup-chain's order with every hard need before its step

About
: bringup-steps


<a id="bringup-steps-helpers"></a>
### The helper map: lpoco bringup steps reads docs' chain and names, per step, its lpoco command or the gap

Project
: linux-phone-oco/lab-tools

Status
: open

Note
: Today: image pack/check/swap/bisect, initramfs build, lab fastboot, flash, provision, suite. Gaps: UART, banner, shell, dmesg map, PMIC, charger, storage. Each gap filled becomes its own item.

Opened
: 2026-11-18

Blocked by
: bringup-steps-seed

Proof
: a test in lab-tools: every helper named in docs' bringup_steps is a subcommand lpoco --help lists at the pinned release, and lpoco bringup steps --device google-walleye prints the gaps

About
: bringup-steps


<a id="bringup-step-runner"></a>
### Research: a runner that walks a device's ready steps - helper, then proof, then the claim in its base; a step that changes the phone queued to its keeper

Project
: linux-phone-oco/lab-tools

Status
: open

Note
: 2026-11-19, orchestration: built by decision 2026-11-19-procedures-chain-small-device-agnostic-steps - steps are small device-agnostic library functions keyed to bring-up step ids, values from device.toml/[layer]; a lane's file only chains them; one step type for lpoco-attended and bringup-step-runner.

Opened
: 2026-11-18

Blocked by
: bringup-steps-helpers,feed-device-steps

Proof
: a research row and a decision with what was rejected, and its failing test: the runner on a made-up device with two ready steps runs each helper and proof and writes two claims

About
: bringup-steps


<a id="milestones-step-terms"></a>
### Milestones name steps: step:ID@device in criteria, read from step_status by milestone-readiness

Project
: linux-phone-oco/docs

Status
: done

Note
: Landed: tad q milestone-steps [--milestone ID] reads every step:ID@DEVICE term of a milestone's criteria from step_status (a term is met when the base claims done or not-needed, else not; ready when all of a milestone's step terms are met; a step or device that is none errs naming it), and records/milestone.sql (ikb milestone) which milestones had none. bin/test-milestone-steps.sh in make verify, in a scratch copy through a fake base and the feed: a walleye milestone over step:kernel-reaches-init@google-walleye and step:shell-on-console@google-walleye reads unmet, partial still unmet, ready when both are done. The readiness rung stays a person's word; goal steps (never claimed) are milestones-name-goals.

Opened
: 2026-11-18

Blocked by
: feed-device-steps

Proof
: milestone-readiness counts a step term done only when step_status says done for that device; a walleye milestone 'reaches a shell' over step:shell-on-console@google-walleye reads ready

Rank
: 8

About
: bringup-steps


<a id="host-record-from-check"></a>
### lpoco host check writes the install record for a root file it proves in place, so the first plan after 0.15 asks no sudo

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: 2026-11-18, lab-tools-builder: done (lab-tools #175, main 9458bfa). A passing share check (every measured device passed, at least one measured) records the staged hash of the polkit rule, share unit and helper that plan could not read and has no record for; check and prepare both do it. A file recorded with other content stays a root install; a failing check records nothing. Proof: host/tests/plan.rs a_passing_share_check_records_the_rule_it_proved_and_a_failing_one_records_nothing (seen failing first) and a_passing_share_check_does_not_vouch_for_a_rule_recorded_with_other_content. share::probe takes the fake root so /run state is testable. Not done: plan wording 'up to date' tied to the file's check passing. Limit: check now writes the install record.

Opened
: 2026-11-18

Needs
: build

Device
: xiaomi-surya

Proof
: host plan test from fixtures: with no record and an unreadable rules folder, a passing share check records the staged hash and the next plan lists 0 root commands for it; a failing check records nothing

Rank
: 5

About
: lpoco-host-rest


<a id="restore-share-per-device"></a>
### Restore the per-device phone share (#164) and the 0.14.2 changelogs that #165 reverted

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Landed lab-tools #177 (main 570fcc7), released v0.17.1 (#178). share.rs carries #164 again with #175's fs_root; its two-shares test passes (it did not exist on main, #165 removed it with the code). Reviewer's fix applied: a share in use is NotMeasured, not Ok. Not done: lpoco host plan on the lab against the installed helper; the [0.14.2] changelog sections stay lost, since check-changelog.sh refuses a changelog changed without a version.

Opened
: 2026-11-18

Needs
: build

Device
: google-walleye

Proof
: host/src/share.rs on main carries #164's per-share nft table and shared forwarding state again, with #175's recorded-rule change kept; a share test (two shares, stopping one leaves the other's table and forwarding) passes, and fails on today's main; lpoco host plan with the next release shows /usr/local/libexec/lpoco-share unchanged against the installed helper

Rank
: 1

About
: lpoco-host-rest


<a id="base-graph"></a>
### Every edge of the repository graph moved by a tool and checked, both ways: files down from one owner, changes up as items, rows up by feeds

Project
: linux-phone-oco/docs

Status
: in-progress

Note
: Decided 2026-11-18-device-layer-from-docs (research base-graph-measured, base-graph-world). graph-drift.sh: 36 FAIL today. Steps: device-layer-in-docs, docs-own-statements-up, docs-tables-idealkb-part, graph-drift-daily, tad-pins-every-base, lpoco-pin-follows (lab-tools), fork-tracking-job, template-follows-docs and template-classifies-its-files (device-template), surya-follows-template, walleye-follows-template; idealkb's side as upstream items idealkb-slice-from-prefix, idealkb-skip-unchanged-slice, idealkb-own-needs-item, idealkb-exit3-sends-up; git-rhizoid's scope as rhizoid-scope-every-edge.

Opened
: 2026-11-18

Proof
: research/base-graph/2026-11-18/graph-drift.sh exits 0


<a id="device-layer-in-docs"></a>
### docs gives the device layer: device-layer/ holds the 10 statements and the marked device part of tables.toml (devices, parts, test_runs, test_results; steps when it lands), a generic list (#! pin = devicebase.toml, #! marker = device, #! from = device-layer/), and takes device-template's place in idealkb's ./sources

Project
: linux-phone-oco/docs

Status
: done

Note
: Done: docs serves device-layer/ (docs #514, #515, release v0.17.0); idealkb ./sources names linux-phone-oco/docs in place of device-template; device-template (#26), surya-lab (PR 258) and google-walleye-lab (PR 267) pin docs 0.17.0, so idealkb's hourly job keeps them current.

Opened
: 2026-11-18

Waits
: idealkb: ./sources names docs in place of device-template (the ikb session)

Proof
: research/base-graph/2026-11-18/graph-drift.sh: layer-owner and layer-follow ok for every device base

About
: base-graph


<a id="docs-own-statements-up"></a>
### docs' six own statements (about, decision, research, backlog, session-log, source) each go up to idealkb as an item or are dropped for idealkb's

Project
: linux-phone-oco/docs

Status
: open

Note
: Decision 2026-11-18-device-layer-from-docs (4). decision.sql lacks --supersedes/--amends/--scope/--tracked-by since idealkb 0.14.0 (this decision set them with ikb set). What docs adds (--project, a place per row) is the likely item: a base holding several places' records.

Opened
: 2026-11-18

Proof
: research/base-graph/2026-11-18/graph-drift.sh: own-behind ok for docs; ikb decision --supersedes accepted in docs

About
: base-graph


<a id="docs-tables-idealkb-part"></a>
### docs' tables.toml carries idealkb's marked part, so new generic fields and rules reach it at the follow

Project
: linux-phone-oco/docs

Status
: open

Note
: Decision 2026-11-18-device-layer-from-docs (4); idealkb's gap tables-own-drift. docs' tables.toml has no idealkb:begin today.

Opened
: 2026-11-18

Proof
: research/base-graph/2026-11-18/graph-drift.sh: own-part ok for docs

About
: base-graph


<a id="graph-drift-daily"></a>
### graph-drift.sh runs daily in docs' CI and each FAIL line becomes an item for the edge's owner

Project
: linux-phone-oco/docs

Status
: open

Note
: Decision 2026-11-18-device-layer-from-docs (5). Read-only, needs gh and the clones it reads (or fetches).

Opened
: 2026-11-18

Proof
: a scheduled run of the workflow, red today with the 36 FAIL lines, green when every edge holds

About
: base-graph


<a id="tad-pins-every-base"></a>
### Every base that installs tad is on tad-engine's consumers list and at its latest release (docs' CI is on 0.6.0)

Project
: linux-phone-oco/docs

Status
: open

Note
: tad-engine's owner adds device-template, surya-lab, google-walleye-lab to consumers; the weekly job then moves docs too.

Opened
: 2026-11-18

Proof
: research/base-graph/2026-11-18/graph-drift.sh: tad-pin ok for every base

About
: base-graph


<a id="lpoco-pin-follows"></a>
### lab.toml's lpoco pin is moved by a job when lpoco releases, or says why it holds

Project
: linux-phone-oco/lab-tools

Status
: open

Note
: Decision 2026-11-18-device-layer-from-docs (5). lab.toml (grenudi/lab-machine) pins 0.15.0, lpoco-v0.17.0 tagged the same day. The pin is the lab machine's; the job is the later rhizoid tool-pin edge.

Opened
: 2026-11-18

Proof
: research/base-graph/2026-11-18/graph-drift.sh: tool-pin ok

About
: base-graph


<a id="fork-tracking-job"></a>
### A daily lab job fetches each fork's upstream into its tracking branch, test-merges every topic onto it and retires topics upstream carries (git cherry)

Project
: linux-phone-oco/docs

Status
: open

Note
: Decision 2026-11-18-device-layer-from-docs (6); the upstreams lane's. grenudi/sxmo-utils master is 4 behind sr.ht today.

Opened
: 2026-11-18

Proof
: research/base-graph/2026-11-18/graph-drift.sh: fork-track ok for grenudi/sxmo-utils and grenudi/linux

About
: upstream-forks


<a id="template-follows-docs"></a>
### device-template becomes a device base like the others: it pins idealkb and docs (devicebase.toml source/version), drops its generic list, keeps its made-once files

Project
: linux-phone-oco/device-template

Status
: done

Note
: Landed in device-template #26: devicebase.toml pins linux-phone-oco/docs 0.17.0 (source, version, own = []); the device tables sit between device:begin and device:end; follow.sh of idealkb laid onto it changes nothing. graph-drift.sh: layer-pin, layer-owner, layer-follow, layer-equal ok for device-template.

Opened
: 2026-11-18

Blocked by
: device-layer-in-docs,template-classifies-its-files

Proof
: research/base-graph/2026-11-18/graph-drift.sh: layer-pin, layer-owner ok for device-template; template-drift.sh classified ok

About
: device-template


<a id="bringup-chain-goal"></a>
### bringup-chain --goal STEP: a goal and what it needs, hard edges all the way down (what a daily-usable phone needs)

Project
: linux-phone-oco/docs

Status
: done

Note
: Landed: queries/bringup-chain.sql takes --goal STEP (the draft of research/bringup-steps/2026-11-18-phone-stages/queries, unchanged); bin/test-bringup-chain-goal.sh in make verify: the rows are the goal and its hard-edge closure (78 for daily-usable-phone: the 77 steps daily-phone.sh counts and the goal itself; 23 for linux-runs), the goal last, --goal of a no step errs naming it.

Opened
: 2026-11-18

Proof
: tad q bringup-chain --goal daily-usable-phone gives the 77 steps daily-phone.sh counts, and --goal nope errs naming the step

Rank
: 3

About
: bringup-steps


<a id="bringup-shape-check"></a>
### make verify checks the steps' shape: every stage has a step, every phone step is needed by complete-phone

Project
: linux-phone-oco/docs

Status
: done

Note
: Landed: bin/check-bringup-steps.sh in make verify (every stage has a step, the three goals exist, every phone step is needed by complete-phone; it names what is wrong). Proof in a scratch copy: an empty stage (ikb bringup-stage) and a loose step in camera failed it naming 'zz' and 'loose-step'; as landed it passes (20 stages, 106 steps).

Opened
: 2026-11-18

Proof
: in a scratch copy, adding a stage with no step (ikb bringup-stage) makes make verify fail naming it; as landed it passes

Rank
: 4

About
: bringup-steps


<a id="prior-art-query"></a>
### tad q prior-art --about S: a subject's prior art - its research, each cited source with what we take from it

Project
: linux-phone-oco/docs

Status
: done

Note
: Landed: tad q prior-art --about S (queries/prior-art.sql): each research about the subject and each source it cites with its title, url and takes; superseded research leaves the answer. bin/test-prior-art.sh in make verify: for bringup-steps 68 cited sources of its researches (landscape, coverage-map, phone-stages among them).

Opened
: 2026-11-18

Proof
: tad q prior-art --about bringup-steps lists the sources of bringup-steps-landscape, bringup-steps-coverage-map and bringup-steps-phone-stages, each with its takes

Rank
: 5

About
: bringup-steps


<a id="landscape-record"></a>
### A landscape record (ikb landscape), so a session can add a project or effort to the landscape

Project
: linux-phone-oco/docs

Status
: done

Note
: Landed: records/landscape.sql (ikb landscape --id --name --effort --what --for-us --link [--checked]; effort is the landscape's project column, --project being the place), bin/test-landscape-record.sh in make verify (adds a row, replaces by id, refuses a link not https, in a scratch copy). First rows: ubports-devices, halium, android-cts (the three the item named).

Opened
: 2026-11-18

Proof
: ikb landscape --id ubports-devices ... records a row and tad check passes

Rank
: 6

About
: bringup-steps


<a id="phone-components"></a>
### Components for the phone steps that have none: GNSS, GPU, battery and charging, keys, front camera; and a component record

Project
: linux-phone-oco/docs

Status
: done

Note
: Landed: records/component.sql (ikb component --id --name --category), bin/test-component-record.sh in make verify; components gnss (connectivity), gpu (display), battery (power), buttons (input); gnss-fix, gpu-renders, battery-gauge-reads, off-mode-charging and buttons-report name them. The front camera needed no new part: camera-front is in the catalogue and no step is its first light. The new parts have no support_status row until the daily parts feed makes them unknown for each device with a base.

Opened
: 2026-11-18

Proof
: tad sql shows gnss-fix, gpu-renders, battery-gauge-reads and buttons-report each naming a component, and tad check passes

Rank
: 7

About
: bringup-steps


<a id="milestones-name-goals"></a>
### Milestones name goal steps: a device's daily-phone milestone is step:daily-usable-phone@DEVICE

Project
: linux-phone-oco/docs

Status
: done

Note
: Landed: milestone-steps reads a goal step (stage goals, never claimed) by what it needs: hard edges all the way down, done when every leaf is done or not-needed on the device, an alternative not taken (console over UART when the gadget's is done) not counted, partial when some are, unknown when none, its proof saying 'derived: N of M needs met'. Milestone surya-daily-phone (docs, subject xiaomi-surya, ord 7, rung 5 left for its keeper) over step:daily-usable-phone@xiaomi-surya reads unknown, not ready - 0 of 76 leaves; daily-phone.sh xiaomi-surya fails with 77 of 77 (it counts linux-runs too). bin/test-milestone-steps.sh in make verify tries the goal through the feed: ready only when every leaf is done (the console alternative untaken), mutation-checked.

Opened
: 2026-11-18

Blocked by
: milestones-step-terms

Proof
: a milestone surya-daily-phone over step:daily-usable-phone@xiaomi-surya reads not ready while daily-phone.sh xiaomi-surya fails, and ready when it passes

Rank
: 9

About
: bringup-steps


<a id="workarounds"></a>
### Workarounds - a script's line or a lane's rule - read one way: where each stands, its item, the item's state, its way out

Project
: linux-phone-oco/docs

Status
: done

Note
: Done: all three parts landed - the reader (ideal-agent 0.3.51), the markers on surya's post-bite rule and lab-tools' keep-awake, and patrol reading them; research/workarounds/2026-11-18/workarounds-read.sh passes against main's reader.

Opened
: 2026-11-18

Proof
: research/workarounds/2026-11-18/workarounds-read.sh exits 0


<a id="workarounds-reader-items-and-sites"></a>
### ideal-agent's scripts/workarounds reads backlog items across bases, sites only, and prints each workaround's way out

Project
: linux-phone-oco/docs

Status
: done

Note
: Done: ideal-agent 0.3.51 (grenudi/ideal-agent#95, decision 2026-11-18-workarounds-reads-sites-items-and-way-out): sites only, items from upstream_items then backlog, a way out on every line. research/workarounds/2026-11-18/workarounds-read.sh passes all checks against main's reader (orchestration ran it with WORKAROUNDS= set; sessions get it with the 0.3.51 plugin).

Opened
: 2026-11-18

Proof
: research/workarounds/2026-11-18/workarounds-read.sh checks B, C and D pass

About
: workarounds


<a id="workarounds-marked-where-they-stand"></a>
### The two live workarounds marked where they stand: surya's bite rule in surya-lab AGENTS.md, the keep-awake in lab-tools

Project
: linux-phone-oco/docs

Status
: done

Note
: Done: surya-lab AGENTS.md marks WORKAROUND(kept-kernel-with-pmic-wdt) (the post-bite boot rule) and lab-tools health/src/awake.rs marks WORKAROUND(sxmo-autosuspend-backoff); check A of workarounds-read.sh passes.

Opened
: 2026-11-18

Proof
: research/workarounds/2026-11-18/workarounds-read.sh check A passes

About
: workarounds


<a id="patrol-reads-workarounds"></a>
### The patrol runs scripts/workarounds over each lab at origin/main and files what is due as a sign to its lane

Project
: linux-phone-oco/docs

Status
: done

Note
: Done: patrol.md item 5 runs scripts/workarounds over docs, lab-tools and each lab; a due line, or a rule spoken of in a note but not marked, is a sign.

Opened
: 2026-11-18

Blocked by
: workarounds-reader-items-and-sites

Proof
: a patrol round's report names the reader's due list, or says none is due

About
: workarounds


<a id="user-config-drift-named"></a>
### lpoco host check names a phone user config file that differs from its package default or the base's declared copy

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: 2026-11-19, lab-tools-builder: done (lab-tools #201, released v0.22.0 #202). device.toml [[user_config]] path + expect (package default on the phone) | from (copy in the base), exactly one; lab-pieces reports config-file:PATH rows 'PATH BLOB DEFAULTBLOB'; stale_pieces names Stale::Config (DRIFTED, both blobs); a missing default or base copy is named; duplicates, expect==path, from outside the base refused. Proof: host/tests/phone_pieces.rs a_user_config_off_its_package_default_or_its_base_copy_is_named_and_a_matching_one_passes (seen failing first: no variant Config), health/tests/pieces_report.rs, devlab device.rs unit test. Open: no device declares user_config yet - surya should declare the sxmo hooks/profile; a copy edited deliberately against expect shows DRIFTED until it moves to from; the line does not name the commit the phone's copy came from.

Opened
: 2026-11-18

Needs
: build

Device
: xiaomi-surya

Proof
: host/tests/phone_pieces.rs from fixtures: a declared user config (expect = package default at /usr/share/...) whose reported blob differs is named with both blobs; one declared as a base copy that differs is named; a matching one passes; an undeclared file is not read

Rank
: 8

About
: phone-side-pieces


<a id="dt-check-verb"></a>
### lpoco-bringup dt-check: dt_binding_check and CHECK_DTBS in a digest-pinned container

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Done: lab-tools #199 (main 6b9d527): lpoco-bringup dt-check binding|dtbs. Proof: bringup/tests/dt_check.rs, 6 tests seen failing first (digest-only image, source :ro, output under --out, make options refused, checker failure ends 1 with its lines, docker ending before a verdict is an error). Not measured: a real container run with the verb (fake docker in tests); the digest to pin is alpine@sha256:020dfcba... (edge, 3 months old) - the caller names it with --image or LPOCO_DT_IMAGE. Release PR left for the owner.

Opened
: 2026-11-19

Needs
: build

Device
: google-walleye

Proof
: bringup/tests/dt_check.rs from fixtures: the verb names the image by digest (never a tag), mounts the kernel source read-only and writes output only under the given scratch dir, runs the two make targets with the given DT_SCHEMA_FILES / dtbs; a run on a fixture with a known schema error ends non-zero and names it (the negative test of docs research upstream-forks/2026-11-19/dt-checks-in-a-container.md)

Rank
: 6

About
: bringup-steps


<a id="reference-capture-diff"></a>
### lpoco-bringup reference capture and diff: what the stock OS does for a part, against our mainline boot

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: 2026-11-19, lab-tools-builder: landed (lab-tools #197, main a4095b8). lpoco-bringup reference capture --via CMD --out DIR (script on stdin: adb shell su 0 sh, ssh HOST sudo sh; saves devicetree.txt normalised as 'node prop = value', plus gpio, pinctrl, regulator_summary, clk_summary, interrupts, drivers; what the phone did not give is 'not measured yet', stale files removed) and reference diff PART --live DIR --ours DIR [--match WORDS] (exit 1 differences, 2 not known yet or a side unmeasured). Proof: bringup/tests/reference.rs (14, seen failing first), walleye's UFS fixture names core_clk_ice, ufs-qcom-crypto only live, power-domains only ours, interrupts 0x0 vs 0x4; the real capture script run by sh against a fake device-tree folder exits 0. Not run on a phone. Open (reviewer): phandles are one placeholder, not the target node's name or the specifier cells, and the list of phandle properties is partial (gpios, interrupts-extended, assigned-clocks...); interrupts and clk_summary lines carry counters and never match - normalise before use; root-node properties dropped; part filter matches node names only (touch needs --match); debugfs mount is done by the script and not undone; no timeout on the transport; the stage in the steps table is not wired.

Opened
: 2026-11-18

Needs
: build

Device
: google-walleye

Proof
: bringup/tests/reference.rs from fixtures: capture normalises a device-tree, gpio, pinctrl, regulator, clk, interrupts and driver-binding snapshot taken over adb or ssh (fixture dirs); diff PART filters both snapshots to one part's nodes, supplies, pins and clocks and names each difference; walleye's UFS case (research walleye-first-fastboot-boot/2026-11-18-ufs-android-way: live-ufs-props vs ours-ufs-props) is reproduced as a fixture and its known difference is named

Rank
: 7

About
: bringup-steps


<a id="bringup-init-finish"></a>
### The generic init's leftovers: shellcheck on its templates, lpoco-ffs-acm cross-built, ffs in the self-test

Project
: linux-phone-oco/lab-tools

Status
: open

Note
: Split from bringup-generic-init (done) so the picking query offers these on their own; the reviewer's caveat stands: an ffs function linked in both c.1 and c.2 is untested on hardware.

Opened
: 2026-11-19

Needs
: build

Device
: google-walleye

Proof
: CI runs shellcheck on every template lpoco-bringup writes (init, udhcpc.script, selftest.sh) and passes; lpoco-ffs-acm builds for aarch64-unknown-linux-musl in CI; selftest.sh with console = ffs checks the ffs function (usb_f_fs in modules.list) and fails without it

Rank
: 9

About
: bringup-generic-init


<a id="nura-relation"></a>
### How we relate to Nura (formerly postmarketOS): what we use, depend on and owe, and where it is recorded

Project
: linux-phone-oco/docs

Status
: done

Note
: Research nura-relation-how-it-stands, decision 2026-11-19-nura-relation; recorded as landscape nura, upstream nura-pmaports (alpine-aports made Alpine's alone); steps: apk-pages-origin-licence, built-on-nura-line, surya-base-image-named, lpoco-nura-names-one-place, nura-give-back-by-hand

Opened
: 2026-11-19

Proof
: tad q about --subject nura-relation shows the research, the decision and the five items


<a id="apk-pages-origin-licence"></a>
### The lab apk repository's page names each package's origin, licence and source, checked in CI

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: 2026-11-19: both halves met - the check (lab-tools #211, check-apk-origin.sh) and the page (conveyor v1.2.2, PR 22): the live page shows lpoco-health's licence, origin and source tag. The proof named sxmo-utils; it was retired from the pages the same day (sxmo-apk-retired), so the display stands on lpoco-health and on any package that returns.

Opened
: 2026-11-19

Needs
: build

Device
: xiaomi-surya

Proof
: the check fails on an APKBUILD with no license= or origin line and passes on packaging/; the published page shows sxmo-utils with AGPL-3.0-only, its origin and the tag's source link

Rank
: 5

About
: nura-relation


<a id="built-on-nura-line"></a>
### One line in each lab README: built on Nura (formerly postmarketOS), itself based on Alpine Linux

Project
: linux-phone-oco/docs

Status
: open

Note
: Research nura-relation-how-it-stands: no README of docs, surya-lab or google-walleye-lab names Nura; Mobian, Ubuntu and Nura itself name their parent in one line where a reader meets them. One line each in docs, surya-lab, lab-tools and device-template (walleye once it runs Nura), linking https://nura.eco/; no credits page. Each repository's owner lands its own line; docs' is orchestration's.

Opened
: 2026-11-19

Proof
: grep -l 'Nura' README.md finds the line in docs, surya-lab, lab-tools and device-template on origin/main

About
: nura-relation


<a id="surya-base-image-named"></a>
### Surya's base image named and kept: the Nura v26.06 image and U-Boot images by name, sha256 and URL, a copy outside surya-audio

Project
: linux-phone-oco/surya-lab

Status
: open

Note
: Research nura-relation-how-it-stands: surya was flashed from 20261030-1151-nura-v26.06-sxmo-de-sway-qcom-sm7150.img (2.8 GB) with u-boot-sm7150-xiaomi-surya-{huaxing,tianma}.img; the only copies sit in ~/Projects/surya-audio, a tree queued for cleanup (surya-lab's surya-audio-cleanup), and Nura's image server keeps recent builds only. Record name, sha256 and origin URL in surya-lab (README or device.toml comment), move the files to a kept place before that cleanup. No phone.

Opened
: 2026-11-19

Proof
: sha256sum of the kept image equals the one recorded in surya-lab on origin/main

About
: nura-relation


<a id="lpoco-nura-names-one-place"></a>
### The Nura names lpoco relies on in one place, and lpoco lab kernel reads the phone's own entry name

Project
: linux-phone-oco/lab-tools

Status
: open

Note
: Research nura-relation-how-it-stands: devlab/src/kernel.rs, outcome.rs and mcp.rs hard-code boot-deploy's pmos.conf, pmos_boot_uuid, /pmOS_init.log and the title postmarketOS (test entries sort before it); guard.rs and fastboot.rs 172.16.42.1 and 18d1:d001. Nura's rename of user-facing strings is announced, not dated (PMCR 0006). Gather them as named constants in one module, and have kernel install take the base entry from the phone (the one LoaderEntryDefault names) rather than pmos.conf, so a renamed entry is said, not misread.

Opened
: 2026-11-19

Proof
: a unit test: with the base entry named nura.conf and the title Nura, kernel install writes a one-try entry from it and the sort test still puts 0-test- first

Rank
: 10

About
: nura-relation


<a id="nura-give-back-by-hand"></a>
### Giving back to Nura, by the author himself: what he may do, what agents may and may not prepare

Project
: linux-phone-oco/docs

Status
: open

Note
: Nura forbids contributions fully or in part created by generative AI (source nura-ai-policy); the CoC names using it, the wiki rules name AI-assisted writing. Agents prepare nothing headed to Nura - no draft issue, report, test result text, patch or wiki line, not even for him to send. Agents may keep our own measurements in our own public places (docs, the labs). The author, if he wants: join the Testing Team and test sm7150 merge requests on surya with mrtest; report in his own words what he has seen on surya; write the surya wiki page facts himself. Not a promise: an option he takes or leaves.

Opened
: 2026-11-19

Waits
: the author: every act toward Nura is his own, in his own words

Proof
: the author's word: taken (his own act, recorded as an upstream item to nura-pmaports in state sent) or left (this item closed)

About
: nura-relation


<a id="dt-check-verdict-from-output"></a>
### dt-check: the verdict comes from the schema's output, dtbs runs defconfig, the image bakes dtschema

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Done 2026-11-19, lab-tools-builder: lab-tools #205 (main), released v0.22.1 (#206). bringup/tests/dt_check.rs, seen failing first: a violation printed with make exit 0 is failed (1) with lines named; make failing with none named is a setup error (2); dtbs on a fresh --out runs defconfig first; an already built dtb is removed so its check reruns (reviewer's catch); yamllint lines count; enabled node checked, disabled not (fake docker, not real dtschema). The container no longer apk-adds: bringup/dt-check/Dockerfile bakes the tools. Not measured: no real container run, and the image is not built or pushed yet - see dt-check-image-published.

Opened
: 2026-11-19

Needs
: build

Device
: google-walleye

Proof
: bringup/tests/dt_check.rs: a fixture whose output carries a schema violation ('.dtb: ... Unevaluated properties are not allowed') while make exits 0 is reported failing with the lines named (fails on main today: 'dt-check: clean'); dtbs on a fresh --out runs make defconfig in O= first (or reports a setup error, never 'checker failed'); the image named by digest contains py3-dt-schema and the build tools (no apk add at run time); a fixture with an enabled pm8998/pm6150 node is checked

Rank
: 1

About
: bringup-steps


<a id="base-distro"></a>
### Which distribution our phones build on, so that we never maintain our own OS

Project
: linux-phone-oco/docs

Status
: in-progress

Note
: Researched 2026-11-19 (base-distro-candidates, base-distro-how-it-stands): recommended staying on Nura with a thin device layer in our own apk repository; walleye starts on the same base. Next: the author's word; then the open items about base-distro.

Opened
: 2026-11-19

Waits
: the author's word on decision 2026-11-19-base-distro


<a id="walleye-rootfs-on-our-layer"></a>
### walleye's first root filesystem: Alpine 3.24 / Nura v26.06 userland with walleye's own kernel and device packages from its lab's apk repository, built by the conveyor, no pmaports fork

Project
: linux-phone-oco/google-walleye-lab

Status
: open

Note
: Decision 2026-11-19-base-distro as amended by 2026-11-19-base-distro-any-arm-base: Nura/Alpine by default (it saves walleye the Qualcomm daemons, phone scripts and the boot.img rewrite; one apk lane), but walleye's layer is ours on any base, so the author may set Debian instead. After walleye's own boot images reach a shell, test layer first (walleye-rootfs-test-layer-first). Next: the author's word, then the walleye builder's look-around.

Opened
: 2026-11-19

Waits
: the author's word on decision 2026-11-19-base-distro

Needs
: build

Device
: google-walleye

Proof
: on walleye, booted from this root filesystem: root-writable and no-failed-units pass, and apk policy names the kernel and device packages from the lab repository

About
: base-distro


<a id="mobian-sm7150-offphone"></a>
### Mobian's SM7150 family measured off the phone: build the surya image from mobian-recipes on the lab machine, flash nothing

Project
: linux-phone-oco/docs

Status
: open

Note
: Settles the fallback's biggest unknown cheaply (decision 2026-11-19-base-distro): kernel 6.18.51 and sm7150-support are in staging only, no image is published, the branch idle since 2026-09-13. Next: a builder runs the recipe and records the result.

Opened
: 2026-11-19

Needs
: build

Device
: xiaomi-surya

Proof
: a research row about base-distro naming the built image's kernel version, the packages from staging, whether the recipe builds unchanged, and what boots surya would need (U-Boot or not); the phone untouched

About
: base-distro


<a id="base-distro-triggers"></a>
### Re-check the triggers that reopen the base question: Alpine's AI policy (council #697/#703), Nura's qcom-sm7150 category, Mobian's SM7150 suite and images

Project
: linux-phone-oco/docs

Status
: open

Note
: Decision 2026-11-19-base-distro names them. Next: re-check at Nura's next release (end of 2026) or when #697 closes, whichever is first.

Opened
: 2026-11-19

Proof
: a dated research row about base-distro with the three readings and their sources; a fired trigger opens a new decision

About
: base-distro


<a id="device-facts-as-data"></a>
### Each lab base keeps the facts its device packages use as data - kernel tag and config fragment, boot image addresses, firmware list - so packaging for another base is generated, not rediscovered

Project
: linux-phone-oco/device-template

Status
: open

Note
: Carried by decision 2026-11-19-device-layer-declared-once if the author says yes: the facts live in device.toml [layer] (item layer-table-in-manifest), typed in lpoco-manifest, and every format is generated from them

Opened
: 2026-11-19

Waits
: the author's word on decision 2026-11-19-base-distro

Proof
: surya-lab and google-walleye-lab each answer one query with their kernel tag, config fragment, boot addresses and firmware list, and their APKBUILDs read them

About
: base-distro


<a id="shell-past-glue-into-rust"></a>
### docs's shell past glue moves to Rust as each file is touched

Project
: linux-phone-oco/docs

Status
: done

Note
: Closed, not done (2026-11-19): the author reversed it, verbatim - 'i dont think its necessary, too much work.. if we dont rely on it much i say we leave them as is for now'. Existing shell stays as it is, with no migration and no move-when-touched rule. What stays is practice 21: a new script with logic starts in Rust.

Opened
: 2026-11-19

Proof
: a file touched after 2026-11-19 that holds logic (parsing, loops over data, functions) is Rust (rust-script for a single file); a count of shell lines in docs only falls


<a id="shell-past-glue-into-rust"></a>
### lab-tools's shell past glue moves to Rust as each file is touched

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Closed, not done (2026-11-19): the author reversed it, verbatim - 'i dont think its necessary, too much work.. if we dont rely on it much i say we leave them as is for now'. Existing shell stays as it is, with no migration and no move-when-touched rule. What stays is practice 21: a new script with logic starts in Rust.

Opened
: 2026-11-19

Proof
: a file touched after 2026-11-19 that holds logic (parsing, loops over data, functions) is Rust (rust-script for a single file); a count of shell lines in lab-tools only falls


<a id="test-layer"></a>
### Hardware tests run in a layer with no phone shell; the shell is a later layer tested on its own (the author's proposal, 2026-11-10 and 2026-11-19)

Project
: linux-phone-oco/docs

Status
: open

Note
: Research lead test-layer-research: measured sxmo's cost, recommended the split (decision 2026-11-19-hardware-test-layer), waiting on the author's word. Carries surya-lab shell-free-base. Next: the author's word, then surya-test-layer-entry.

Opened
: 2026-11-19

Proof
: test-layer-quiet


<a id="surya-test-layer-entry"></a>
### surya boots its hardware-test layer: a second boot entry, the same image at multi-user.target, the sxmo entry kept

Project
: linux-phone-oco/surya-lab

Status
: open

Note
: Carries surya-lab shell-free-base. First, read only: systemctl get-default; what graphical.target alone pulls in (systemctl list-dependencies graphical.target vs multi-user.target); which suite checks need the user session (pipewire, wireplumber are user services). Then one entry beside the stock one through lpoco's test-kernel route (boot counting, fallback to the sxmo entry): same kernel, dtb and root, systemd.unit=multi-user.target. Boot it once, run the suite: test-layer-quiet passes and the base layer passes as under sxmo (29 of 29 outside known gaps); audio checks that need the session say so, they are not hidden. lpoco-awake stays enabled. No suspend in this item.

Opened
: 2026-11-19

Blocked by
: health-test-layer-quiet

Needs
: phone

Device
: xiaomi-surya

Proof
: test-layer-quiet

About
: test-layer


<a id="surya-test-layer-default"></a>
### The test layer is surya's default boot; the sxmo entry is chosen for shell tests only

Project
: linux-phone-oco/surya-lab

Status
: open

Note
: After surya-test-layer-entry passes. The watch's boots land in the test layer (test-layer-quiet passes on every boot report); suspend items (health-suspend-cycle-proof, sleep-standby-current r5, sensors-across-suspend) drop their 'sxmo autosleep stopped first' step and run there. The shell entry stays and is chosen by the shell-stage items.

Opened
: 2026-11-19

Blocked by
: surya-test-layer-entry

Needs
: phone

Device
: xiaomi-surya

Proof
: test-layer-quiet

About
: test-layer


<a id="surya-sxmo-from-nura"></a>
### surya runs Nura's own sxmo-utils again, not sxmo-utils@lab

Project
: linux-phone-oco/surya-lab

Status
: done

Note
: Done: surya-lab PR 356 - sxmo-utils 1.18.1-r4 from Alpine community, no @lab package installed, suite healthy (82 pass).

Opened
: 2026-11-19

Needs
: phone

Device
: xiaomi-surya

Proof
: shell-up

Rank
: 1

About
: test-layer


<a id="sxmo-apk-retired"></a>
### lab-tools stops building sxmo-utils: packaging/sxmo-utils, its CI check and its Pages entry go

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: 2026-11-19, conveyor-builder: conveyor v1.2.2/v1.2.3 (retire: [alpine] retire in the declaration, and a call input for a retirement newer than the release tag), lab-tools #215 (retire line) and #216 (packages workflow_dispatch input retire); run 44466561032 with retire=sxmo-utils: the live page and APKINDEX list lpoco-health only, the sxmo-utils apk and its record answer 404. Left: the retire line in packaging/conveyor.toml stays until sxmo-utils is shipped again, then it must go.

Opened
: 2026-11-19

Blocked by
: surya-sxmo-from-nura

Needs
: build

Device
: xiaomi-surya

Proof
: lab apk repository lists no sxmo-utils (CI check)

Rank
: 1

About
: test-layer


<a id="sxmo-fork-retired"></a>
### Retire the sxmo fork: grenudi/sxmo-utils archived with its history, its three upstream items withdrawn, fork tracking stops

Project
: linux-phone-oco/docs

Status
: open

Note
: Items sxmo-autosuspend-backoff, sxmo-suspend-stop-by-profile, sxmo-surya-sensors-suspend: state withdrawn, carried-in none (SourceHut's terms bar agent-made patches; the author may send his own by hand). fork-tracking-job drops fork-sxmo-utils. Archive (read-only) on GitHub is the author's or orchestration's act; the tag lab-20261118.1 and the topics stay as history. The surya profile is upstream (1fd7822) and is not touched.

Opened
: 2026-11-19

Blocked by
: sxmo-apk-retired

Proof
: tad q carried lists no fork-sxmo-utils item; upstream items withdrawn, carried in none

About
: test-layer


<a id="awake-not-a-workaround"></a>
### lpoco-awake is the lab's policy, not a WORKAROUND(sxmo-autosuspend-backoff): the mark and the item's local-ref go

Project
: linux-phone-oco/lab-tools

Status
: open

Note
: A lab phone on USB stays awake unless a test asks, in every layer; the bluetooth-not-up gate stays for allow-autosleep runs. Retire the stale devlab-usb-awake declaration with host-check-stale-pieces (surya-lab). Proof: awake-wakelock-held passes; scripts/workarounds no longer lists it.

Opened
: 2026-11-19

Blocked by
: sxmo-fork-retired

Needs
: build

Device
: xiaomi-surya

Proof
: awake-wakelock-held

Rank
: 5

About
: test-layer


<a id="suspend-cycle-stops-services"></a>
### lpoco-health suspend cycle stops the services the manifest names before a suspend and starts them after (sensorspd on surya)

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: 2026-11-19, lab-tools-builder: done (lab-tools #209, main f998e51). [health] suspend_stop (units) -> SUSPEND_STOP; lpoco-health suspend cycle stops the active ones before the alarm is armed, starts them back last-stopped-first after the wake (also after a cut-off cycle, via stopped.json); report has stopped/not_stopped/not_started, not_started fails the run. Proof: health/tests/suspend_cycle.rs (stopped before the suspend, started after, inactive left alone, refused stops nothing, stale started by next) seen failing first. Open: no device declares suspend_stop yet (surya's device.toml needs suspend_stop=[sensorspd] and the test sensors-after-suspend re-said without 'under Sxmo'); unit names unparsed (suspend_quiet likewise); reverse dependents of a stopped unit are not restarted; no phone run.

Opened
: 2026-11-19

Needs
: build

Device
: xiaomi-surya

Proof
: sensors-after-suspend

Rank
: 3

About
: test-layer


<a id="steps-shell-stage-split"></a>
### Bring-up steps: the shell's own sleep goes to the shell stage; a lab step test-layer-boots; standby measured first in the test layer

Project
: linux-phone-oco/docs

Status
: done

Note
: Done 2026-11-19: test-layer-boots added (lab, proof test-layer-quiet); shell stage moved last before the goals and carries shell-autosleep-tamed, real-suspend-under-shell, alarm-wakes-from-sleep, auto-rotate-follows, brightness-follows-light, proximity-blanks-in-call, days-without-reboot (ids kept); the shape check fails on a hardware step that needs a shell step. standby-current needs s2idle-cycle-returns and suspend-way-back hard, its edge on the shell removed (not soft). Lanes: claim the new test-layer-boots; no id changed.

Opened
: 2026-11-19

Needs
: build

Device
: xiaomi-surya

Proof
: tad q bringup-chain: test-layer-boots in stage lab with proof test-layer-quiet; shell-autosleep-tamed in stage shell

Rank
: 1

About
: test-layer


<a id="walleye-rootfs-test-layer-first"></a>
### walleye's first root filesystem is a test layer: no UI package, tty and ssh, lpoco-health

Project
: linux-phone-oco/google-walleye-lab

Status
: open

Note
: Decision 2026-11-19-hardware-test-layer point 5 on walleye-rootfs-on-our-layer (decision 2026-11-19-base-distro): build it with no postmarketos-ui-* package (ui=none or console), sshd from the base, lpoco-health and lpoco-awake; a shell comes later in the shell stage. Its bare init stays for the boot, console and kernel stages.

Opened
: 2026-11-19

Blocked by
: walleye-rootfs-on-our-layer

Needs
: build

Device
: google-walleye

Proof
: test-layer-quiet

About
: test-layer


<a id="health-test-layer-quiet"></a>
### lpoco-health base check test-layer-quiet, and each report says which layer the phone booted (test or shell)

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Done 2026-11-19, lab-tools-builder (lab-tools #207, main 451e1fe): base check 95-test-layer.sh (test-layer-quiet); LPOCO_BOOTED (test|shell|unknown: cmdline systemd.unit=multi-user.target, then the shell that runs) reaches the checks and every row carries booted. Test boot + shell process fails and names it; shell boot skips; unknown skips 'not known yet'. Proof: health/tests/test_layer_quiet.rs (seen failing first: no such check) and main.rs unit tests. Not yet on surya: the entry that boots the test layer is surya-test-layer-entry; until then the step reads unknown. Shell names are in the script, not the manifest (no SHELL_PROCS: reviewer found no source for it).

Opened
: 2026-11-19

Needs
: build

Device
: xiaomi-surya

Proof
: test-layer-quiet

Rank
: 2

About
: test-layer


<a id="agnostic-layer"></a>
### A distro-agnostic device layer: each phone's kernel, dtb, firmware, UCM, config and boot glue described once and packaged for any base (apk, deb, rpm, pkg), contributed upstream first

Project
: linux-phone-oco/docs

Status
: in-progress

Note
: Researched 2026-11-19 (agnostic-layer-how-it-stands); decision 2026-11-19-device-layer-declared-once waits on the author's word; then the items about agnostic-layer, first lpoco-layer-pack's failing test

Opened
: 2026-11-19

About
: base-distro


<a id="layer-table-in-manifest"></a>
### lpoco-manifest declares [layer]: files with kind and /usr destination, dependency tokens, kernel (tree, tag, config fragment, dtbs), boot method, firmware method, early modules; schema projected

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: 2026-11-19, lab-tools-builder: done (lab-tools #212). [layer] typed in manifest/src/layer.rs: name, needs tokens, kernel (tree, tag, config, dtbs), boot method (efi-kernel-install, android-bootimg needs [boot]), firmware method (extract-from-partitions, files), initramfs modules, [[layer.file]] with kind and plain unique /usr destination. Proof: manifest/tests/schema.rs layer tests (seen failing first) and schema_is_current. Next: lpoco-layer-pack, surya-layer-declared, walleye-layer-declared.

Opened
: 2026-11-19

Needs
: build

Device
: xiaomi-surya

Proof
: manifest tests: a fixture with [layer] parses, an unknown [layer] field is refused, device.schema.json equals the types

Rank
: 6

About
: agnostic-layer


<a id="lpoco-layer-pack"></a>
### lpoco layer pack --format apk|deb|rpm|archlinux: an nfpm config from [layer] with the dependency token map, systemd presets, initramfs drop-ins (mkinitfs, initramfs-tools, dracut, mkinitcpio), Nura deviceinfo, /usr/lib/kernel/devicetree

Project
: linux-phone-oco/lab-tools

Status
: in-progress

Note
: 2026-11-19, lab-tools-builder: slice 1 landed (lab-tools #217): lpoco layer pack --format apk|deb|rpm|archlinux writes NAME-config (declared files + /usr/lib/kernel/devicetree) and NAME-boot (not apk: systemd preset, initramfs hook/dracut/mkinitcpio drop-in), nfpm config each, nfpm packs. Proof layer/tests/pack.rs; research test-layer-apk-and-deb.sh passes with real nfpm on a fixture. Slice 2 landed (lab-tools #219): check() refuses efi-kernel-install without [layer.kernel] dtbs, and an initramfs module name that is not one word (not for apk, which writes none); stale() removes a NAME-config/-boot of the same version this run no longer makes. Proof: pack.rs a_layer_that_cannot_be_packed_right_is_refused_before_anything_is_written, a_boot_package_an_earlier_run_left_is_named_when_this_format_makes_none (seen failing first). surya-lab main's real [layer] (PR 364) writes its xiaomi-surya-config nfpm config (no nfpm on this machine, so not packed). Open: preset scriptlet (systemctl preset), per-base dependency token map, kernel package linux-NAME (surya moves [layer.kernel] to an exact commit + config fragment), mkinitfs for apk, Nura deviceinfo, pack() test with a fake nfpm, stale only matches the same version, module-name rule could move to manifest Layer::validate, packing surya's real declaration with real nfpm. Slice 3 landed (lab-tools #221, main 753ae63): layer/tests/pack_run.rs runs the real binary against a stand-in nfpm: packager/target per format, a failing nfpm stops with exit 2 and the config kept, a missing nfpm named (failing case seen failing with the status check removed). 2026-11-19, lab-tools-builder: slice 4 landed (lab-tools #223, main 2d3957b): the -boot package (deb, rpm, archlinux) carries a postinstall that runs systemctl preset for the layer's units, on first install only (deb $2 empty, rpm $1 = 1), also in a chroot (guard: command -v systemctl), and depends on NAME-config so the units are unpacked first; check() refuses a unit name outside letters, digits and _-.@: (it goes into a root script). Proof: layer/tests/pack.rs the_boot_package_applies_its_preset_after_install_and_follows_the_config_package, a_unit_name_that_would_run_as_root_in_the_scriptlet_is_refused, the_preset_runs_on_first_install_only_in_each_format_and_also_in_a_chroot (seen failing first). Open now: per-base dependency token map, kernel package linux-NAME, mkinitfs for apk, Nura deviceinfo, rpm/arch scriptlets not run on a real package manager, pack_run.rs does not assert the written postinstall. 2026-11-19, lab-tools-builder: slice 5 landed (lab-tools #225, main 5225163): the per-base dependency token map is device.toml [layer.names.apk|deb|rpm|archlinux] token = "that format's package name"; the -config package's depends are named through it, the version bound kept, a token not listed keeps its name; the manifest refuses a map for a token layer.needs lacks and a name that is not one word without < > =. Proof: layer/tests/pack.rs a_dependency_token_is_named_per_format_by_the_layers_map_and_kept_when_unmapped, a_name_map_for_a_token_the_layer_does_not_need_is_refused (seen failing first: unknown field names); device.schema.json regenerated. Open now: kernel package linux-NAME, mkinitfs for apk, Nura deviceinfo, rpm/arch scriptlets not run on a real package manager, pack_run.rs does not assert the written postinstall, surya declares no [layer.names] yet. 2026-11-19, lab-tools-builder: slice 6 landed (lab-tools #227, main 681c95d): layer/tests/pack_run.rs the_boot_package_is_packed_with_the_postinstall_the_run_wrote runs the binary with a unit and reads what the stand-in nfpm was given: the postinstall file exists with systemctl preset and the config names it. Caveat: its mutation check was weak (a renamed scripts: key still matched the asserted line), so the test pins the path and body, not the key's name. pack_run no longer open; the rest stands as in slice 5. 2026-11-19, lab-tools-builder: slice 7 landed (lab-tools #229, main 0784c72): lpoco layer pack --kernel-build DIR (a finished build: Image, kernel.release, dtbs/, optional modules/) also packs linux-NAME for arm64: /usr/lib/modules/REL/vmlinuz, declared dtbs under .../REL/dtb/ (the path /usr/lib/kernel/devicetree names), the module tree as an nfpm tree keeping its file modes; a missing Image/dtb, a release that is not one word, a modules/ holding vmlinuz or dtb are refused; a stale linux-NAME is named when no build is given. Proof: layer/tests/pack.rs the_kernel_package_lays_out_what_kernel_install_reads_and_is_arm64, a_kernel_build_that_cannot_be_packed_right_is_refused_and_says_why, the_modules_tree_keeps_its_own_file_modes_and_a_clash_with_the_kernels_files_is_refused, a_kernel_package_an_earlier_run_left_is_stale_when_no_build_is_given_now, pack_run.rs a_kernel_build_given_is_packed_as_linux_name_for_arm64 (seen failing first; review caught the tree mode 0755 bug, fixed). Open now: building the kernel from [layer.kernel] tree and tag (the package takes a finished build), version tied to kernel release, symlinks in modules/, Arch enum for arm64, who runs kernel-install add, nothing run with real nfpm. mkinitfs for apk: built on lab-tools branch builder-layer-mkinitfs (unlanded, orchestration said leave it); review found its .modules file must list module paths relative to /lib/modules/KERNELVERSION/ (not bare names), the scriptlet untested and silent on odd features= lines, no mkinitfs dependency; redo before landing. Nura deviceinfo still open. 2026-11-19, lab-tools-builder: slice 8 landed (lab-tools #231, main 2fb8637): mkinitfs for apk redone from the parked branch: apk gets NAME-boot with /etc/mkinitfs/features.d/NAME.modules as globs mkinitfs matches under /lib/modules/KERNEL (it globs each line, so a bare name matches nothing; depth 1-8, both - and _ spellings), a postinstall adding NAME to features in mkinitfs.conf once (warns, by hand, on a missing conf or no one-line features=), dependency on mkinitfs; README updated. Proof: layer/tests/pack.rs apk_names_its_modules_as_mkinitfs_reads_them_and_turns_the_feature_on_once (globs run against a fake module tree incl. 7-deep, .xz, decoys; scriptlet run on first/middle/alone/prefix/dotted-name/missing cases; seen failing with bare names, with dot unescaped, with depth cap 6). Review caught depth cap, regex dot, README. Not covered: busybox ash run, tab in features, several features= lines (all lines edited), apk upgrade re-trigger. Open now: Nura deviceinfo, kernel from [layer.kernel], symlinks in modules/, Arch enum for arm64, rpm/arch scriptlets on a real package manager, surya declares no [layer.names] yet. 2026-11-19, lab-tools-builder: slice 9 landed (lab-tools #233, main 1653146): --kernel-build refuses a modules/ symlink that is absolute, climbs out of the tree, or has a .. after a name (build/source links would dangle on the phone), and a modules/ that is itself a link; a link inside the tree is kept. Proof: layer/tests/pack.rs a_modules_symlink_that_leaves_the_tree_is_refused_and_one_inside_is_kept (seen failing first), a_link_that_climbs_out_through_another_link_or_a_linked_modules_folder_is_refused (written with the review's fix, not seen failing alone). Review caught the climb-through-another-link hole, a sticky flag and the error path. Open now: Nura deviceinfo, kernel from [layer.kernel], Arch enum for arm64, rpm/arch scriptlets on a real package manager, surya declares no [layer.names] yet. 2026-11-19, lab-tools-builder: slice 10 landed (lab-tools #235, main edd6b0f): Nura's deviceinfo: for apk NAME-config holds /etc/deviceinfo (the override of the device package's file) from [boot] and [device]: codename, arch aarch64, header_version, generate_bootimg, pagesize, flash offsets (0x%08x), kernel_cmdline; a codename or cmdline a shell would run (quote, $, backtick, backslash, newline) is refused before anything is written; a layer without files keeps its needs on the config package. Proof: layer/tests/pack.rs nura_gets_the_phones_deviceinfo_from_boot_and_the_others_do_not, a_cmdline_a_shell_would_run_is_refused_in_the_deviceinfo, a_codename_a_shell_would_run_is_refused_and_the_file_sources_to_what_is_declared (sources the file with sh), a_layer_without_files_still_gets_its_dependencies...; pack_run.rs apk_packs_the_deviceinfo_from_boot_and_deb_does_not (seen failing with the wiring off). Review caught codename injection and lost needs, fixed. Open now: pmaports marks deviceinfo_kernel_cmdline obsolete for /usr/lib/kernel-cmdline.d/*.conf (boot-deploy 0.24 not confirmed to ignore it: write the .d file too), flash_method and dtb not written, no name/manufacturer, kernel from [layer.kernel], Arch enum for arm64, rpm/arch scriptlets on a real package manager, surya declares no [layer.names] yet. 2026-11-19, lab-tools-builder: slice 11 landed (lab-tools #237, main 4d24d96): for apk, NAME-config also carries /usr/lib/kernel-cmdline.d/50-NAME.conf (the [boot] cmdline, one line), written by add_deviceinfo beside /etc/deviceinfo (the deviceinfo key stays: boot-deploy 0.24 not confirmed to ignore it, so a cmdline doubled on the boot image is not ruled out). Proof: layer/tests/pack_run.rs apk_also_writes_the_cmdline_as_a_kernel_cmdline_d_file (seen failing first). Review moved it into add_deviceinfo (no call-order hazard). Not covered: the layer declaring that same path itself (duplicate dst, as for /etc/deviceinfo). Open now: confirm boot-deploy with both, flash_method and dtb not written, kernel from [layer.kernel], Arch enum for arm64, rpm/arch scriptlets on a real package manager, surya declares no [layer.names] yet.

Opened
: 2026-11-19

Blocked by
: layer-table-in-manifest

Needs
: build

Device
: xiaomi-surya

Proof
: docs research/base-distro/2026-11-19-agnostic-layer/test-layer-apk-and-deb.sh passes for surya

Rank
: 7

About
: agnostic-layer


<a id="layer-test-in-lab-tools"></a>
### The failing test test-layer-apk-and-deb.sh moved from docs' research material into lab-tools' suite, run by CI and reported unknown until lpoco-layer-pack lands

Project
: linux-phone-oco/lab-tools

Status
: open

Opened
: 2026-11-19

Blocked by
: layer-apk-via-nfpm

Needs
: build

Device
: xiaomi-surya

Proof
: lab-tools CI runs the test on every change; it reads fail before lpoco-layer-pack and pass after

Rank
: 9

About
: agnostic-layer


<a id="surya-layer-declared"></a>
### surya's device layer declared in device.toml [layer]: UCM, pd-mapper modprobe, way-back sysctl, call units and scripts move from [[flash.overlay]]; lab-only overlays stay

Project
: linux-phone-oco/surya-lab

Status
: open

Opened
: 2026-11-19

Proof
: docs research/base-distro/2026-11-19-agnostic-layer/test-layer-apk-and-deb.sh passes against surya-lab; the remaining overlays are lab-only

About
: agnostic-layer


<a id="walleye-layer-declared"></a>
### walleye's device layer declared in device.toml [layer], boot method android-bootimg from [boot]'s addresses

Project
: linux-phone-oco/google-walleye-lab

Status
: open

Opened
: 2026-11-19

Proof
: the same test run against google-walleye-lab passes

About
: agnostic-layer


<a id="layer-apk-via-nfpm"></a>
### The conveyor's apk lane takes an nfpm-made apk (packed unsigned, signed in the signing container); settles nfpm against Alpine 3.24's apk-tools

Project
: linux-phone-oco/lab-tools

Status
: open

Opened
: 2026-11-19

Blocked by
: lpoco-layer-pack

Needs
: build

Device
: xiaomi-surya

Proof
: the layer's apk installs at its version in a clean alpine:3.24 container from the published repository

Rank
: 8

About
: agnostic-layer


<a id="conveyor-deb-lane"></a>
### The conveyor gains a deb lane (the conveyor's owner, linux-package-distribution-oco): nfpm deb, a signed apt repository on pages, an install test

Project
: linux-phone-oco/lab-tools

Status
: open

Opened
: 2026-11-19

Blocked by
: layer-apk-via-nfpm

Needs
: build

Device
: xiaomi-surya

Proof
: the layer's deb installs at its version in a clean debian:trixie container from the published repository

Rank
: 10

About
: agnostic-layer


<a id="conveyor-rpm-lane"></a>
### The conveyor gains an rpm lane (the conveyor's owner): nfpm rpm, createrepo_c, rpmsign, an install test - when a device asks for Fedora

Project
: linux-phone-oco/lab-tools

Status
: open

Opened
: 2026-11-19

Waits
: a device asks for this format (decision 2026-11-19-device-layer-declared-once: rpm and arch only on demand)

Needs
: build

Device
: xiaomi-surya

Proof
: the layer's rpm installs at its version in a clean fedora container from the published repository

About
: agnostic-layer


<a id="layer-archlinux-on-pacman-lane"></a>
### The conveyor's pacman lane takes nfpm-made archlinux packages (repo-add) - when a device asks for Arch

Project
: linux-phone-oco/lab-tools

Status
: open

Opened
: 2026-11-19

Waits
: a device asks for this format (decision 2026-11-19-device-layer-declared-once: rpm and arch only on demand)

Needs
: build

Device
: xiaomi-surya

Proof
: the layer's package installs with pacman in a clean archlinux:arm container from the published repository

About
: agnostic-layer


<a id="bootimg-trigger-per-base"></a>
### walleye's boot.img rewrite on kernel upgrade, one script with a trigger per base: kernel-install plugin (Fedora, Arch, Debian with systemd-boot), qcom-phone-utils on Debian, boot-deploy via deviceinfo on Nura

Project
: linux-phone-oco/lab-tools

Status
: open

Opened
: 2026-11-19

Needs
: build

Device
: xiaomi-surya

Proof
: in a container per base, installing a new kernel package leaves a boot.img that lpoco bringup image check accepts with the dtb appended

Rank
: 11

About
: agnostic-layer


<a id="layer-export-makefile"></a>
### lpoco layer export: a source tarball with the layer's tree and an Asahi-style Makefile (install, install-alpine, install-debian, install-fedora, install-arch) for a distribution's own packager

Project
: linux-phone-oco/lab-tools

Status
: open

Opened
: 2026-11-19

Needs
: build

Device
: xiaomi-surya

Proof
: make install DESTDIR=x from the tarball yields the deb's file list

Rank
: 13

About
: agnostic-layer


<a id="upstream-policies-measured"></a>
### The AI-assisted contribution policy of each upstream of the layer, read at source: alsa-ucm-conf, linux-firmware, systemd, U-Boot, feedbackd-device-themes, DebianOnMobile (qcom-phone-utils, droid-juicer), Arch/ALARM

Project
: linux-phone-oco/docs

Status
: open

Opened
: 2026-11-19

Proof
: each upstream row in docs names its policy with a source; the upstream-first table in the material has no 'not known yet'

About
: agnostic-layer


<a id="bringup-step-layer-packaged"></a>
### A generic bring-up step device-layer-packaged (stage upkeep, helper lpoco layer pack, the format an argument) for orchestration to add to the catalogue

Project
: linux-phone-oco/docs

Status
: open

Opened
: 2026-11-19

Proof
: tad q bringup-chain lists device-layer-packaged, unknown for surya and walleye until claimed

About
: agnostic-layer


<a id="firmware-extract-declared"></a>
### [layer.firmware] extract-from-partitions packed as a droid-juicer entry (deb, rpm, archlinux) and an msm-firmware-loader config (apk), never the OEM-signed blobs themselves

Project
: linux-phone-oco/lab-tools

Status
: open

Opened
: 2026-11-19

Needs
: build

Device
: xiaomi-surya

Proof
: the test's packages hold the extractor's entry for surya and no file under /lib/firmware signed by the OEM

Rank
: 12

About
: agnostic-layer


<a id="dt-check-image-published"></a>
### dt-check's baked image built on the lab and run for real (publishing waits on the author's registry)

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: Local half done 2026-11-19: baked image built on the lab, real run proven (clean on enabled pm8998/pm6150 watchdog nodes; bogus-prop named, 3 violations, exit 1; binding clean); pin lpoco-dt-check@sha256:632e25f8b283316564bbe54d2a9d80be74276870361ec4f506d334a39e7bd1d2 (local id, lab only). Not done: publishing, on the author naming a registry (ghcr.io/linux-phone-oco or none).

Opened
: 2026-11-19

Needs
: build

Device
: google-walleye

Proof
: a real dt-check dtbs run with the pushed image names a bogus property's violation and exits 1

Rank
: 1

About
: bringup-steps


<a id="layer-install-test-per-distro"></a>
### CI installs each phone's packages into a clean container of every enabled distribution, then runs the health suite

Project
: linux-phone-oco/lab-tools

Status
: open

Note
: The author, with his yes to decision 2026-11-19-device-layer-declared-once ('ok, sounds good'), on how it stays organized (through the Top Coordinator, 2026-11-19): CI per change builds each phone's packages in every enabled format and installs them into a clean container of that distribution; the phone's health suite runs after installing from each repository.

Opened
: 2026-11-19

Blocked by
: layer-test-in-lab-tools

Needs
: build

Device
: xiaomi-surya

Proof
: per change, CI packs each declared phone's layer in every enabled format, installs it into a clean container of that distribution (alpine, debian, ...), and checks every declared file is in place; the phone's health suite runs after installing from each published repository. Grows from test-layer-apk-and-deb.sh. Fails while a format's install leaves a declared file out

Rank
: 9

About
: agnostic-layer


<a id="site-packaged-and-upstream"></a>
### The site shows, per phone, which distributions it is packaged for and which layer pieces are already upstream

Project
: linux-phone-oco/docs

Status
: open

Note
: The author's second part of 'how it stays organized' (with his yes to decision 2026-11-19-device-layer-declared-once): the site and the steps view show per phone which distributions it is packaged for and which layer pieces are already upstream, derived from the data.

Opened
: 2026-11-19

Needs
: build

Device
: xiaomi-surya

Proof
: the steps view (or its own view) shows per phone a row of the formats/repositories its layer is published in and, per layer piece (kernel, dtb, firmware, UCM, udev, boot glue), whether it is upstream (from upstream_items) - derived from the data, a make verify check that every declared phone appears

About
: agnostic-layer


<a id="conveyor-site-origin-licence"></a>
### The conveyor's published page lists each package's licence, origin and source link

Project
: linux-phone-oco/docs

Status
: done

Note
: 2026-11-19, conveyor-builder: conveyor PR 22 (v1.2.2): each package on the apk page has its licence (index L:), project url, origin (the APKBUILD's '# Origin:' line) and exact source (source= as abuild expands it, plus the APKBUILD folder at the release tag), derived, kept per package in origins/NAME.json; tests/alpine/run.sh proves it. Seen on https://linux-phone-oco.github.io/lab-tools/ for lpoco-health (MIT OR Apache-2.0, tag lpoco-health-v0.24.0). The sxmo-utils proof is moot: it left the pages (sxmo-apk-retired).

Opened
: 2026-11-19

Needs
: build

Device
: xiaomi-surya

Proof
: the published lab-tools page shows sxmo-utils with AGPL-3.0-only, its '# Origin:' line and the tag's source link

About
: nura-relation


<a id="lpoco-health-suspend-trace-hook"></a>
### lpoco-health suspend cycle: pre/post hooks or a --trace option (dyndbg, irq trace), so probes need no wrapper

Project
: linux-phone-oco/lab-tools

Status
: open

Note
: Taken over from surya-lab's queue (the lanes waker nudged surya over a lab-tools build item; coordinator, 2026-11-19). surya's sleep/bt-trace.sh is the stopgap probe that wraps the cycle to trace Bluetooth across suspend; it is removed once this exists. Fits beside suspend_stop (lab-tools #209).

Opened
: 2026-11-19

Needs
: build

Device
: xiaomi-surya

Proof
: health/tests/suspend_cycle.rs from fixtures: a cycle run with --trace (or a declared [health] suspend_trace / pre and post hooks) enables the given dynamic_debug sites and irq tracepoints before suspend, collects their output after resume into the run's report, and restores them; without the option nothing is changed

Rank
: 8

About
: health-reports-pieces


<a id="lpoco-attended"></a>
### lpoco attended: a Rust library so a lane's attended procedure is a short entry file of named steps that reads like a script

Project
: linux-phone-oco/lab-tools

Status
: in-progress

Note
: 2026-11-19, lab-tools-builder: first slice released as lpoco-attended-v0.29.0 (lab-tools #247; example tag #248): crate attended/, free functions procedure/step/check/ask_author/phone/retry over one Step type (decision 2026-11-19-attended-crate-free-functions; it supersedes the bringup module of #243). Proof: attended/tests/attended.rs (8: dry run reaches no phone, even from main; real run via a stand-in devlab files the log; failing check names the step; non-ok answer stops at the ask; no answer stops; a panic is never a pass; help) + unit tests for retry and outcomes; failing first as a module move. Review fixed: panic reported as a pass, guard dropped at once (must_use), dry run reaching the phone from main, false end line in a dry run. Open: library steps keyed to bring-up ids (boot_once, read_dmesg, check_probe, wait_for_usb, back_to_known_good), reading values from device.toml/[layer]; the unattended runner on the same Step (bringup-step-runner); a step time limit; Step<'a> if a file needs shared locals; no run against a real devlab or phone; the log holds no output of a passing step.

Opened
: 2026-11-19

Needs
: build

Device
: xiaomi-surya

Proof
: lab-tools tests: a sequence file with steps, a stopping check, a prompt-and-wait point and a log runs in --dry-run and for real against a stand-in phone; a failing check stops the run and names the step

Rank
: 1

About
: bringup-steps


<a id="attended-step-library"></a>
### lpoco-attended library steps boot_once, wait_for_usb, back_to_known_good, read_dmesg - keyed to bring-up steps, values from device.toml

Project
: linux-phone-oco/lab-tools

Status
: done

Note
: 2026-11-19, lab-tools-builder: first three library steps landed (lab-tools #250: dmesg_clean, check_probe, wait_for_phone; tested on a stand-in via examples/library.rs). Open: boot_once and back_to_known_good through lpoco lab kernel try / the kept kernel, wait_for_usb, read_dmesg; their values from a device.toml [attended] table (known-good entry, usb id) in the manifest crate, schema regenerated; surya-lab lab/attended to use them; fit procedures/NAME.rs (decision 2026-11-19-procedures-one-shape). 2026-11-19, lab-tools-builder: read_dmesg(text) and wait_for_usb(vendor:product, tries, every) landed (lab-tools #251, main fb2e94d): the host's sysfs USB folder is read through the contract's LPOCO_ATTENDED_SYSFS_USB (listed in --help), an empty dmesg text and a malformed id are refused before the phone is reached, an unreadable folder is named. Proof: attended/tests/attended.rs read_dmesg_needs_the_line_in_the_log_and_names_what_was_missing, wait_for_usb_passes_when_the_id_is_on_the_bus..., wait_for_usb_sees_a_device_that_arrives_late_refuses_a_bad_id_and_names_an_unreadable_folder (the example did not yet know the steps, so it failed to compile first; review caught the undeclared env var, the empty text, error-text asserts that matched the step's own line, no retry or id tests). Open now: boot_once and back_to_known_good (through lpoco lab kernel try / the kept kernel, never around it; values from the manifest's [device]/[boot]/kernel entries and the USB ids devlab finds the phone by, a new field only for what no table has: orchestration, decision device-layer-declared-once), keying to bring-up ids, surya-lab lab/attended to use the steps, procedures/NAME.rs shape. Not covered: dry run of the two new steps, interface entries in the fake bus. 2026-11-19, lab-tools-builder: boot_once(name) and back_to_known_good() landed (lab-tools #253, main bc1dedf): boot_once goes through devlab kernel try NAME (devlab waits, measures and refuses an entry with no try left) and refuses a name devlab would not take (+, capitals, empty) before reaching devlab; back_to_known_good reboots the phone as root into its default (set -e, so a reboot not scheduled fails the step); a dry run reaches neither. New crate-private devlab() beside Phone. Proof: attended/tests/attended.rs boot_once_asks_devlab_for_one_try_of_the_named_kernel_and_names_a_refusal, boot_once_refuses_a_name_devlab_would_not_take_before_reaching_it, back_to_known_good_reboots_the_phone_into_its_default_and_a_dry_run_does_not, a_reboot_that_was_not_scheduled_fails_the_step_and_a_dry_boot_once_reaches_nothing (the example did not know the steps, so it failed to compile first; the stand-in fakes systemd-run, systemctl, reboot, shutdown, poweroff, sync so no test can reboot the host). Review caught the reboot script's exit status, the host-reboot risk in tests, the missing boot_once dry case, the dropped devlab output. Open now: the kernel name is a parameter; per orchestration's order (decision 2026-11-19-procedure-values-from-the-named-device) both steps move to kernel entries / kept kernel from device.toml under attended-device-values (rank 2, next); keying to bring-up ids; surya-lab lab/attended to use the steps; procedures/NAME.rs shape; not covered: back_to_known_good on a real phone, a try on a phone. 2026-11-19, lab-tools-builder: wait_for_usb keyed to bring-up step gadget-enumerates (lab-tools #255, main ecc4e01); proof attended/tests/attended.rs wait_for_usb_is_keyed_to_the_bring_up_step_gadget_enumerates (seen failing first: the dry log named no step). Review: the step proves vendor:product only, not the serial half of the id, said in its doc; the other steps are left unkeyed on purpose (no docs step matches: read_dmesg, check_probe, wait_for_phone are generic; boot_once/back_to_known_good are moves, not proofs). Open now: serial in wait_for_usb (with attended-device-values), surya-lab lab/attended to use the steps, procedures/NAME.rs shape, not covered: back_to_known_good and a try on a real phone. 2026-11-19, orchestration: done - the seven steps are in lpoco-attended (v0.29.3 and lab-tools #255). What stayed open moves to its own item: the USB serial and the kernel names from device.toml go to attended-device-values; procedures/NAME.rs to attended-scaffold; surya-lab's use of the library to surya's move item. Marked done so the builder's query takes attended-device-values next.

Opened
: 2026-11-19

Needs
: build

Device
: xiaomi-surya

Proof
: lab-tools attended tests: each step against a stand-in phone reads its values from a fixture device.toml (no device value in the library), names its bring-up step id, runs in --dry-run without touching anything; surya-lab lab/attended uses them in place of its inline copies

Rank
: 1

About
: bringup-steps


<a id="kernel-try-cmdline"></a>
### lpoco lab kernel try --cmdline: boot an entry once with an extra or replaced kernel command line

Project
: linux-phone-oco/lab-tools

Status
: open

Note
: 2026-11-19, orchestration: the surya keeper's real run of the attended program may need it if kernel try calls4+ refuses (relayed by the Top Coordinator). lpoco 0.24.0's kernel try has only --dtb and --device. Ready it before the keeper's run. 2026-11-19, orchestration: also in devlab/src/kernel.rs: the refusal of a name with + is deliberate - entries are pmos-NAME+1-0.conf (systemd-boot's boot-counting suffix) and removal globs pmos-NAME+*.conf, so a + in NAME would be read as the counter and a try named calls would remove the kept calls+ entries. Keep the rule; make the message say why ("+ is systemd-boot's try counter in the entry name; the label is free, e.g. calls4"). The kept calls+ and calls2+ predate the rule and cannot be kept/unkept through lpoco: surya's keeper retires them by new names, not a workaround.

Opened
: 2026-11-19

Needs
: build

Device
: xiaomi-surya

Proof
: lab-tools devlab tests: kernel try NAME --cmdline ARGS writes a one-boot entry whose command line carries ARGS, refused when ARGS holds a newline or the entry has none to extend; the next boot is stock

Rank
: 5

About
: bringup-steps


<a id="attended-scaffold"></a>
### lpoco attended new|run|check: scaffold, run and dry-run a device repo's procedures/NAME.rs

Project
: linux-phone-oco/lab-tools

Status
: open

Note
: 2026-11-19, orchestration: decision 2026-11-19-procedures-one-shape. The template is attended/examples/attended.rs; rust-script runs each file (cached builds in AGENT_BUILD). The steps crate is the repo's own procedures/steps when present. Then surya-lab and google-walleye-lab move over (their own items, by their builders).

Opened
: 2026-11-19

Needs
: build

Device
: google-walleye

Proof
: lab-tools tests: in a fixture device repo, attended new NAME writes procedures/NAME.rs that runs in --dry-run unchanged; with procedures/steps present it is in the cargo block; run NAME passes --dry-run/--log through; check dry-runs every procedure against the stand-in phone and names the failing one

Rank
: 4

About
: bringup-steps


<a id="chip-layer"></a>
### The chip layer: knowledge of a part, for any product, upstream first; docs keeps a thin row per part number that links up

Project
: linux-phone-oco/docs

Status
: in-progress

Note
: Research chip-layer-open-homes, decision 2026-11-19-chip-knowledge-upstream-first-docs-indexes-by-part. Done here: the chips table (chips-table). Open: lpoco-chip-check, lpoco-chip-series-check, chip-series-in-fork-linux, chip-boards-claimed-by-bases; each lab's chips written as it brings one up (walleye: ti-drv2624, ti-tas2557 first).

Opened
: 2026-11-19

Proof
: test-chip-record

About
: bringup-steps


<a id="chips-table"></a>
### The chips table: one row per part number, about the part whatever product carries it, linking up to its homes (ikb chip, tad q chips)

Project
: linux-phone-oco/docs

Status
: done

Note
: 2026-11-19, research-chip-layer: declared in tables.toml (chips; a chip is a subject: decisions, research, backlog, summaries and session logs may be about it; chips joins the unique ids), records/chip.sql, queries/chips.sql, bin/test-chip-record.sh in make verify. First rows: ti-tas2557, ti-drv2624.

Opened
: 2026-11-19

Proof
: test-chip-record

About
: chip-layer


<a id="lpoco-chip-check"></a>
### lpoco chip check: a library step that tells a chip is present and bound on any board, from its chips row (identify) and the board's device.toml

Project
: linux-phone-oco/lab-tools

Status
: open

Note
: Decision 2026-11-19-chip-knowledge-upstream-first-docs-indexes-by-part (3) and 2026-11-19-procedures-chain-small-device-agnostic-steps: one Step type for lpoco-attended and the runner. Board values (bus, address) from device.toml, chip values (driver name, id register and value) from docs' chips row; reading only, never writing the chip. Today the same check lives as walleye-only shell in google-walleye-lab tests/health/base/amp-present.sh.

Opened
: 2026-11-19

Proof
: lab-tools unit test on a stand-in sysfs and i2c; then walleye's amp-present.sh rewritten as library calls gives the same verdicts (amp-present-0x4c/0x4d, haptics-chip-present)

About
: chip-layer


<a id="lpoco-chip-series-check"></a>
### lpoco chip series-check: a chip's series is binding, driver, dts apart, each passing checkpatch --strict and dt_binding_check, authors kept

Project
: linux-phone-oco/lab-tools

Status
: open

Note
: Decision 2026-11-19-chip-knowledge-upstream-first-docs-indexes-by-part (1): the order upstream reads (docs.kernel.org devicetree/bindings/submitting-patches). Runs on a topic branch of fork-linux; checks only, sends nothing.

Opened
: 2026-11-19

Proof
: fails today on porthole's DRV2624 (0018 has no binding) and passes on Boiano's TAS2557 v3 shape (dt-bindings 1/2, driver 2/2); a lab-tools test on two fixture series

About
: chip-layer


<a id="chip-series-in-fork-linux"></a>
### Each chip a topic branch in fork-linux: ti-drv2624 (binding new, porthole's driver, board dts apart), ti-tas2557 (Boiano's v3 as on the list)

Project
: linux-phone-oco/docs

Status
: open

Note
: For the upstreams lane. DRV2624: write the YAML binding (ti,drv2624: the LRA properties porthole's driver reads), keep porthole's driver with Giuseppe Maggio's authorship, our changes as commits on top, then a dts patch per board (taimen, walleye). TAS2557: carry Boiano's v3 unchanged and test it on walleye; a reply on the list is the author's, in his name. Nothing is sent by an agent.

Opened
: 2026-11-19

Blocked by
: lpoco-chip-series-check

Proof
: lpoco chip series-check passes on topic/chip-ti-drv2624; the chips rows' homes name the branches

About
: chip-layer


<a id="chip-boards-claimed-by-bases"></a>
### Device bases claim the chips they carry (part, bus, address, read back or not); docs pulls the claims into the chips' boards

Project
: linux-phone-oco/docs

Status
: open

Note
: Only once a second lab writes chips (decision 2026-11-19-chip-knowledge-upstream-first-docs-indexes-by-part rejected a join table until then); the shape follows feed-device-parts and feed-device-steps.

Opened
: 2026-11-19

Proof
: a feed test like test-feed-device-steps: a base's claim shows on its chip, an unclaimed board stays a claim

About
: chip-layer


<a id="attended-device-values"></a>
### lpoco-attended loads the named device's device.toml: steps read keys, a missing key fails the dry run, devlab gets --device

Project
: linux-phone-oco/lab-tools

Status
: open

Note
: 2026-11-19, orchestration: decision 2026-11-19-procedure-values-from-the-named-device (amends docs #638 and #646). Before attended-scaffold, so the scaffold's template names no values. Reuse lpoco-manifest's loader and the existing tables; add a key only where none holds the fact. boot_once and back_to_known_good (in progress) take their kernel names from the kernel entries and the kept kernel there. Also from attended-step-library: wait_for_usb proves vendor:product only - the serial comes with this item; boot_once and back_to_known_good take their kernel names as parameters now (v0.29.3) and change to keys here.

Opened
: 2026-11-19

Needs
: build

Device
: xiaomi-surya

Proof
: lab-tools attended tests with two fixture device repos: procedure(name, device) loads the named one's device.toml; wait_for_usb() and check_probe read their keys from it; --dry-run with a key missing fails naming the key and touches nothing; phone() runs devlab with that device's --device even when run from the other repo

Rank
: 2

About
: bringup-steps


<a id="attended-lift"></a>
### lpoco attended lift: every device repo's procedures/steps beside the library, near-duplicates flagged by body

Project
: linux-phone-oco/lab-tools

Status
: open

Note
: 2026-11-19, orchestration: decision 2026-11-19-procedures-reflect-and-lift. Reads the device repos device-template knows. Bodies compared as token runs (PMD CPD's way), not by name. Output a table patrol can read (--format csv). After attended-device-values and attended-scaffold.

Opened
: 2026-11-19

Needs
: build

Device
: google-walleye

Proof
: lab-tools attended tests with two fixture device repos and the library: a step copied into both (renamed) is flagged as one pair with both places; a step the library already has is flagged as 'use the library'; a step in one repo only is listed, not flagged; three differing copies are flagged, two differing are listed

Rank
: 6

About
: bringup-steps


<a id="attended-export"></a>
### lpoco attended export: a procedure's checks as a LAVA test definition others' labs can run

Project
: linux-phone-oco/lab-tools

Status
: open

Note
: 2026-11-19, orchestration: decision 2026-11-19-procedures-reflect-and-lift, part (4). Later than the lift loop; nothing is opened upstream without the author's word.

Opened
: 2026-11-19

Needs
: build

Device
: google-walleye

Proof
: lab-tools attended tests: export of a fixture procedure writes a LAVA test definition whose run steps are its checks, with the device's values filled from device.toml; it validates against LAVA's schema

About
: bringup-steps


<a id="attended-physical-steps"></a>
### lpoco-attended: physical steps (press_power, hold_button, unplug_usb, replug_usb, touch, swipe, look_for, listen_for, confirm) over a Bench trait, the person backend only

Project
: linux-phone-oco/lab-tools

Status
: open

Note
: 2026-11-19, orchestration: decision 2026-11-19-attended-steps-name-the-physical-act. Build only the trait and the person backend, and the rename; no rig backend. The bench's declared acts come later from lab.toml (per device), so read nothing yet - default person. Before attended-scaffold, so its template is written with physical steps once.

Opened
: 2026-11-19

Needs
: build

Device
: google-walleye

Proof
: lab-tools attended tests: each physical step through the person backend prints its act and what to check and records the answer; --dry-run lists the doer of each act (person); a stand-in Bench that claims unplug_usb is called instead of the person for that act only; ask_author still compiles and maps to confirm

Rank
: 3

About
: bringup-steps

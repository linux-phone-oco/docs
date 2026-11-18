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
: Decided 2026-11-17 (idealkb decision 2026-11-17-chain-follow-by-slice): the same pin-and-follow slice as idealkb, not a fork, subtree or Copier. Done: device-template lists what it gives (generic) and ships idealkb and itself as upstreams in its base. Next: device-template releases (release-please) and idealkb's follow-source-from-pin (update-pins reading its source from the pin file); then surya-lab and google-walleye-lab follow it with move-device-rows. Improvements go back as upstream items (PRs). rhizoid's missing slice mode is on git-rhizoid's backlog (slice-consumption).

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
: open

Note
: Write the failing test first: the full text is in docs research/phone-side-pieces/2026-11-18/inventory.md (not landed - lab-tools has no ignored/expected-fail convention and it does not compile until the function exists). lpoco_host gains blob_id (git's blob id), stale_pieces(device, report, main) -> Vec<Stale> (File {path, found, main} for each declared overlay/install/device check whose reported blob differs from origin/main's; Package {name, found, pin} for a lab-tools package off the [tools] lpoco pin). check reads each device's newest tests/results/*.jsonl at origin/main, names the commit the installed copy came from (git log --find-object) and the report's age. Then lpoco lab names the same at every change's end from the report it reads back.

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
: open

Note
: Decision 2026-11-18-device-manifest-schema-from-rust. Today devlab, host and bringup each parse device.toml in their own shape and devlab ignores a misspelled table. One crate (lpoco-manifest) holds the serde types with doc comments; devlab, host and bringup read it; schemars (draft-07, already in Cargo.lock via rmcp) projects device.schema.json, committed and published with each release; roof pieces are an enum with tokens. A generated device.toml template with every field's doc beside it is the device-template file.

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
: open

Note
: walleye carries ~20 init variants in build/initramfs*/ and ffs-acm-rs; lpoco bringup already makes the cpio (bringup/src/initramfs.rs) with the gadget address a variable. The generic init and console come into lab-tools; the device names its serial, address and functions in device.toml [boot].

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
: Its queue at start: push the topic and lab branches to grenudi/sxmo-utils and grenudi/linux (local now: ~/Projects/grenudi/sxmo-utils-topics, ~/Projects/grenudi/linux-topics); retire sxmo-utils deviceprofile/xiaomi-surya (upstream as 1fd7822); see the proofs through; prepare each send for the author. 2026-11-18 orchestration: forks transferred to grenudi; pushed there: sxmo-utils topic/sxmo-autosuspend-backoff 2bb2500, topic/sxmo-suspend-stop-by-profile 1156bb6, topic/sxmo-surya-sensors-suspend and lab 6432ef9; linux topic/pmic-wdt-wake-in-suspend e123d3bff. Local clones: sxmo-utils remote 'mirror' now names grenudi; the kernel clone (surya-audio/linux) still names linux-phone-oco/linux, which redirects.

Opened
: 2026-11-18

About
: upstream-forks


<a id="sxmo-utils-lab-apk"></a>
### sxmo-utils from our fork as a lab apk: an APKBUILD forked from Alpine's, all subpackages, source the fork's lab tag, signed, installed as sxmo-utils@lab

Project
: linux-phone-oco/lab-tools

Status
: open

Note
: pmbootstrap aportgen --fork-alpine sxmo-utils as the start; pkgver 1.18.1_pYYYYMMDD; the tagged lab repository so apk upgrade keeps it (decision 2026-11-18-upstream-forks). Pin (upstreams-coordinator, 2026-11-18): https://github.com/grenudi/sxmo-utils tag lab-20261118.1 (annotated, 6432ef936a84 = branch lab = upstream 1fd7822 + backoff 2bb2500, stop-by-profile 1156bb6, surya sensors 6432ef9); pkgver 1.18.1_p20261118. When it is out, surya-lab surya-sxmo-suspend-series is unblocked.

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
: upstream-forks

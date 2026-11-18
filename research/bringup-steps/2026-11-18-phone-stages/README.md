# Bring-up steps, a second look: the phone beyond "Linux boots"

The material of research rows bringup-steps-coverage-map and bringup-steps-phone-stages and of decision
2026-11-18-bringup-steps-phone-stages-and-goal-steps. It holds four researchers' digests, the coverage map,
the seed (`sources.sh`, `seed-phone.sh`, already run through ikb), the failing test (`daily-phone.sh`) and a
draft of the chain query with `--goal` (`queries/bringup-chain.sql`, docs' owner's to land). Read only when
the finding is questioned.

## Files

- `sources.sh`: 33 sources, each with what we take from it (`ikb source`).
- `seed-phone.sh`: 12 stages, 80 steps (4 into power, 2 into the empty lab stage, 74 into new stages, 3 of
  them goals) and 186 edges (`ikb bringup-stage|bringup-step|bringup-edge`).
- `daily-phone.sh [DEVICE]`: the shape (every stage has a step; complete-phone needs every phone step), then
  the device: fails while any step daily-usable-phone needs is not done or not-needed. In a scratch copy with
  every step claimed done it passed, with gnss-fix open it failed naming it, and an untaken alternative (UART
  when the gadget's console is done) was not counted against the device.
- `queries/bringup-chain.sql`: `--goal STEP` keeps that goal and what it needs, hard edges all the way down
  (77 rows for daily-usable-phone, 106 for the whole chain, tried in a scratch copy).

## The coverage map: what the first research (bringup-steps-landscape) looked at, and what it did not

| Looked at | Not looked at |
|---|---|
| How Linux comes up: bootloader, image, console, kernel, PMIC, storage, rootfs, suite (walleye's 26 steps, surya's road) | What makes a phone after that: modem, calls, call audio, sensors, GNSS, camera, suspend and battery, shell, updates |
| How others keep steps: pmOS porting and mainlining guides, Infobox, bootrr, Collabora DT kselftest, LAVA, KernelCI, BitBake, openQA, beads, Taskwarrior, Yocto | UBports' progress stages (the only stage order kept as data), PinePhone and megi status, Mobian, Librem 5 |
| UBports porting and Sailfish HADK subsystems, for order in prose | Sailfish's checklist (suspend, act-dead charging, proximity in calls, thermal) and CSD |
| | Android's definition of a phone: CDD areas and MUST ids, CTS/VTS units, the HAL list, Halium's map of what Linux must replace |
| | Qualcomm's own stacks on mainline: remoteprocs and firmware, QRTR services, q6voice, IMS, CAMSS and the ISP, SSC sensors, fuel gauges, wake for calls |
| | Talks: Weiss FOSDEM 2025 "the missing 20%" (reliability, not function), FOSDEM 2026 mobile track |
| | Our own labs past the rootfs: surya's audio, calls, microphones, sensors and suspend records (~50 steps met) |

The lab stage was seeded with no step: the author saw "7 stages of 26 steps".

## Gaps in the world's own knowledge (modern Qualcomm phones)

No public prior art, or only one report: an open IMS (VoLTE) across carriers (81voltd on some phones and
carriers, OpenIMSd in progress, one emergency VoLTE call on a Fairphone 6); a q6voice upstream would take,
and any call audio on AudioReach SoCs; the hardware ISP (BPS/IPE/ICP) and 3A tuning; waking for a call but
not for chatter; s2idle current figures per SoC with the modem attached, and the SoC floor on an
SM7150/845-class phone; whole-stack recovery after a coprocessor crash; why SSC registry writes fail on some
firmware; assisted GPS; eSIM; NFC on these phones; charging while off (charging-sdl unmaintained);
hardware-backed keys (keymint's counterpart); a userspace thermal policy; a CTS-like conformance suite for
Linux phones; reliability as a per-device field anywhere. Each is named "World gap" in its step's guide.

## How others group a phone (digest)

- **UBports** (devices.ubuntu-touch.io data): nine categories of feature ids, each with a weight and the stage
  it gates; stages 2 booting, 3 core connectivity (calls, SMS, data), 4 essential (photo, Wi-Fi, speaker,
  mic), 5 fully optimised (~30, incl. audioRoutings, offlineCharging, endurance), 6 never caps (VoLTE, NFC,
  fingerprint). A feature not working caps the device a stage lower. Status: the porter's tick.
- **Nura/pmOS Infobox**: main, multimedia, connectivity, modem (calls, sms, mobiledata), misc, sensors; no
  suspend, off-charging, call audio or updates field; SoC pages carry suspend and thermal.
- **Sailfish HADK**: subsystems with a test command each (list-modems, test_gps, test_sensors); the checklist
  names suspend, act-dead mode, thermal, watchdog, proximity blanking. CSD tests on device, never reports.
- **PinePhone Pro / megi**: stability, suspend, updates, push as rows; megi per driver with a mainline column.
- **Mobian**: tiers; dated "image tested" lines.
- **Android**: CDD areas 7.1-9 (about 150 handheld MUST ids); CTS module/case/method, pass/fail per build
  (ignored counts as pass); VTS per HAL instance (each SIM, each camera); the HAL list (radio x8, audio,
  camera, sensors, gnss, health, power, thermal, vibrator, light, usb, wifi, bluetooth, nfc, biometrics,
  keymint, boot); Halium reuses radio, audio, camera, media, sensors, GNSS, Wi-Fi, vibrator, fingerprint -
  the list a native phone must replace.
- **Nobody** keeps phone features as ordered steps with dependencies and a test per device; nobody but UBports
  gates by stage, and that by ticks.

## Structure: what nests and what does not

A step is the unit (one done-when, one proof - the size of a UBports feature id or a CTS module's case). A
stage is a chapter: one level, rows. A group of groups is a goal step - a step that does nothing but need
others (systemd's targets, BitBake's do_build, Make's phony targets): linux-runs, daily-usable-phone (needs
linux-runs) and complete-phone (needs daily-usable-phone) nest by their edges, with no new table or column.
A milestone names a goal on a device (step:daily-usable-phone@xiaomi-surya), once milestones-step-terms
lands. Features and components stay the outcomes a person sees; a step names its component where it is that
part's first light.

# Bring-up steps as data: material

Research `bringup-steps-landscape` and decision `2026-11-18-bringup-steps-generic-in-docs-status-in-each-base`
(bringup-steps-research.r1). The author's question: a table, below features and components, of every small
step that makes Linux run on a machine, with how the steps need each other and the proof of each; later a
guidebook and helpers from it, and each device base recording where it stands on each step.

## What is here

| file | what |
|---|---|
| `schema.toml` | the three tables in tables.toml's form: `bringup_steps`, `bringup_step_edges` (docs), `step_status` (docs, filled by the feed) |
| `records/bringup-step.sql`, `records/bringup-edge.sql` | the two records (the edge record refuses a cycle) |
| `queries/bringup-chain.sql` | the chain in order (depth over all edges, then stage, then ord) with a device's status, proof, run and ready/waits |
| `seed.sh` | 26 generic steps and 37 edges, through the records: walleye's real chain generalised, surya's path checked against it |
| `claims-walleye.sh` | walleye's 26 claims as its own base will make them, each run a record of google-walleye-lab |
| `chain-walleye.md` | what the query answers with those claims: 17 done, 2 partial, 1 failing, 6 open; ready: charger, watchdog, storage, USB network, UART, stock measure |
| `bringup-chain-walleye.sh` | the failing test: fails on main (no query); passed in a scratch copy with the claims; fails again when one claim is removed (checked) |

All of it was run in a scratch clone of docs at 3596bb3 (`tad check`: all is well, 36 tables). Nothing of it is
in docs' tables yet: that is item `bringup-steps-schema`.

## The design in one picture

    docs (the commons)                                device base (google-walleye-lab, surya-lab, a new one)
    bringup_steps  --< bringup_step_edges             steps (contract steps = 1 in devicebase.toml):
      id, stage, ord, applies, done_when,               step, status, proof, run, proven_on, notes, updated
      proof, proof_kind, helper, component, guide       claimed with tad r step, never typed in docs
            |                                                     |
            +---- step_status (device x step) <---- feed-device-steps.sql pulls data/steps.json
                    a step the base never claimed: unknown, "not known yet"
                    a base unreadable or without steps = 1: every step unknown, and why

    tad q bringup-chain [--device D]  -> the chain in order, status, proof, run, ready/waits
    make render                       -> docs/guidebook.md: per stage, each step's done-when, needs, proof, helper, guide, and a column per device
    lpoco bringup steps               -> the same chain read by the helpers; later the runner walks "ready"

## Surya's path, against the catalogue (from surya-lab and docs' records)

Surya came in through a distribution that already booted: U-Boot, systemd-boot and an EFI kernel, from Nura's
generic qcom-sm7150 port. Its claims will be: bootloader-unlocked done (first-fastboot-probe, getvar);
stock-facts-read, slot-state-known, control-image-boots, boot-image-packs, dtbo-accepted,
stock-kernel-runs-our-init, initramfs-gadget-emulated, reference-kernel-boots not-needed (UEFI chain, the
distribution's kernel); crash-window partial (uart8 exists, no cable); kernel-builds done (linux-phone-oco/linux
-wcd branches, 2026-11-11); kernel-reaches-init, gadget-enumerates, usb-network done (job 0004, ping
172.16.42.1); shell-on-console done by ssh (2026-11-09); dmesg-clean done (boot-warnings, no-oops,
20261116-232330); rootfs-boots done (2026-11-10-flashed-by-devlab); health-suite-runs done
(2026-11-17-1550-lpoco-health-v017); watchdog-way-back done (2026-11-17-way-back-proven); pmic-bound and
charger-online unknown (no record, no test: not known yet). Steps surya met that walleye has not yet: a test
kernel as a second EFI entry with one try (decision 2026-11-11-efi-kernel), the USB wake lock (usb-awake), the
DT boot hang removed (wcd937x-dt-aoncc) - the first two are lab steps and go in as `lab` stage rows when
surya's claims are made; the third is a case of kernel-reaches-init.

## Looking around (22 sources read by a researcher, 2026-11-18)

Nobody keeps bring-up steps as data with edges and a proof per step. The pieces exist apart:

- Step order is prose: Nura's porting guide (pages chained by order, one downstream/mainline fork) and its
  Mainlining Guide (minimal boot = RAM + serial, then one feature after another); Ubuntu Touch and Sailfish HADK
  stages; Qualcomm's "initial support" cover letters (boot to shell with a ramdisk first; USB, Ethernet later).
- Per-device status is a person's tick: Nura's Infobox device (about 60 status_* fields, Y/P/N, stored as a
  Cargo table the device lists query) and Asahi's feature-support pages (SoC blocks apart from device
  integration; states say where the code lives, from linux-asahi to a mainline version).
- Proofs are flat lists: bootrr (Linaro, one assertion per driver/device with a LAVA test-case id, dropped
  because kernel names are unstable ABI and every board needs its own list), Collabora's DT probe kselftest
  (derives "probed" from the live devicetree), LAVA's boot stages (bootloader message, kernel-start-message,
  login prompt) and `lava-test-case ID --result`, with `expected:` turning a missing case into a fail.
- Dependencies are data only where machines run them: BitBake (addtask after/before, deptask, rdeptask,
  stamps keyed on input hashes, so a changed input makes a task stale), KernelCI (a job waits on another's
  result), openQA (fatal vs ignore_failure, START_AFTER_TEST; needles as screenshot proof), issue trackers
  (beads blocks/related and `bd ready`; GitHub blocked-by; Taskwarrior's READY and BLOCKED computed, never
  stored). Yocto's BSP guide and "Yocto Project Compatible" keep a declared answer apart from a checked one.
- Nura's device categories are levels as gate sets (builds and boots; kconfig check and kernel upgrades;
  hardware CI in two places) - a milestone over step proofs.

What we take: a generic catalogue plus per-device instances (Nura's pmtest opt-in, LAVA expected, KernelCI
job x platform); typed edges, hard and soft, with alternatives; readiness computed, never stored; a proof
per step that names a stable check, never a kernel driver name; what a proof ran on, so a changed kernel can
be told; levels as sets of steps (our milestones). What we would be first at: one graph from which both the
guidebook and the device's status are made, with each cell proven.

Sources (recorded): nura-porting-guide, nura-infobox-device, nura-device-categorization, nura-hardware-ci,
nura-mainlining-guide, asahi-feature-support, bootrr, collabora-dt-probe-kselftest, yocto-bsp-guide,
yocto-compatible, bitbake-task-deps, lava-boot-action, lava-test-definition, kernelci-pipeline-config, openqa-docs,
beads-issue-graph, github-issue-dependencies, taskwarrior-virtual-tags, ubports-porting, sailfish-hadk-subsystems.

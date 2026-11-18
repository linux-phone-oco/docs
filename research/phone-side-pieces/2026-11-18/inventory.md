# Phone-side pieces: inventory, 2026-11-18

Material of research rows phone-side-pieces-landscape and device-declaration-typed-landscape. Read at
origin/main: surya-lab 65690df, google-walleye-lab 63d68ce, lab-tools 85975d9, device-template main,
sxmo-utils clone 868b5c9. Neither phone was touched.

## Routes onto a phone today

| Route | Declared in | Written by | Versioned? | Drift seen by |
|---|---|---|---|---|
| `[[flash.overlay]]` | device.toml | lpoco lab flash, into the rootfs image | only as the image | nothing |
| `[[provision.install]]` | device.toml | lpoco lab provision, over ssh | no | nothing |
| `[health] checks` | device.toml | lpoco lab suite put, copied to /usr/lib/lpoco-health/device/ | no | nothing |
| lpoco-health apk | lab-tools packaging/ | suite put: apk add from the signed lab-tools repository | package version | `apk list` (not compared to a pin) |
| `lpoco lab phone put` + by hand | nobody | a session, over ssh | no | nothing |
| boot image (fastboot boot) | walleye build/ | lpoco lab fastboot boot now, held in memory | the image's hash | nothing to drift: nothing written |

## The pieces

| # | Piece | File | Reaches the phone by | Roof or device |
|---|---|---|---|---|
| 1 | keep-awake (wake lock `devlab-usb`, always; udc-configured + bt gate under allow-autosleep) | surya-lab lab/devlab-usb-awake, lab/devlab-usb-awake.service | flash.overlay to /usr/local/bin and /etc/systemd/system; re-copied by hand (PR 205) | roof: every lab phone on USB |
| 2 | autosleep-off health check (wake lock held, service active, gate grepped in the installed copy) | surya-lab tests/health/base/autosleep-off.sh | suite put (device check) | roof: generic check of piece 1 |
| 3 | way back from suspend (watchdog fuse, cycle, pstore collect) | surya-lab sleep/way-back.sh | phone put to /var/tmp, transient unit | roof already: lpoco-health suspend plan/cycle (health/src/suspend.rs); the guard command stays per device |
| 4 | qcom_wdt kept armed in suspend (module in updates/) | surya-lab patches/qcom-wdt-keep-armed-in-suspend.patch, sleep/build-wdt.sh | way-back.sh install | per device until upstream (linux-arm-msm) |
| 5 | standby-run, bt-trace | surya-lab sleep/standby-run.sh, sleep/bt-trace.sh | phone put, by hand | per device, diagnostic |
| 6 | call uplink capture + unit | surya-lab lab/devlab-call-uplink(.service) | flash.overlay | per device (SM7150 DSP); upstream question: q6voiced |
| 7 | PD mapper softdep | surya-lab lab/devlab-pd-mapper.conf | flash.overlay /etc/modprobe.d | per device; upstream item pd-mapper-order-finding exists |
| 8 | Alpine edge repository line | surya-lab lab/devlab-edge.list | flash.overlay | per device, temporary (alpine-tqftpserv-request) |
| 9 | UCM VoiceCall/HiFi, q6voiced conf | surya-lab ucm/*, lab/q6voiced.conf | flash.overlay | per device; upstream ucm-surya-stereo-patch exists |
| 10 | tas2562 module | surya-audio kernel-rc3/snd-soc-tas2562.ko.zst | flash.overlay if_exists | per device, until the kernel carries it |
| 11 | mobile data connection | surya-lab lab/mobile.nmconnection | provision.install | per device (the SIM) |
| 12 | Sxmo device profile | sxmo-deviceprofiles profiles/sxmo_deviceprofile_{compatible}.sh | provision.install | upstream (sxmo-profile-patch exists) |
| 13 | sensors: patched hexagonrpcd, resume hook, install script | surya-lab lab/build-hexagonrpcd-sns.sh, lab/devlab-sensors-resume, lab/sensors-install.sh | phone put + run as root | per device; upstream hexagonrpcd; sxmo hard-codes the same stop for sdm670 |
| 14 | masked/enabled units | device.toml [flash] mask, enable | flash | per device data |
| 15 | phone's own checks (amplifiers, call-audio, microphone, bt-suspend, shell/, telephony/) | surya-lab tests/health/** | suite put | per device; call-echo, sms-loopback may be generic later |
| 16 | the health suite (runner, generic checks, timer) | lab-tools health/, packaging/alpine/APKBUILD | apk from the lab-tools repository | roof (already) |
| 17 | bring-up init: configfs gadget (ECM, ACM, mass storage window), udhcpd, telnetd, banner | google-walleye-lab build/initramfs*/init, udhcpd.conf, selftest.sh | inside the boot image, fastboot boot | roof: lpoco-bringup makes the cpio already; the init itself is generic |
| 18 | FunctionFS ACM console (serial tty over the gadget) | google-walleye-lab build/ffs-acm-rs, build/ffs-acm/ffs-acm.c | inside the boot image | roof: a tty for any phone without a UART |
| 19 | gadget host-side checks (gadget-up, ffs-acm-up, massstorage-read, mainline-shell-read) | google-walleye-lab tests/host/* | not on the phone | roof later (lpoco-bringup checks) |
| 20 | host udev for gadget serials | device.toml [host] | lpoco host prepare | roof (done) |

device-template carries no phone-side piece (decision 2026-11-17-the-phone-is-data); its backlog dt-usb-awake
already asks for piece 1 under devlab.

## Today's case

The image surya was flashed with on 2026-11-10 carried lab/devlab-usb-awake of PR 40 (1ec8685: the lock only while
the port is configured). PR 195 (f9c8f25) made it held always; the phone kept the 11-10 copy, whose release on a
USB blip let sxmo_autosuspend.sh suspend, and the idle phone fell silent. PR 204 queued the copy, PR 205 recorded
it put by hand. PR 208 (98a29e1) changed it again (the bt gate) - and autosleep-off.sh's only way to know the copy
is current is `grep -q bt_unsafe` on the installed file: a hand-written stamp for one feature.

sxmo-utils 868b5c9 scripts/core/sxmo_autosuspend.sh: a failed sxmo_suspend.sh is retried after `sleep 1`, with no
backoff - on a phone whose suspend aborts while the gadget is up, every second's attempt drops the link.
scripts/core/sxmo_suspend.sh stops hexagonrpcd-adsp-sensorspd for "google,b4s4-sdm670" by name - the same
service surya masks and restarts by hand.

## Three parsers of one file

device.toml is read by three crates, each its own shape: devlab/src/device.rs (no deny_unknown_fields at the top
or in flash, overlay, provision, install, connection - a misspelled `[[flash.overlays]]` is silently ignored, though
the template's header says unknown fields are refused), host/src/lib.rs (reads [device] codename, [host] strictly,
[tools] lpoco and [fastboot] serial loosely from a toml::Value), bringup/src/boot.rs ([boot] only). No one
declaration says what the file may hold.

## The failing test (to write, lab-tools host/tests/phone_pieces.rs)

No convention for an ignored or expected-fail test exists in lab-tools (no #[ignore] anywhere; CI runs
`cargo test --workspace`), and this one does not compile until the function exists, so it is not landed; it is
the proof of backlog phone-pieces-drift-named, written first by the builder:

```rust
//! A stale phone-side piece is named by `lpoco host check`, from the phone's last gathered report - no phone.
use lpoco_host::{blob_id, parse_device, stale_pieces, Stale};
use std::path::Path;

const MANIFEST: &str = r#"
[device]
codename = "xiaomi-surya"
[tools]
lpoco = "0.9"
[[flash.overlay]]
from = "lab/devlab-usb-awake"
to = "root:/usr/local/bin/devlab-usb-awake"
mode = "755"
"#;
const ON_MAIN: &[u8] = b"#!/bin/sh\n# held always, with the bt gate\n";
const ON_PHONE: &[u8] = b"#!/bin/sh\n# held only while configured\n";

fn report(piece_blob: &str, health_version: &str) -> String {
    format!(
        "{{\"layer\":\"base\",\"component\":\"lab-pieces\",\"test\":\"piece\",\"outcome\":\"pass\",\"detail\":\"/usr/local/bin/devlab-usb-awake blob {piece_blob}\"}}\n\
         {{\"layer\":\"base\",\"component\":\"lab-pieces\",\"test\":\"package\",\"outcome\":\"pass\",\"detail\":\"lpoco-health {health_version}\"}}\n"
    )
}

#[test]
fn check_names_a_stale_phone_piece() {
    let device = parse_device(Path::new("device.toml"), MANIFEST).unwrap();
    let main = |from: &str| (from == "lab/devlab-usb-awake").then(|| ON_MAIN.to_vec());
    let stale = stale_pieces(&device, &report(&blob_id(ON_PHONE), "0.9.1"), main);
    assert_eq!(
        stale,
        vec![Stale::File {
            path: "/usr/local/bin/devlab-usb-awake".into(),
            found: blob_id(ON_PHONE),
            main: blob_id(ON_MAIN),
        }]
    );
}

#[test]
fn check_names_a_package_off_its_pin_and_passes_a_current_phone() {
    let device = parse_device(Path::new("device.toml"), MANIFEST).unwrap();
    let main = |_: &str| Some(ON_MAIN.to_vec());
    let off = stale_pieces(&device, &report(&blob_id(ON_MAIN), "0.8.0"), main);
    assert_eq!(off, vec![Stale::Package { name: "lpoco-health".into(), found: "0.8.0".into(), pin: "0.9".into() }]);
    assert!(stale_pieces(&device, &report(&blob_id(ON_MAIN), "0.9.1"), main).is_empty());
}
```

`blob_id` is git's blob id (sha1 of `blob LEN\0` + bytes): the phone computes it with busybox
(`{ printf 'blob %s\0' "$(wc -c < F)"; cat F; } | sha1sum`), and the host then names the commit the installed
copy came from with `git log --find-object=ID origin/main -- PATH` ("the phone runs surya-lab 1ec8685 (#40),
main has 98a29e1 (#208)").

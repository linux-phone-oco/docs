# The lab host as it stands, 2026-11-17 (read only, nothing changed)

What this folder holds: what the lab host (grig, CachyOS) has today that a phone's bring-up needs, how each
part got there, and which of it is a hand step outside any tool. Measured from the host itself, the lab
repositories at origin/main and today's session logs. The outside landscape is in `landscape.md`.

## Measured on the host

- systemd 262.2 (Arch). Since 258 udevd applies uaccess ACLs itself and the hwdb tags ADB (ff4201),
  ADB DbC (dc0201) and fastboot (ff4203) interfaces `uaccess`; since 260 `xaccess-debug-appliance` too.
- The lab user (uid 1000) is in sys, network, docker, nopasswdlogin, rfkill, users, video, storage, lp,
  audio, wheel. Not in disk (owner group of /dev/sdX) nor uucp (owner group of /dev/ttyACM* on Arch).
- logind: the lab user holds a session on seat0 (tty2, Plasma), so uaccess ACLs reach uid 1000 while it is
  active. Agents run as that uid, so an ACL on the node is enough for them; a headless boot with no seat
  session would give none (uaccess grants only the seat's active session).
- /etc/udev/rules.d/51-android.rules (Nov 4): MODE 0666 for USB vendors 18d1, 05c6, 2717, group plugdev
  (which does not exist here). Written by lab-agent's connect.sh as printed commands run by hand. Redundant
  now beside the android-udev package (20260922) and systemd 262's own tags; it never covers block or tty.
- Packages: android-tools 37.0.0.p1, android-udev 20260922.
- No /etc/modules-load.d entry of ours; usb_storage loaded (with uas). cdc_acm loads by modalias.
  Today the host ran a kernel whose module directory was gone after an update, so usb_storage and cdc_acm
  could not load until the host was rebooted into 7.3.4 (walleye-retry-*-after-reboot rows).
- ~/.local/share/devlab-cross: a rustup and cargo home kept beside the system's for
  aarch64-unknown-linux-musl, linked by aarch64-linux-gnu-gcc through `nix-shell -p rustup`
  (lab-tools health/build.sh). Who installed it is in no record.
- User units: devlab-watch@surya-lab active, from lab-machine setup/devlab-watch.sh (installs
  setup/systemd/devlab-watch@.service, enables one per device repository). walleye has none.
- Root: only `sudo -n lab-agent root-exec -- ARGV` (one sudoers grant); devlab reads $DEVLAB_ROOT, default
  that (lab-tools devlab/src/provision.rs, flash.rs).

## Hand steps found (today's logs and the records)

| step | how it was done | belongs to |
|---|---|---|
| uaccess for walleye's gadget serial `walleye-first-boot` (/dev/sda root:disk, /dev/ttyACM0 root:uucp) | handed to the author as a manual rule; he refused: the tool's first use is its test | the tool: [host] gadget |
| usb_storage, cdc_acm missing after a kernel update | host rebooted by root-exec systemd-run | the tool's plan says "running kernel has no modules: reboot" |
| fastboot devices as root | `root-exec -- fastboot devices` (5 times) | covered by systemd 262 hwdb; the tool checks it as the lab user |
| 51-android.rules | connect.sh printed commands, run by hand | superseded; the plan names it as foreign |
| perl-io-socket-ssl, perl-authen-sasl (git send-email) | `root-exec -- pacman -S` | the tool: host commands a lab needs (later) |
| ~/.local/share/devlab-cross toolchain | by hand, unrecorded | the tool: targets (later) |
| devlab-watch@ per device | lab-machine setup script, by hand per repository | the tool: watchers (later) |
| ssh to the phone as root | `root-exec -- ssh 172.16.42.1` (21) | not host preparation: the phone's key; out of scope |

## The device side

- google-walleye-lab device.toml already declares (lab PR 54, for this tool):
  `[host] modules = ["usb_storage","cdc_acm"]` and `[[host.gadget]] serial = "walleye-first-boot",
  access = ["block","tty"]`. devlab's Device has no deny_unknown_fields at the top, so the table is
  accepted and ignored today. Its base holds walleye-host-access-via-lab-prepare waiting on the tool.
- surya-lab declares no [host]; its gadget is postmarketOS' (NCM, 172.16.42.1).
- device-template has no [host].
- The pin: device.toml [tools] lpoco = "X.Y" names the whole family (decision 2026-11-17-bringup-in-lab-tools).

## Root's future

ideal-agent decision 2026-11-17-lab-agent-retires-by-parts, part 6 (backlog lab-agent-6-root-exec-grant):
devlab and setup scripts call a root-owned wrapper `lab-root` in lab-machine (same power, renamed) or a
narrower grant per command; the grant is the author's and root's to write. Its proof names DEVLAB_ROOT.
So the tool must name the exact root commands it runs, which is the list a narrow grant needs.

# How others prepare a host for USB phones, read at the sources, 2026-11-17

What this file holds: the outside practices weighed for preparing the lab host from declarations - what each
does, how it declares, how it gets root, whether it has a dry plan - and what we take. Read by a read-only
researcher at upstream heads of that day (systemd c50b9f5, pmbootstrap e0dfe2c, android-udev-rules a9c2aeb,
labgrid 6743d2e, LAVA b826e7d). The lab host's own inventory is in `inventory.md`.

## Finding in one paragraph

Nobody derives host rules from per-device declarations. LAVA ships one static rule that calls a privileged
helper which matches the device dictionary at event time; labgrid matches udev properties at run time and
leaves rules and groups to the administrator. systemd's uaccess grants an ACL only to the active session of
the device's seat (seat0 by default); ssh sessions and services have no seat, so a headless user gets nothing
from it. A rule setting uaccess must sort before 73-seat-late and, since systemd 258, must not be add-only
(use ACTION!="remove"). systemd 258+ already tags ADB and fastboot interfaces; 260 adds
xaccess-debug-appliance for headless sessions that ask for it through PAM. Only GROUP/MODE also covers
services with no session.

## Each source

- pmbootstrap: no udev rules at all; flashers run as root inside its chroot with /dev/bus/usb bind-mounted.
  Root by whole-command doas/sudo/run0 (PMB_SUDO overrides). No dry run; each step checks then acts;
  `pmbootstrap shutdown` tears its host state down. deviceinfo usb_* fields are the gadget side only.
  Take: probe order with an override; check-then-act; a teardown. Avoid: whole-command root, no plan.
- android-udev-rules (51-android.rules; Arch android-udev): vendor and product blocks, one grant at the end
  with MODE 0660, GROUP adbusers (sysusers.d) and TAG uaccess; add-only guard; asks for a replug.
  Take: group plus uaccess, sysusers.d. Avoid: add-only guard, a giant vendor list, replug.
- systemd (udev-builtin-uaccess.c, 70-uaccess, 71-seat, 73-seat-late, hwdb 60-usb-interface, NEWS 258/260):
  as in the paragraph above. Defaults: tty -> dialout (uucp on Arch), block -> disk. NCM has no node.
- NixOS: services.udev.packages union of rule files by name, extraRules at 99-local (too late for uaccess),
  boot.kernelModules merged into modules-load.d; programs.adb removed as systemd 258 covers it.
  Take: union of many sources, prefixed file names, a check at build. Avoid: rules at 99.
- Ansible: check mode changes nothing and reports; diff mode shows before and after; modprobe can persist to
  modules-load.d but its own docs prefer autoloading by modalias. Take: a per-resource plan with a diff.
- LAVA (lava_dispatcher_host): one static rule with RUN to a helper; device_info board_id = ID_SERIAL_SHORT;
  root by a hardened daemon on a 0600 socket; `rules install` writes only when content differs and reloads.
- labgrid: exporter YAML match on udev properties (ID_SERIAL_SHORT, interface number); no rules written;
  service with DynamicUser and SupplementaryGroups dialout plugdev; narrow root by sudoers lines for fixed
  helper programs.
- udevadm: `control --reload` does not touch present devices; `trigger --action=change` re-applies GROUP,
  MODE and (258+) uaccess on present nodes; narrow it with --attr-match; `verify` and `test` suit a dry plan.

## Taken

1. A rule file per device, numbered below 73 (70-lpoco-CODENAME.rules), every line ACTION!="remove",
   matching the gadget serial on the parent (ATTRS{serial}), granting TAG+="uaccess"; a lab group with
   MODE 0660 later, for a headless host and services.
2. Nothing for adb and fastboot by vendor: systemd 262 on the lab covers them; the check proves it.
3. The plan is a content diff per file and the exact root commands; the verb writes, reloads, and triggers
   change only on the devices it touched.
4. modules-load.d only for modules a device declares; the plan says when the running kernel has no module
   directory (reboot needed), which is what stopped usb_storage and cdc_acm on the lab today.
5. Root by a fixed, printed list of commands through one prefix, so a narrow grant can be written from it.

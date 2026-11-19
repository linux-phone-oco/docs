# A distro-agnostic device layer: the material

The material of research rows `device-layer-agnostic-prior-art` and `agnostic-layer-how-it-stands` (2026-11-19, run
agnostic-layer-research.r1): how others keep one device family's layer for several distributions, the shape proposed
for us, the cost per format, the upstream-first map, and the failing test. Asked on the author's words, verbatim: "for
distro i think debian, but i would like to postpone it a bit and consider how we could work and contribute distro
agnostic or something". Two read-only researchers read the outside sources at source; their findings are condensed
here, each source a `sources` row.

- `test-layer-apk-and-deb.sh` - the failing test: surya's declared layer packs into an apk and a deb with the same
  files, holding its UCM and its kernel-install devicetree file. Fails today on the missing `[layer]` and `lpoco layer`.
- `layer-sketch.toml` - what surya's `[layer]` could say, for the builder of item layer-table-in-manifest to weigh.

## Prior art

**Asahi Linux** (Apple Silicon; Fedora flagship, Arch, Gentoo, Debian, NixOS). No common description is generated
into spec, PKGBUILD, ebuild and debian/. Each piece has one upstream repository with a plain Makefile of small install
targets (`install`, `install-dracut`, `install-mkinitcpio`, `install-udev-hwdb`) and per-distribution bundles
(`install-fedora`, `install-arch`); each distribution keeps a thin hand-written recipe that calls one target (Fedora
`%make_install install-fedora`; asahi-alarm `make install-arch` from a fork 4 commits ahead; Gentoo's ebuild calls the
pieces one by one; Debian patched in `install-debian`, never merged upstream; NixOS skips the scripts). The one
cross-format link is Packit: every upstream commit builds the Fedora spec in COPR; asahi-alarm follows Fedora's
versions (versions.txt). One boot script (update-m1n1) with a different trigger per base: kernel-install hook plus rpm
triggers (Fedora), dpkg triggers and postinst.d (Debian), a libalpm hook (Arch), kernel-install (Gentoo), extraFiles
(NixOS). Firmware is never packaged: asahi-fwextract takes it from macOS at install. A written distribution policy:
Fedora flagship; an alternative is listed only if its own maintainers back it, it ships all 8 named packages, it takes
new versions within 2 weeks, it installs the distribution's normal way and hosts its own support; it can be
disendorsed. What hurt: a kernel fork of 1000+ patches rebased weekly by one person (now "shifting to upstream-first"),
a stale installer, Debian still without the kernel and Mesa in its archive.

**Pocketblue** (Fedora Atomic for Qualcomm phones): bootc images, a per-device directory with a build script and
device.conf, all RPMs in one packages repository built into per-SoC COPRs, the kernel swapped for a same-named package
from a higher-priority COPR. Asahi's shape again: the distribution where it can, a side repository where not.

**Mobian / Debian**: mobian-recipes (debos) keeps per-SoC TOML (`configs/sm7150.toml`: surya huaxing/tianma, boot.img
offsets) and builds boot.img at image time; `qcom-support` builds `sm7150-support` (depends on
linux-image-6.18-sm7150 and qcom-support-common: droid-juicer, qcom-phone-utils, rmtfs, tqftpserv). Kernels on salsa
(branch mobian-sm7150-6.18). Mobian gives back through DebianOnMobile: qcom-phone-utils, droid-juicer,
protection-domain-mapper and mkbootimg are in Debian proper; device kernels stay in Mobian. qcom-phone-utils'
`zz-qcom-bootimg` (an /etc/kernel/postinst.d hook) unpacks the flashed boot.img, appends the dtb from
/usr/lib/linux-image-VER/, repacks and writes it back - walleye's boot glue, already in Debian. The Debian kernel ships
dtbs in /usr/lib/linux-image-VER/; flash-kernel's database has one android machine and no Qualcomm phone.

**pmaports / Nura**: device-, firmware-, linux-, alsa-ucm-conf- and soc- packages; `deviceinfo` is the closest
existing one-description of a phone, read by pmbootstrap, mkinitfs, boot-deploy and deviceinfo-converter (which
already generates another project's format, Lomiri's). No effort uses pmaports device packages on another base.

**mkosi**: one config tree with `[Match] Distribution=`, drop-ins and profiles; supports Fedora, Debian, Ubuntu, Arch,
openSUSE and Nura (added 2024 as postmarketOS, renamed 2026-09-29; edge only) - source `mkosi-distributions` saying
"not Alpine" is out of date. systemd builds its own package for six bases from each base's native recipe under one
mkosi: the closest prior art for "one source, every base", but with a native recipe per base.

**systemd kernel-install**: plugins in /usr/lib/kernel/install.d (layouts bls, uki, other, or a plugin's own);
`/usr/lib/kernel/devicetree` names a dtb under /usr/lib/modules/VER/dtb/ to install with each kernel (checked in
kernel-install(8), systemd 262) - surya's EFI boot glue as one data file. Who runs it: Fedora (required), Debian only
with systemd-boot (zz-systemd-boot), Arch through mkinitcpio's hooks, Alpine not (built -Dkernel-install=false, its own
kernel-hooks.d), Nura through mkinitfs and boot-deploy (whether its systemd edition runs it is not known yet).

**One description, many formats**: nfpm v2.49.0 (2026-11-12) packs prebuilt files into apk, archlinux, deb, ipk, rpm
from one YAML, with per-format overrides of dependencies and scripts, config/noreplace, modes, and signing for deb, rpm
and apk; it compiles nothing; whether it writes repository indexes or apk-tools v3 packages is not known yet. fpm
(Ruby) has deb, rpm, pacman and an apk module. melange is apk only. OBS's obs-build reads spec, debian/, PKGBUILD,
APKBUILD (since 2024-11) and mkosi, still one native recipe per family.

## The shape proposed (vectors and costs)

1. **Declared once in Rust, packed per format (chosen).** `[layer]` in device.toml, typed in lpoco-manifest: files
   with their kind (data, config, unit, script), dependency tokens, the kernel (tree, tag, config fragment, dtbs), the
   boot method (efi-kernel-install, android-bootimg), the firmware method (extract-from-partitions, files), the early
   modules. `lpoco layer pack --format apk|deb|rpm|archlinux` writes an nfpm config and packs; the conveyor signs and
   publishes. Generated per device: everything - file lists, dependency names through a token map, systemd presets
   instead of enable scriptlets, initramfs drop-ins for mkinitfs, initramfs-tools, dracut and mkinitcpio from one module
   list, Nura's deviceinfo, /usr/lib/kernel/devicetree. Hand-kept once per base, never per device: the kernel package's
   scriptlet (about ten lines), a boot trigger where the base has none, the token map's column, the conveyor lane.
   `lpoco layer export` adds Asahi's contract: a tarball with the tree and a Makefile of install targets, for a
   distribution's own packager.
2. **Asahi's: a Makefile and hand recipes.** One recipe per device per format kept by hand - 8 for two phones and four
   formats, drifting as asahi-alarm's fork did. Its Makefile contract is taken into 1 as `export`.
3. **Native recipes generated per base and built in each base's container** (systemd/mkosi, OBS). Distribution-grade
   packages, but four templates and four toolchains to keep, for a quality that matters only when a distribution takes
   the recipe - and then its packager writes it from `export`. Later, if a distribution asks.
4. **Image only** (mkosi trees or today's flash overlays). No upgrades through the package manager, nothing a
   distribution can take; Nura is edge-only in mkosi.
5. **Each distribution's own tree** (Mobian's qcom-support, pmaports). The destination for giving back, not a way to
   stay agnostic; Nura takes it only by the author's hand.

Cost, in agent-hours (estimates, not measured): the [layer] types and schema 3-4; `lpoco layer pack` with the token map,
presets, initramfs drop-ins and deviceinfo 8-12; apk through nfpm in the existing lane 2-3 (settles nfpm against
apk-tools v3); deb lane in the conveyor (apt index, signed InRelease, install test in debian:trixie) 6-10; rpm lane
(createrepo_c, rpmsign, install test in fedora) 6-10; archlinux on the existing pacman lane 3-5; the walleye boot.img
trigger per base 4-6; a new device's [layer] 2-4, then every format at no further cost.

## Upstream-first, per piece

| Piece | Its upstream | Reaches every base when | Policy for AI-assisted work (giving-back-by-distro) |
|---|---|---|---|
| Kernel drivers, dts | Linux via linux-arm-msm (surya first through sm7150-mainline) | merged, and the base's kernel config enables it | kernel: allowed, the author signs |
| Kernel config | each base's kernel team: Debian salsa kernel-team, Fedora kernel-ark, ALARM PKGBUILDs, Alpine aports | per base | Debian, Fedora allow; ALARM, Alpine unclear |
| Generic firmware, ath10k board files | linux-firmware; the ath10k board list | the next linux-firmware | not known yet |
| OEM-signed firmware (modem, adsp, cdsp, zap) | none - not redistributable; extracted from the phone's partitions: droid-juicer (Debian), msm-firmware-loader (Nura) | the extractor learns the device | DebianOnMobile allows; Nura forbids |
| UCM | alsa-ucm-conf (GitHub) | the next alsa-ucm-conf | not known yet |
| Sensor and key hwdb | systemd hwdb | the next systemd | not known yet |
| Haptics, LED themes | feedbackd-device-themes (freedesktop) | the next feedbackd | not known yet |
| Boot glue, surya | U-Boot (qcom generic, dt from Linux), systemd-boot, kernel-install devicetree | already generic | U-Boot not known yet |
| Boot glue, walleye | qcom-phone-utils zz-qcom-bootimg (DebianOnMobile); boot-deploy (Nura) | the device's facts known to it | Debian allows; Nura forbids |
| qrtr, rmtfs, tqftpserv, qbootctl | linux-msm; already in Debian, Fedora, Alpine | ALARM: AUR only | ALARM unclear |
| hexagonrpcd, q6voiced, bootmac, swclock-offset | their own projects; packaged in Alpine/Nura | a Debian package each | Debian allows |

What stays ours after that: the kernel until merged, each base's config request, the extractor's device entry, the
walleye trigger where no base has one, and UCM until alsa-ucm-conf takes it.

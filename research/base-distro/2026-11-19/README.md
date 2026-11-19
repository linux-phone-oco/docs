# Which distribution our phones build on - material (2026-11-19)

Research lead base-distro-research, for orchestration. Four read-only researchers read the candidates'
own pages, repositories and APIs on 2026-11-19 (Arch family; Debian/Fedora/openSUSE; NixOS/Halium;
Nura/Alpine); the lead re-measured the Mobian, ALARM, AUR, Debian and Alpine package facts below with
curl the same day. Nothing on a phone was touched. Rows: research `base-distro-candidates`,
`base-distro-how-it-stands`; decision `2026-11-19-base-distro`. Giving back builds on
`giving-back-by-distro` (research/upstream-forks/2026-11-19/giving-back-by-distro.md), not redone here.

## What we carry today (measured in our bases)

- surya runs Nura v26.06 (Alpine 3.24) whole: `device-qcom-sm7150` r11 (community; maintainers Aelin,
  Danila Tikhonov, David Wronek, Arian Kulmer - the sm7150-mainline people), `linux-postmarketos-qcom-sm7150`
  7.1_rc3 from sm7150-mainline's tags, U-Boot + systemd-boot, the UI meta-packages (research
  nura-relation-how-it-stands).
- On top, our own: the lab apk repository on Pages through the package conveyor (lab-tools/packaging:
  `lpoco-health`, `sxmo-utils` 1.18.1_p20261118 from grenudi/sxmo-utils' lab tag, pinned `sxmo-utils@lab`),
  and test kernels from grenudi/linux by lpoco's lab route (decision 2026-11-18-upstream-forks). The conveyor
  publishes pacman and apk repositories; it has no deb lane (conveyor README).
- walleye runs no distribution: kernel.org v7.3 + own dts + own initramfs. Nura has no walleye package;
  its msm8998 packages are archived. The nearest prior art (porthole-dev/pmaports taimen-bringup, 7.2.2 +
  263 patches) is pmaports-shaped (research walleye-mainline-prior-art).

So we already do not maintain an OS: the distribution carries device, kernel, Qualcomm userspace and UI
for surya; we carry a thin layer (lab tools, one forked UI package, test kernels).

## Candidates

| Candidate | surya / SM7150 | walleye / MSM8998 | Kernel | Health | AI policy | Cost to us |
|---|---|---|---|---|---|---|
| Nura (stay) | community generic port, 4 maintainers, 7.1_rc3 | none (msm8998 archived) | mainline fork | 30 Assembly members, ASBL, ~EUR 47k/yr, release every 6 months + edge | forbids (merged 2026-02-18) | today's thin layer |
| Mobian | `linux-image-6.18-sm7150` 6.18.51-1 + `sm7150-support` in **staging only**; recipe lists surya; **no image** in images.mobian.org/qcom (weekly or release); branch idle since 2026-09-13 | none | per-SoC mainline, 6.18 LTS | 2-3 core, weekly images, 13.0 Oct 2025 | Debian GR 2026-002 allows, responsibility on the contributor | reinstall; kernel back to 6.18; sxmo in Debian is 1.12.0 (2023), so ours; a deb lane in the conveyor; lpoco's boot names rewritten |
| Arch Linux ARM | none; stock `linux-aarch64` 7.3.5 has `MSM_GCC_8998` and `SM_GCC_7150` not set | none | generic mainline | rolling, 2 committers (80+19 of last 100) | none written; RFC in progress | whole device layer: kernel, device, firmware, boot; qrtr, rmtfs, tqftpserv, hexagonrpcd, qbootctl only in AUR (404 in ALARM, measured); sxmo only AUR `sxmo-utils-git` 1.17.1 (2025-08) |
| DanctNix | Pine64 only | none | linux-megi | 1 maintainer (284 of ~300 commits) | forbids LLM-written work | n/a (could lend Phosh/sxmo PKGBUILDs) |
| Manjaro ARM | none | none | - | no ARM maintainer since 2025; "not actively maintained" (2026, unconfirmed quote) | none found | dead |
| Fedora / Pocketblue | COPR `pocketblue/sm7150` kernel 6.18 last built 2026-02, no device listed | none | Fedora generic + Pocketblue COPRs | Mobility SIG a rallying point; Pocketblue 2 people | Fedora allows (Council 2025-10, disclosure); Pocketblue: reviewed and disclosed | kernel + device alone in COPR; Phosh 0.57 |
| openSUSE Mobile | none | none | sdm845 home project | 1 volunteer | none adopted | everything alone |
| Mobile NixOS | none | walleye dropped 2023 (downstream) | sdm845 at 6.4 | 1 maintainer (78 of last 100), no releases | mobile-nixos forbids LLM-written; nixpkgs allows with Assisted-by | own device module + kernel; sxmo not in nixpkgs |
| Ubuntu Touch / Droidian | UT: Halium 10, kernel 4.14.221; Droidian: "currently unsupported" | UT 16.04 only | Android vendor (downstream) | - | - | rejected: the author's word; not mainline |

Arch-based projects aimed at Qualcomm phones: none at distribution level. Individual efforts only
(Renegade OnePlus 6/6T guide 2022, stale; r8q-arch, S20 FE; omarchy-mobile, ALARM + own pacman repo, Pixel
Tensor only, active). None has SM7150 or MSM8998.

## A thin device layer on a general distribution

Every general base (ALARM, Debian, Fedora, Tumbleweed, NixOS) documents a third-party repository on top:
pacman repo, apt repo with Signed-By, COPR, OBS home project, flake overlay; pmbootstrap documents
`mirrors.pmaports_custom` / `systemd_custom` with keys in `config_apk_keys`. The question is only how thick
the layer must be. On Nura for surya it is thin (the distribution carries device, kernel, Qualcomm userspace,
UI). On ALARM, Fedora, Tumbleweed or NixOS it is the whole phone OS minus the generic userland: kernel,
device, firmware, boot config, the Qualcomm daemons, sxmo - exactly the burden the author wants to avoid.
On Mobian it is middling for surya (the family exists in staging) and whole for walleye.

## Giving back (from giving-back-by-distro, checked against the reports)

- Kernel (sm7150-mainline, LKML): open with every base, author's sign-off - this is where our device work goes.
- sxmo: closed for agent-made patches by SourceHut's terms (2026-09-10), whatever the base.
- Nura: closed (policy, no exceptions). Alpine aports: open today, council #697/#703 undecided.
- Debian/Mobian: open (GR 2026-002; Salsa MRs). Fedora: open with disclosure. nixpkgs open with
  Assisted-by, mobile-nixos itself closed. DanctNix closed. ALARM, openSUSE, Manjaro: no written rule.

## Sources read (by the researchers and the lead)

Nura: nura.eco/blog/2026/09/27/nura-rename/, 2026/09/29/road-to-main-category/, 2026/06/21/v26.06-release/,
2026/11/05/Nura-update-2026-10/; docs.nura.eco/policies-and-processes/development/ai-policy.html; pmaports
API (device-qcom-sm7150, linux-postmarketos-qcom-sm7150, archived msm8998); pmbootstrap docs/mirrors.md;
opencollective.com/postmarketos; nura.eco/team/. Alpine: council issues 697, 703; wiki Alpine_Linux:Contribute.
Mobian: wiki.debian.org/Mobian/{Devices,Contribute,Porting}, Teams/Mobian/DevelopersGuide;
salsa.debian.org/Mobian-team/devices/kernels/qcom-linux (mobian-sm7150-6.18), mobian-recipes
devices/qcom/configs/sm7150.toml; repo.mobian.org/dists/{trixie,staging,forky}; images.mobian.org/qcom/ and
/weekly/; www.debian.org/vote/2026/vote_002; sources.debian.org (sxmo-utils, qrtr, rmtfs, tqftpserv, qbootctl).
Arch: archlinuxarm.org/platforms/armv8/generic, /packages/aarch64/{linux-aarch64,phosh,plasma-mobile,qrtr,
rmtfs,tqftpserv,hexagonrpcd,qbootctl}; github.com/archlinuxarm/PKGBUILDs (CONTRIBUTING, commits, linux-aarch64
config); aur.archlinux.org RPC; codeberg.org/DanctNIX (Pine64-Arch CONTRIBUTING, danctnix-packages);
manjaro.org/products/download/arm; forum.manjaro.org/t/the-fate-of-manjaro-arm-unstable/181661;
blog.strits.dk/is-manjaro-arm-dead/; github.com/derekross/omarchy-mobile. Fedora:
fedoraproject.org/wiki/Mobility; docs.fedoraproject.org/en-US/council/policy/ai-contribution-policy/;
github.com/pocketblue/pocketblue, pocketblue.github.io/contributing; copr pocketblue/sm7150. openSUSE:
en.opensuse.org/Mobile (API); github.com/alefnode/opensuse-sdm845-images. NixOS:
mobile-nixos.github.io/mobile-nixos/devices/; mobile-nixos CONTRIBUTING.adoc; NixOS/mobile-nixos#428;
nixpkgs CONTRIBUTING (PR 514587, 581542). Halium route: devices.ubuntu-touch.io/device/{surya,walleye}/;
docs.halium.org/en/latest/porting/first-steps.html; droidian-devices surya.json.

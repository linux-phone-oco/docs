# Nura and us: what we use, depend on and owe (2026-11-19)

The material behind research `nura-relation-how-it-stands`: what each lab place takes from Nura (formerly
postmarketOS), measured from the repositories' origin/main on 2026-11-19, and the outside pages read. Read
only if the finding is questioned.

## Measured: what we use, per place

Commits read: surya-lab a800f70, google-walleye-lab baa9049, lab-tools 586c410, device-template 184c172,
sxmo-deviceprofiles 5618297; Nura pmaports 5df1155 (2026-11-18), Nura docs 44bd0a3.

| Place | What of Nura | Where it shows |
|---|---|---|
| surya-lab | The whole OS: the prebuilt image `20261030-1151-nura-v26.06-sxmo-de-sway-qcom-sm7150.img` (2.8 GB; a phosh build of 2026-11-06 beside it), Nura v26.06 on Alpine 3.24 | ~/Projects/surya-audio/image-fresh-stock, image-phosh (outside any repository; that tree is queued for cleanup, backlog surya-audio-cleanup) |
| surya-lab | Generic port qcom-sm7150: device-qcom-sm7150 r11 (MIT; deviceinfo, systemd-boot, soc-qcom, hexagonrpcd, qbootctl, alsa-ucm-conf-qcom-sm7150), linux-postmarketos-qcom-sm7150 7.1_rc3 (the sm7150-mainline tag), firmware-xiaomi-surya (proprietary, from sm7150-mainline) | pmaports device/community/*; the phone's installed set |
| surya-lab | UI packages `postmarketos-ui-{phosh,plasma-mobile,gnome-mobile,sxmo-de-sway}` | ui/switch.sh |
| surya-lab | The debug shell `pmos.debug-shell` and 172.16.42.1 USB networking | AGENTS.md, device.toml `[connection]` |
| surya-lab | Packages from Nura/Alpine v3.24 plus Alpine edge for tqftpserv | provision/packages.txt, lab/devlab-edge.list |
| surya-lab | U-Boot images per panel (huaxing, tianma) from sm7150-mainline/u-boot, the install steps from Nura's wiki | ~/Projects/surya-audio/image; sources nura-sm7150-wiki, fresh-install-plan log |
| lab-tools | Boot entry names Nura's boot-deploy writes: `pmos.conf`, `pmos_boot_uuid=`, `/pmOS_init.log`, the title "postmarketOS" (test entries sort before it) | devlab/src/kernel.rs, outcome.rs, mcp.rs |
| lab-tools | 172.16.42.1 and the USB gadget id 18d1:d001 as "the postmarketOS gadget" | devlab/src/guard.rs, fastboot.rs |
| lab-tools | deviceinfo's words in device.toml `[boot]`; the initramfs and test shapes (code ours) | manifest/, bringup/src/init.sh, health |
| lab-tools | The apk repository on Pages built for "postmarketOS v26.06 (Alpine 3.24)", aarch64: lpoco-health (ours, MIT OR Apache-2.0) and sxmo-utils 1.18.1_p20261118 (Alpine's APKBUILD forked, source grenudi/sxmo-utils tag lab-20261118.1, AGPL-3.0-only) | packaging/, .github/workflows/packages.yml |
| google-walleye-lab | No Nura OS yet: kernel.org v7.3 + our dts + our gadget initramfs; porthole-dev/pmaports (a third party's pmaports fork, branch taimen-bringup) read for the msm8998 kernel series and config; no google-walleye package or wiki page in Nura | build/pk-kernel.sh, build/README.md |
| device-template | "a phone running postmarketOS" is the template's premise | README.md |
| docs | 45 sources at postmarketos.org or nura.eco (22 + 23 of 318), 4 landscape rows of effort postmarketOS, 20 research rows naming it; upstream row alpine-aports names "Alpine aports / postmarketOS pmaports" at Alpine's address | tad sql over sources, landscape, research, upstreams |

sxmo reaches us through Nura's `postmarketos-ui-sxmo-de-sway` and Alpine's sxmo-utils package; sxmo itself
is its own project (sr.ht ~mil), not Nura's.

## What we redistribute, and what it says

The Pages repository (https://linux-phone-oco.github.io/lab-tools/) carries two packages. Its APKINDEX names,
per package, the licence (`L:`) and the upstream URL (`U:`): lpoco-health `MIT OR Apache-2.0`, every
sxmo-utils subpackage `AGPL-3.0-only` with `https://github.com/grenudi/sxmo-utils`. The tag tarball the
APKBUILD builds from is public (lab-20261118.1 resolves). The page a person reads names neither the origin
(sxmo-utils by ~mil on sr.ht, packaged from Alpine's community/sxmo-utils), nor the licence, nor where the
corresponding source is - AGPL-3.0 section 6(d) asks for "clear directions" next to the object code.
Nothing of Nura's own (pmaports files, images, firmware) is redistributed: images and U-Boot stay on the lab
machine. None of the five lab repositories has a LICENSE file, and none of their READMEs names Nura except
lab-tools' and device-template's in passing.

## Outside, read

- Rename: blog post 2026-09-27 (https://nura.eco/blog/2026/09/27/nura-rename/); PMCR 0003 (the plan,
  2025-03-04) and PMCR 0006 (2025-08-20) - pmaports, bpo and pmbootstrap keep their names, the mirror keeps a
  `postmarketos` path, `postmarketos-*` packages to be renamed with `provides` for the old names. Hosts
  postmarketos.org redirect (301) to nura.eco; GitLab group now gitlab.nura.eco/nura (2026-10-30).
  endoflife.date: renamed to Nura in September 2026.
- AI policy: https://docs.nura.eco/policies-and-processes/development/ai-policy.html, forbidding since
  2026-02-16 (docs commit 3c4f547, MR 49): "We forbid the use of generative AI tools in Nura." Not allowed:
  submitting contributions "fully or in part created by generative AI tools", and recommending such tools.
  The Code of Conduct lists "Using or promoting generative AI tools" as unacceptable; the wiki rules ask
  writing to be one's own and name AI-assisted writing. It names no kinds (code, issues, test results); it
  covers the GitLab instance, so issues and comments too.
- Giving back as a person: https://nura.eco/contribute/ (issues, wiki, Testing Team, porting, upstream work,
  donations); Testing Team on the wiki (members test MRs with mrtest; on edge "any person in a MR thread"
  may confirm it works); hardware CI by a device's gitlab-ci.yml.j2 on CI-tron (none for sm7150).
- Licences: pmaports LICENSE is GPL-3.0; APKBUILDs carry their package's licence (device-qcom-sm7150 MIT);
  pmbootstrap GPL-3.0-or-later; Alpine aports has no repository licence (asked, never settled);
  sxmo-utils AGPL-3.0-only.
- How others record a downstream: Mobian - Debian's derivatives census entry
  (https://wiki.debian.org/Derivatives/Census/Mobian) and "Based on Debian" on its home page; PureOS/Purism -
  a census entry (https://wiki.debian.org/Derivatives/Census/Purism), nothing on pureos.net; Ubuntu - a
  governance page "Debian is the rock on which Ubuntu is built"; Nura itself - one line on its home page,
  "Alpine Linux on which we are directly based". Debian asks derivatives to join the census and give back
  (https://www.debian.org/derivatives/). Nura and Alpine keep no census of their own downstreams. The shape:
  one line where a reader meets the project, plus one structured entry where the parent keeps them.

Scratch clones the researcher read (Nura docs, pmcr, pmaports, pmbootstrap, Alpine aports, sxmo-utils) were
not kept.

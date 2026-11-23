<!-- Generated from data/ by tad. Do not edit by hand. -->

# Upstream Items

<a id="sxmo-profile-patch"></a>
### Sxmo device profile for xiaomi,surya (POCO X3 NFC)

Upstream
: sxmo-devel

Form
: patch

State
: landed

From work
: upstream-sxmo-profile

Domain
: sxmo

Tags
: device-profile,surya

Local ref
: linux-phone-oco/sxmo-utils deviceprofile/xiaomi-surya

File
: upstream/sxmo-devel/sxmo-profile-patch/

Sent on
: 2026-11-17

Forwarded
: https://lists.sr.ht/~mil/sxmo-devel

Applied upstream
: https://git.sr.ht/~mil/sxmo-utils/commit/1fd7822

Waits
: nothing (landed)

Note
: Accepted on sxmo-devel ('accepted. thank you', the author's mail 2026-11-17) and in sxmo-utils master as 1fd7822 'deviceprofiles: add xiaomi,surya (POCO X3 NFC)'. Next: it reaches pmOS with sxmo-utils' next release.

Last update
: 2026-11-17


<a id="tas2562-slot-length-patch"></a>
### ASoC: tas2562: match the RX slot length to the samples

Upstream
: linux-sound

Form
: patch

State
: draft

From work
: upstream-tas2562-slot-length

Domain
: audio

Tags
: kernel,tas2562,stereo

About
: audio-mic

Local ref
: linux-phone-oco/linux fix/tas2562-i2s-slot-length

File
: upstream/linux-sound/tas2562-slot-length-patch/

Waits
: the author's word and sign-off

Note
: Patch 1 of 2 of a series with tas2562-volume-patch; send both with a cover letter

Last update
: 2026-11-17


<a id="sm7150-wcd-series"></a>
### SM7150 WCD9375: four patches, with the message to sm7150-mainline

Upstream
: sm7150-mainline

Form
: patch

State
: draft

From work
: mic-upstream

Domain
: audio

Tags
: kernel,wcd9375,soundwire,dts

About
: audio-mic

Local ref
: linux-phone-oco/linux PRs 3-6

File
: upstream/sm7150-mainline/sm7150-wcd-series/

Waits
: the author's word; patches 2 and 3 apply on feat/surya-wcd937x-mic-headphone

Note
: Neither file is in mainline yet; goes to sm7150-mainline first, with the message in the folder

Last update
: 2026-11-17


<a id="ucm-surya-stereo-patch"></a>
### UCM: stereo speakers for xiaomi surya (HiFi.conf)

Upstream
: alsa-ucm-conf

Form
: patch

State
: draft

From work
: upstream-ucm-surya-stereo

Domain
: audio

Tags
: ucm,stereo

Local ref
: surya-lab ucm/Xiaomi/surya/HiFi.conf

File
: upstream/alsa-ucm-conf/ucm-surya-stereo-patch/

Waits
: the tas2562 slot-length fix accepted or at least posted

Last update
: 2026-11-17


<a id="pd-mapper-order-finding"></a>
### The ADSP must not boot before the in-kernel PD mapper

Upstream
: linux-arm-msm

Form
: finding

State
: draft

From work
: upstream-pd-mapper-order

Domain
: audio

Tags
: remoteproc,pd-mapper,adsp

File
: upstream/linux-arm-msm/pd-mapper-order-finding/

Waits
: the author's word

Note
: About one boot in five the ADSP asks for domains before qcom_pd_mapper answers

Last update
: 2026-11-17


<a id="alpine-tqftpserv-request"></a>
### tqftpserv >= 1.2 in Alpine v3.24-stable

Upstream
: alpine-aports

Form
: correction

State
: draft

From work
: upstream-alpine-tqftpserv

Domain
: modem

Tags
: tqftpserv,alpine

File
: upstream/alpine-aports/alpine-tqftpserv-request/

Bug
: pmaports issue 4441

Waits
: the author: a request to Alpine is made in his name

Note
: v3.24 ships 1.1.1 which never writes the modem's state files; edge has 1.3

Last update
: 2026-11-17


<a id="mic-pr60-comment"></a>
### Review and test PR 60 on surya, comment with surya's findings

Upstream
: sm7150-mainline

Form
: information

State
: draft

From work
: mic-upstream

Domain
: audio

Tags
: review,capture

About
: audio-mic

File
: upstream/sm7150-mainline/mic-pr60-comment/

Note
: ADC2 needs its own port (2 3 4 5); the codec node without pin states

Last update
: 2026-11-17


<a id="tas2562-volume-patch"></a>
### ASoC: tas2562: fix the digital volume write order, table and resume

Upstream
: linux-sound

Form
: patch

State
: draft

From work
: upstream-tas2562-volume

Domain
: audio

Tags
: kernel,tas2562,volume

Local ref
: linux-phone-oco/linux PR 2 fix/tas2562-volume

File
: upstream/linux-sound/tas2562-volume-patch/

Waits
: the author's word and sign-off

Note
: Patch 2 of 2 with tas2562-slot-length-patch

Last update
: 2026-11-17


<a id="bring-up-method-a-feedback-channel-first-then"></a>
### Bring-up method: a feedback channel first, then the vendor kernel as known-good, then mainline (bring-up-a-part)

Upstream
: ideal-agent

Form
: finding

State
: landed

From work
: walleye-bootstrap-method-how-it-stands

Domain
: bring-up

Tags
: bring-up,method,fastboot

About
: google-walleye

Forwarded
: grenudi/ideal-agent PR 56

Applied upstream
: https://github.com/grenudi/ideal-agent/pull/56 (plugin 0.3.21, bring-up-a-part 'A device from nothing', decision 2026-11-17-a-device-from-nothing)

Note
: Taken in as written for any device: the known-good boot may be the vendor kernel or the accepted stock image itself.

Last update
: 2026-11-17


<a id="qcom-wdt-armed-in-suspend"></a>
### qcom_wdt: a way to keep the watchdog armed through system suspend, as a test lab's way back from a suspend that does not return

Upstream
: linux-arm-msm

Form
: question

State
: superseded

From work
: 2026-11-18-phone-side-pieces-under-the-roof

About
: phone-side-pieces

Waits
: none

Note
: Not to be asked: keeping a watchdog running through suspend was refused as policy for imx2_wdt (Roeck Dec 2025, Kozlowski Jan 2026), and the APSS counter freezes in the deepest sleep (why try 4 had no bite). Superseded by pmic-wdt-wake-in-suspend (decision 2026-11-18-upstream-forks, research pmic-wdt-way-back); the surya-lab module parameter stays lab-only until that is proven.

Last update
: 2026-11-18


<a id="pmic-wdt-wake-in-suspend"></a>
### [RFC PATCH 0/4] watchdog: pm8916_wdt: gen2 PON (pm8998, pm6150) and kept running through suspend when its bark may wake

Upstream
: linux-watchdog

Form
: patch

State
: held

From work
: 2026-11-18-upstream-forks

About
: deep-sleep

Local ref
: linux-phone-oco/linux topic/pmic-wdt-wake-in-suspend e123d3bff on v7.3 (local worktree ~/Projects/linux-phone-oco/linux-topics)

File
: upstream/linux-watchdog/pmic-wdt-wake-in-suspend/

Supersedes
: qcom-wdt-armed-in-suspend

Carried in
: fork-linux/topic/pmic-wdt-wake-in-suspend

Waits
: pmic-wdt-gen2-v1 accepted, then the proof pmic-wdt-wakes-in-suspend on surya and walleye, then the author's word and sign-off

Note
: Split 2026-11-19: the gen2, binding, dts and the two fixes went to pmic-wdt-gen2-v1; this item is now only the later suspend series (wakeup-source, kept running in suspend), on top of v1.

Last update
: 2026-11-19


<a id="sxmo-autosuspend-backoff"></a>
### [PATCH sxmo-utils 1/3] sxmo_autosuspend.sh: back off after a failed suspend (1..64 s, SXMO_SUSPEND_RETRY_MAX)

Upstream
: sxmo-devel

Form
: patch

State
: withdrawn

From work
: 2026-11-18-upstream-forks

About
: upstream-forks

Local ref
: linux-phone-oco/sxmo-utils topic/sxmo-autosuspend-backoff 2bb2500 (local clone ~/Projects/linux-phone-oco/sxmo-utils-topics)

File
: upstream/sxmo-devel/sxmo-suspend-series/

Carried in
: fork-sxmo-utils/topic/sxmo-autosuspend-backoff

Waits
: none

Note
: Withdrawn 2026-11-19, unsent: sxmo's list is on SourceHut, whose ToS since 2026-09-10 bars LLM-written contributions; the author's yes to 2026-11-19-hardware-test-layer. The fork branch stays as it is; nothing goes to sxmo-devel.

Last update
: 2026-11-19


<a id="sxmo-suspend-stop-by-profile"></a>
### [PATCH sxmo-utils 2/3] suspend: stop the services a device profile names around suspend (SXMO_SUSPEND_STOP_SERVICES)

Upstream
: sxmo-devel

Form
: patch

State
: withdrawn

From work
: 2026-11-18-upstream-forks

About
: upstream-forks

Local ref
: linux-phone-oco/sxmo-utils topic/sxmo-suspend-stop-by-profile 1156bb6 (on the backoff patch)

File
: upstream/sxmo-devel/sxmo-suspend-series/

Carried in
: fork-sxmo-utils/topic/sxmo-suspend-stop-by-profile

Waits
: none

Note
: Withdrawn 2026-11-19, unsent: sxmo's list is on SourceHut, whose ToS since 2026-09-10 bars LLM-written contributions; the author's yes to 2026-11-19-hardware-test-layer. The fork branch stays as it is; nothing goes to sxmo-devel.

Last update
: 2026-11-19


<a id="sxmo-surya-sensors-suspend"></a>
### [PATCH sxmo-utils 3/3] deviceprofiles: xiaomi,surya: stop the sensors daemon around suspend

Upstream
: sxmo-devel

Form
: patch

State
: withdrawn

From work
: 2026-11-18-upstream-forks

About
: upstream-forks

Local ref
: linux-phone-oco/sxmo-utils topic/sxmo-surya-sensors-suspend 6432ef9

File
: upstream/sxmo-devel/sxmo-suspend-series/

Carried in
: fork-sxmo-utils/topic/sxmo-surya-sensors-suspend

Waits
: none

Note
: Withdrawn 2026-11-19, unsent: sxmo's list is on SourceHut, whose ToS since 2026-09-10 bars LLM-written contributions; the author's yes to 2026-11-19-hardware-test-layer. The fork branch stays as it is; nothing goes to sxmo-devel.

Last update
: 2026-11-19


<a id="rhizoid-carries-mail-forks"></a>
### What rhizoid needs to carry a mailing-list fork: non-GitHub tracking, a topic series per item, mail send-back, retire on landed, a distro package pin

Upstream
: git-rhizoid

Form
: finding

State
: draft

From work
: upstream-forks-landscape

About
: upstream-forks

Waits
: its owner's look-around (a backlog item in git-rhizoid.github.io, beside send-back-writes-the-upstream-item and cutting-as-cargo-dependency)

Note
: From linux-phone-oco: sxmo-utils (sr.ht, mailed) and the kernel (b4, mailed). (1) a cutting of a non-GitHub upstream: tracking by git fetch + push, created by gh repo create + push; (2) one topic branch per upstream item off tracking, rebased only before a send, and an integration branch merging the topics, never rebased, that consumers pin - the patch branch cut per item; (3) send-back by mail: format-patch/b4 prep of tracking..topic with cover letter and recipients, never sending, returned for the follower's upstream item; (4) retire a topic when upstream carries it (patch-id against tracking) and say so (landed, carried-in none); (5) a pin where a distro package reads it (APKBUILD source tag + sha512sums), the cargo item generalised. Meanwhile: plain git by decision 2026-11-18-upstream-forks and tad q carried.

Last update
: 2026-11-18


<a id="idealkb-slice-from-prefix"></a>
### A source's generic list may say #! from = DIR/: its files are read from DIR in the source and laid at the base's root; check-one-owner compares the laid paths

Upstream
: idealkb

Form
: patch

State
: landed

From work
: 2026-11-18-device-layer-from-docs

About
: base-graph

Applied upstream
: idealkb v0.17.0 (decision 2026-11-18-slice-from-a-folder)

Note
: Released; docs v0.17.0 serves device-layer/ with it.

Last update
: 2026-11-18


<a id="idealkb-skip-unchanged-slice"></a>
### update-pins moves a base's pin only when a file of the source's list changed between the pin and the latest release

Upstream
: idealkb

Form
: patch

State
: landed

From work
: 2026-11-18-device-layer-from-docs

About
: base-graph

Applied upstream
: idealkb v0.18.0 (decision 2026-11-18-pin-moves-only-with-its-slice)

Note
: docs releases several times a day; most releases do not touch the device layer and should open nothing in four bases. git diff --quiet vOLD vNEW -- the listed files (and the marked parts).

Last update
: 2026-11-18


<a id="idealkb-own-needs-item"></a>
### own is a named override with a status: an own file that differs from the source at the pin passes only while an upstream item of the base names it or the pin says own_why; an own tables.toml keeps the marked part

Upstream
: idealkb

Form
: patch

State
: landed

From work
: 2026-11-18-device-layer-from-docs

About
: base-graph

Applied upstream
: idealkb v0.19.0 (decision 2026-11-18-own-says-why; [why] in the pin file, bin/check-own.sh)

Note
: Measured: docs' 6 own statements differ, decision.sql lacks --supersedes/--amends/--scope/--tracked-by since 0.14.0, no item names them; each device base's own tables.toml lacks 101 lines of 0.16.0's part (the known gap tables-own-drift). Yocto Upstream-Status and DEP-3 Forwarded, failing rather than warning (9.4% forwarded where it only warns). graph-drift.sh own-behind and own-part are the test.

Last update
: 2026-11-18


<a id="idealkb-exit3-sends-up"></a>
### When a base changed a followed file, update-pins also opens that change as a PR on the source at the pinned release and records an upstream item in the base

Upstream
: idealkb

Form
: patch

State
: landed

From work
: 2026-11-18-device-layer-from-docs

About
: base-graph

Applied upstream
: idealkb v0.19.0 (decision 2026-11-18-exit3-sends-up; bin/send-up.sh)

Note
: Not run live yet: no base differs (idealkb backlog exit3-sends-up-live).

Last update
: 2026-11-18


<a id="rhizoid-scope-every-edge"></a>
### rhizoid's scope: the follow tool for every edge a repository has (slice, tool pin, cutting), one status over all, both ways; status first, then follow by conformance with idealkb's follow.sh, send-back, cuttings

Upstream
: git-rhizoid

Form
: finding

State
: draft

From work
: 2026-11-18-device-layer-from-docs

About
: base-graph

Note
: From research base-graph-measured and base-graph-world: no Rust or shell tool carries root-level files down and changes up (only copybara, JVM); the cutting case has no tool here. Build order, each replacing shell only once it passes the shell's tests: status (passes graph-drift.sh), follow (passes idealkb bin/test-follow.sh fixtures byte for byte; keeps the pin naming its source, one owner per file, the followers' gate), send-back (idealkb-exit3-sends-up's shape), cuttings (rhizoid-carries-mail-forks). Never a template engine, a merge of data or rows. Its base's items slice-consumption, followers-one-pin-bump, send-back-writes-the-upstream-item and implement-cli are reshaped to it.

Last update
: 2026-11-18


<a id="workarounds-reader-items-and-sites"></a>
### scripts/workarounds: read backlog items across bases, sites only, and say each workaround's way out - so a lane rule and a script read the same

Upstream
: ideal-agent

Form
: finding

State
: draft

From work
: workarounds-reader-items-and-sites

Domain
: agents

Tags
: workarounds,scripts,rules

About
: workarounds

Note
: From decision 2026-11-18-workarounds-read-as-one (linux-phone-oco/docs). Measured on 2026-11-18 over surya-lab, google-walleye-lab and docs at origin/main: every marker found is a record's note or AGENTS.md's 'WORKAROUND(item-id)' example, so the reader reports 'due: item-id' on two bases; a marker naming a backlog item (our own work, here a kept kernel) reads 'not known' and so 'due'; the lines give a state but not the way out. Asked: --base repeatable; ITEM looked up in upstream_items then backlog; skip data/, rendered docs/, research/ and the example; print SITE: ITEM - STATE - way out (patch to UPSTREAM | carried in FORK, due once the device runs it | our work, backlog ITEM in BASE | due: retire). The check that shows it: research/workarounds/2026-11-18/workarounds-read.sh in linux-phone-oco/docs (B, C, D). The skill text (look-around-first, after a fix) may say a lane rule is a workaround too, marked where the lane reads it.

Last update
: 2026-11-18


<a id="pmic-wdt-gen2-v1"></a>
### [PATCH 0/6] watchdog: pm8916_wdt: Second generation PON (PM8998, PM6150): two fixes, binding, driver, two dts nodes

Upstream
: linux-watchdog

Form
: patch

State
: held

From work
: upstream-readiness-inventory

About
: upstream-forks

Local ref
: next-20261118 + 6 (prep tree); fork-linux/topic/pmic-wdt-wake-in-suspend 8b2283da3 and f5bb57d27 for the fixes

File
: upstream/linux-watchdog/pmic-wdt-gen2-v1/

Waits
: the author's word to send; first re-checked against walleye-wdt-reset-boots-charger-mode, bootstatus after a bite, surya's PM6150 bite (attended-keep-calls4-for-bite) and walleye-wdt-bite-cable-out, as each lands

Note
: Held 2026-11-20 on the author's word: 'lets hold on them for now, good thing they are prepared. just in case we stumble upon something more while working on walleye that is relative to those patches'. Prepared on next-20261119, checked clean, Pixel 2 bite and reboot passed (PR 624). Corrected: surya's bite was the APSS watchdog's, so no PM6150 bite is proven; the cover letter now says so. SEND-NOTES 'On hold' ties the series to the four open items.

Last update
: 2026-11-19


<a id="role-start-brief-whole"></a>
### The role start hands the brief over whole from origin/main: a per-session file with its commit, the hook's output under the app's cap

Upstream
: ideal-agent

Form
: finding

State
: landed

From work
: 2026-11-19-roles-read-origin-main-not-shared-clones

About
: agent-folder

Applied upstream
: grenudi/ideal-agent#113 (plugin 0.3.63)

Note
: 2026-11-19: the whole brief from origin/main in ~/.local/state/ideal-agent/sessions/SESSION.brief.md; starts 5.7-8.3 KB for linux-phone-oco's roles, under the 10,000 cap (ideal-agent decision 2026-11-19-roles-act-on-origin-main).

Last update
: 2026-11-19


<a id="guard-refuses-stale-clone-reads"></a>
### The guard refuses a command in, or a file read from, a shared clone's main checkout behind its local origin/main, naming the worktree line

Upstream
: ideal-agent

Form
: finding

State
: landed

From work
: 2026-11-19-roles-read-origin-main-not-shared-clones

About
: agent-folder

Applied upstream
: grenudi/ideal-agent 0.3.63

Note
: 2026-11-19: PreToolUse on Bash|Read|Grep|Glob refuses work in a shared clone behind its origin/main; seen refusing orchestration's ikb in the docs clone 1 behind the same evening.

Last update
: 2026-11-19


<a id="stale-worktrees-pruned"></a>
### Agent worktrees left behind are pruned: about 90 under ~/Projects/linux-phone-oco, most 200-540 commits behind, some on branches

Upstream
: ideal-agent

Form
: finding

State
: landed

From work
: 2026-11-19-roles-read-origin-main-not-shared-clones

About
: agent-folder

Applied upstream
: grenudi/ideal-agent#114 (plugin 0.3.64)

Note
: 2026-11-19: ideal-agent prune now|show, daily from the session start; clean worktrees and build runs idle 3 days. Also fixed orchestration's 0.3.62 sweep (find -newermt '-3 days' fails under bfs, so it removed every other build run folder).

Last update
: 2026-11-19


<a id="walleye-board-dts"></a>
### [PATCH 0/2] arm64: dts: qcom: Add Google Pixel 2 (walleye): binding and a minimal board file

Upstream
: linux-arm-msm

Form
: patch

State
: draft

From work
: upstream-readiness-inventory

About
: upstream-forks

Local ref
: google-walleye-lab research/walleye-first-fastboot-boot/2026-11-19-upstream-dts (walleye-upstream-dts-series)

File
: upstream/linux-arm-msm/walleye-board-dts/

Waits
: walleye-upstream-board-dts-next (touch, haptics, display, splash, PMIC wdt node, each its own patch), the author's authorship, sign-off and go

Note
: Draft v0: two patches, checked on v7.3, booted once to the usb0 shell (walleye-upstream-dts-tried-boots). The walleye lane makes the next version, here. Not sent.

Last update
: 2026-11-19


<a id="walleye-drv2624"></a>
### Input: drv2624: TI DRV2624 haptics - binding, driver (porthole, Giuseppe Maggio), two fix patches, the walleye dts node

Upstream
: linux-input

Form
: patch

State
: draft

From work
: chip-series-in-fork-linux

About
: walleye-drv2624

Local ref
: topic/walleye-drv2624

File
: upstream/linux-input/walleye-drv2624/

Carried in
: fork-linux/topic/walleye-drv2624

Waits
: its topic branch on v7.3 made and pushed by walleye's builder, then the author's authorship, sign-off and go

Note
: topic/walleye-drv2624 exists on the lab machine only (4 commits on v7.3); the dts node 0005 is still a .patch in google-walleye-lab kernel/drv2624/. The driver is porthole's port, Assisted-by LLM: the author settles the lab's line before it goes.

Last update
: 2026-11-23


<a id="walleye-fuel-gauge-rfc"></a>
### Tested-by on [PATCH RFC 0/8] Qualcomm 3rd gen fuel gauge (Heidelberg for Selvaraj): patches 1-3 carried for the Pixel 2

Upstream
: linux-pm

Form
: information

State
: draft

From work
: 2026-11-23-structure-kernel-topics-and-integration

About
: walleye-fuel-gauge

Local ref
: topic/walleye-fuel-gauge-rfc

File
: upstream/linux-pm/walleye-fuel-gauge-rfc/

Carried in
: fork-linux/topic/walleye-fuel-gauge-rfc

Waits
: the fuel gauge's readings checked on walleye (readiness class b), then the author's word for a Tested-by reply

Note
: Others' patches, kept as received (lore 20251124-pmi8998_fuel_gauge-v1-0-dd3791f61478@ixit.cz). Today they are 3 .patch files in google-walleye-lab kernel/fuel-gauge-rfc/ and 3 commits inside topic/ufs-match-android: they move to their own topic. Ends when the RFC lands upstream.

Last update
: 2026-11-23


<a id="walleye-audio-adsp-q6"></a>
### MSM8998 ADSP audio: sndcard binding, machine driver, q6afe I2S clock fix, APR/slimbus/voice dtsi nodes, the walleye dts (9 patches, mostly porthole's)

Upstream
: linux-sound

Form
: patch

State
: draft

From work
: 2026-11-23-structure-kernel-topics-and-integration

About
: walleye-adsp-q6-mi2s

Local ref
: topic/walleye-audio-adsp-q6

File
: upstream/linux-sound/walleye-audio-adsp-q6/

Carried in
: fork-linux/topic/walleye-audio-adsp-q6

Waits
: its topic branch on v7.3 made and pushed by walleye's builder, then the author's authorship, sign-off and go; the dtsi and board patches go to linux-arm-msm as their own series

Note
: Nine .patch files in google-walleye-lab kernel/audio-adsp-q6/, authors Maggio, Kettunen, Del Regno, Connolly kept (decision 2026-11-19-walleye-audio-port-shape: four groups, each upstreamable alone). Not yet a branch. Whether we send others' patches or ask porthole to is the author's call.

Last update
: 2026-11-23


<a id="walleye-panel-s6e3fa5"></a>
### drm/panel: Samsung S6E3FA5 (Pixel 2) - dt-bindings and the panel driver, two patches

Upstream
: dri-devel

Form
: patch

State
: draft

From work
: 2026-11-23-structure-kernel-topics-and-integration

About
: walleye-display-s6e3fa5

Local ref
: topic/walleye-panel-s6e3fa5

File
: upstream/dri-devel/walleye-panel-s6e3fa5/

Carried in
: fork-linux/topic/walleye-panel-s6e3fa5

Waits
: its topic branch on v7.3 made and pushed by walleye's builder, then the author's authorship, sign-off and go; a clean boot of the exact series (walleye's walleye-upstream-panel-series)

Note
: Today one source file, google-walleye-lab kernel/panel-samsung-s6e3fa5.c, copied in by the build; the binding is not written yet. Walleye named the docs home upstream/dri-devel/ in PR 637.

Last update
: 2026-11-23


<a id="ufs-match-android"></a>
### MSM8998 UFS as Android runs it: host revision to the PHY, qmp-ufs tables by revision, UFS_RESET gpio, the card's quirk and purge guard, register dump

Upstream
: linux-scsi

Form
: patch

State
: draft

From work
: 2026-11-23-structure-kernel-topics-and-integration

About
: walleye-ufs-match-android-z

Local ref
: topic/ufs-match-android

File
: upstream/linux-scsi/ufs-match-android/

Carried in
: fork-linux/topic/ufs-match-android

Waits
: walleye-ufs-try-2 on the phone (the author's go), then the series split by list (scsi, phy, pinctrl) and the author's word

Note
: topic/ufs-match-android exists on the lab machine only, on v7.3 plus the pmic-wdt topic and 3 fuel-gauge commits: those leave it (a topic stands alone). The register dump is bring-up only and is not sent.

Last update
: 2026-11-23


<a id="ufs-hynix-quirks"></a>
### scsi: ufs: qcom: Hynix quirks (extended sync length, no purge, one TX lane) with review fixes

Upstream
: linux-scsi

Form
: patch

State
: draft

From work
: 2026-11-23-structure-kernel-topics-and-integration

About
: walleye-ufs-match-android-z

Local ref
: topic/ufs-hynix-quirks

File
: upstream/linux-scsi/ufs-hynix-quirks/

Carried in
: fork-linux/topic/ufs-hynix-quirks

Waits
: whether it goes at all: decision 2026-11-19-walleye-ufs-no-sync-length-quirk found Android writes neither quirk on this card

Note
: On the fork, 2 commits on v7.3 plus the pmic-wdt topic (which leaves it). Likely not-needed for walleye; kept as a row so the assemble check knows it.

Last update
: 2026-11-23


<a id="surya-wcd9375-wireup"></a>
### arm64: dts: qcom: sm7150-xiaomi-surya: wire up the WCD9375 codec for mic and headphone (LPASS SoundWire, codec node, DAI links)

Upstream
: sm7150-mainline

Form
: patch

State
: draft

From work
: 2026-11-23-structure-kernel-topics-and-integration

About
: audio-mic

Local ref
: topic/surya-wcd9375-wireup

File
: upstream/sm7150-mainline/surya-wcd9375-wireup/

Carried in
: fork-linux/topic/surya-wcd9375-wireup

Waits
: surya's builder splitting the 9 commits into topics until rhizoid assemble --reproduces 29d92793b says equal; then the author's word

Note
: Commit cadeb5a68 on origin/v7.2 (feat/surya-wcd937x-mic-headphone). It adds aoncc, which sm7150-va-macro-q6afecc-clock removes: the two should be folded into one patch before sending, beside sm7150-wcd-series.

Last update
: 2026-11-23


<a id="sm7150-va-macro-q6afecc-clock"></a>
### arm64: dts: qcom: sm7150: drop aoncc; clock the VA macro from q6afecc (aoncc at the SM8250 address hung the boot)

Upstream
: sm7150-mainline

Form
: patch

State
: draft

From work
: wcd937x-dt-aoncc

About
: audio-mic

Local ref
: topic/sm7150-va-macro-q6afecc-clock

File
: upstream/sm7150-mainline/sm7150-va-macro-q6afecc-clock/

Carried in
: fork-linux/topic/sm7150-va-macro-q6afecc-clock

Waits
: the same split and reproduce as surya-wcd9375-wireup; folded into it if that is not upstream first

Note
: Commit 708930065 (dt/surya-wcd-rx-channel-map), proven on the phone: only aoncc disabled, the tree boots. Fixes our own wire-up, so upstream it only exists as part of that patch.

Last update
: 2026-11-23


<a id="surya-q6voice-calls"></a>
### Modem calls on SM7150: q6voice from sdm845-mainline with CVD 2.3, APR voice services and a VoiceMMode1 link (pulpoff's commit)

Upstream
: sm7150-mainline

Form
: patch

State
: draft

From work
: calls-audio-q6voice

About
: modem-calls

Local ref
: topic/surya-q6voice-calls

File
: upstream/sm7150-mainline/surya-q6voice-calls/

Carried in
: fork-linux/topic/surya-q6voice-calls

Waits
: pulpoff, whose work it is: whether he sends it to sm7150-mainline; we carry it as it is

Note
: Commit 29d92793b, cherry-picked from pulpoff/linux-surya c314b3bdf (test/surya-calls). Not ours to send. Its uplink also needs a userspace mono capture during a call (surya-call-uplink): a WORKAROUND candidate, not marked yet.

Last update
: 2026-11-23


<a id="walleye-mdss-reset"></a>
### arm64: dts: qcom: msm8998: Add the MDSS reset (the bootloader leaves the display block scanning out its splash)

Upstream
: linux-arm-msm

Form
: patch

State
: draft

From work
: 2026-11-23-structure-kernel-topics-and-integration

About
: walleye-display-s6e3fa5

Local ref
: topic/walleye-mdss-reset

File
: upstream/linux-arm-msm/walleye-mdss-reset/

Carried in
: fork-linux/topic/walleye-mdss-reset

Waits
: the display boot proven with it on walleye, then the author's word

Note
: topic/walleye-mdss-reset on the fork: one commit on v7.3 (58d8fd902, walleye-builder, 2026-11-23); one dtsi line, the mmcc already provides MDSS_BCR.

Last update
: 2026-11-23

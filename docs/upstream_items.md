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
: draft

From work
: 2026-11-18-upstream-forks

About
: deep-sleep

Local ref
: linux-phone-oco/linux topic/pmic-wdt-wake-in-suspend e123d3bff on v7.3 (local worktree ~/Projects/linux-phone-oco/linux-topics)

File
: research/upstream-forks/2026-11-18/patches/linux/

Supersedes
: qcom-wdt-armed-in-suspend

Carried in
: fork-linux/topic/pmic-wdt-wake-in-suspend

Waits
: the phone proofs (tests pmic-wdt-bites, pmic-wdt-wakes-in-suspend on surya, then walleye), then the author's word and sign-off

Note
: Built (LLVM, W=1), checkpatch --strict clean but the trailer, binding validated. Before sending: b4 prep from the author's clone, Co-Authored-By replaced by 'Assisted-by: LLM', his Signed-off-by; recipients by get_maintainer (Wim Van Sebroeck, Guenter Roeck, linux-watchdog; dt: Rob Herring, Krzysztof Kozlowski, Conor Dooley, devicetree; dts: Bjorn Andersson, Konrad Dybcio, linux-arm-msm). Drop RFC once both phones pass.

Last update
: 2026-11-18


<a id="sxmo-autosuspend-backoff"></a>
### [PATCH sxmo-utils 1/3] sxmo_autosuspend.sh: back off after a failed suspend (1..64 s, SXMO_SUSPEND_RETRY_MAX)

Upstream
: sxmo-devel

Form
: patch

State
: draft

From work
: 2026-11-18-upstream-forks

About
: upstream-forks

Local ref
: linux-phone-oco/sxmo-utils topic/sxmo-autosuspend-backoff 2bb2500 (local clone ~/Projects/linux-phone-oco/sxmo-utils-topics)

File
: research/upstream-forks/2026-11-18/patches/sxmo-utils/

Carried in
: fork-sxmo-utils/topic/sxmo-autosuspend-backoff

Waits
: the phone proof surya-sxmo-suspend-series, then the author's word: sent in his name

Note
: Was a question; now a patch with its spec (spec/scripts/core/sxmo_autosuspend_spec.sh, fails on master, passes here). First of a series of three with sxmo-suspend-stop-by-profile and sxmo-surya-sensors-suspend; cover letter 0000 in the same folder. Send: git send-email --to '~mil/sxmo-devel@lists.sr.ht' from the author's clone.

Last update
: 2026-11-18


<a id="sxmo-suspend-stop-by-profile"></a>
### [PATCH sxmo-utils 2/3] suspend: stop the services a device profile names around suspend (SXMO_SUSPEND_STOP_SERVICES)

Upstream
: sxmo-devel

Form
: patch

State
: draft

From work
: 2026-11-18-upstream-forks

About
: upstream-forks

Local ref
: linux-phone-oco/sxmo-utils topic/sxmo-suspend-stop-by-profile 1156bb6 (on the backoff patch)

File
: research/upstream-forks/2026-11-18/patches/sxmo-utils/

Carried in
: fork-sxmo-utils/topic/sxmo-suspend-stop-by-profile

Waits
: the phone proof surya-sxmo-suspend-series, then the author's word: sent in his name

Note
: Was a question; now a patch. Answers why proycon's 2024 list was refused (sxmo-devel 55649: the wakeup count goes stale while services stop): the count is read again after the stop. Moves google,b4s4-sdm670 into its profile (it is now started again after suspend - say so in the cover letter).

Last update
: 2026-11-18


<a id="sxmo-surya-sensors-suspend"></a>
### [PATCH sxmo-utils 3/3] deviceprofiles: xiaomi,surya: stop the sensors daemon around suspend

Upstream
: sxmo-devel

Form
: patch

State
: draft

From work
: 2026-11-18-upstream-forks

About
: upstream-forks

Local ref
: linux-phone-oco/sxmo-utils topic/sxmo-surya-sensors-suspend 6432ef9

File
: research/upstream-forks/2026-11-18/patches/sxmo-utils/

Carried in
: fork-sxmo-utils/topic/sxmo-surya-sensors-suspend

Waits
: the phone proof surya-sxmo-suspend-series, then the author's word

Note
: Third of the sxmo series; proven by test sensors-after-suspend on surya.

Last update
: 2026-11-18


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

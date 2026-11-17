<!-- Generated from data/ by tad. Do not edit by hand. -->

# Upstream Items

<a id="sxmo-profile-patch"></a>
### Sxmo device profile for xiaomi,surya (POCO X3 NFC)

Upstream
: sxmo-devel

Form
: patch

State
: sent

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

Waits
: review on the list

Note
: Sent by the author at 04:25 UTC, signed off, rebased on upstream master eb237fe; watch the archive

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

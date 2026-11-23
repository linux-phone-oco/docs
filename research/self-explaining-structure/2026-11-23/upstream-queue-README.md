# Upstream queue

Patches ready to send. Nothing here is sent until the user decides; each is sent signed off by the
user (add your `Signed-off-by:` - `git am` the patch, `git commit --amend -s`, `git format-patch` again).

## Linux: tas2562 (2 patches, a series)

1. `linux/0001-ASoC-tas2562-match-the-RX-slot-length-to-the-samples.patch` - stereo: the amps
   expected 32-bit slots on a 16-bit I2S link (linux-phone-oco/linux, fix/tas2562-i2s-slot-length)
2. `linux/0002-ASoC-tas2562-fix-the-digital-volume-...patch` - the volume: write order, a short and
   corrupt table (0 dB muted the amps), resume (PR #2, fix/tas2562-volume)

Recipients, from the kernel's scripts/get_maintainer.pl:

```
Shenghao Ding <shenghao-ding@ti.com>
Kevin Lu <kevin-lu@ti.com>
Baojun Xu <baojun.xu@ti.com>
Sen Wang <sen@ti.com>
Liam Girdwood <lgirdwood@gmail.com>
Mark Brown <broonie@kernel.org>
Jaroslav Kysela <perex@perex.cz>
Takashi Iwai <tiwai@suse.com>
linux-sound@vger.kernel.org
linux-kernel@vger.kernel.org
```

Send (from a kernel tree, after signing off):

```
git send-email --cover-letter --annotate \
  --to "shenghao-ding@ti.com" \\
  --to "kevin-lu@ti.com" \\
  --to "baojun.xu@ti.com" \\
  --cc "sen@ti.com" \\
  --cc "lgirdwood@gmail.com" \\
  --cc "broonie@kernel.org" \\
  --cc "perex@perex.cz" \\
  --cc "tiwai@suse.com" \\
  --cc "linux-sound@vger.kernel.org" \\
  --cc "linux-kernel@vger.kernel.org" \\
  linux/*.patch
```

## Sxmo: the device profile for surya - SENT 2026-11-17

Sent by the author, signed off by him, with git send-email at 04:25 UTC (plain text; a first send
through the Gmail connector was refused by lists.sr.ht for its HTML part and never reached the list):
"[PATCH sxmo-utils] deviceprofiles: add xiaomi,surya (POCO X3 NFC)", rebased on upstream master
eb237fe. In the archive: https://lists.sr.ht/~mil/sxmo-devel - watch it for review; replies in his name
need his word. The send setup for later patches: ~/sxmo-send on the lab machine.

`sxmo-utils/0001-deviceprofiles-add-xiaomi-surya-POCO-X3-NFC.patch` (linux-phone-oco/sxmo-utils,
branch deviceprofile/xiaomi-surya). sxmo-utils takes patches by mailing list:

```
git send-email --to "~mil/sxmo-devel@lists.sr.ht" sxmo-utils/*.patch
```

## Linux: SM7150 WCD9375 (4 patches, for sm7150-mainline)

Neither file is in mainline Linux yet - the SM7150 LPI pin driver and the surya device tree live in
sm7150-mainline/linux - so these go there first, with the message in
`messages/sm7150-mainline-wcd-question.md` (rewritten 2026-11-17 to carry the findings).

1. `linux/sm7150-wcd/0001-pinctrl-qcom-sm7150-lpass-lpi-fix-the-SoundWire-data.patch` - two SoundWire
   data pins at the wrong mux index (linux-phone-oco/linux PR #3, fix/sm7150-lpass-lpi-swr-data-mux,
   on v7.2)
2. `linux/sm7150-wcd/0002-arm64-dts-qcom-sm7150-correct-the-LPASS-SoundWire-co.patch` - the SoundWire
   controllers' addresses (0x62ed0000/0x62ef0000), port tables, and no DCODEC vote, which this DSP
   rejects (PR #5, dt/sm7150-lpass-soundwire-nodes, on feat/surya-wcd937x-mic-headphone)
3. `linux/sm7150-wcd/0003-arm64-dts-qcom-sm7150-xiaomi-fix-the-WCD9375-reset.patch` - the reset's
   polarity, mux, and the sleep pin state that held the codec in reset whenever idle (PR #4,
   dt/surya-wcd9375-reset-no-sleep, on feat/surya-wcd937x-mic-headphone)
4. `linux/sm7150-wcd/0004-arm64-dts-qcom-sm7150-xiaomi-surya-capture-through-t.patch` - capture through
   the TX SoundWire controller's DAI 1 (DAI 0 is its playback DAI); found in pulpoff/linux-surya
   (PR #6, dt/surya-wcd-capture-swr-dai, on feat/surya-wcd937x-mic-headphone)

Patches 2 and 3 correct the WCD commit on feat/surya-wcd937x-mic-headphone (cadeb5a68, 708930065),
which was never the tree proven on the phone; they apply on it.

Send: sign off each (`git am`, `git commit --amend -s`), then either open a pull request on
github.com/sm7150-mainline/linux with the message as its text, or mail the patches to the LPI
driver's author (Danila Tikhonov <danila@jiaxyga.com>, from the file's copyright) and Aelin Reidel
<aelin@mainlining.org>:

```
git send-email --annotate --to danila@jiaxyga.com --to aelin@mainlining.org \
  linux/sm7150-wcd/000[1234]-*.patch
```

Status 2026-11-17: the four together (linux-phone-oco/linux test/surya-mic, with the tas2562 fixes) boot
healthy on the phone and the microphone works: the phone's own check mic-hears-speaker finds a quiet tone
from its speaker 57 dB above the noise. Credit pulpoff/linux-surya for patch 4 in the mail.

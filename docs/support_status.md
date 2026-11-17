<!-- Generated from data/ by tad. Do not edit by hand. -->

# Support Status

Rows are components, columns devices. ✅ works · 🟡 partial · ❌ broken · ❌ missing · ❔ unknown · — not-applicable. A pair nobody has checked shows ❔.

### Audio

| Components | [Xiaomi POCO X3 NFC](devices.md#xiaomi-surya) |
|---|---|
| [Speaker](components.md#audio-speaker) | [✅](support_status.md#audio-speaker--xiaomi-surya) |
| [Headphone output (3.5mm)](components.md#audio-headphone) | [❔](support_status.md#audio-headphone--xiaomi-surya) |
| [Microphone](components.md#audio-mic) | [✅](support_status.md#audio-mic--xiaomi-surya) |
| [Earpiece (call speaker)](components.md#audio-earpiece) | [✅](support_status.md#audio-earpiece--xiaomi-surya) |

### Camera

| Components | [Xiaomi POCO X3 NFC](devices.md#xiaomi-surya) |
|---|---|
| [Front camera](components.md#camera-front) | [❌](support_status.md#camera-front--xiaomi-surya) |
| [Rear camera(s)](components.md#camera-rear) | [❌](support_status.md#camera-rear--xiaomi-surya) |

### Display

| Components | [Xiaomi POCO X3 NFC](devices.md#xiaomi-surya) |
|---|---|
| [Display panel](components.md#display-panel) | [✅](support_status.md#display-panel--xiaomi-surya) |

### Input

| Components | [Xiaomi POCO X3 NFC](devices.md#xiaomi-surya) |
|---|---|
| [Touchscreen](components.md#touchscreen) | [✅](support_status.md#touchscreen--xiaomi-surya) |
| [Haptics (vibration motor)](components.md#haptics) | [✅](support_status.md#haptics--xiaomi-surya) |
| [Fingerprint or face unlock](features.md#fingerprint) | [❌](support_status.md#fingerprint--xiaomi-surya) |

### Connectivity

| Components | [Xiaomi POCO X3 NFC](devices.md#xiaomi-surya) |
|---|---|
| [Mobile data](components.md#modem-data) | [✅](support_status.md#modem-data--xiaomi-surya) |
| [Phone calls](components.md#modem-calls) | [✅](support_status.md#modem-calls--xiaomi-surya) |
| [SMS](components.md#modem-sms) | [✅](support_status.md#modem-sms--xiaomi-surya) |
| [Wi-Fi](features.md#wifi) | [✅](support_status.md#wifi--xiaomi-surya) |
| [Bluetooth](features.md#bluetooth) | [🟡](support_status.md#bluetooth--xiaomi-surya) |
| [NFC](features.md#nfc) | [❔](support_status.md#nfc--xiaomi-surya) |

### Other

| Components | [Xiaomi POCO X3 NFC](devices.md#xiaomi-surya) |
|---|---|
| [Accelerometer / gyroscope / other sensors](components.md#sensors) | [❌](support_status.md#sensors--xiaomi-surya) |
| [Kernel (boots without unexpected warnings)](components.md#kernel) | ❔ |

### Power

| Components | [Xiaomi POCO X3 NFC](devices.md#xiaomi-surya) |
|---|---|
| [USB OTG](components.md#usb-otg) | [✅](support_status.md#usb-otg--xiaomi-surya) |
| [Fastboot / bootloader](components.md#fastboot) | [✅](support_status.md#fastboot--xiaomi-surya) |
| [Deep sleep that wakes for calls and messages](features.md#deep-sleep) | [❔](support_status.md#deep-sleep--xiaomi-surya) |

### Details

<a id="audio-speaker--xiaomi-surya"></a>
Speaker × Xiaomi POCO X3 NFC
: works — notes: Stereo, both speakers, verified by ear on 2026-11-09 through PipeWire (left-only tone from the top speaker, right-only from the bottom). Needs two fixes not yet upstream: the tas2562 amplifier driver set 32-bit I2S slots on a link clocked for 16-bit, so the right channel fell outside the frame (kernel patch on linux-phone-oco/linux branch fix/tas2562-i2s-slot-length); and the packaged UCM profile is mono with no amplifier channel setup (stereo profile in surya-lab ucm/). Also needs the ADSP sensors service off (adsp-sensor-crash-loop). Both fixes are installed on the test phone, over package files a system update would replace. Measured 2026-11-11 with a microphone placed at the bottom: the right channel is the bottom speaker (7 dB louder there). — updated: 2026-11-11 — judged: works — measured: adsp-running pass (present) 20261117-095152, amp-channels pass (present) 20261117-095152, amp-volume-0x4c pass (present) 20261117-095152, amp-volume-0x4d pass (present) 20261117-095152, default-output pass (present) 20261117-095152, sound-card pass (present) 20261117-095152, speaker-stereo pass (present) 20261117-095152 — measured run: 20261117-095152

<a id="audio-headphone--xiaomi-surya"></a>
Headphone output (3.5mm) × Xiaomi POCO X3 NFC
: unknown — notes: The headset jack's detector is present. Sound through it needs a person and a pair of headphones: a witnessed test, not done yet. — updated: 2026-11-11 — judged: unknown — measured: jack-detector pass (present) 20261117-095152 — measured run: 20261117-095152

<a id="audio-mic--xiaomi-surya"></a>
Microphone × Xiaomi POCO X3 NFC
: works — notes: Both microphones work on mainline (2026-11-17): the bottom one on WCD9375 ADC1, the top one on ADC2 at INP3, through the TX SoundWire bus and the DSP's TX_CODEC_DMA_TX_3, with the UCM profile's Mic and TopMic. The phone proves it after every boot: a soft 1 kHz beep through its speaker (-6 dBFS at 20%, which the author heard and approved) is found by each microphone through the sound server, 40-60 dB above the noise. Runs on the kept kernel linux-phone-oco/linux test/surya-mic (four WCD9375 fixes, PRs 3-6, queued for sm7150-mainline). The headset microphone is not yet tried. — updated: 2026-11-17 — judged: works — measured: mic-hears-speaker pass (works) 20261117-095152, mic-records pass (present) 20261117-095152, mic-top-hears-speaker pass (works) 20261117-095152 — measured run: 20261117-095152

<a id="audio-earpiece--xiaomi-surya"></a>
Earpiece (call speaker) × Xiaomi POCO X3 NFC
: works — notes: The earpiece is the top speaker: the TAS2564 at 0x4d (left of the stereo pair), not the WCD9375's EAR amplifier, which is silent (the author listened, 2026-11-17). The UCM profile's Earpiece device plays through it alone at -18 dB, both channels mixed. The phone proves it after every boot: earpiece-heard - a soft tone through the Earpiece found by the top microphone, 50 dB above the noise. — updated: 2026-11-17 — judged: works — measured: earpiece-heard pass (works) 20261117-095152 — measured run: 20261117-095152

<a id="camera-front--xiaomi-surya"></a>
Front camera × Xiaomi POCO X3 NFC
: broken — notes: The camera pipeline and its three control buses work; the phone's description lists no image sensor, which alone is why the cameras are dark. The vendor's kernel gives the wiring of seven sensor slots and names no model. Next: power a slot and ask the chip what it is (surya-lab, research/cameras.md). — updated: 2026-11-11 — judged: broken — measured: image-sensor fail (present) 20261117-095152 — measured run: 20261117-095152

<a id="camera-rear--xiaomi-surya"></a>
Rear camera(s) × Xiaomi POCO X3 NFC
: broken — notes: The camera pipeline and its three control buses work; the phone's description lists no image sensor, which alone is why the cameras are dark. The vendor's kernel gives the wiring of seven sensor slots and names no model. Next: power a slot and ask the chip what it is (surya-lab, research/cameras.md). — updated: 2026-11-11 — judged: broken — measured: image-sensor fail (present) 20261117-095152 — measured run: 20261117-095152

<a id="display-panel--xiaomi-surya"></a>
Display panel × Xiaomi POCO X3 NFC
: works — notes: Video-mode panel fixes and panel regulator/variant support landed (6.7.4, 6.13.2). — updated: 2026-11-04 — judged: works — measured: backlight pass (present) 20261117-095152, panel-connected pass (present) 20261117-095152 — measured run: 20261117-095152

<a id="touchscreen--xiaomi-surya"></a>
Touchscreen × Xiaomi POCO X3 NFC
: works — notes: nt36xxx touchscreen driver rewrite for xiaomi-surya landed (6.7.4). — updated: 2026-11-04 — judged: works — measured: touch-device pass (present) 20261117-095152 — measured run: 20261117-095152

<a id="haptics--xiaomi-surya"></a>
Haptics (vibration motor) × Xiaomi POCO X3 NFC
: works — notes: awinic,aw8624 haptics driver added (6.2.0). — updated: 2026-11-04 — judged: works — measured: vibrator pass (present) 20261117-095152 — measured run: 20261117-095152

<a id="modem-data--xiaomi-surya"></a>
Mobile data × Xiaomi POCO X3 NFC
: works — notes: Mobile data works on mainline with a SIM (2026-11-17, Vodafone.de, LTE): tqftpserv >= 1.2 (from Alpine edge until v3.24 carries it) lets the modem finish starting, and a NetworkManager gsm connection with no APN uses the network's default. The phone proves it after every boot: mobile-data - three pings and a 100 kB download over the modem's interface. surya-lab provisions both (packages tqftpserv@edge, lab/mobile.nmconnection). — updated: 2026-11-17 — judged: works — measured: mobile-data pass (works) 20261117-095152, modem-registered pass (works) 20261117-095152, modem-running pass (present) 20261117-095152, modem-seen pass (present) 20261117-095152 — measured run: 20261117-095152

<a id="modem-calls--xiaomi-surya"></a>
Phone calls × Xiaomi POCO X3 NFC
: works — notes: Calls work both ways on mainline (2026-11-17, Vodafone.de network, 1&1 SIM): q6voice (from pulpoff/linux-surya, sdm845-mainline's drivers) in the kept kernel, a Voice Call UCM verb with earpiece and speaker, q6voiced and an uplink capture service. The phone proves it once a day: call-echo calls an echo line, plays a tone and hears it come back. The author heard the echo line's announcement on the earpiece. — updated: 2026-11-17 — judged: works — measured: call-audio-path pass (present) 20261117-095152, call-echo pass (works) 20261117-094741 — measured run: 20261117-095152

<a id="modem-sms--xiaomi-surya"></a>
SMS × Xiaomi POCO X3 NFC
: works — notes: SMS works both ways on mainline (2026-11-17, Vodafone.de network): the phone texts its own number and receives it in seconds; the author saw it arrive. Proven once a day by sms-loopback (surya-lab tests/health/base). — updated: 2026-11-17 — judged: works — measured: sms-loopback pass (works) 20261117-094741 — measured run: 20261117-094741

<a id="wifi--xiaomi-surya"></a>
Wi-Fi × Xiaomi POCO X3 NFC
: works — notes: Joins a network, holds an address, and its gateway answers - checked after every start. Speed and the 5 GHz band are not measured. — updated: 2026-11-11 — judged: works — measured: wifi-connected pass (works) 20261117-095152, wifi-interface pass (present) 20261117-095152, wifi-reaches-gateway pass (works) 20261117-095152 — measured run: 20261117-095152

<a id="bluetooth--xiaomi-surya"></a>
Bluetooth × Xiaomi POCO X3 NFC
: partial — notes: The adapter is powered and hears nearby devices (five on 2026-11-11) - checked after every start. Pairing, and sound over Bluetooth, have not been tried. — updated: 2026-11-11 — judged: partial — measured: bt-controller pass (present) 20261117-095152, bt-powered pass (present) 20261117-095152 — measured run: 20261117-095152

<a id="nfc--xiaomi-surya"></a>
NFC × Xiaomi POCO X3 NFC
: unknown — notes: The controller is seen by the kernel. No tool on the phone reads a tag yet. — updated: 2026-11-11 — judged: unknown — measured: nfc-device pass (present) 20261117-095152 — measured run: 20261117-095152

<a id="fingerprint--xiaomi-surya"></a>
Fingerprint or face unlock × Xiaomi POCO X3 NFC
: broken — notes: No fingerprint reader is exposed by the kernel. — updated: 2026-11-11 — judged: broken — measured: reader-exposed fail (present) 20261117-095152 — measured run: 20261117-095152

<a id="sensors--xiaomi-surya"></a>
Accelerometer / gyroscope / other sensors × Xiaomi POCO X3 NFC
: broken — notes: No motion, light or proximity sensor is exposed to the system. The sensor hub's service is masked on purpose: with it running, the audio processor crashed at every suspend. — updated: 2026-11-11 — judged: broken — measured: motion-and-light fail (present) 20261117-095152 — measured run: 20261117-095152

<a id="usb-otg--xiaomi-surya"></a>
USB OTG × Xiaomi POCO X3 NFC
: works — notes: OTG support added (6.13.2). — updated: 2026-11-04 — judged: works — measured: usb-awake pass (works) 20261117-095152, usb-role pass (present) 20261117-095152 — measured run: 20261117-095152

<a id="fastboot--xiaomi-surya"></a>
Fastboot / bootloader × Xiaomi POCO X3 NFC
: works — notes: Required for Nura to be installable at all, and for lab-agent's own boot-and-test loop. — updated: 2026-11-04 — judged: works

<a id="deep-sleep--xiaomi-surya"></a>
Deep sleep that wakes for calls and messages × Xiaomi POCO X3 NFC
: unknown — notes: Not measured yet: on USB the lab keeps the phone awake, and it has not suspended in a measured boot. Read 2026-11-17 without a suspend: the SoC's sleep counters work (CX collapse 0, AOSS sleep 0), the audio DSP never slept, and the device tree asks for SC7180's cluster parameters, not surya's. The path: decision 2026-11-17-deep-sleep-measured-s2idle; the steps are the sleep-* backlog items. — updated: 2026-11-17 — judged: unknown — measured: soc-sleeps skip (works) 20261117-095152 — measured run: 20261117-095152

<!-- Generated from data/ by .tad/tools/render.py. Do not edit by hand. -->

# Support Status

Rows are components, columns devices. ✅ works · 🟡 partial · ❌ broken · ❌ missing · ❔ unknown · — not-applicable. A pair nobody has checked shows ❔.

### Audio

| Components | [Xiaomi POCO X3 NFC](devices.md#xiaomi-surya) |
|---|---|
| [Speaker](components.md#audio-speaker) | [✅](support_status.md#audio-speaker--xiaomi-surya) |
| [Headphone output (3.5mm)](components.md#audio-headphone) | [❔](support_status.md#audio-headphone--xiaomi-surya) |
| [Microphone](components.md#audio-mic) | [❌](support_status.md#audio-mic--xiaomi-surya) |
| [Earpiece (call speaker)](components.md#audio-earpiece) | [❌](support_status.md#audio-earpiece--xiaomi-surya) |

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
| [Mobile data](components.md#modem-data) | [🟡](support_status.md#modem-data--xiaomi-surya) |
| [Phone calls](components.md#modem-calls) | [❔](support_status.md#modem-calls--xiaomi-surya) |
| [SMS](components.md#modem-sms) | [❔](support_status.md#modem-sms--xiaomi-surya) |
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

### Details

<a id="audio-speaker--xiaomi-surya"></a>
Speaker × Xiaomi POCO X3 NFC
: works — notes: Stereo, both speakers, verified by ear on 2026-11-09 through PipeWire (left-only tone from the top speaker, right-only from the bottom). Needs two fixes not yet upstream: the tas2562 amplifier driver set 32-bit I2S slots on a link clocked for 16-bit, so the right channel fell outside the frame (kernel patch on linux-phone-oco/linux branch fix/tas2562-i2s-slot-length); and the packaged UCM profile is mono with no amplifier channel setup (stereo profile in surya-lab ucm/). Also needs the ADSP sensors service off (adsp-sensor-crash-loop). Both fixes are installed on the test phone, over package files a system update would replace. — updated: 2026-11-09

<a id="audio-headphone--xiaomi-surya"></a>
Headphone output (3.5mm) × Xiaomi POCO X3 NFC
: unknown — notes: The headset jack's detector is present. Sound through it needs a person and a pair of headphones: a witnessed test, not done yet. — updated: 2026-11-11

<a id="audio-mic--xiaomi-surya"></a>
Microphone × Xiaomi POCO X3 NFC
: broken — notes: Explicitly called out as not yet working when the device moved from testing to community in pmOS packaging. — updated: 2026-11-04

<a id="audio-earpiece--xiaomi-surya"></a>
Earpiece (call speaker) × Xiaomi POCO X3 NFC
: broken — notes: Same source as audio-mic. — updated: 2026-11-04

<a id="camera-front--xiaomi-surya"></a>
Front camera × Xiaomi POCO X3 NFC
: broken — notes: Cameras explicitly called out as not yet working, same source as audio-mic. Measured 2026-11-11: the camera pipeline is present (10 nodes), but no image sensor is bound to it. — updated: 2026-11-11

<a id="camera-rear--xiaomi-surya"></a>
Rear camera(s) × Xiaomi POCO X3 NFC
: broken — notes: Same source as camera-front. Measured 2026-11-11: the camera pipeline is present (10 nodes), but no image sensor is bound to it. — updated: 2026-11-11

<a id="display-panel--xiaomi-surya"></a>
Display panel × Xiaomi POCO X3 NFC
: works — notes: Video-mode panel fixes and panel regulator/variant support landed (6.7.4, 6.13.2). — updated: 2026-11-04

<a id="touchscreen--xiaomi-surya"></a>
Touchscreen × Xiaomi POCO X3 NFC
: works — notes: nt36xxx touchscreen driver rewrite for xiaomi-surya landed (6.7.4). — updated: 2026-11-04

<a id="haptics--xiaomi-surya"></a>
Haptics (vibration motor) × Xiaomi POCO X3 NFC
: works — notes: awinic,aw8624 haptics driver added (6.2.0). — updated: 2026-11-04

<a id="modem-data--xiaomi-surya"></a>
Mobile data × Xiaomi POCO X3 NFC
: partial — notes: Mobile data fix landed (6.2.0); calls and SMS not separately confirmed. — updated: 2026-11-04

<a id="modem-calls--xiaomi-surya"></a>
Phone calls × Xiaomi POCO X3 NFC
: unknown — notes: Not known: there is no SIM card in the phone, and without one the modem reports a failed state. Nothing about calls can be shown until a SIM is in. — updated: 2026-11-11

<a id="modem-sms--xiaomi-surya"></a>
SMS × Xiaomi POCO X3 NFC
: unknown — notes: Not known: there is no SIM card in the phone, and without one the modem reports a failed state. Nothing about messages can be shown until a SIM is in. — updated: 2026-11-11

<a id="wifi--xiaomi-surya"></a>
Wi-Fi × Xiaomi POCO X3 NFC
: works — notes: Joins a network, holds an address, and its gateway answers - checked after every start. Speed and the 5 GHz band are not measured. — updated: 2026-11-11

<a id="bluetooth--xiaomi-surya"></a>
Bluetooth × Xiaomi POCO X3 NFC
: partial — notes: The adapter is powered and hears nearby devices (five on 2026-11-11) - checked after every start. Pairing, and sound over Bluetooth, have not been tried. — updated: 2026-11-11

<a id="nfc--xiaomi-surya"></a>
NFC × Xiaomi POCO X3 NFC
: unknown — notes: The controller is seen by the kernel. No tool on the phone reads a tag yet. — updated: 2026-11-11

<a id="fingerprint--xiaomi-surya"></a>
Fingerprint or face unlock × Xiaomi POCO X3 NFC
: broken — notes: No fingerprint reader is exposed by the kernel. — updated: 2026-11-11

<a id="sensors--xiaomi-surya"></a>
Accelerometer / gyroscope / other sensors × Xiaomi POCO X3 NFC
: broken — notes: No motion, light or proximity sensor is exposed to the system. The sensor hub's service is masked on purpose: with it running, the audio processor crashed at every suspend. — updated: 2026-11-11

<a id="usb-otg--xiaomi-surya"></a>
USB OTG × Xiaomi POCO X3 NFC
: works — notes: OTG support added (6.13.2). — updated: 2026-11-04

<a id="fastboot--xiaomi-surya"></a>
Fastboot / bootloader × Xiaomi POCO X3 NFC
: works — notes: Required for Nura to be installable at all, and for lab-agent's own boot-and-test loop. — updated: 2026-11-04

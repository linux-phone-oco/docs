<!-- Generated from data/ by tad. Do not edit by hand. -->

# Bringup Step Edges

### Row 1

Step
: bootloader-unlocked

Requires
: stock-measured

Kind
: soft

Why
: an unlock may wipe the stock system


### Row 2

Step
: control-image-boots

Requires
: bootloader-unlocked

Kind
: hard

Why
: fastboot boot needs an unlocked bootloader


### Row 3

Step
: control-image-boots

Requires
: slot-state-known

Kind
: hard

Why
: walleye: refusals were the slot state (walleye-load-error-first-state)


### Row 4

Step
: boot-image-packs

Requires
: stock-facts-read

Kind
: hard

Why
: the header and offsets are the stock image's


### Row 5

Step
: kernel-builds

Requires
: stock-facts-read

Kind
: soft

Why
: the dtb ids the bootloader matches


### Row 6

Step
: dtbo-accepted

Requires
: kernel-builds

Kind
: hard

Why
: it is our dtb that must merge


### Row 7

Step
: stock-kernel-runs-our-init

Requires
: control-image-boots

Kind
: hard

Why
: the control is the image swapped into


### Row 8

Step
: stock-kernel-runs-our-init

Requires
: boot-image-packs

Kind
: hard

Why
: the swap repacks


### Row 9

Step
: stock-kernel-runs-our-init

Requires
: initramfs-gadget-emulated

Kind
: soft

Why
: an init proven emulated spends no phone time


### Row 10

Step
: crash-window

Requires
: stock-facts-read

Kind
: soft

Why
: the ramoops region is the stock fdt's


### Row 11

Step
: reference-kernel-boots

Requires
: control-image-boots

Kind
: hard

Why
: same bootloader path


### Row 12

Step
: reference-kernel-boots

Requires
: boot-image-packs

Kind
: hard

Why
: packed the device's way


### Row 13

Step
: kernel-reaches-init

Requires
: kernel-builds

Kind
: hard

Why
: it is our kernel


### Row 14

Step
: kernel-reaches-init

Requires
: boot-image-packs

Kind
: hard

Why
: packed the device's way


### Row 15

Step
: kernel-reaches-init

Requires
: control-image-boots

Kind
: hard

Why
: the bootloader accepts images


### Row 16

Step
: kernel-reaches-init

Requires
: dtbo-accepted

Kind
: hard

Why
: walleye: no start without the merge (walleye-dtbo-overlay-merge-why)


### Row 17

Step
: kernel-reaches-init

Requires
: crash-window

Kind
: soft

Why
: without one a dead kernel says nothing


### Row 18

Step
: kernel-reaches-init

Requires
: reference-kernel-boots

Kind
: soft

Why
: the bisect reference


### Row 19

Step
: uart-console

Requires
: kernel-builds

Kind
: hard

Why
: it is our kernel's log


### Row 20

Step
: gadget-enumerates

Requires
: kernel-reaches-init

Kind
: hard

Why
: our kernel's gadget


### Row 21

Step
: gadget-enumerates

Requires
: initramfs-gadget-emulated

Kind
: hard

Why
: the init makes the gadget


### Row 22

Step
: banner-on-console

Requires
: gadget-enumerates

Kind
: hard

Group
: console

Why
: the console over the gadget


### Row 23

Step
: banner-on-console

Requires
: uart-console

Kind
: hard

Group
: console

Why
: or over UART


### Row 24

Step
: shell-on-console

Requires
: banner-on-console

Kind
: hard

Why
: a console that carries text first


### Row 25

Step
: first-dmesg-mapped

Requires
: shell-on-console

Kind
: hard

Why
: dmesg is read through the shell


### Row 26

Step
: dmesg-clean

Requires
: first-dmesg-mapped

Kind
: hard

Why
: the map names what to clean


### Row 27

Step
: pmic-bound

Requires
: shell-on-console

Kind
: hard

Why
: read through the shell


### Row 28

Step
: pmic-bound

Requires
: first-dmesg-mapped

Kind
: soft

Why
: the map names the PMIC's faults


### Row 29

Step
: charger-online

Requires
: pmic-bound

Kind
: hard

Why
: the charger is a PMIC child


### Row 30

Step
: watchdog-way-back

Requires
: kernel-reaches-init

Kind
: hard

Why
: it is our kernel that hangs


### Row 31

Step
: watchdog-way-back

Requires
: pmic-bound

Kind
: soft

Why
: walleye's way is the PMIC watchdog


### Row 32

Step
: storage-readonly

Requires
: shell-on-console

Kind
: hard

Why
: read through the shell


### Row 33

Step
: storage-readonly

Requires
: dmesg-clean

Kind
: soft

Why
: smmu and supplier faults stop DMA devices


### Row 34

Step
: usb-network

Requires
: gadget-enumerates

Kind
: hard

Why
: the network rides the gadget


### Row 35

Step
: rootfs-boots

Requires
: storage-readonly

Kind
: hard

Why
: the root is on the storage


### Row 36

Step
: rootfs-boots

Requires
: usb-network

Kind
: hard

Why
: ssh is the proof


### Row 37

Step
: health-suite-runs

Requires
: rootfs-boots

Kind
: hard

Why
: the suite runs on the root


### Row 38

Step
: battery-gauge-reads

Requires
: pmic-bound

Kind
: hard

Why
: the gauge is a PMIC function


### Row 39

Step
: power-off-stays-off

Requires
: pmic-bound

Kind
: hard

Why
: the power-on reason and power-off are the PMIC's


### Row 40

Step
: off-mode-charging

Requires
: charger-online

Kind
: hard

Why
: it charges


### Row 41

Step
: off-mode-charging

Requires
: power-off-stays-off

Kind
: hard

Why
: off must be off before it can charge while off (surya off-state-charging)


### Row 42

Step
: off-mode-charging

Requires
: battery-gauge-reads

Kind
: soft

Why
: the level shown is the gauge's


### Row 43

Step
: thermal-zones-sane

Requires
: rootfs-boots

Kind
: hard

Why
: the zones are read from userspace under load


### Row 44

Step
: lab-link-held-awake

Requires
: usb-network

Kind
: hard

Why
: the link is the USB network


### Row 45

Step
: shell-autosleep-tamed

Requires
: lab-link-held-awake

Kind
: hard

Why
: the shell's loop cut the lab off (2026-11-18-who-runs-rtcwake-99999999)


### Row 46

Step
: firmware-reachable

Requires
: kernel-reaches-init

Kind
: hard

Why
: the kernel asks for the files


### Row 47

Step
: pd-mapper-before-remoteproc

Requires
: kernel-reaches-init

Kind
: hard

Why
: an order of modules at boot


### Row 48

Step
: remoteprocs-running

Requires
: firmware-reachable

Kind
: hard

Why
: each coprocessor boots a signed blob


### Row 49

Step
: remoteprocs-running

Requires
: pd-mapper-before-remoteproc

Kind
: hard

Why
: the audio domain needs the mapper first (no-sound-card-boots)


### Row 50

Step
: fastrpc-helpers-stable

Requires
: remoteprocs-running

Kind
: hard

Why
: the helpers talk to a running DSP


### Row 51

Step
: fastrpc-helpers-stable

Requires
: rootfs-boots

Kind
: hard

Why
: hexagonrpcd is userspace


### Row 52

Step
: panel-lit

Requires
: kernel-reaches-init

Kind
: hard

Why
: the panel driver is the kernel's


### Row 53

Step
: touch-input

Requires
: kernel-reaches-init

Kind
: hard

Why
: the touch driver is the kernel's


### Row 54

Step
: touch-input

Requires
: firmware-reachable

Kind
: soft

Why
: some touch controllers load firmware


### Row 55

Step
: buttons-report

Requires
: rootfs-boots

Kind
: hard

Why
: events are read in userspace


### Row 56

Step
: buttons-report

Requires
: pmic-bound

Kind
: soft

Why
: the power and volume-down keys are the PMIC's on most phones


### Row 57

Step
: haptics-buzz

Requires
: rootfs-boots

Kind
: hard

Why
: the effect is played from userspace


### Row 58

Step
: gpu-renders

Requires
: panel-lit

Kind
: hard

Why
: renders to the panel


### Row 59

Step
: gpu-renders

Requires
: firmware-reachable

Kind
: hard

Why
: the zap shader and GMU firmware


### Row 60

Step
: audio-codec-attached

Requires
: remoteprocs-running

Kind
: hard

Why
: on DSP-routed audio the codec's bus is the DSP's


### Row 61

Step
: sound-card-registered

Requires
: audio-codec-attached

Kind
: hard

Why
: the card binds its codec


### Row 62

Step
: sound-card-registered

Requires
: pd-mapper-before-remoteproc

Kind
: hard

Why
: 8 boots of 42 had no card without it (no-sound-card-boots)


### Row 63

Step
: speaker-amps-fed

Requires
: sound-card-registered

Kind
: hard

Why
: the amplifiers are the card's links


### Row 64

Step
: ucm-hifi-profile

Requires
: speaker-amps-fed

Kind
: hard

Why
: the profile drives the amplifiers


### Row 65

Step
: ucm-hifi-profile

Requires
: rootfs-boots

Kind
: hard

Why
: UCM and the sound server are userspace


### Row 66

Step
: speaker-heard

Requires
: ucm-hifi-profile

Kind
: hard

Why
: the tone plays through the profile


### Row 67

Step
: mic-captures

Requires
: sound-card-registered

Kind
: hard

Why
: capture is the card's


### Row 68

Step
: mic-hears-speaker

Requires
: speaker-heard

Kind
: hard

Why
: the tone it listens for


### Row 69

Step
: mic-hears-speaker

Requires
: mic-captures

Kind
: hard

Why
: it records


### Row 70

Step
: earpiece-plays

Requires
: ucm-hifi-profile

Kind
: hard

Why
: routed by the profile


### Row 71

Step
: headset-jack

Requires
: ucm-hifi-profile

Kind
: hard

Why
: routed by the profile


### Row 72

Step
: headset-jack

Requires
: mic-captures

Kind
: soft

Why
: the headset's microphone is a capture path


### Row 73

Step
: modem-file-services

Requires
: remoteprocs-running

Kind
: hard

Why
: the modem runs


### Row 74

Step
: modem-file-services

Requires
: rootfs-boots

Kind
: hard

Why
: rmtfs and tqftpserv are userspace


### Row 75

Step
: modem-seen

Requires
: modem-file-services

Kind
: hard

Why
: the modem stays offline without them (modem-online-tqftpserv)


### Row 76

Step
: sim-ready

Requires
: modem-seen

Kind
: hard

Why
: read through the modem


### Row 77

Step
: modem-registered

Requires
: sim-ready

Kind
: hard

Why
: no registration without a SIM


### Row 78

Step
: sms-both-ways

Requires
: modem-registered

Kind
: hard

Why
: needs the network


### Row 79

Step
: mobile-data

Requires
: modem-registered

Kind
: hard

Why
: needs the network


### Row 80

Step
: mms-both-ways

Requires
: mobile-data

Kind
: hard

Why
: MMS is fetched over data


### Row 81

Step
: mms-both-ways

Requires
: sms-both-ways

Kind
: hard

Why
: MMS is announced by SMS


### Row 82

Step
: call-audio-path

Requires
: modem-registered

Kind
: hard

Why
: a call needs the network


### Row 83

Step
: call-audio-path

Requires
: sound-card-registered

Kind
: hard

Why
: the voice path is the card's


### Row 84

Step
: call-audio-path

Requires
: mic-captures

Kind
: hard

Why
: the uplink is a capture (call-audio-on-surya)


### Row 85

Step
: call-audio-path

Requires
: earpiece-plays

Kind
: soft

Why
: the downlink's usual way out


### Row 86

Step
: voice-call-both-ways

Requires
: call-audio-path

Kind
: hard

Why
: sound both ways


### Row 87

Step
: emergency-numbers-known

Requires
: modem-seen

Kind
: hard

Why
: the list is the modem's and the SIM's


### Row 88

Step
: proximity-blanks-in-call

Requires
: voice-call-both-ways

Kind
: hard

Why
: in a call


### Row 89

Step
: proximity-blanks-in-call

Requires
: proximity-reads

Kind
: hard

Why
: the sensor it follows


### Row 90

Step
: proximity-blanks-in-call

Requires
: shell-runs-with-hardware

Kind
: hard

Why
: the shell blanks the screen


### Row 91

Step
: volte-call

Requires
: voice-call-both-ways

Kind
: hard

Why
: a call first


### Row 92

Step
: volte-call

Requires
: mobile-data

Kind
: hard

Why
: IMS rides a data bearer the AP serves (voltd-81)


### Row 93

Step
: wifi-joins

Requires
: firmware-reachable

Kind
: hard

Why
: the Wi-Fi core's firmware


### Row 94

Step
: wifi-joins

Requires
: remoteprocs-running

Kind
: hard

Why
: WCN3990: the Wi-Fi firmware runs on the modem's processor


### Row 95

Step
: bt-controller-up

Requires
: firmware-reachable

Kind
: hard

Why
: the controller's firmware


### Row 96

Step
: bt-pairs-carries-audio

Requires
: bt-controller-up

Kind
: hard

Why
: pairs through it


### Row 97

Step
: bt-pairs-carries-audio

Requires
: ucm-hifi-profile

Kind
: soft

Why
: the sound server carries the audio


### Row 98

Step
: nfc-reads-tag

Requires
: rootfs-boots

Kind
: hard

Why
: read in userspace


### Row 99

Step
: nfc-reads-tag

Requires
: firmware-reachable

Kind
: soft

Why
: some controllers load firmware


### Row 100

Step
: usb-host-works

Requires
: rootfs-boots

Kind
: hard

Why
: the device is read in userspace


### Row 101

Step
: usb-host-works

Requires
: lab-link-held-awake

Kind
: soft

Why
: switching the port cuts the lab's USB link: another way in first


### Row 102

Step
: hotspot-shares-data

Requires
: mobile-data

Kind
: hard

Why
: it shares the data


### Row 103

Step
: hotspot-shares-data

Requires
: wifi-joins

Kind
: hard

Why
: over the Wi-Fi core


### Row 104

Step
: sensor-hub-stable

Requires
: fastrpc-helpers-stable

Kind
: hard

Why
: the sensor helper is a FastRPC client


### Row 105

Step
: sensors-exposed

Requires
: sensor-hub-stable

Kind
: hard

Why
: the hub serves them (on Qualcomm's sensor DSP)


### Row 106

Step
: proximity-reads

Requires
: sensors-exposed

Kind
: hard

Why
: through the same service


### Row 107

Step
: auto-rotate-follows

Requires
: sensors-exposed

Kind
: hard

Why
: the accelerometer


### Row 108

Step
: auto-rotate-follows

Requires
: shell-runs-with-hardware

Kind
: hard

Why
: the shell rotates


### Row 109

Step
: brightness-follows-light

Requires
: sensors-exposed

Kind
: hard

Why
: the light sensor


### Row 110

Step
: brightness-follows-light

Requires
: panel-lit

Kind
: hard

Why
: the backlight


### Row 111

Step
: brightness-follows-light

Requires
: shell-runs-with-hardware

Kind
: soft

Why
: the shell's auto-brightness


### Row 112

Step
: gnss-fix

Requires
: modem-seen

Kind
: hard

Why
: on Qualcomm the location engine is the modem's (QMI LOC)


### Row 113

Step
: gnss-fix

Requires
: rootfs-boots

Kind
: hard

Why
: ModemManager, gnss-share and geoclue are userspace


### Row 114

Step
: fingerprint-unlocks

Requires
: rootfs-boots

Kind
: hard

Why
: fprintd is userspace


### Row 115

Step
: camera-bus-bound

Requires
: kernel-reaches-init

Kind
: hard

Why
: the receiver is the kernel's


### Row 116

Step
: image-sensor-identified

Requires
: camera-bus-bound

Kind
: hard

Why
: read over the control bus


### Row 117

Step
: raw-frame-captured

Requires
: image-sensor-identified

Kind
: hard

Why
: a sensor described and probed


### Row 118

Step
: camera-stream-viewable

Requires
: raw-frame-captured

Kind
: hard

Why
: the ISP takes raw frames


### Row 119

Step
: camera-stream-viewable

Requires
: gpu-renders

Kind
: soft

Why
: libcamera's software ISP runs on the GPU (libcamera-softisp-fosdem-2026)


### Row 120

Step
: photo-taken

Requires
: camera-stream-viewable

Kind
: hard

Why
: the app takes the stream


### Row 121

Step
: video-recorded

Requires
: photo-taken

Kind
: hard

Why
: the camera app


### Row 122

Step
: video-recorded

Requires
: mic-captures

Kind
: hard

Why
: its sound


### Row 123

Step
: focus-and-flash

Requires
: camera-stream-viewable

Kind
: hard

Why
: focus is judged on the stream


### Row 124

Step
: suspend-way-back

Requires
: watchdog-way-back

Kind
: hard

Why
: the watchdog, kept armed through sleep


### Row 125

Step
: s2idle-cycle-returns

Requires
: rootfs-boots

Kind
: hard

Why
: an RTC-timed suspend from userspace


### Row 126

Step
: s2idle-cycle-returns

Requires
: suspend-way-back

Kind
: soft

Why
: blind without it: a hang in sleep leaves no trace


### Row 127

Step
: suspend-wakes-quiet

Requires
: s2idle-cycle-returns

Kind
: hard

Why
: read across a suspend


### Row 128

Step
: radios-survive-suspend

Requires
: s2idle-cycle-returns

Kind
: hard

Why
: across suspends


### Row 129

Step
: radios-survive-suspend

Requires
: wifi-joins

Kind
: hard

Why
: Wi-Fi up first


### Row 130

Step
: radios-survive-suspend

Requires
: bt-controller-up

Kind
: hard

Why
: Bluetooth up first


### Row 131

Step
: sensors-across-suspend

Requires
: s2idle-cycle-returns

Kind
: hard

Why
: across suspends


### Row 132

Step
: sensors-across-suspend

Requires
: sensors-exposed

Kind
: hard

Why
: sensors up first


### Row 133

Step
: resume-without-stall

Requires
: s2idle-cycle-returns

Kind
: hard

Why
: across suspends


### Row 134

Step
: resume-without-stall

Requires
: sensors-across-suspend

Kind
: hard

Why
: an attached helper crashes the DSP at resume (sleep-fastrpc-helpers)


### Row 135

Step
: resume-without-stall

Requires
: suspend-way-back

Kind
: hard

Why
: a stall must come back to be counted


### Row 136

Step
: real-suspend-under-shell

Requires
: shell-runs-with-hardware

Kind
: hard

Why
: the shell's own suspend


### Row 137

Step
: real-suspend-under-shell

Requires
: resume-without-stall

Kind
: hard

Why
: it returns


### Row 138

Step
: real-suspend-under-shell

Requires
: radios-survive-suspend

Kind
: hard

Why
: the radios come back


### Row 139

Step
: soc-floor-reached

Requires
: s2idle-cycle-returns

Kind
: hard

Why
: read in suspend


### Row 140

Step
: soc-floor-reached

Requires
: suspend-wakes-quiet

Kind
: soft

Why
: wakes keep it off the floor


### Row 141

Step
: call-wakes-from-sleep

Requires
: voice-call-both-ways

Kind
: hard

Why
: a call to ring


### Row 142

Step
: call-wakes-from-sleep

Requires
: sms-both-ways

Kind
: hard

Why
: a message to arrive


### Row 143

Step
: standby-current

Requires
: soc-floor-reached

Kind
: hard

Why
: no floor, no low current


### Row 144

Step
: standby-current

Requires
: battery-gauge-reads

Kind
: soft

Why
: a meter can stand in for the gauge


### Row 145

Step
: all-day-battery

Requires
: standby-current

Kind
: hard

Why
: most of a day is standby


### Row 146

Step
: all-day-battery

Requires
: call-wakes-from-sleep

Kind
: hard

Why
: a sleeping phone that misses calls is not a day's use


### Row 147

Step
: shell-runs-with-hardware

Requires
: panel-lit

Kind
: hard

Why
: it shows


### Row 148

Step
: shell-runs-with-hardware

Requires
: touch-input

Kind
: hard

Why
: it is touched


### Row 149

Step
: shell-runs-with-hardware

Requires
: rootfs-boots

Kind
: hard

Why
: a distribution's shell


### Row 150

Step
: shell-runs-with-hardware

Requires
: ucm-hifi-profile

Kind
: soft

Why
: its sound (plasma-silent)


### Row 151

Step
: shell-runs-with-hardware

Requires
: gpu-renders

Kind
: soft

Why
: Phosh and Plasma Mobile need the GPU; sxmo does not


### Row 152

Step
: on-screen-keyboard

Requires
: shell-runs-with-hardware

Kind
: hard

Why
: the shell's keyboard


### Row 153

Step
: lock-and-unlock

Requires
: shell-runs-with-hardware

Kind
: hard

Why
: the shell's lock


### Row 154

Step
: lock-and-unlock

Requires
: buttons-report

Kind
: hard

Why
: the power key


### Row 155

Step
: notifications-arrive

Requires
: shell-runs-with-hardware

Kind
: hard

Why
: the shell's notifications


### Row 156

Step
: notifications-arrive

Requires
: sms-both-ways

Kind
: soft

Why
: a message to announce


### Row 157

Step
: notifications-arrive

Requires
: speaker-heard

Kind
: soft

Why
: it sounds


### Row 158

Step
: update-applies

Requires
: rootfs-boots

Kind
: hard

Why
: the distribution updates


### Row 159

Step
: update-applies

Requires
: health-suite-runs

Kind
: soft

Why
: an update is proven by the same suite


### Row 160

Step
: update-rolls-back

Requires
: update-applies

Kind
: hard

Why
: a bad one to roll back from


### Row 161

Step
: update-rolls-back

Requires
: watchdog-way-back

Kind
: hard

Why
: a hung boot must come back


### Row 162

Step
: update-rolls-back

Requires
: slot-state-known

Kind
: soft

Why
: A/B slots are one way back


### Row 163

Step
: kernel-upgrade-keeps-steps

Requires
: health-suite-runs

Kind
: hard

Why
: the suite says what still passes


### Row 164

Step
: coprocessor-restart-recovers

Requires
: remoteprocs-running

Kind
: hard

Why
: a coprocessor to crash


### Row 165

Step
: coprocessor-restart-recovers

Requires
: mic-hears-speaker

Kind
: soft

Why
: sound to come back


### Row 166

Step
: coprocessor-restart-recovers

Requires
: modem-registered

Kind
: soft

Why
: the modem to come back


### Row 167

Step
: coprocessor-restart-recovers

Requires
: sensors-exposed

Kind
: soft

Why
: sensors to come back


### Row 168

Step
: days-without-reboot

Requires
: real-suspend-under-shell

Kind
: hard

Why
: daily use sleeps


### Row 169

Step
: days-without-reboot

Requires
: call-wakes-from-sleep

Kind
: hard

Why
: and is reachable


### Row 170

Step
: cycles-repeat-clean

Requires
: resume-without-stall

Kind
: hard

Why
: a cycle that returns


### Row 171

Step
: cycles-repeat-clean

Requires
: health-suite-runs

Kind
: hard

Why
: what is lost is read by the suite


### Row 172

Step
: linux-runs

Requires
: health-suite-runs

Kind
: hard

Why
: the close of the generic bring-up


### Row 173

Step
: linux-runs

Requires
: storage-readonly

Kind
: hard

Why
: the close of the generic bring-up


### Row 174

Step
: linux-runs

Requires
: watchdog-way-back

Kind
: hard

Why
: the close of the generic bring-up


### Row 175

Step
: linux-runs

Requires
: dmesg-clean

Kind
: hard

Why
: the close of the generic bring-up


### Row 176

Step
: linux-runs

Requires
: charger-online

Kind
: hard

Why
: the close of the generic bring-up


### Row 177

Step
: daily-usable-phone

Requires
: linux-runs

Kind
: hard

Why
: a person needs it every day


### Row 178

Step
: daily-usable-phone

Requires
: speaker-heard

Kind
: hard

Why
: a person needs it every day


### Row 179

Step
: daily-usable-phone

Requires
: mic-hears-speaker

Kind
: hard

Why
: a person needs it every day


### Row 180

Step
: daily-usable-phone

Requires
: earpiece-plays

Kind
: hard

Why
: a person needs it every day


### Row 181

Step
: daily-usable-phone

Requires
: voice-call-both-ways

Kind
: hard

Why
: a person needs it every day


### Row 182

Step
: daily-usable-phone

Requires
: sms-both-ways

Kind
: hard

Why
: a person needs it every day


### Row 183

Step
: daily-usable-phone

Requires
: mobile-data

Kind
: hard

Why
: a person needs it every day


### Row 184

Step
: daily-usable-phone

Requires
: emergency-numbers-known

Kind
: hard

Why
: a person needs it every day


### Row 185

Step
: daily-usable-phone

Requires
: proximity-blanks-in-call

Kind
: hard

Why
: a person needs it every day


### Row 186

Step
: daily-usable-phone

Requires
: wifi-joins

Kind
: hard

Why
: a person needs it every day


### Row 187

Step
: daily-usable-phone

Requires
: bt-controller-up

Kind
: hard

Why
: a person needs it every day


### Row 188

Step
: daily-usable-phone

Requires
: on-screen-keyboard

Kind
: hard

Why
: a person needs it every day


### Row 189

Step
: daily-usable-phone

Requires
: lock-and-unlock

Kind
: hard

Why
: a person needs it every day


### Row 190

Step
: daily-usable-phone

Requires
: notifications-arrive

Kind
: hard

Why
: a person needs it every day


### Row 191

Step
: daily-usable-phone

Requires
: gnss-fix

Kind
: hard

Why
: a person needs it every day


### Row 192

Step
: daily-usable-phone

Requires
: photo-taken

Kind
: hard

Why
: a person needs it every day


### Row 193

Step
: daily-usable-phone

Requires
: call-wakes-from-sleep

Kind
: hard

Why
: a person needs it every day


### Row 194

Step
: daily-usable-phone

Requires
: all-day-battery

Kind
: hard

Why
: a person needs it every day


### Row 195

Step
: daily-usable-phone

Requires
: off-mode-charging

Kind
: hard

Why
: a person needs it every day


### Row 196

Step
: daily-usable-phone

Requires
: update-applies

Kind
: hard

Why
: a person needs it every day


### Row 197

Step
: complete-phone

Requires
: daily-usable-phone

Kind
: hard

Why
: everything the hardware does, lasting


### Row 198

Step
: complete-phone

Requires
: volte-call

Kind
: hard

Why
: everything the hardware does, lasting


### Row 199

Step
: complete-phone

Requires
: mms-both-ways

Kind
: hard

Why
: everything the hardware does, lasting


### Row 200

Step
: complete-phone

Requires
: headset-jack

Kind
: hard

Why
: everything the hardware does, lasting


### Row 201

Step
: complete-phone

Requires
: bt-pairs-carries-audio

Kind
: hard

Why
: everything the hardware does, lasting


### Row 202

Step
: complete-phone

Requires
: nfc-reads-tag

Kind
: hard

Why
: everything the hardware does, lasting


### Row 203

Step
: complete-phone

Requires
: usb-host-works

Kind
: hard

Why
: everything the hardware does, lasting


### Row 204

Step
: complete-phone

Requires
: hotspot-shares-data

Kind
: hard

Why
: everything the hardware does, lasting


### Row 205

Step
: complete-phone

Requires
: haptics-buzz

Kind
: hard

Why
: everything the hardware does, lasting


### Row 206

Step
: complete-phone

Requires
: gpu-renders

Kind
: hard

Why
: everything the hardware does, lasting


### Row 207

Step
: complete-phone

Requires
: auto-rotate-follows

Kind
: hard

Why
: everything the hardware does, lasting


### Row 208

Step
: complete-phone

Requires
: brightness-follows-light

Kind
: hard

Why
: everything the hardware does, lasting


### Row 209

Step
: complete-phone

Requires
: fingerprint-unlocks

Kind
: hard

Why
: everything the hardware does, lasting


### Row 210

Step
: complete-phone

Requires
: video-recorded

Kind
: hard

Why
: everything the hardware does, lasting


### Row 211

Step
: complete-phone

Requires
: focus-and-flash

Kind
: hard

Why
: everything the hardware does, lasting


### Row 212

Step
: complete-phone

Requires
: thermal-zones-sane

Kind
: hard

Why
: everything the hardware does, lasting


### Row 213

Step
: complete-phone

Requires
: update-rolls-back

Kind
: hard

Why
: everything the hardware does, lasting


### Row 214

Step
: complete-phone

Requires
: kernel-upgrade-keeps-steps

Kind
: hard

Why
: everything the hardware does, lasting


### Row 215

Step
: complete-phone

Requires
: coprocessor-restart-recovers

Kind
: hard

Why
: everything the hardware does, lasting


### Row 216

Step
: complete-phone

Requires
: days-without-reboot

Kind
: hard

Why
: everything the hardware does, lasting


### Row 217

Step
: complete-phone

Requires
: cycles-repeat-clean

Kind
: hard

Why
: everything the hardware does, lasting


### Row 218

Step
: standby-current

Requires
: suspend-wakes-quiet

Kind
: hard

Why
: a phone woken by chatter does not stay low (floor-irq-quiet)


### Row 219

Step
: pon-reason-read

Requires
: pmic-bound

Kind
: hard

Why
: the reasons are the PMIC's registers


### Row 220

Step
: reset-types-right

Requires
: pmic-bound

Kind
: hard

Why
: the reset types are the PMIC's


### Row 221

Step
: reset-types-right

Requires
: pon-reason-read

Kind
: soft

Why
: blind without it: the next boot's reason is the proof


### Row 222

Step
: power-off-stays-off

Requires
: reset-types-right

Kind
: hard

Why
: off must end in the PMIC's shutdown, not a reset


### Row 223

Step
: power-off-stays-off

Requires
: pon-reason-read

Kind
: soft

Why
: tells a reboot from a charger or alarm power-on


### Row 224

Step
: charger-mode-entered

Requires
: pon-reason-read

Kind
: hard

Why
: a charger power-on is told by its reason


### Row 225

Step
: charger-mode-entered

Requires
: power-off-stays-off

Kind
: hard

Why
: a charger mode needs an off to start from


### Row 226

Step
: charger-mode-entered

Requires
: panel-lit

Kind
: hard

Why
: it shows the level


### Row 227

Step
: charger-mode-entered

Requires
: battery-gauge-reads

Kind
: soft

Why
: the level is the gauge's


### Row 228

Step
: off-mode-charging

Requires
: charger-mode-entered

Kind
: hard

Why
: the screen and the power key while off


### Row 229

Step
: reset-state-survives

Requires
: pon-reason-read

Kind
: hard

Why
: read after each kind of reset


### Row 230

Step
: reset-state-survives

Requires
: watchdog-way-back

Kind
: hard

Why
: the watchdog state is part of it


### Row 231

Step
: key-reset-recovers

Requires
: pmic-bound

Kind
: hard

Why
: the key reset is the PMIC's


### Row 232

Step
: key-reset-recovers

Requires
: pon-reason-read

Kind
: soft

Why
: the reason proves it was the key


### Row 233

Step
: rtc-alarm-powers-on

Requires
: power-off-stays-off

Kind
: hard

Why
: it must be off to be turned on


### Row 234

Step
: rtc-alarm-powers-on

Requires
: pon-reason-read

Kind
: hard

Why
: the reason reads RTC alarm


### Row 235

Step
: alarm-wakes-from-sleep

Requires
: real-suspend-under-shell

Kind
: hard

Why
: it sleeps as in daily use


### Row 236

Step
: alarm-wakes-from-sleep

Requires
: speaker-heard

Kind
: hard

Why
: it rings


### Row 237

Step
: daily-usable-phone

Requires
: alarm-wakes-from-sleep

Kind
: hard

Why
: a person needs it every day


### Row 238

Step
: daily-usable-phone

Requires
: key-reset-recovers

Kind
: hard

Why
: a person needs it every day


### Row 239

Step
: complete-phone

Requires
: rtc-alarm-powers-on

Kind
: hard

Why
: everything the hardware does, lasting


### Row 240

Step
: complete-phone

Requires
: reset-state-survives

Kind
: hard

Why
: everything the hardware does, lasting


### Row 241

Step
: test-layer-boots

Requires
: rootfs-boots

Kind
: hard

Why
: a root with its services


### Row 242

Step
: test-layer-boots

Requires
: health-suite-runs

Kind
: hard

Why
: the layer is proven by a health check


### Row 243

Step
: test-layer-boots

Requires
: lab-link-held-awake

Kind
: hard

Why
: lpoco-awake is part of the layer: the lab's link stays up unless a test asks


### Row 244

Step
: s2idle-cycle-returns

Requires
: test-layer-boots

Kind
: hard

Why
: the suspend work runs in the test layer, with no shell to suspend or lock on its own


### Row 245

Step
: call-wakes-from-sleep

Requires
: s2idle-cycle-returns

Kind
: hard

Why
: it sleeps in the test layer first, where nothing else wakes it


### Row 246

Step
: standby-current

Requires
: s2idle-cycle-returns

Kind
: hard

Why
: measured first in the test layer


### Row 247

Step
: standby-current

Requires
: suspend-way-back

Kind
: hard

Why
: a hang in sleep must find its way back before a night is measured


### Row 248

Step
: daily-usable-phone

Requires
: real-suspend-under-shell

Kind
: hard

Why
: a person's phone sleeps under its shell and returns


### Row 249

Step
: real-suspend-under-shell

Requires
: shell-autosleep-tamed

Kind
: hard

Why
: the shell's idle loop is held off first, or it cuts the lab off from its test (2026-11-18-who-runs-rtcwake-99999999)


### Row 250

Step
: display-any-order

Requires
: panel-lit

Kind
: hard

Why
: the panel must light by hand before its order can be left to deferred probe


### Row 251

Step
: storage-full-speed

Requires
: storage-readonly

Kind
: hard

Why
: the link speed is read on a card that already lists its partitions

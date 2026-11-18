<!-- Generated from data/ by tad. Do not edit by hand. -->

# Step Status

### Row 1

Device id
: google-walleye

Step id
: bootloader-unlocked

Status
: done

Proof
: fastboot-unlocked

Run
: google-walleye-bootloader-first-look

Proven on
: stock-bootloader

Updated
: 2026-11-18


### Row 2

Device id
: google-walleye

Step id
: stock-measured

Status
: partial

Proof
: android-reference

Run
: android-reference-walleye-measured

Notes
: read only on LineageOS 15 over the stock vendor; the stock Android of the Pixel 2 itself is not measured

Updated
: 2026-11-18


### Row 3

Device id
: google-walleye

Step id
: stock-facts-read

Status
: done

Proof
: stock-facts-recorded

Run
: walleye-stock-ids-recorded

Proven on
: stock-boot.img

Updated
: 2026-11-18


### Row 4

Device id
: google-walleye

Step id
: slot-state-known

Status
: done

Proof
: slot-report

Run
: walleye-first-state-control-accepted

Notes
: slot flags read and the first state restored; walleye-slot-flip-why says how a failed boot flips them

Updated
: 2026-11-18


### Row 5

Device id
: google-walleye

Step id
: control-image-boots

Status
: done

Proof
: fastboot-boot-control

Run
: walleye-try-s0-control-healthy-state

Proven on
: control

Updated
: 2026-11-18


### Row 6

Device id
: google-walleye

Step id
: boot-image-packs

Status
: done

Proof
: build/check-bootimg.sh

Run
: walleye-bootimage

Proven on
: pk3/y2

Updated
: 2026-11-18


### Row 7

Device id
: google-walleye

Step id
: dtbo-accepted

Status
: done

Proof
: tests/host/dtbo-overlay-merges.sh

Run
: walleye-s4-overlay-symbols-try

Proven on
: s4

Notes
: with the stock dtbo (entry 3); our own minimal dtbo is not tried (decision 2026-11-19-walleye-minimal-dtbo-try)

Updated
: 2026-11-18


### Row 8

Device id
: google-walleye

Step id
: initramfs-gadget-emulated

Status
: done

Proof
: build/build-initramfs.sh

Run
: walleye-initramfs-usb-gadget

Updated
: 2026-11-18


### Row 9

Device id
: google-walleye

Step id
: stock-kernel-runs-our-init

Status
: done

Proof
: tests/host/massstorage-read.sh

Run
: 2026-11-17-walleye-m1-window-read

Proven on
: m1

Updated
: 2026-11-18


### Row 10

Device id
: google-walleye

Step id
: crash-window

Status
: partial

Proof
: tests/host/pstore-t1-read.sh

Run
: walleye-pstore-warm-reset-how-it-stands

Notes
: mass_storage window read on the vendor kernel (m1); pstore empty after every mainline try, so a mainline crash is not yet seen

Updated
: 2026-11-18


### Row 11

Device id
: google-walleye

Step id
: kernel-builds

Status
: done

Proof
: dtb-builds-with-ids

Run
: walleye-kernel-dts

Updated
: 2026-11-18


### Row 12

Device id
: google-walleye

Step id
: reference-kernel-boots

Status
: done

Proof
: reference-alive

Run
: walleye-pk-bisect-returns

Proven on
: pk3/pk5

Updated
: 2026-11-18


### Row 13

Device id
: google-walleye

Step id
: kernel-reaches-init

Status
: done

Proof
: kernel-alive

Run
: walleye-y-tried

Proven on
: y2

Updated
: 2026-11-18


### Row 14

Device id
: google-walleye

Step id
: uart-console

Status
: open

Notes
: waits the cable: walleye-get-uart-setup

Updated
: 2026-11-18


### Row 15

Device id
: google-walleye

Step id
: gadget-enumerates

Status
: done

Proof
: tests/host/mainline-light-up.sh

Run
: walleye-y-tried

Proven on
: y2

Updated
: 2026-11-18


### Row 16

Device id
: google-walleye

Step id
: banner-on-console

Status
: done

Proof
: tests/host/banner-check.sh

Run
: walleye-banner2-tried

Proven on
: banner2

Updated
: 2026-11-18


### Row 17

Device id
: google-walleye

Step id
: shell-on-console

Status
: done

Proof
: tests/host/mainline-shell-read.sh

Run
: walleye-z6-tried

Proven on
: z6

Updated
: 2026-11-18


### Row 18

Device id
: google-walleye

Step id
: first-dmesg-mapped

Status
: done

Proof
: dmesg-map

Run
: walleye-z6-dmesg-mapped

Proven on
: z6

Updated
: 2026-11-18


### Row 19

Device id
: google-walleye

Step id
: dmesg-clean

Status
: done

Proof
: tests/host/dmesg-clean-check.sh

Run
: walleye-z7-tried

Proven on
: z7

Updated
: 2026-11-18


### Row 20

Device id
: google-walleye

Step id
: pmic-bound

Status
: done

Proof
: tests/host/pmic-dmesg-check.sh

Run
: walleye-z7-tried

Proven on
: z7

Updated
: 2026-11-18


### Row 21

Device id
: google-walleye

Step id
: charger-online

Status
: partial

Proof
: tests/host/charger-check.sh

Run
: walleye-c3-tried

Proven on
: c3

Notes
: c2 deferred it (tps61099 has no driver); c3 with fw_devlink=permissive reads type USB, online 1, only one cable state seen and voltage_now read 0, and the phone then went silent: no restart gate yet (decision 2026-11-18-walleye-restart-gate-before-charger-try)

Updated
: 2026-11-18


### Row 22

Device id
: google-walleye

Step id
: watchdog-way-back

Status
: unknown

Notes
: The z9 PMIC bite did bite (20 s after arming; the series works) but the phone's recovery is unproven as 'by itself' (the author's Power hold fell in the window: research walleye-z9-recovery-unproven); a bite that restarts is not measured yet (decision 2026-11-18-walleye-pmic-bite-read-then-warm, the series fix f5bb57d27 is untried).

Updated
: 2026-11-18


### Row 23

Device id
: google-walleye

Step id
: storage-readonly

Status
: open

Updated
: 2026-11-18


### Row 24

Device id
: google-walleye

Step id
: usb-network

Status
: open

Updated
: 2026-11-18


### Row 25

Device id
: google-walleye

Step id
: rootfs-boots

Status
: open

Updated
: 2026-11-18


### Row 26

Device id
: google-walleye

Step id
: health-suite-runs

Status
: open

Updated
: 2026-11-18


### Row 27

Device id
: google-walleye

Step id
: battery-gauge-reads

Status
: open

Updated
: 2026-11-18


### Row 28

Device id
: google-walleye

Step id
: off-mode-charging

Status
: open

Updated
: 2026-11-18


### Row 29

Device id
: google-walleye

Step id
: thermal-zones-sane

Status
: open

Updated
: 2026-11-18


### Row 30

Device id
: google-walleye

Step id
: lab-link-held-awake

Status
: open

Updated
: 2026-11-18


### Row 31

Device id
: google-walleye

Step id
: shell-autosleep-tamed

Status
: open

Updated
: 2026-11-18


### Row 32

Device id
: google-walleye

Step id
: firmware-reachable

Status
: open

Updated
: 2026-11-18


### Row 33

Device id
: google-walleye

Step id
: pd-mapper-before-remoteproc

Status
: open

Updated
: 2026-11-18


### Row 34

Device id
: google-walleye

Step id
: remoteprocs-running

Status
: open

Updated
: 2026-11-18


### Row 35

Device id
: google-walleye

Step id
: fastrpc-helpers-stable

Status
: open

Updated
: 2026-11-18


### Row 36

Device id
: google-walleye

Step id
: panel-lit

Status
: open

Updated
: 2026-11-18


### Row 37

Device id
: google-walleye

Step id
: touch-input

Status
: open

Updated
: 2026-11-18


### Row 38

Device id
: google-walleye

Step id
: buttons-report

Status
: open

Updated
: 2026-11-18


### Row 39

Device id
: google-walleye

Step id
: haptics-buzz

Status
: open

Updated
: 2026-11-18


### Row 40

Device id
: google-walleye

Step id
: gpu-renders

Status
: open

Updated
: 2026-11-18


### Row 41

Device id
: google-walleye

Step id
: audio-codec-attached

Status
: open

Updated
: 2026-11-18


### Row 42

Device id
: google-walleye

Step id
: sound-card-registered

Status
: open

Updated
: 2026-11-18


### Row 43

Device id
: google-walleye

Step id
: speaker-amps-fed

Status
: open

Updated
: 2026-11-18


### Row 44

Device id
: google-walleye

Step id
: ucm-hifi-profile

Status
: open

Updated
: 2026-11-18


### Row 45

Device id
: google-walleye

Step id
: speaker-heard

Status
: open

Updated
: 2026-11-18


### Row 46

Device id
: google-walleye

Step id
: mic-captures

Status
: open

Updated
: 2026-11-18


### Row 47

Device id
: google-walleye

Step id
: mic-hears-speaker

Status
: open

Updated
: 2026-11-18


### Row 48

Device id
: google-walleye

Step id
: earpiece-plays

Status
: open

Updated
: 2026-11-18


### Row 49

Device id
: google-walleye

Step id
: headset-jack

Status
: open

Updated
: 2026-11-18


### Row 50

Device id
: google-walleye

Step id
: modem-file-services

Status
: open

Updated
: 2026-11-18


### Row 51

Device id
: google-walleye

Step id
: modem-seen

Status
: open

Updated
: 2026-11-18


### Row 52

Device id
: google-walleye

Step id
: sim-ready

Status
: open

Updated
: 2026-11-18


### Row 53

Device id
: google-walleye

Step id
: modem-registered

Status
: open

Updated
: 2026-11-18


### Row 54

Device id
: google-walleye

Step id
: sms-both-ways

Status
: open

Updated
: 2026-11-18


### Row 55

Device id
: google-walleye

Step id
: mobile-data

Status
: open

Updated
: 2026-11-18


### Row 56

Device id
: google-walleye

Step id
: mms-both-ways

Status
: open

Updated
: 2026-11-18


### Row 57

Device id
: google-walleye

Step id
: call-audio-path

Status
: open

Updated
: 2026-11-18


### Row 58

Device id
: google-walleye

Step id
: voice-call-both-ways

Status
: open

Updated
: 2026-11-18


### Row 59

Device id
: google-walleye

Step id
: emergency-numbers-known

Status
: open

Updated
: 2026-11-18


### Row 60

Device id
: google-walleye

Step id
: proximity-blanks-in-call

Status
: open

Updated
: 2026-11-18


### Row 61

Device id
: google-walleye

Step id
: volte-call

Status
: open

Updated
: 2026-11-18


### Row 62

Device id
: google-walleye

Step id
: wifi-joins

Status
: open

Updated
: 2026-11-18


### Row 63

Device id
: google-walleye

Step id
: bt-controller-up

Status
: open

Updated
: 2026-11-18


### Row 64

Device id
: google-walleye

Step id
: bt-pairs-carries-audio

Status
: open

Updated
: 2026-11-18


### Row 65

Device id
: google-walleye

Step id
: nfc-reads-tag

Status
: open

Updated
: 2026-11-18


### Row 66

Device id
: google-walleye

Step id
: usb-host-works

Status
: open

Updated
: 2026-11-18


### Row 67

Device id
: google-walleye

Step id
: hotspot-shares-data

Status
: open

Updated
: 2026-11-18


### Row 68

Device id
: google-walleye

Step id
: sensor-hub-stable

Status
: open

Updated
: 2026-11-18


### Row 69

Device id
: google-walleye

Step id
: sensors-exposed

Status
: open

Updated
: 2026-11-18


### Row 70

Device id
: google-walleye

Step id
: proximity-reads

Status
: open

Updated
: 2026-11-18


### Row 71

Device id
: google-walleye

Step id
: auto-rotate-follows

Status
: open

Updated
: 2026-11-18


### Row 72

Device id
: google-walleye

Step id
: brightness-follows-light

Status
: open

Updated
: 2026-11-18


### Row 73

Device id
: google-walleye

Step id
: gnss-fix

Status
: open

Updated
: 2026-11-18


### Row 74

Device id
: google-walleye

Step id
: fingerprint-unlocks

Status
: open

Updated
: 2026-11-18


### Row 75

Device id
: google-walleye

Step id
: camera-bus-bound

Status
: open

Updated
: 2026-11-18


### Row 76

Device id
: google-walleye

Step id
: image-sensor-identified

Status
: open

Updated
: 2026-11-18


### Row 77

Device id
: google-walleye

Step id
: raw-frame-captured

Status
: open

Updated
: 2026-11-18


### Row 78

Device id
: google-walleye

Step id
: camera-stream-viewable

Status
: open

Updated
: 2026-11-18


### Row 79

Device id
: google-walleye

Step id
: photo-taken

Status
: open

Updated
: 2026-11-18


### Row 80

Device id
: google-walleye

Step id
: video-recorded

Status
: open

Updated
: 2026-11-18


### Row 81

Device id
: google-walleye

Step id
: focus-and-flash

Status
: open

Updated
: 2026-11-18


### Row 82

Device id
: google-walleye

Step id
: suspend-way-back

Status
: open

Updated
: 2026-11-18


### Row 83

Device id
: google-walleye

Step id
: s2idle-cycle-returns

Status
: open

Updated
: 2026-11-18


### Row 84

Device id
: google-walleye

Step id
: suspend-wakes-quiet

Status
: open

Updated
: 2026-11-18


### Row 85

Device id
: google-walleye

Step id
: radios-survive-suspend

Status
: open

Updated
: 2026-11-18


### Row 86

Device id
: google-walleye

Step id
: sensors-across-suspend

Status
: open

Updated
: 2026-11-18


### Row 87

Device id
: google-walleye

Step id
: resume-without-stall

Status
: open

Updated
: 2026-11-18


### Row 88

Device id
: google-walleye

Step id
: real-suspend-under-shell

Status
: open

Updated
: 2026-11-18


### Row 89

Device id
: google-walleye

Step id
: soc-floor-reached

Status
: open

Updated
: 2026-11-18


### Row 90

Device id
: google-walleye

Step id
: call-wakes-from-sleep

Status
: open

Updated
: 2026-11-18


### Row 91

Device id
: google-walleye

Step id
: standby-current

Status
: open

Updated
: 2026-11-18


### Row 92

Device id
: google-walleye

Step id
: all-day-battery

Status
: open

Updated
: 2026-11-18


### Row 93

Device id
: google-walleye

Step id
: shell-runs-with-hardware

Status
: open

Updated
: 2026-11-18


### Row 94

Device id
: google-walleye

Step id
: on-screen-keyboard

Status
: open

Updated
: 2026-11-18


### Row 95

Device id
: google-walleye

Step id
: lock-and-unlock

Status
: open

Updated
: 2026-11-18


### Row 96

Device id
: google-walleye

Step id
: notifications-arrive

Status
: open

Updated
: 2026-11-18


### Row 97

Device id
: google-walleye

Step id
: update-applies

Status
: open

Updated
: 2026-11-18


### Row 98

Device id
: google-walleye

Step id
: update-rolls-back

Status
: open

Updated
: 2026-11-18


### Row 99

Device id
: google-walleye

Step id
: kernel-upgrade-keeps-steps

Status
: open

Updated
: 2026-11-18


### Row 100

Device id
: google-walleye

Step id
: coprocessor-restart-recovers

Status
: open

Updated
: 2026-11-18


### Row 101

Device id
: google-walleye

Step id
: days-without-reboot

Status
: open

Updated
: 2026-11-18


### Row 102

Device id
: google-walleye

Step id
: cycles-repeat-clean

Status
: open

Updated
: 2026-11-18


### Row 103

Device id
: google-walleye

Step id
: linux-runs

Status
: open

Updated
: 2026-11-18


### Row 104

Device id
: google-walleye

Step id
: daily-usable-phone

Status
: open

Updated
: 2026-11-18


### Row 105

Device id
: google-walleye

Step id
: complete-phone

Status
: open

Updated
: 2026-11-18


### Row 106

Device id
: google-walleye

Step id
: pon-reason-read

Status
: open

Updated
: 2026-11-18


### Row 107

Device id
: google-walleye

Step id
: reset-types-right

Status
: open

Updated
: 2026-11-18


### Row 108

Device id
: google-walleye

Step id
: power-off-stays-off

Status
: open

Updated
: 2026-11-18


### Row 109

Device id
: google-walleye

Step id
: charger-mode-entered

Status
: open

Updated
: 2026-11-18


### Row 110

Device id
: google-walleye

Step id
: reset-state-survives

Status
: open

Updated
: 2026-11-18


### Row 111

Device id
: google-walleye

Step id
: key-reset-recovers

Status
: open

Updated
: 2026-11-18


### Row 112

Device id
: google-walleye

Step id
: rtc-alarm-powers-on

Status
: open

Updated
: 2026-11-18


### Row 113

Device id
: google-walleye

Step id
: alarm-wakes-from-sleep

Status
: open

Updated
: 2026-11-18


### Row 114

Device id
: xiaomi-surya

Step id
: bootloader-unlocked

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 115

Device id
: xiaomi-surya

Step id
: stock-measured

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 116

Device id
: xiaomi-surya

Step id
: stock-facts-read

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 117

Device id
: xiaomi-surya

Step id
: slot-state-known

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 118

Device id
: xiaomi-surya

Step id
: control-image-boots

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 119

Device id
: xiaomi-surya

Step id
: boot-image-packs

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 120

Device id
: xiaomi-surya

Step id
: dtbo-accepted

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 121

Device id
: xiaomi-surya

Step id
: initramfs-gadget-emulated

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 122

Device id
: xiaomi-surya

Step id
: stock-kernel-runs-our-init

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 123

Device id
: xiaomi-surya

Step id
: crash-window

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 124

Device id
: xiaomi-surya

Step id
: kernel-builds

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 125

Device id
: xiaomi-surya

Step id
: reference-kernel-boots

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 126

Device id
: xiaomi-surya

Step id
: kernel-reaches-init

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 127

Device id
: xiaomi-surya

Step id
: uart-console

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 128

Device id
: xiaomi-surya

Step id
: gadget-enumerates

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 129

Device id
: xiaomi-surya

Step id
: banner-on-console

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 130

Device id
: xiaomi-surya

Step id
: shell-on-console

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 131

Device id
: xiaomi-surya

Step id
: first-dmesg-mapped

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 132

Device id
: xiaomi-surya

Step id
: dmesg-clean

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 133

Device id
: xiaomi-surya

Step id
: pmic-bound

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 134

Device id
: xiaomi-surya

Step id
: charger-online

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 135

Device id
: xiaomi-surya

Step id
: watchdog-way-back

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 136

Device id
: xiaomi-surya

Step id
: storage-readonly

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 137

Device id
: xiaomi-surya

Step id
: usb-network

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 138

Device id
: xiaomi-surya

Step id
: rootfs-boots

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 139

Device id
: xiaomi-surya

Step id
: health-suite-runs

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 140

Device id
: xiaomi-surya

Step id
: battery-gauge-reads

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 141

Device id
: xiaomi-surya

Step id
: off-mode-charging

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 142

Device id
: xiaomi-surya

Step id
: thermal-zones-sane

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 143

Device id
: xiaomi-surya

Step id
: lab-link-held-awake

Status
: done

Proof
: usb-awake

Run
: 20261118-191339

Proven on
: 7.1.0-sm7150-calls+

Notes
: suite run 20261118-191339: usb-awake=pass

Updated
: 2026-11-18


### Row 144

Device id
: xiaomi-surya

Step id
: shell-autosleep-tamed

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 145

Device id
: xiaomi-surya

Step id
: firmware-reachable

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 146

Device id
: xiaomi-surya

Step id
: pd-mapper-before-remoteproc

Status
: done

Proof
: sound-card

Run
: 20261118-202945

Proven on
: 7.1.0-sm7150-calls+

Notes
: suite run 20261118-202945: sound-card=pass (the 19:13 run failed on a boot whose ADSP came up without its audio services; see log 2026-11-18-2035-adsp-audio-restart)

Updated
: 2026-11-18


### Row 147

Device id
: xiaomi-surya

Step id
: remoteprocs-running

Status
: done

Proof
: adsp-running,cdsp-running,modem-running,no-processor-crashes

Run
: 20261118-191339

Proven on
: 7.1.0-sm7150-calls+

Notes
: suite run 20261118-191339: adsp-running=pass cdsp-running=pass modem-running=pass no-processor-crashes=pass

Updated
: 2026-11-18


### Row 148

Device id
: xiaomi-surya

Step id
: fastrpc-helpers-stable

Status
: done

Proof
: no-processor-crashes

Run
: 20261118-191339

Proven on
: 7.1.0-sm7150-calls+

Notes
: suite run 20261118-191339: no-processor-crashes=pass

Updated
: 2026-11-18


### Row 149

Device id
: xiaomi-surya

Step id
: panel-lit

Status
: done

Proof
: panel-connected,backlight

Run
: 20261118-191339

Proven on
: 7.1.0-sm7150-calls+

Notes
: suite run 20261118-191339: panel-connected=pass backlight=pass

Updated
: 2026-11-18


### Row 150

Device id
: xiaomi-surya

Step id
: touch-input

Status
: done

Proof
: touch-device

Run
: 20261118-191339

Proven on
: 7.1.0-sm7150-calls+

Notes
: suite run 20261118-191339: touch-device=pass

Updated
: 2026-11-18


### Row 151

Device id
: xiaomi-surya

Step id
: buttons-report

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 152

Device id
: xiaomi-surya

Step id
: haptics-buzz

Status
: done

Proof
: vibrator

Run
: 20261118-191339

Proven on
: 7.1.0-sm7150-calls+

Notes
: suite run 20261118-191339: vibrator=pass

Updated
: 2026-11-18


### Row 153

Device id
: xiaomi-surya

Step id
: gpu-renders

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 154

Device id
: xiaomi-surya

Step id
: audio-codec-attached

Status
: done

Proof
: sound-card,mic-records

Run
: 20261118-202945

Proven on
: 7.1.0-sm7150-calls+

Notes
: suite run 20261118-202945: sound-card=pass mic-records=pass

Updated
: 2026-11-18


### Row 155

Device id
: xiaomi-surya

Step id
: sound-card-registered

Status
: done

Proof
: sound-card

Run
: 20261118-202945

Proven on
: 7.1.0-sm7150-calls+

Notes
: suite run 20261118-202945: sound-card=pass, 2 cards

Updated
: 2026-11-18


### Row 156

Device id
: xiaomi-surya

Step id
: speaker-amps-fed

Status
: partial

Proof
: amp-channels,amp-volume-0x4c,amp-volume-0x4d

Run
: 20261118-191339

Proven on
: 7.1.0-sm7150-calls+

Notes
: suite run 20261118-191339: amp-channels=fail amp-volume-0x4c=pass amp-volume-0x4d=pass

Updated
: 2026-11-18


### Row 157

Device id
: xiaomi-surya

Step id
: ucm-hifi-profile

Status
: done

Proof
: default-output,speaker-stereo

Run
: 20261118-202945

Proven on
: 7.1.0-sm7150-calls+

Notes
: suite run 20261118-202945: default-output=pass speaker-stereo=pass

Updated
: 2026-11-18


### Row 158

Device id
: xiaomi-surya

Step id
: speaker-heard

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 159

Device id
: xiaomi-surya

Step id
: mic-captures

Status
: done

Proof
: mic-records

Run
: 20261118-202945

Proven on
: 7.1.0-sm7150-calls+

Notes
: suite run 20261118-202945: mic-records=pass

Updated
: 2026-11-18


### Row 160

Device id
: xiaomi-surya

Step id
: mic-hears-speaker

Status
: done

Proof
: mic-hears-speaker,mic-top-hears-speaker

Run
: 20261118-202945

Proven on
: 7.1.0-sm7150-calls+

Notes
: suite run 20261118-202945: both pass

Updated
: 2026-11-18


### Row 161

Device id
: xiaomi-surya

Step id
: earpiece-plays

Status
: partial

Proof
: earpiece-heard

Run
: 20261118-202945

Proven on
: 7.1.0-sm7150-calls+

Notes
: suite run 20261118-202945: earpiece-heard=pass (played: yes); heard by a person is a witnessed test, not claimed

Updated
: 2026-11-18


### Row 162

Device id
: xiaomi-surya

Step id
: headset-jack

Status
: partial

Proof
: jack-detector

Run
: 20261118-202945

Proven on
: 7.1.0-sm7150-calls+

Notes
: suite run 20261118-202945: jack-detector=pass; headset-loop not measured (witnessed)

Updated
: 2026-11-18


### Row 163

Device id
: xiaomi-surya

Step id
: modem-file-services

Status
: done

Proof
: modem-running

Run
: 20261118-191339

Proven on
: 7.1.0-sm7150-calls+

Notes
: suite run 20261118-191339: modem-running=pass

Updated
: 2026-11-18


### Row 164

Device id
: xiaomi-surya

Step id
: modem-seen

Status
: done

Proof
: modem-seen

Run
: 20261118-191339

Proven on
: 7.1.0-sm7150-calls+

Notes
: suite run 20261118-191339: modem-seen=pass

Updated
: 2026-11-18


### Row 165

Device id
: xiaomi-surya

Step id
: sim-ready

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 166

Device id
: xiaomi-surya

Step id
: modem-registered

Status
: open

Proof
: modem-registered

Run
: 20261118-191339

Proven on
: 7.1.0-sm7150-calls+

Notes
: suite run 20261118-191339: modem-registered=skip

Updated
: 2026-11-18


### Row 167

Device id
: xiaomi-surya

Step id
: sms-both-ways

Status
: open

Proof
: sms-loopback

Run
: 20261118-191339

Proven on
: 7.1.0-sm7150-calls+

Notes
: suite run 20261118-191339: sms-loopback=skip

Updated
: 2026-11-18


### Row 168

Device id
: xiaomi-surya

Step id
: mobile-data

Status
: open

Proof
: mobile-data

Run
: 20261118-191339

Proven on
: 7.1.0-sm7150-calls+

Notes
: suite run 20261118-191339: mobile-data=skip

Updated
: 2026-11-18


### Row 169

Device id
: xiaomi-surya

Step id
: mms-both-ways

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 170

Device id
: xiaomi-surya

Step id
: call-audio-path

Status
: done

Proof
: call-audio-path

Run
: 20261118-202945

Proven on
: 7.1.0-sm7150-calls+

Notes
: suite run 20261118-202945: call-audio-path=pass

Updated
: 2026-11-18


### Row 171

Device id
: xiaomi-surya

Step id
: voice-call-both-ways

Status
: open

Proof
: call-echo

Run
: 20261118-191339

Proven on
: 7.1.0-sm7150-calls+

Notes
: suite run 20261118-191339: call-echo=skip

Updated
: 2026-11-18


### Row 172

Device id
: xiaomi-surya

Step id
: emergency-numbers-known

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 173

Device id
: xiaomi-surya

Step id
: proximity-blanks-in-call

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 174

Device id
: xiaomi-surya

Step id
: volte-call

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 175

Device id
: xiaomi-surya

Step id
: wifi-joins

Status
: done

Proof
: wifi-interface,wifi-connected,wifi-reaches-gateway

Run
: 20261118-191339

Proven on
: 7.1.0-sm7150-calls+

Notes
: suite run 20261118-191339: wifi-interface=pass wifi-connected=pass wifi-reaches-gateway=pass

Updated
: 2026-11-18


### Row 176

Device id
: xiaomi-surya

Step id
: bt-controller-up

Status
: done

Proof
: bt-controller,bt-powered

Run
: 20261118-191339

Proven on
: 7.1.0-sm7150-calls+

Notes
: suite run 20261118-191339: bt-controller=pass bt-powered=pass

Updated
: 2026-11-18


### Row 177

Device id
: xiaomi-surya

Step id
: bt-pairs-carries-audio

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 178

Device id
: xiaomi-surya

Step id
: nfc-reads-tag

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 179

Device id
: xiaomi-surya

Step id
: usb-host-works

Status
: partial

Proof
: usb-role,usb-host-device

Run
: 20261118-191339

Proven on
: 7.1.0-sm7150-calls+

Notes
: suite run 20261118-191339: usb-host-device=- usb-role=pass

Updated
: 2026-11-18


### Row 180

Device id
: xiaomi-surya

Step id
: hotspot-shares-data

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 181

Device id
: xiaomi-surya

Step id
: sensor-hub-stable

Status
: done

Proof
: no-processor-crashes

Run
: 20261118-191339

Proven on
: 7.1.0-sm7150-calls+

Notes
: suite run 20261118-191339: no-processor-crashes=pass

Updated
: 2026-11-18


### Row 182

Device id
: xiaomi-surya

Step id
: sensors-exposed

Status
: done

Proof
: motion-and-light

Run
: 20261118-202945

Proven on
: 7.1.0-sm7150-calls+

Notes
: suite run 20261118-202945: motion-and-light=pass

Updated
: 2026-11-18


### Row 183

Device id
: xiaomi-surya

Step id
: proximity-reads

Status
: done

Proof
: proximity-reads

Run
: 20261118-202945

Proven on
: 7.1.0-sm7150-calls+

Notes
: suite run 20261118-202945: proximity-reads=pass

Updated
: 2026-11-18


### Row 184

Device id
: xiaomi-surya

Step id
: auto-rotate-follows

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 185

Device id
: xiaomi-surya

Step id
: brightness-follows-light

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 186

Device id
: xiaomi-surya

Step id
: gnss-fix

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 187

Device id
: xiaomi-surya

Step id
: fingerprint-unlocks

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 188

Device id
: xiaomi-surya

Step id
: camera-bus-bound

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 189

Device id
: xiaomi-surya

Step id
: image-sensor-identified

Status
: failing

Proof
: image-sensor

Run
: 20261118-202945

Proven on
: 7.1.0-sm7150-calls+

Notes
: suite run 20261118-202945: image-sensor=fail (0 sensors bound): a real gap on this kernel, not a stale run

Updated
: 2026-11-18


### Row 190

Device id
: xiaomi-surya

Step id
: raw-frame-captured

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 191

Device id
: xiaomi-surya

Step id
: camera-stream-viewable

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 192

Device id
: xiaomi-surya

Step id
: photo-taken

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 193

Device id
: xiaomi-surya

Step id
: video-recorded

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 194

Device id
: xiaomi-surya

Step id
: focus-and-flash

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 195

Device id
: xiaomi-surya

Step id
: suspend-way-back

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 196

Device id
: xiaomi-surya

Step id
: s2idle-cycle-returns

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 197

Device id
: xiaomi-surya

Step id
: suspend-wakes-quiet

Status
: open

Proof
: suspend-irq-quiet

Run
: 20261118-191339

Proven on
: 7.1.0-sm7150-calls+

Notes
: suite run 20261118-191339: suspend-irq-quiet=skip

Updated
: 2026-11-18


### Row 198

Device id
: xiaomi-surya

Step id
: radios-survive-suspend

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 199

Device id
: xiaomi-surya

Step id
: sensors-across-suspend

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 200

Device id
: xiaomi-surya

Step id
: resume-without-stall

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 201

Device id
: xiaomi-surya

Step id
: real-suspend-under-shell

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 202

Device id
: xiaomi-surya

Step id
: soc-floor-reached

Status
: open

Proof
: soc-sleeps

Run
: 20261118-191339

Proven on
: 7.1.0-sm7150-calls+

Notes
: suite run 20261118-191339: soc-sleeps=skip

Updated
: 2026-11-18


### Row 203

Device id
: xiaomi-surya

Step id
: call-wakes-from-sleep

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 204

Device id
: xiaomi-surya

Step id
: standby-current

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 205

Device id
: xiaomi-surya

Step id
: all-day-battery

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 206

Device id
: xiaomi-surya

Step id
: shell-runs-with-hardware

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 207

Device id
: xiaomi-surya

Step id
: on-screen-keyboard

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 208

Device id
: xiaomi-surya

Step id
: lock-and-unlock

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 209

Device id
: xiaomi-surya

Step id
: notifications-arrive

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 210

Device id
: xiaomi-surya

Step id
: update-applies

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 211

Device id
: xiaomi-surya

Step id
: update-rolls-back

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 212

Device id
: xiaomi-surya

Step id
: kernel-upgrade-keeps-steps

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 213

Device id
: xiaomi-surya

Step id
: coprocessor-restart-recovers

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 214

Device id
: xiaomi-surya

Step id
: days-without-reboot

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 215

Device id
: xiaomi-surya

Step id
: cycles-repeat-clean

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 216

Device id
: xiaomi-surya

Step id
: linux-runs

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 217

Device id
: xiaomi-surya

Step id
: daily-usable-phone

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 218

Device id
: xiaomi-surya

Step id
: complete-phone

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 219

Device id
: xiaomi-surya

Step id
: pon-reason-read

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 220

Device id
: xiaomi-surya

Step id
: reset-types-right

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 221

Device id
: xiaomi-surya

Step id
: power-off-stays-off

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 222

Device id
: xiaomi-surya

Step id
: charger-mode-entered

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 223

Device id
: xiaomi-surya

Step id
: reset-state-survives

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 224

Device id
: xiaomi-surya

Step id
: key-reset-recovers

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 225

Device id
: xiaomi-surya

Step id
: rtc-alarm-powers-on

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18


### Row 226

Device id
: xiaomi-surya

Step id
: alarm-wakes-from-sleep

Status
: unknown

Notes
: no suite result for its proof in this base's runs; nobody checked

Updated
: 2026-11-18

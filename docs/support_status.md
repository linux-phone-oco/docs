<!-- Generated from data/ by .tad/tools/render.py. Do not edit by hand. -->

# Support Status

### Row 1

Device id
: xiaomi-surya

Component id
: audio-speaker

Status
: works

Notes
: Works on the stock Nura kernel (7.1-rc3) and device tree once the ADSP sensors service is off (see backlog adsp-sensor-crash-loop): heard by the user on 2026-11-09, then a 5-minute playback soak with 0 ADSP crashes, the sound card present throughout and 0 playback errors. Before that fix, sound lasted seconds: the ADSP crashed every 13-25 s.

Updated
: 2026-11-09


### Row 2

Device id
: xiaomi-surya

Component id
: audio-headphone

Status
: unknown

Notes
: Not individually confirmed; grouped with mic/earpiece as still-WIP in the postmarketOS (now Nura) community-promotion notes.

Updated
: 2026-11-04


### Row 3

Device id
: xiaomi-surya

Component id
: audio-mic

Status
: broken

Notes
: Explicitly called out as not yet working when the device moved from testing to community in pmOS packaging.

Updated
: 2026-11-04


### Row 4

Device id
: xiaomi-surya

Component id
: audio-earpiece

Status
: broken

Notes
: Same source as audio-mic.

Updated
: 2026-11-04


### Row 5

Device id
: xiaomi-surya

Component id
: camera-front

Status
: broken

Notes
: Cameras explicitly called out as not yet working, same source as audio-mic.

Updated
: 2026-11-04


### Row 6

Device id
: xiaomi-surya

Component id
: camera-rear

Status
: broken

Notes
: Same source as camera-front.

Updated
: 2026-11-04


### Row 7

Device id
: xiaomi-surya

Component id
: display-panel

Status
: works

Notes
: Video-mode panel fixes and panel regulator/variant support landed (6.7.4, 6.13.2).

Updated
: 2026-11-04


### Row 8

Device id
: xiaomi-surya

Component id
: touchscreen

Status
: works

Notes
: nt36xxx touchscreen driver rewrite for xiaomi-surya landed (6.7.4).

Updated
: 2026-11-04


### Row 9

Device id
: xiaomi-surya

Component id
: haptics

Status
: works

Notes
: awinic,aw8624 haptics driver added (6.2.0).

Updated
: 2026-11-04


### Row 10

Device id
: xiaomi-surya

Component id
: modem-data

Status
: partial

Notes
: Mobile data fix landed (6.2.0); calls and SMS not separately confirmed.

Updated
: 2026-11-04


### Row 11

Device id
: xiaomi-surya

Component id
: modem-calls

Status
: unknown

Notes
: Not confirmed either way.

Updated
: 2026-11-04


### Row 12

Device id
: xiaomi-surya

Component id
: modem-sms

Status
: unknown

Notes
: Not confirmed either way.

Updated
: 2026-11-04


### Row 13

Device id
: xiaomi-surya

Component id
: wifi

Status
: unknown

Notes
: Not confirmed either way.

Updated
: 2026-11-04


### Row 14

Device id
: xiaomi-surya

Component id
: bluetooth

Status
: unknown

Notes
: Not confirmed either way.

Updated
: 2026-11-04


### Row 15

Device id
: xiaomi-surya

Component id
: nfc

Status
: unknown

Notes
: Not confirmed for this device specifically; a related device in the same family (davinci) is known to disable NFC over a GPIO conflict, which does not necessarily apply here.

Updated
: 2026-11-04


### Row 16

Device id
: xiaomi-surya

Component id
: fingerprint

Status
: unknown

Notes
: Not confirmed either way.

Updated
: 2026-11-04


### Row 17

Device id
: xiaomi-surya

Component id
: sensors

Status
: unknown

Notes
: Not confirmed either way.

Updated
: 2026-11-04


### Row 18

Device id
: xiaomi-surya

Component id
: usb-otg

Status
: works

Notes
: OTG support added (6.13.2).

Updated
: 2026-11-04


### Row 19

Device id
: xiaomi-surya

Component id
: fastboot

Status
: works

Notes
: Required for Nura to be installable at all, and for lab-agent's own boot-and-test loop.

Updated
: 2026-11-04

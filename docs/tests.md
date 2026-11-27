<!-- Generated from data/ by tad. Do not edit by hand. -->

# Tests

<a id="root-fills-its-partition"></a>
### root-fills-its-partition

Component id
: kernel

Proves
: works

Says
: the system fills its partition


<a id="root-has-room"></a>
### root-has-room

Component id
: kernel

Proves
: works

Says
: the system partition has room


<a id="root-writable"></a>
### root-writable

Component id
: kernel

Proves
: works

Says
: a file can be written


<a id="no-oops"></a>
### no-oops

Component id
: kernel

Proves
: works

Says
: no oops, BUG or panic this boot


<a id="boot-warnings"></a>
### boot-warnings

Component id
: kernel

Proves
: works

Says
: no kernel warning but the known ones


<a id="no-processor-crashes"></a>
### no-processor-crashes

Component id
: kernel

Proves
: works

Says
: no signal processor crashed this boot


<a id="no-failed-units"></a>
### no-failed-units

Component id
: kernel

Proves
: works

Says
: no service failed but the known ones


<a id="cdsp-running"></a>
### cdsp-running

Component id
: kernel

Proves
: present

Says
: the compute DSP runs


<a id="adsp-running"></a>
### adsp-running

Component id
: audio-speaker

Proves
: present

Says
: the audio DSP runs


<a id="sound-card"></a>
### sound-card

Component id
: audio-speaker

Proves
: present

Says
: the sound card is registered


<a id="amp-channels"></a>
### amp-channels

Component id
: audio-speaker

Proves
: present

Says
: each amplifier is fed its channel


<a id="amp-volume-0x4c"></a>
### amp-volume-0x4c

Component id
: audio-speaker

Proves
: present

Says
: the left amplifier is not muted at the chip


<a id="amp-volume-0x4d"></a>
### amp-volume-0x4d

Component id
: audio-speaker

Proves
: present

Says
: the right amplifier is not muted at the chip


<a id="default-output"></a>
### default-output

Component id
: audio-speaker

Proves
: present

Says
: the shell plays to a real sound card


<a id="heard-left"></a>
### heard-left

Component id
: audio-speaker

Proves
: works

Says
: a tone on the left speaker heard by the lab microphone


<a id="heard-right"></a>
### heard-right

Component id
: audio-speaker

Proves
: works

Says
: a tone on the right speaker heard by the lab microphone


<a id="modem-running"></a>
### modem-running

Component id
: modem-data

Proves
: present

Says
: the modem processor runs


<a id="modem-seen"></a>
### modem-seen

Component id
: modem-data

Proves
: present

Says
: ModemManager sees the modem


<a id="modem-registered"></a>
### modem-registered

Component id
: modem-data

Proves
: works

Says
: registered on a network, with a SIM


<a id="wifi-interface"></a>
### wifi-interface

Component id
: wifi

Proves
: present

Says
: a Wi-Fi interface exists


<a id="wifi-connected"></a>
### wifi-connected

Component id
: wifi

Proves
: works

Says
: joined a network, with an address


<a id="wifi-reaches-gateway"></a>
### wifi-reaches-gateway

Component id
: wifi

Proves
: works

Says
: the gateway answers through Wi-Fi


<a id="bt-controller"></a>
### bt-controller

Component id
: bluetooth

Proves
: present

Says
: a Bluetooth controller exists


<a id="bt-powered"></a>
### bt-powered

Component id
: bluetooth

Proves
: present

Says
: the adapter is powered


<a id="panel-connected"></a>
### panel-connected

Component id
: display-panel

Proves
: present

Says
: the panel is connected


<a id="backlight"></a>
### backlight

Component id
: display-panel

Proves
: present

Says
: the backlight is lit


<a id="touch-device"></a>
### touch-device

Component id
: touchscreen

Proves
: present

Says
: a touchscreen input device exists


<a id="vibrator"></a>
### vibrator

Component id
: haptics

Proves
: present

Says
: a vibration motor exists


<a id="nfc-device"></a>
### nfc-device

Component id
: nfc

Proves
: present

Says
: the NFC controller is seen


<a id="usb-role"></a>
### usb-role

Component id
: usb-otg

Proves
: present

Says
: the USB role switch exists


<a id="usb-awake"></a>
### usb-awake

Component id
: usb-otg

Proves
: works

Says
: on USB the lab link holds (wake lock held)


<a id="jack-detector"></a>
### jack-detector

Component id
: audio-headphone

Proves
: present

Says
: the headset jack detector exists


<a id="reader-exposed"></a>
### reader-exposed

Component id
: fingerprint

Proves
: present

Says
: a fingerprint reader is exposed


<a id="image-sensor"></a>
### image-sensor

Component id
: camera-rear

Proves
: present

Says
: an image sensor is bound


<a id="mic-records"></a>
### mic-records

Component id
: audio-mic

Proves
: present

Says
: one second recorded from the main microphone is not digital silence


<a id="soc-sleeps"></a>
### soc-sleeps

Component id
: deep-sleep

Proves
: works

Says
: the SoC reached its lowest power state this boot (CX collapse or AOSS sleep, counted by the SoC itself)


<a id="mic-hears-speaker"></a>
### mic-hears-speaker

Component id
: audio-mic

Proves
: works

Says
: the bottom microphone finds a quiet tone from the phone's speaker, 20 dB above the noise


<a id="speaker-stereo"></a>
### speaker-stereo

Component id
: audio-speaker

Proves
: present

Says
: the speaker plays in two channels


<a id="mic-top-hears-speaker"></a>
### mic-top-hears-speaker

Component id
: audio-mic

Proves
: works

Says
: the top microphone finds a quiet tone from the phone's speaker, 20 dB above the noise


<a id="earpiece-heard"></a>
### earpiece-heard

Component id
: audio-earpiece

Proves
: works

Says
: a quiet tone played through the earpiece as a mono stream is found by the top microphone beside it, 20 dB above the noise


<a id="sms-loopback"></a>
### sms-loopback

Component id
: modem-sms

Proves
: works

Says
: an SMS the phone sends to its own number arrives, at most once a day


<a id="mobile-data"></a>
### mobile-data

Component id
: modem-data

Proves
: works

Says
: over the interface of the modem's data bearer (not Wi-Fi, not the IMS bearer), at least 3 of 5 pings are answered and 100 kB is downloaded (5 MB once a week, for throughput); each run's bytes are kept against the month's budget, and the check skips once that is spent


<a id="call-echo"></a>
### call-echo

Component id
: modem-calls

Proves
: works

Says
: a daily call to an echo line carries a tone up and back: it is heard again after it ended


<a id="call-audio-path"></a>
### call-audio-path

Component id
: modem-calls

Proves
: present

Says
: the VoiceMMode1 PCM, its routing controls and q6voiced are there


<a id="motion-and-light"></a>
### motion-and-light

Component id
: sensors

Proves
: present

Says
: motion, light or proximity sensors are exposed - as IIO devices or through iio-sensor-proxy (a DSP's sensor core)


<a id="proximity-reads"></a>
### proximity-reads

Component id
: sensors

Proves
: present

Says
: the proximity sensor gives a reading through iio-sensor-proxy (near or far when covered is a witnessed test)


<a id="walleye-gadget-up"></a>
### walleye-gadget-up

Component id
: kernel

Proves
: works

Says
: A boot image of ours left fastboot: the phone's USB gadget appears on the host (lsusb by the manifest serial within 60 s) and answers on 172.16.43.1 (ping, telnet)


<a id="walleye-vendor-gadget-image-built"></a>
### walleye-vendor-gadget-image-built

Component id
: kernel

Proves
: present

Says
: The control boot.img repacked with only the ramdisk swapped (vendor-gadget.img = bisect s1) exists, with kernel, dtb, command line, header and AVB footer equal to the control's; counted by check-bisect


<a id="standby-current"></a>
### standby-current

Component id
: deep-sleep

Proves
: works

Says
: battery-only average current across a suspended screen-off cycle stays under 15 mA (Droidian miatoll reads 9 mA; Android on surya not known yet)


<a id="suspend-irq-quiet"></a>
### suspend-irq-quiet

Component id
: deep-sleep

Proves
: works

Says
: the interrupts counted across one 15 s suspended cycle stay under the manifest's threshold; over it, the top three sources are named


<a id="pmic-wdt-bites"></a>
### pmic-wdt-bites

Component id
: deep-sleep

Proves
: works

Says
: armed and left unpetted with nothing suspended, the PMIC watchdog resets the phone within its timeout and the next boot reports a PMIC watchdog reset (bootstatus CARDRESET)


<a id="pmic-wdt-wakes-in-suspend"></a>
### pmic-wdt-wakes-in-suspend

Component id
: deep-sleep

Proves
: works

Says
: with the PMIC watchdog armed (60 s, pretimeout 30 s, wakeup on) and nothing else to wake it, a suspend is ended by the watchdog's bark within 25 to 45 s and the phone does not reset (same boot id)


<a id="suspend-retry-backs-off"></a>
### suspend-retry-backs-off

Component id
: deep-sleep

Proves
: works

Says
: while suspend keeps failing under Sxmo, the tries are spaced 1, 2, 4 ... 64 s apart (sxmo.log 'next try in'), and the USB link drops at most 8 times in 5 minutes (26 before the fix)


<a id="test-layer-quiet"></a>
### test-layer-quiet

Component id
: deep-sleep

Proves
: works

Says
: in a boot that claims the hardware-test layer (multi-user.target, no display manager), no shell or idle-suspend process runs (tinydm, sxmo_*, superd, swayidle, phoc, phosh, plasmashell, powerdevil, gsd-power), logind's IdleAction and HandlePowerKey are ignore, and no suspend was entered this boot but lpoco-health's own cycles; a boot into a shell layer says skip and names the shell, so the step stays unknown until the test layer boots


<a id="sensors-after-suspend"></a>
### sensors-after-suspend

Component id
: sensors

Proves
: works

Says
: after a suspend the sensors daemon (hexagonrpcd-adsp-sensorspd) was stopped before it and runs again after it, and a sensor gives a reading; run in the test layer, with no shell


<a id="walleye-modem-up"></a>
### walleye-modem-up

Component id
: modem-data

Proves
: present

Says
: Walleye's modem is up (tests/health/base/modem-up.sh, google-walleye-lab #1267): remoteproc 4080000.remoteproc (qcom-q6v5-mss) is running and qrtr lists services 2 (device management) and 21 (the modem's embedded file system) on node 0; calls, SIM and data are not proved

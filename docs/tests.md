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


<a id="motion-and-light"></a>
### motion-and-light

Component id
: sensors

Proves
: present

Says
: motion, light or proximity sensors are exposed


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

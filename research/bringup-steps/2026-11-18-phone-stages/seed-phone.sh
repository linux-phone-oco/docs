#!/bin/sh
# Seeds the phone-completion stages, their generic steps and edges, and three goal steps, through the records
# (decision 2026-11-18-bringup-steps-phone-stages-and-goal-steps). Run in docs after sources.sh. Generic steps
# only: each device's status is claimed in its own base. Steps first met on surya (surya-lab's records) are
# generalised; steps nobody has done are here too, so they show as not known yet instead of being forgotten.
# "World gap" in a guide marks a step with no public prior art on modern Qualcomm phones.
set -eu
st() { ikb bringup-step --checked-on 2026-11-18 "$@" >/dev/null; }
ed() { ikb bringup-edge "$@" >/dev/null; }
sg() { ikb bringup-stage "$@" >/dev/null; }
GOAL="A goal: it does nothing itself - done when every hard need is done or not-needed, read off tad q bringup-chain (its ready is its done). A group of groups, as a systemd target is (systemd-target)."

# ---- stages: after lab (8), in the order a phone usually meets them; goals last
sg --id coprocessors --ord 9 --title "Coprocessors" --what "The processors a phone leans on - the modem's, the audio and sensor DSPs, the Wi-Fi core - get their firmware, run, and stay up."
sg --id display --ord 10 --title "Display and input" --what "The panel lights, touch and keys answer, the GPU renders."
sg --id audio --ord 11 --title "Sound" --what "The card, the codec and the amplifiers, a profile for the shell, sound heard and recorded."
sg --id modem --ord 12 --title "Modem, SMS and data" --what "The modem seen, the SIM read, the network joined; messages and data both ways."
sg --id calls --ord 13 --title "Calls" --what "A call with sound both ways, the screen dark at the ear, emergency numbers known, calls over LTE."
sg --id radios --ord 14 --title "Local radios" --what "Wi-Fi, Bluetooth, NFC, USB host and sharing the connection."
sg --id sensors --ord 15 --title "Sensors and location" --what "Motion, light and proximity read and used; a position fix; the fingerprint reader."
sg --id camera --ord 16 --title "Camera" --what "From the camera bus to a photo and a video: sensor, raw frame, a viewable stream, focus and flash."
sg --id sleep --ord 17 --title "Sleep and battery life" --what "Suspend that returns, wakes only for what matters and reaches the SoC's floor; a day on one charge."
sg --id shell --ord 18 --title "Shell" --what "A phone shell on the hardware: keyboard, lock, notifications."
sg --id upkeep --ord 19 --title "Updates and endurance" --what "Updates that apply and roll back, and the phone still working after days, upgrades and crashes of its parts."
sg --id goals --ord 20 --title "Goals" --what "The steps that only name a whole: Linux runs, a daily-usable phone, a complete phone - each done when all it needs is."

# ---- power (existing stage): what a battery machine needs beyond the charger
st --id battery-gauge-reads --title "The battery gauge reads true" --stage power --ord 4 --applies power:battery \
  --done-when "capacity, voltage and current read in power_supply agree with a meter within 5 % over a discharge" \
  --proof battery-gauge --proof-kind host-check \
  --guide "Test to write. surya read gauge averages in its standby run (2026-11-17-r3-partial-and-the-reset-after); walleye open (walleye-fuel-gauge). PMI8998-class gauges are still RFCs (pmi8998-fg-rfc)." --sources pmi8998-fg-rfc
st --id power-off-stays-off --title "Off stays off" --stage power --ord 5 --applies any \
  --done-when "poweroff leaves the machine off, and plugging a charger in does not boot the full system" \
  --proof stays-off --proof-kind witness \
  --guide "surya fails: poweroff and a plugged charger both boot pmOS (off-state-charging). Read the PMIC's power-on reason to tell the two apart."
st --id off-mode-charging --title "Charges while off" --stage power --ord 6 --applies power:battery \
  --done-when "plugged in while off it charges, shows its level, and boots on the power key" \
  --proof off-mode-charging --proof-kind witness \
  --guide "Sailfish names it act-dead mode (sailfish-hadk-checklist). World gap: the usual tool, charging-sdl, is unmaintained and boot-loops at low battery (pmaports-charging-sdl-1064)." --sources sailfish-hadk-checklist,pmaports-charging-sdl-1064
st --id thermal-zones-sane --title "Thermal zones read and throttle" --stage power --ord 7 --applies any \
  --done-when "every thermal zone reads a plausible temperature, trips are set, and a load throttles before any shutdown" \
  --proof thermal-zones --proof-kind phone-suite \
  --guide "Test to write; never touched in our labs. Android has a thermal HAL and a policy; Linux phones have the kernel's zones and no policy daemon (aosp-compat-matrix, sailfish-hadk-checklist)." --sources aosp-compat-matrix,sailfish-hadk-checklist

# ---- lab (existing stage, empty until now)
st --id lab-link-held-awake --title "The lab's link holds the phone awake" --stage lab --ord 1 --applies any \
  --done-when "while a host holds the USB link, nothing suspends the phone, and the hold is released on purpose for sleep tests" \
  --proof usb-awake --proof-kind phone-suite \
  --guide "surya: 26 link drops in 5 minutes before the hold (2026-11-10-usb-flapping), the screen blanking by itself (2026-11-18-screen-blanks-by-itself); held by devlab-usb-awake-hold-through-resume, moving to a package (surya-awake-from-package)."
st --id shell-autosleep-tamed --title "The shell's own sleep loop is gated" --stage lab --ord 2 --applies any \
  --done-when "the shell's auto-suspend is off or gated while the lab works, and a failed suspend backs off instead of looping" \
  --proof autosleep-off --proof-kind phone-suite \
  --guide "surya: sxmo's rtcwake loop cut the lab off (2026-11-18-who-runs-rtcwake-99999999); kept off by sxmo-autosleep-off-lasting and bt-suspend-gate, proven by suspend-retry-backs-off; the fix goes to sxmo (surya-sxmo-suspend-series)."

# ---- coprocessors
st --id firmware-reachable --title "The device's firmware is reachable" --stage coprocessors --ord 1 --applies any \
  --done-when "every firmware file the kernel asks for is found: no failed direct firmware load for a needed file" \
  --proof firmware-found --proof-kind host-check \
  --guide "Signed blobs are the stock system's, per device: from the stock partitions read-only (msm-firmware-loader, which assumes eMMC) or a firmware package (pmos-firmware-docs; surya firmware-xiaomi-surya)." --sources msm-firmware-loader-emmc,pmos-firmware-docs,firmware-xiaomi-surya
st --id pd-mapper-before-remoteproc --title "The domain mapper is up before the DSPs" --stage coprocessors --ord 2 --applies soc:qcom \
  --done-when "the protection-domain mapper serves before qcom_q6v5_pas probes, so the audio domain comes up on 20 boots of 20" \
  --proof sound-card --proof-kind phone-suite \
  --guide "surya: 8 boots of 42 had no sound card without a softdep (no-sound-card-boots; surya-lab lab/devlab-pd-mapper.conf), 21 of 21 with it; the upstream form is open (upstream-pd-mapper-order). The mapper is in the kernel since 2024 (inkernel-pd-mapper)." --sources inkernel-pd-mapper
st --id remoteprocs-running --title "Every coprocessor runs" --stage coprocessors --ord 3 --applies any \
  --done-when "every remoteproc the device has reads running and none crashed this boot" \
  --proof adsp-running,cdsp-running,modem-running,no-processor-crashes --proof-kind phone-suite \
  --guide "surya done; walleye open (walleye-radios-research). Trap: the ADSP 'handover signaled' every second (adsp-handover-loop)."
st --id fastrpc-helpers-stable --title "The DSP helpers run without crashing the DSP" --stage coprocessors --ord 4 --applies soc:qcom \
  --done-when "the FastRPC helpers (hexagonrpcd) serve and the DSP they talk to stays up over three boots" \
  --proof no-processor-crashes --proof-kind phone-suite \
  --guide "surya: the rootpd helper crashed the ADSP 24 times of 24 (2026-11-10-suspend-crash-found, adsp-sensor-crash-loop); masked in surya's device.toml."

# ---- display and input
st --id panel-lit --title "The panel lights" --stage display --ord 1 --applies any \
  --done-when "the console or a test pattern shows on the panel and the backlight follows its control" \
  --proof panel-connected,backlight --proof-kind phone-suite --component display-panel \
  --guide "Qualcomm DSI panels: a driver generated from the downstream tree (lmdpdg). walleye needs a command-mode panel driver (walleye-display-s6e3fa5)." --sources lmdpdg
st --id touch-input --title "Touch answers" --stage display --ord 2 --applies any \
  --done-when "a touch at each corner gives events at the right coordinates" \
  --proof touch-device --proof-kind phone-suite --component touchscreen \
  --guide "surya done; walleye open (walleye-touch-rmi4). The suite proves presence; coordinates need a hand or a robot."
st --id buttons-report --title "The keys report one event a press" --stage display --ord 3 --applies any \
  --done-when "power and volume keys give one press and one release each, no chatter" \
  --proof key-events --proof-kind witness \
  --guide "surya: the volume-down key on the PMIC chatters (2026-11-18-screen-off-while-typing-key-events, surya-key-chatter-resin)."
st --id haptics-buzz --title "The vibrator buzzes" --stage display --ord 4 --applies any \
  --done-when "a force-feedback effect is felt" --proof vibrator --proof-kind phone-suite --component haptics \
  --guide "The suite proves presence only; the buzz is a hand's witness. walleye open (walleye-audio-haptics, DRV2624)."
st --id gpu-renders --title "The GPU renders" --stage display --ord 5 --applies any \
  --done-when "a GL and a Vulkan client render on the GPU (not a software renderer) to the panel" \
  --proof gpu-renders --proof-kind phone-suite \
  --guide "Test to write; never measured in our labs. Adreno needs its zap shader and GMU firmware from the device."

# ---- sound
st --id audio-codec-attached --title "The codec attaches and stays" --stage audio --ord 1 --applies any \
  --done-when "the codec enumerates on its buses (SoundWire, I2S, I2C) and stays attached across the boot" \
  --proof sound-card,mic-records --proof-kind phone-suite \
  --guide "surya WCD937x: a wrong aoncc address hung the boot (wcd937x-dt-aoncc); the sleep pin state drove reset low (microphone-codec-drops-off); the LPI mux from the vendor tree (2026-11-11-lpi-mux-from-vendor). Hazard: reading the LPASS pinctrl in debugfs hangs the phone." --sources lineage-sm6150-wcd937x,vendor-sm6150-lpi-dtsi
st --id sound-card-registered --title "The sound card registers" --stage audio --ord 2 --applies any \
  --done-when "the machine's card is listed on every boot" --proof sound-card --proof-kind phone-suite \
  --guide "surya: lost on 8 boots of 42 until the domain mapper was ordered (no-sound-card-boots)."
st --id speaker-amps-fed --title "The amplifiers get their channels" --stage audio --ord 3 --applies any \
  --done-when "each speaker amplifier gets its slot and is unmuted at the chip, not only in the driver's cache" \
  --proof amp-channels,amp-volume-0x4c,amp-volume-0x4d --proof-kind phone-suite \
  --guide "surya tas2562: the slot length (upstream-tas2562-slot-length) and a volume write that reached only the cache (plasma-silent, upstream-tas2562-volume)."
st --id ucm-hifi-profile --title "A UCM profile plays to the real card" --stage audio --ord 4 --applies any \
  --done-when "the shell's sound server picks the card's HiFi verb and plays in stereo, the right channel to the right speaker" \
  --proof default-output,speaker-stereo --proof-kind phone-suite \
  --guide "surya ucm/Xiaomi/surya/HiFi.conf (2026-11-11-right-is-bottom), upstream open (upstream-ucm-surya-stereo)." --sources sm7125-mainline-ucm-miatoll
st --id speaker-heard --title "The speaker is heard" --stage audio --ord 5 --applies any \
  --done-when "a quiet tone on each channel is heard by the lab's ear" \
  --proof heard-left,heard-right --proof-kind phone-suite --component audio-speaker \
  --guide "Quiet tones only. surya: one 'heard' was withdrawn when the microphone had moved (2026-11-10-heard)."
st --id mic-captures --title "The microphones capture" --stage audio --ord 6 --applies any \
  --done-when "a second of capture from each microphone is not digital silence" \
  --proof mic-records --proof-kind phone-suite --component audio-mic \
  --guide "surya: zeros meant the link named the wrong DAI (mic-zeros-meant-no-input); the mics are analog through the WCD, ADC2 on its own port (2026-11-17-microphones-analog-wcd-path)." --sources lineage-sm6150-bolero
st --id mic-hears-speaker --title "Each microphone hears the speaker" --stage audio --ord 7 --applies any \
  --done-when "each microphone finds the phone's own tone 20 dB above the noise" \
  --proof mic-hears-speaker,mic-top-hears-speaker --proof-kind phone-suite \
  --guide "A closed loop with no hands: surya done (mic-held)."
st --id earpiece-plays --title "The earpiece plays" --stage audio --ord 8 --applies form:phone \
  --done-when "a tone through the earpiece is heard by the bottom microphone" \
  --proof earpiece-heard --proof-kind phone-suite --component audio-earpiece \
  --guide "surya: the earpiece is the second TAS256x at 0x4d, not the codec's EAR amplifier (parts row audio-earpiece)."
st --id headset-jack --title "A headset works through the jack" --stage audio --ord 9 --applies any \
  --done-when "plugging is detected, sound plays to the headset and its microphone records" \
  --proof jack-detector,headset-loop --proof-kind phone-suite --component audio-headphone \
  --guide "surya partial: detection only (verify-headphone-mic-earpiece). A loopback plug can prove both ways without hands."

# ---- modem, SMS and data
st --id modem-file-services --title "The modem's file services serve" --stage modem --ord 1 --applies soc:qcom \
  --done-when "rmtfs, the qrtr name service, pd-mapper and tqftpserv run and the modem's mode is online, not shutting down" \
  --proof modem-running --proof-kind phone-suite \
  --guide "surya: tqftpserv 1.1.1 never wrote short files and the modem looped 4769 times; 1.2 or later fixed it (modem-online-tqftpserv, upstream-alpine-tqftpserv)." --sources pmaports-tqftpserv-4747,pmaports-4441-tqftpserv
st --id modem-seen --title "The modem is seen" --stage modem --ord 2 --applies radio:cellular \
  --done-when "ModemManager (or oFono) lists the modem" --proof modem-seen --proof-kind phone-suite \
  --guide "On Qualcomm SoCs through the qcom-soc plugin over QRTR and IPA or BAM-DMUX (mm-qcom-soc-plugin)." --sources mm-qcom-soc-plugin
st --id sim-ready --title "The SIM is read" --stage modem --ord 3 --applies radio:cellular \
  --done-when "the SIM reads present and unlocked, in each slot the device has" \
  --proof sim-ready --proof-kind phone-suite \
  --guide "surya: the SIM works only in slot 2 (modem-online-tqftpserv); checks that need a SIM skip, not fail, without one (sim-removed-skips)." --sources pmaports-4441-tqftpserv
st --id modem-registered --title "The modem joins the network" --stage modem --ord 4 --applies radio:cellular \
  --done-when "the modem is registered on a network" --proof modem-registered --proof-kind phone-suite \
  --guide "Read-only first (2026-11-11-modem-read-only-first). surya done."
st --id sms-both-ways --title "SMS both ways" --stage modem --ord 5 --applies radio:cellular \
  --done-when "a message sent to the phone's own number comes back" --proof sms-loopback --proof-kind phone-suite --component modem-sms \
  --guide "surya done (tests/health/telephony/sms-loopback.sh); it costs money, so it runs at most once a day."
st --id mobile-data --title "Mobile data" --stage modem --ord 6 --applies radio:cellular \
  --done-when "pings and a 100 kB download go over the bearer's own interface, so Wi-Fi cannot stand in" \
  --proof mobile-data --proof-kind phone-suite --component modem-data \
  --guide "surya: naming the APN gave 'Multiple PDN connection', so the connection carries none (modem-online-tqftpserv); budget mobile-data-check-budget."
st --id mms-both-ways --title "MMS both ways" --stage modem --ord 7 --applies radio:cellular \
  --done-when "a picture message sent to the phone's own number comes back" --proof mms-loopback --proof-kind phone-suite \
  --guide "Test to write; never tried in our labs (mmsd-tng)."

# ---- calls
st --id call-audio-path --title "The call's sound path exists" --stage calls --ord 1 --applies form:phone \
  --done-when "the voice DSP path (q6voice on Qualcomm), its routing and a Voice Call UCM verb are present" \
  --proof call-audio-path --proof-kind phone-suite \
  --guide "surya: a TX topology sent silence; the uplink needs a 1-channel capture on TX_CODEC_DMA_TX_3 (call-audio-on-surya, calls-q6voice-kernel, calls-voice-ucm-uplink). World gap: q6voice lives out of tree in diverging copies and nothing exists for AudioReach SoCs (ixit-sdm845-upstreaming-0)." --sources ixit-sdm845-upstreaming-0
st --id voice-call-both-ways --title "A call carries sound both ways" --stage calls --ord 2 --applies form:phone \
  --done-when "a tone sent into a call comes back from an echo line" --proof call-echo --proof-kind phone-suite --component modem-calls \
  --guide "Proven by an echo call, no hands (2026-11-17-calls-proven-by-echo-call, echo-call-test-design). surya done." --sources twilio-voice
st --id emergency-numbers-known --title "Emergency numbers are known" --stage calls --ord 3 --applies form:phone \
  --done-when "the modem's emergency list is read, and 112 would be dialled as an emergency call even without a SIM - proven without dialling" \
  --proof emergency-list --proof-kind phone-suite \
  --guide "Test to write. Android's rule: 112 and 911 always; the list from network, SIM, modem or defaults (android-emergency-call). surya open (volte-and-emergency)." --sources android-emergency-call
st --id proximity-blanks-in-call --title "The screen goes dark at the ear" --stage calls --ord 4 --applies form:phone \
  --done-when "in a call the screen blanks and touch is ignored while the proximity sensor is covered" \
  --proof proximity-in-call --proof-kind witness \
  --guide "surya open (sensors-proximity-in-calls). Sailfish checks it while suspended too (sailfish-hadk-checklist)." --sources sailfish-hadk-checklist
st --id volte-call --title "A call over LTE" --stage calls --ord 5 --applies radio:cellular \
  --done-when "a call is known to go over IMS and carries sound both ways" --proof volte-call --proof-kind phone-suite \
  --guide "World gap: no open IMS works across carriers; 81voltd serves the IMS data service on some phones and carriers, OpenIMSd reverse-engineers the rest, one emergency VoLTE call on a Fairphone 6 (linmob-weekly-34-2026). surya open (volte-and-emergency)." --sources voltd-81,openimsd-nlnet,nura-volte-frida,linmob-weekly-34-2026

# ---- local radios
st --id wifi-joins --title "Wi-Fi joins and reaches the gateway" --stage radios --ord 1 --applies any \
  --done-when "the interface joins a network and reaches its gateway" \
  --proof wifi-interface,wifi-connected,wifi-reaches-gateway --proof-kind phone-suite --component wifi \
  --guide "walleye open: the WCN3990 firmware from the vendor partition (walleye-wifi-wcn3990). 5 GHz and speed never measured."
st --id bt-controller-up --title "The Bluetooth controller is up" --stage radios --ord 2 --applies any \
  --done-when "the controller is listed and powers on" --proof bt-controller,bt-powered --proof-kind phone-suite --component bluetooth \
  --guide "surya done; walleye open (walleye-wifi-wcn3990)."
st --id bt-pairs-carries-audio --title "Bluetooth pairs and carries sound" --stage radios --ord 3 --applies any \
  --done-when "a headset pairs, plays and records, in a call too" --proof bt-pairs --proof-kind witness \
  --guide "surya open (bt-pairing)."
st --id nfc-reads-tag --title "NFC reads a tag" --stage radios --ord 4 --applies any \
  --done-when "a tag held to the phone is read" --proof nfc-reads-tag --proof-kind witness --component nfc \
  --guide "surya: the controller probes (nfc-device), nothing reads tags. World gap: NFC unclaimed on these phones."
st --id usb-host-works --title "USB host works" --stage radios --ord 5 --applies any \
  --done-when "the port switches to host and a plugged device enumerates" --proof usb-role,usb-host-device --proof-kind phone-suite --component usb-otg \
  --guide "Switching the port cuts the lab's USB link: a second way in first."
st --id hotspot-shares-data --title "The phone shares its data" --stage radios --ord 6 --applies radio:cellular \
  --done-when "a client on the phone's Wi-Fi hotspot reaches the internet over mobile data" --proof hotspot --proof-kind host-check \
  --guide "Test to write; never tried."

# ---- sensors and location
st --id sensor-hub-stable --title "The sensor hub runs without crashing its DSP" --stage sensors --ord 1 --applies soc:qcom \
  --done-when "the sensor domain runs with no DSP crash over three boots" --proof no-processor-crashes --proof-kind phone-suite \
  --guide "surya: the registry kept current and a hexagonrpcd patch (2026-11-17-sensors-registry-kept-current, 2026-11-17-sensors-lasting-install-three-boots). World gap: why registry writes fail on some firmware." --sources hexagonrpc-source,libssc,wiki-surya-ssc-2024
st --id sensors-exposed --title "Motion and light sensors read" --stage sensors --ord 2 --applies any \
  --done-when "accelerometer, gyroscope and light give changing values through iio-sensor-proxy" \
  --proof motion-and-light --proof-kind phone-suite --component sensors \
  --guide "surya done (motion-and-light; the test once counted devices only, sensors-hardware-surya). Behind the Qualcomm DSP through libssc (iio-sensor-proxy-libssc)." --sources iio-sensor-proxy-libssc
st --id proximity-reads --title "Proximity reads near and far" --stage sensors --ord 3 --applies any \
  --done-when "covering the sensor changes its reading from far to near and back" --proof proximity-reads --proof-kind phone-suite \
  --guide "surya partial: covering it waits a witness (sensors-proximity-cover-witnessed)."
st --id auto-rotate-follows --title "The screen follows rotation" --stage sensors --ord 4 --applies any \
  --done-when "turning the phone turns the shell's screen" --proof auto-rotate --proof-kind witness \
  --guide "Never tried in our labs."
st --id brightness-follows-light --title "Brightness follows the light" --stage sensors --ord 5 --applies any \
  --done-when "covering the light sensor dims the panel under auto-brightness" --proof auto-brightness --proof-kind witness \
  --guide "Never tried in our labs."
st --id gnss-fix --title "A position fix" --stage sensors --ord 6 --applies any \
  --done-when "a fix outdoors within 5 minutes, reaching geoclue" --proof gps-fix --proof-kind phone-suite \
  --guide "On Qualcomm the location engine is the modem's (QMI LOC), through ModemManager and gnss-share. surya open (gps-measurable). World gap: no assisted GPS (XTRA) anywhere." --sources gnss-share
st --id fingerprint-unlocks --title "The fingerprint unlocks" --stage sensors --ord 7 --applies any \
  --done-when "a finger enrols and unlocks through fprintd" --proof fingerprint-unlock --proof-kind witness --component fingerprint \
  --guide "surya: the reader is not exposed (reader-exposed fails, a declared gap). Most phone readers are not in libfprint."

# ---- camera
st --id camera-bus-bound --title "The camera bus binds" --stage camera --ord 1 --applies any \
  --done-when "the camera receiver (CAMSS: CSIPHY, CSID, VFE) and the control bus (CCI) bind" \
  --proof camera-bus --proof-kind phone-suite \
  --guide "surya: CAMSS binds, no sensor described yet (2026-11-11-cameras-understood, surya-lab research/cameras.md)."
st --id image-sensor-identified --title "Each image sensor is identified" --stage camera --ord 2 --applies any \
  --done-when "each sensor's chip-id register reads its expected value in its slot" --proof image-sensor --proof-kind phone-suite \
  --guide "surya failing: the slots are being identified (camera-identify-slots)."
st --id raw-frame-captured --title "A raw frame" --stage camera --ord 3 --applies any \
  --done-when "one raw frame from each sensor arrives through the receiver" --proof raw-frame --proof-kind phone-suite \
  --guide "Test to write. Sensor drivers are often out of tree (Pixel 3a, OnePlus 6)."
st --id camera-stream-viewable --title "A viewable stream" --stage camera --ord 4 --applies any \
  --done-when "libcamera lists each camera and its ISP (software or hardware) gives a viewable stream" \
  --proof camera-stream --proof-kind phone-suite \
  --guide "Today a software ISP, on the GPU since libcamera 0.7 (libcamera-softisp-fosdem-2026). World gap: the hardware ISP is not used on any Qualcomm phone (camss-stats-uapi-rfc)." --sources libcamera-softisp-fosdem-2026,camss-stats-uapi-rfc
st --id photo-taken --title "A photo" --stage camera --ord 5 --applies any \
  --done-when "a camera app saves a photo with sane exposure and colour from each camera" \
  --proof photo --proof-kind witness --component camera-rear \
  --guide "Fairphone 6: all three cameras in 2026, the furthest any Qualcomm phone got (linmob-weekly-34-2026)." --sources linmob-weekly-34-2026
st --id video-recorded --title "A video with sound" --stage camera --ord 6 --applies any \
  --done-when "a recorded video plays back with its sound in step" --proof video --proof-kind witness \
  --guide "Never tried in our labs."
st --id focus-and-flash --title "Focus and flash" --stage camera --ord 7 --applies any \
  --done-when "autofocus moves the lens to a sharp image and the flash fires" --proof focus-flash --proof-kind witness \
  --guide "World gap: 3A tuning for phone sensors has no public prior art; focus-coil drivers were in review in 2025."

# ---- sleep and battery life
st --id suspend-way-back --title "A hang in sleep finds its way back" --stage sleep --ord 1 --applies any \
  --done-when "a hang in or after suspend resets the machine or panics into ramoops" \
  --proof sleep-way-back,pmic-wdt-wakes-in-suspend --proof-kind phone-suite \
  --guide "Extends watchdog-way-back into sleep. surya: the stock watchdog stops in suspend (2026-11-17-surya-way-back-inventory), kept armed by a patch (qcom-wdt-keep-armed-in-suspend); walleye: the PMIC watchdog bit and did not return (walleye-pmic-bite-reset-type-how-it-stands)." --sources lkml-qcom-wdt-suspend-2019,ramoops-doc
st --id s2idle-cycle-returns --title "A timed suspend returns" --stage sleep --ord 2 --applies any \
  --done-when "a 15 s RTC-timed suspend returns in the same boot" --proof suspend-cycle --proof-kind phone-suite \
  --guide "surya partial (health-suspend-cycle-proof): woke at once (2026-11-17-surya-s2idle-wakes-at-once), a UART wake across suspend (2026-11-17-qca-uart-wake-across-suspend). These SoCs have s2idle only (qcom-sleep-path)." --sources qcom-soc-sleep-states
st --id suspend-wakes-quiet --title "Only the meant sources wake it" --stage sleep --ord 3 --applies any \
  --done-when "over a suspend only the RTC, the modem, the keys and the charger wake it" --proof suspend-irq-quiet --proof-kind phone-suite \
  --guide "surya partial (floor-irq-quiet); ath10k floods the modem's interrupt on sdm845 (qcom-sleep-blockers)."
st --id radios-survive-suspend --title "The radios come back from sleep" --stage sleep --ord 4 --applies any \
  --done-when "after 20 cycles Wi-Fi and Bluetooth are up, with no interrupt storm and no controller crash" \
  --proof bt-suspend --proof-kind phone-suite \
  --guide "surya partial: the CTS pull-down hung the boot (2026-11-18-cts-pulldown-dtb-hangs); serial wakeup off (2026-11-17-serial-wakeup-off, 2026-11-18-bt-suspend-way)."
st --id sensors-across-suspend --title "Sensors come back from sleep" --stage sleep --ord 5 --applies any \
  --done-when "the sensor helper is stopped before suspend and serves again after" --proof sensors-after-suspend --proof-kind phone-suite \
  --guide "FastRPC helpers attached across suspend crash the ADSP: surya and the Pixel 3a stop them around it (2026-11-18-systemctl-suspend-leaves-sensors-stopped, sleep-fastrpc-helpers)." --sources pmaports-sargo-suspend
st --id resume-without-stall --title "Resume without a stall" --stage sleep --ord 6 --applies any \
  --done-when "20 attended cycles with no coprocessor crash and no RCU stall" --proof resume-clean --proof-kind phone-suite \
  --guide "surya failing (2026-11-18-resume-stall-how-it-stands, resume-stall-stop-clients)."
st --id real-suspend-under-shell --title "The shell's own suspend returns" --stage sleep --ord 7 --applies any \
  --done-when "the shell's auto-suspend and systemctl suspend return, again and again" --proof shell-suspend --proof-kind phone-suite \
  --guide "surya failing: the phone did not return (2026-11-18-real-suspend-try4-phone-did-not-return)." --sources sxmo-autosuspend
st --id soc-floor-reached --title "The SoC reaches its floor" --stage sleep --ord 8 --applies any \
  --done-when "in suspend the SoC's deepest-state counters rise (on Qualcomm: CX collapse and AOSS sleep)" \
  --proof soc-sleeps --proof-kind phone-suite --component deep-sleep \
  --guide "surya failing: cxsd, aosd and ddr stay 0 (2026-11-17-adsp-stopped-cx-aosd-ddr-stay-0, sleep-cluster-params). World gap: no public example of that floor on an SM7150/845-class phone (2026-11-17-floor-research)." --sources qcom-stats-c,soc-sleeps-check
st --id call-wakes-from-sleep --title "A call or a message wakes it" --stage sleep --ord 9 --applies form:phone \
  --done-when "a call rings and an SMS arrives within 10 s while the phone sleeps" --proof wakes-for-call --proof-kind phone-suite \
  --guide "The IPCRTR glink wakeup plus ModemManager's quick suspend; reported not dependable on OnePlus 6 and Pixel 3a (qcom-wake-for-calls). World gap: waking for a call but not for chatter. surya open (sleep-wakes-for-calls)." --sources nura-sdm845-wiki,nura-enchilada-wiki
st --id standby-current --title "Standby draws little" --stage sleep --ord 10 --applies power:battery \
  --done-when "on battery alone, asleep with the modem attached, the average current is under the device's target (15 mA on surya)" \
  --proof standby-current --proof-kind phone-suite \
  --guide "The arbiter of sleep (2026-11-17-standby-current-is-the-arbiter). surya partial: median 31 mA (2026-11-17-r3-partial-and-the-reset-after). World gap: no published s2idle figures per SoC with a modem." --sources android-doze-standby
st --id all-day-battery --title "A day on one charge" --stage sleep --ord 11 --applies power:battery \
  --done-when "a day of mixed use - standby, calls, screen time - ends with charge left" --proof battery-day --proof-kind witness \
  --guide "Never measured. UBports keeps it as an endurance test (ubports-device-data)." --sources ubports-device-data

# ---- shell
st --id shell-runs-with-hardware --title "A phone shell runs on the hardware" --stage shell --ord 1 --applies any \
  --done-when "a phone shell (sxmo, Phosh, Plasma Mobile) starts on the panel with touch, sound to the real card and its device profile" \
  --proof shell-up --proof-kind phone-suite \
  --guide "surya: sxmo with its profile; under Phosh the host loses the USB link (phosh-usb); Plasma was silent from a saved -110 dB mixer (plasma-silent). Phosh and Plasma need the GPU, sxmo does not." --sources sxmo-contribute
st --id on-screen-keyboard --title "The on-screen keyboard types" --stage shell --ord 2 --applies any \
  --done-when "the keyboard comes up in a text field and types into it" --proof osk-types --proof-kind witness \
  --guide "Witness for now; a robot finger or an input injection can stand in."
st --id lock-and-unlock --title "Lock and unlock" --stage shell --ord 3 --applies any \
  --done-when "the power key locks and darkens; the phone unlocks with its code" --proof lock-unlock --proof-kind witness \
  --guide "Needs the keys clean of chatter (buttons-report)."
st --id notifications-arrive --title "Notifications arrive with the screen off" --stage shell --ord 4 --applies form:phone \
  --done-when "a message or a call shows a notification and sounds while the screen is off" --proof notification --proof-kind witness \
  --guide "Push for apps is a service (feature push-notifications), not a step."

# ---- updates and endurance
st --id update-applies --title "An update applies" --stage upkeep --ord 1 --applies any \
  --done-when "an update from the distribution applies over the air and the phone boots it, the health suite as before" \
  --proof update-applies --proof-kind phone-suite \
  --guide "Test to write. UBports proves it by a local OTA test before an installer (ubports-porting)." --sources ubports-porting
st --id update-rolls-back --title "A bad update rolls back" --stage upkeep --ord 2 --applies any \
  --done-when "an update that does not boot falls back to the last good one with no hands" --proof update-rollback --proof-kind phone-suite \
  --guide "A/B slots (qbootctl) or a boot counter; Android's boot control HAL (aosp-compat-matrix)." --sources aosp-compat-matrix
st --id kernel-upgrade-keeps-steps --title "A kernel upgrade keeps every step" --stage upkeep --ord 3 --applies any \
  --done-when "on a new kernel release the suite passes what it passed before, and proven_on moves to the new kernel" \
  --proof suite-compare --proof-kind phone-suite \
  --guide "How claims stay true without expiry: a later kernel is told by proven_on and re-proven."
st --id coprocessor-restart-recovers --title "A coprocessor crash is survived" --stage upkeep --ord 4 --applies any \
  --done-when "a coprocessor crashed on purpose restarts and its users - sound, modem, sensors - come back with no reboot" \
  --proof ssr-recovers --proof-kind phone-suite \
  --guide "surya failing for audio after a DSP restart (surya-adsp-audio-after-suspend-loop). World gap: nobody tests whole-stack recovery."
st --id days-without-reboot --title "Days without a reboot" --stage upkeep --ord 5 --applies any \
  --done-when "seven days of ordinary use with no reboot, crash or part lost" --proof uptime-days --proof-kind phone-suite \
  --guide "Reliability, not function (weiss-fosdem-2025-missing-20); UBports' noRebootTest (ubports-device-data)." --sources weiss-fosdem-2025-missing-20,ubports-device-data
st --id cycles-repeat-clean --title "Repeated cycles stay clean" --stage upkeep --ord 6 --applies any \
  --done-when "100 suspend cycles, 20 calls and 50 camera switches with no part lost" --proof cycles-clean --proof-kind phone-suite \
  --guide "'Does audio still work after two hours asleep' (weiss-fosdem-2025-missing-20)." --sources weiss-fosdem-2025-missing-20,fosdem-2026-foss-on-mobile

# ---- goals: groups of groups, as steps
st --id linux-runs --title "Linux runs" --stage goals --ord 1 --applies any \
  --done-when "every step it needs is done or not-needed" --proof bringup-chain-ready --proof-kind host-check \
  --guide "$GOAL The close of the generic bring-up, any machine." --sources systemd-target
st --id daily-usable-phone --title "A daily-usable phone" --stage goals --ord 2 --applies form:phone \
  --done-when "every step it needs is done or not-needed" --proof bringup-chain-ready --proof-kind host-check \
  --guide "$GOAL What a person needs every day: calls, messages, data, sound, a photo, a position, a day of battery, charging, updates (the features of milestones lp-calls-and-messages, lp-connected, lp-daily-basics; UBports' stages 3-4)." --sources systemd-target,ubports-device-data
st --id complete-phone --title "A complete phone" --stage goals --ord 3 --applies form:phone \
  --done-when "every step it needs is done or not-needed" --proof bringup-chain-ready --proof-kind host-check \
  --guide "$GOAL Everything the hardware does, lasting: VoLTE, MMS, every radio and sensor, video, rollback, reliability. Apps and services (Android apps, banking, sync, backup) stay features, not steps." --sources systemd-target,android-cdd,halium-scope

# ---- edges
h() { ed --step "$1" --requires "$2" --kind hard --why "$3"; }
s() { ed --step "$1" --requires "$2" --kind soft --why "$3"; }

h battery-gauge-reads pmic-bound "the gauge is a PMIC function"
h power-off-stays-off pmic-bound "the power-on reason and power-off are the PMIC's"
h off-mode-charging charger-online "it charges"
h off-mode-charging power-off-stays-off "off must be off before it can charge while off (surya off-state-charging)"
s off-mode-charging battery-gauge-reads "the level shown is the gauge's"
h thermal-zones-sane rootfs-boots "the zones are read from userspace under load"
h lab-link-held-awake usb-network "the link is the USB network"
h shell-autosleep-tamed lab-link-held-awake "the shell's loop cut the lab off (2026-11-18-who-runs-rtcwake-99999999)"
h firmware-reachable kernel-reaches-init "the kernel asks for the files"
h pd-mapper-before-remoteproc kernel-reaches-init "an order of modules at boot"
h remoteprocs-running firmware-reachable "each coprocessor boots a signed blob"
h remoteprocs-running pd-mapper-before-remoteproc "the audio domain needs the mapper first (no-sound-card-boots)"
h fastrpc-helpers-stable remoteprocs-running "the helpers talk to a running DSP"
h fastrpc-helpers-stable rootfs-boots "hexagonrpcd is userspace"
h panel-lit kernel-reaches-init "the panel driver is the kernel's"
h touch-input kernel-reaches-init "the touch driver is the kernel's"
s touch-input firmware-reachable "some touch controllers load firmware"
h buttons-report rootfs-boots "events are read in userspace"
s buttons-report pmic-bound "the power and volume-down keys are the PMIC's on most phones"
h haptics-buzz rootfs-boots "the effect is played from userspace"
h gpu-renders panel-lit "renders to the panel"
h gpu-renders firmware-reachable "the zap shader and GMU firmware"
h audio-codec-attached remoteprocs-running "on DSP-routed audio the codec's bus is the DSP's"
h sound-card-registered audio-codec-attached "the card binds its codec"
h sound-card-registered pd-mapper-before-remoteproc "8 boots of 42 had no card without it (no-sound-card-boots)"
h speaker-amps-fed sound-card-registered "the amplifiers are the card's links"
h ucm-hifi-profile speaker-amps-fed "the profile drives the amplifiers"
h ucm-hifi-profile rootfs-boots "UCM and the sound server are userspace"
h speaker-heard ucm-hifi-profile "the tone plays through the profile"
h mic-captures sound-card-registered "capture is the card's"
h mic-hears-speaker speaker-heard "the tone it listens for"
h mic-hears-speaker mic-captures "it records"
h earpiece-plays ucm-hifi-profile "routed by the profile"
h headset-jack ucm-hifi-profile "routed by the profile"
s headset-jack mic-captures "the headset's microphone is a capture path"
h modem-file-services remoteprocs-running "the modem runs"
h modem-file-services rootfs-boots "rmtfs and tqftpserv are userspace"
h modem-seen modem-file-services "the modem stays offline without them (modem-online-tqftpserv)"
h sim-ready modem-seen "read through the modem"
h modem-registered sim-ready "no registration without a SIM"
h sms-both-ways modem-registered "needs the network"
h mobile-data modem-registered "needs the network"
h mms-both-ways mobile-data "MMS is fetched over data"
h mms-both-ways sms-both-ways "MMS is announced by SMS"
h call-audio-path modem-registered "a call needs the network"
h call-audio-path sound-card-registered "the voice path is the card's"
h call-audio-path mic-captures "the uplink is a capture (call-audio-on-surya)"
s call-audio-path earpiece-plays "the downlink's usual way out"
h voice-call-both-ways call-audio-path "sound both ways"
h emergency-numbers-known modem-seen "the list is the modem's and the SIM's"
h proximity-blanks-in-call voice-call-both-ways "in a call"
h proximity-blanks-in-call proximity-reads "the sensor it follows"
h proximity-blanks-in-call shell-runs-with-hardware "the shell blanks the screen"
h volte-call voice-call-both-ways "a call first"
h volte-call mobile-data "IMS rides a data bearer the AP serves (voltd-81)"
h wifi-joins firmware-reachable "the Wi-Fi core's firmware"
h wifi-joins remoteprocs-running "WCN3990: the Wi-Fi firmware runs on the modem's processor"
h bt-controller-up firmware-reachable "the controller's firmware"
h bt-pairs-carries-audio bt-controller-up "pairs through it"
s bt-pairs-carries-audio ucm-hifi-profile "the sound server carries the audio"
h nfc-reads-tag rootfs-boots "read in userspace"
s nfc-reads-tag firmware-reachable "some controllers load firmware"
h usb-host-works rootfs-boots "the device is read in userspace"
s usb-host-works lab-link-held-awake "switching the port cuts the lab's USB link: another way in first"
h hotspot-shares-data mobile-data "it shares the data"
h hotspot-shares-data wifi-joins "over the Wi-Fi core"
h sensor-hub-stable fastrpc-helpers-stable "the sensor helper is a FastRPC client"
h sensors-exposed sensor-hub-stable "the hub serves them (on Qualcomm's sensor DSP)"
h proximity-reads sensors-exposed "through the same service"
h auto-rotate-follows sensors-exposed "the accelerometer"
h auto-rotate-follows shell-runs-with-hardware "the shell rotates"
h brightness-follows-light sensors-exposed "the light sensor"
h brightness-follows-light panel-lit "the backlight"
s brightness-follows-light shell-runs-with-hardware "the shell's auto-brightness"
h gnss-fix modem-seen "on Qualcomm the location engine is the modem's (QMI LOC)"
h gnss-fix rootfs-boots "ModemManager, gnss-share and geoclue are userspace"
h fingerprint-unlocks rootfs-boots "fprintd is userspace"
s fingerprint-unlocks shell-runs-with-hardware "unlocking is the shell's"
h camera-bus-bound kernel-reaches-init "the receiver is the kernel's"
h image-sensor-identified camera-bus-bound "read over the control bus"
h raw-frame-captured image-sensor-identified "a sensor described and probed"
h camera-stream-viewable raw-frame-captured "the ISP takes raw frames"
s camera-stream-viewable gpu-renders "libcamera's software ISP runs on the GPU (libcamera-softisp-fosdem-2026)"
h photo-taken camera-stream-viewable "the app takes the stream"
h photo-taken shell-runs-with-hardware "an app on the shell"
h video-recorded photo-taken "the camera app"
h video-recorded mic-captures "its sound"
h focus-and-flash camera-stream-viewable "focus is judged on the stream"
h suspend-way-back watchdog-way-back "the watchdog, kept armed through sleep"
h s2idle-cycle-returns rootfs-boots "an RTC-timed suspend from userspace"
s s2idle-cycle-returns suspend-way-back "blind without it: a hang in sleep leaves no trace"
h suspend-wakes-quiet s2idle-cycle-returns "read across a suspend"
h radios-survive-suspend s2idle-cycle-returns "across suspends"
h radios-survive-suspend wifi-joins "Wi-Fi up first"
h radios-survive-suspend bt-controller-up "Bluetooth up first"
h sensors-across-suspend s2idle-cycle-returns "across suspends"
h sensors-across-suspend sensors-exposed "sensors up first"
h resume-without-stall s2idle-cycle-returns "across suspends"
h resume-without-stall sensors-across-suspend "an attached helper crashes the DSP at resume (sleep-fastrpc-helpers)"
h resume-without-stall suspend-way-back "a stall must come back to be counted"
h real-suspend-under-shell shell-runs-with-hardware "the shell's own suspend"
h real-suspend-under-shell resume-without-stall "it returns"
h real-suspend-under-shell radios-survive-suspend "the radios come back"
s real-suspend-under-shell shell-autosleep-tamed "in the lab the loop is gated first"
h soc-floor-reached s2idle-cycle-returns "read in suspend"
s soc-floor-reached suspend-wakes-quiet "wakes keep it off the floor"
h call-wakes-from-sleep real-suspend-under-shell "it sleeps as in daily use"
h call-wakes-from-sleep voice-call-both-ways "a call to ring"
h call-wakes-from-sleep sms-both-ways "a message to arrive"
h standby-current soc-floor-reached "no floor, no low current"
h standby-current real-suspend-under-shell "measured asleep as in daily use"
s standby-current battery-gauge-reads "a meter can stand in for the gauge"
h standby-current suspend-wakes-quiet "a phone woken by chatter does not stay low (floor-irq-quiet)"
h all-day-battery standby-current "most of a day is standby"
h all-day-battery call-wakes-from-sleep "a sleeping phone that misses calls is not a day's use"
h shell-runs-with-hardware panel-lit "it shows"
h shell-runs-with-hardware touch-input "it is touched"
h shell-runs-with-hardware rootfs-boots "a distribution's shell"
s shell-runs-with-hardware ucm-hifi-profile "its sound (plasma-silent)"
s shell-runs-with-hardware gpu-renders "Phosh and Plasma Mobile need the GPU; sxmo does not"
h on-screen-keyboard shell-runs-with-hardware "the shell's keyboard"
h lock-and-unlock shell-runs-with-hardware "the shell's lock"
h lock-and-unlock buttons-report "the power key"
h notifications-arrive shell-runs-with-hardware "the shell's notifications"
s notifications-arrive sms-both-ways "a message to announce"
s notifications-arrive speaker-heard "it sounds"
h update-applies rootfs-boots "the distribution updates"
s update-applies health-suite-runs "an update is proven by the same suite"
h update-rolls-back update-applies "a bad one to roll back from"
h update-rolls-back watchdog-way-back "a hung boot must come back"
s update-rolls-back slot-state-known "A/B slots are one way back"
h kernel-upgrade-keeps-steps health-suite-runs "the suite says what still passes"
h coprocessor-restart-recovers remoteprocs-running "a coprocessor to crash"
s coprocessor-restart-recovers mic-hears-speaker "sound to come back"
s coprocessor-restart-recovers modem-registered "the modem to come back"
s coprocessor-restart-recovers sensors-exposed "sensors to come back"
h days-without-reboot real-suspend-under-shell "daily use sleeps"
h days-without-reboot call-wakes-from-sleep "and is reachable"
h cycles-repeat-clean resume-without-stall "a cycle that returns"
h cycles-repeat-clean health-suite-runs "what is lost is read by the suite"

for n in health-suite-runs storage-readonly watchdog-way-back dmesg-clean charger-online; do
  h linux-runs "$n" "the close of the generic bring-up"
done
for n in linux-runs speaker-heard mic-hears-speaker earpiece-plays voice-call-both-ways sms-both-ways mobile-data \
  emergency-numbers-known proximity-blanks-in-call wifi-joins bt-controller-up on-screen-keyboard lock-and-unlock \
  notifications-arrive gnss-fix photo-taken call-wakes-from-sleep all-day-battery off-mode-charging update-applies; do
  h daily-usable-phone "$n" "a person needs it every day"
done
for n in daily-usable-phone volte-call mms-both-ways headset-jack bt-pairs-carries-audio nfc-reads-tag usb-host-works \
  hotspot-shares-data haptics-buzz gpu-renders auto-rotate-follows brightness-follows-light fingerprint-unlocks \
  video-recorded focus-and-flash thermal-zones-sane update-rolls-back kernel-upgrade-keeps-steps \
  coprocessor-restart-recovers days-without-reboot cycles-repeat-clean; do
  h complete-phone "$n" "everything the hardware does, lasting"
done

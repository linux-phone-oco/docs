#!/bin/sh
# The sources of research bringup-steps-phone-stages and bringup-steps-coverage-map, recorded through ikb
# source. Each row's takes is what we take from it, so prior art is found by tad q find and never read twice.
# Run in docs.
set -eu
so() { ikb source --project docs "$@" >/dev/null; }

so --id ubports-device-data --title "devices.ubuntu-touch.io data: portStatus, progressStages, supportStatus" \
  --url https://gitlab.com/ubports/infrastructure/devices.ubuntu-touch.io --by UBports \
  --takes "The only stage order kept as data: nine categories of feature ids (Actors, Camera, Cellular, Endurance, GPU, Misc, Network, Sensors, Sound, USB), each with a weight and the progress stage it gates (2 booting: uiBoot, touchscreen; 3 core connectivity: calls, sms, data, voiceCall; 4 essential: photo, wifi, speaker, mic; 5 fully optimised: bluetooth, gps, proximity, audioRoutings, offlineCharging, endurance tests; 6 never caps: VoLTE, NFC, fingerprint). A feature not + caps the device a stage lower. Status is the porter's tick; we take the gating as goal steps, not the weights."
so --id sailfish-hadk-checklist --title "Sailfish OS HADK: hardware adaptation checklist" \
  --url https://hadk.sailfishos.org/ha-checklist/ --by Jolla \
  --takes "Names as gates what feature tables miss: suspend and resume (iphb), act-dead mode (charging while off), thermal for dsme, the watchdog, proximity blanking in a call and while suspended, power and volume keys, LED."
so --id sailfish-csd --title "Sailfish OS CSD hardware test tool" \
  --url https://docs.sailfishos.org/Support/Help_Articles/Test_Tool_CSD --by Jolla \
  --takes "On-device factory, hardware and run-in tests per subsystem - the nearest to a proof per step - but with no reporting: results never leave the phone."
so --id pine64-ppp-software-state --title "PinePhone Pro software state" \
  --url https://pine64.org/documentation/PinePhone_Pro/Software/Software_state/ --by PINE64 \
  --takes "Keeps stability, suspend, updates and push notifications as rows beside the parts; status words edited by the community."
so --id megi-pinephone-status --title "PinePhone mainline status (megi)" --author "Ondrej Jirman" \
  --url https://xnux.eu/devices/pine64-pinephone.html \
  --takes "Driver-grained mainline status per block (UI in and out, wireless with voice apart from data, power and thermal, SoC blocks), one author's tree; a mainline column per row."
so --id mobian-devices --title "Mobian supported devices" --url https://wiki.debian.org/Mobian/Devices --by Mobian \
  --takes "Tiers by support and testing, device pages in prose with dated 'image tested' lines: a weak but real proof by date."
so --id nura-devices-table --title "Nura (postmarketOS) wiki: Devices" --url https://wiki.nura.eco/wiki/Devices \
  --takes "Cargo queries over the Infobox fields (main, multimedia, connectivity, modem, misc, sensors); no field for suspend, charging while off, call audio or updates; SoC status kept apart from device status (suspend and thermal only at SoC level)."
so --id weiss-fosdem-2025-missing-20 --title "Kernel support for Mobile Linux: the missing 20%" --author "Luca Weiss" --year 2025 \
  --url https://fosdem.org/2025/schedule/event/fosdem-2025-4836-kernel-support-for-mobile-linux-the-missing-20-/ \
  --takes "What is missing on mainline phones: cameras, fuel gauges and calls (hardest: they join many parts and suspend); bring-up proves function, not reliability - 'does audio still work after two hours asleep' - so reliability needs steps of its own."
so --id fosdem-2026-foss-on-mobile --title "FOSDEM 2026: FOSS on Mobile devroom" --year 2026 \
  --url https://archive.fosdem.org/2026/schedule/track/foss-on-mobile/ \
  --takes "postmarketOS reliability in 2026, photos and video on phones, the Fairphone mainline update: reliability and cameras are the open fronts."
so --id lwn-weiss-2026 --title "LWN: mainline Linux on phones (Weiss, OSS Japan 2025)" --year 2026 \
  --url https://lwn.net/Articles/1055391/ \
  --takes "Modem and coprocessor firmware, camera quality and app services (Play Services, banking) as what stands between a mainline phone and daily use."
so --id android-cdd --title "Android 17 Compatibility Definition Document" --by Google --year 2026 \
  --url https://source.android.com/docs/compatibility/17/android-17-cdd \
  --takes "What a phone must do, as areas (7.1 display ... 7.4 connectivity, 7.5 cameras, 7.8 audio, 8 power, 9 security) and one MUST per id (section/device type/condition/number, H for handheld): about 150 H- ids in 7-9. A cross-check list for our stages, not a template: many rules are Android's own."
so --id android-cts --title "Android Compatibility Test Suite" --by Google \
  --url https://source.android.com/docs/compatibility/cts \
  --takes "Smallest unit: module, case, method, run per device and build, pass/fail/not executed; ignored and assumption failure count as pass - we keep not-needed and not known yet apart."
so --id android-vts --title "Android Vendor Test Suite" --by Google --url https://source.android.com/docs/core/tests/vts \
  --takes "Tests each HAL per instance (each SIM slot): a step may need a per-instance proof (each camera, each SIM)."
so --id aosp-compat-matrix --title "AOSP framework compatibility matrix 202604" --by Google \
  --url https://android.googlesource.com/platform/hardware/interfaces/+/refs/heads/main/compatibility_matrices/compatibility_matrix.202604.xml \
  --takes "The HAL list: radio (config, modem, sim, network, data, messaging, voice, ims), audio, camera provider, sensors, gnss, health, power and power.stats, thermal, vibrator, light, usb, wifi, bluetooth, nfc, biometrics, keymint, boot control - the areas a phone platform must answer; each maps to a Linux counterpart."
so --id android-emergency-call --title "Android emergency calls" --by Google \
  --url https://source.android.com/docs/core/connect/emergency-call \
  --takes "112 and 911 always dial; the emergency list comes from the network, the SIM, the modem or defaults - a step provable without dialling."
so --id halium-scope --title "Halium: scope" --by Halium --url https://docs.halium.org/en/latest/project/Scope.html \
  --takes "Which Android HALs Ubuntu Touch and Sailfish reuse through libhybris (radio, audio, camera, media, sensors, GNSS, Wi-Fi, vibrator, fingerprint): the list a native mainline phone must replace, the hardest first."
so --id inkernel-pd-mapper --title "In-kernel protection-domain mapper, v9" --author "Dmitry Baryshkov" --year 2024 \
  --url https://lkml.iu.edu/2406.2/09265.html \
  --takes "pd-mapper moves into the kernel; the order against qcom_q6v5_pas still decides whether the ADSP audio PD comes up."
so --id msm-firmware-loader-emmc --title "msm-firmware-loader: eMMC assumption" --by postmarketOS \
  --url https://gitlab.com/postmarketOS/msm-firmware-loader/-/issues/3 \
  --takes "Firmware from the stock partitions, mounted read-only at boot; it assumes eMMC, so UFS phones need another way."
so --id pmos-firmware-docs --title "postmarketOS: firmware packaging" --by postmarketOS \
  --url https://docs.postmarketos.org/pmaports/main/firmware.html \
  --takes "How signed per-device blobs are packaged and where they go: the step 'firmware reachable' has two roads, a package or the stock partitions."
so --id mm-qcom-soc-plugin --title "ModemManager qcom-soc plugin" --author "Aleksander Morgado" \
  --url https://gitlab.freedesktop.org/mobile-broadband/ModemManager/-/merge_requests/374 \
  --takes "ModemManager claims a QRTR plus IPA (or BAM-DMUX) modem on Qualcomm SoCs: the step 'modem seen' rests on it."
so --id voltd-81 --title "81voltd README" --author "Richard Acayan" \
  --url https://sources.debian.org/src/81voltd/1.1.0-1/README.md \
  --takes "Serves the IMS data service the modem asks the AP for; VoLTE works on some sdm845 phones and some carriers only."
so --id openimsd-nlnet --title "NLnet: VoLTE on Qualcomm (OpenIMSd)" --url https://nlnet.nl/project/VoLTE-Qualcom/ \
  --takes "Funded reverse engineering of the IMS QMI services; an open IMS across carriers is still the world's gap."
so --id nura-volte-frida --title "VoLTE project: QMI sniffing with Frida" --year 2025 \
  --url https://nura.eco/blog/2025/06/17/volte-project-qmi-sniffing-with-frida/ \
  --takes "How the IMS QMI messages are traced on the stock system, as observed behaviour."
so --id ixit-sdm845-upstreaming-0 --title "sdm845 upstreaming, month 0" --author "David Heidelberg" --year 2025 \
  --url https://ixit.cz/blog/2025-12-21-upstreaming-0 \
  --takes "OnePlus 6 'mostly working, calls pending'; q6voice lives out of tree in diverging copies, and the qdsp6 set is judged to need a 2-3 month rewrite nobody has funded."
so --id pmi8998-fg-rfc --title "PMI8998 Gen3 fuel gauge RFC" --year 2025 --url https://lkml.iu.edu/2511.3/01492.html \
  --takes "Fuel gauges on these PMICs are still RFCs: 'battery gauge reads' is open across the family."
so --id camss-stats-uapi-rfc --title "qcom-camss stats and params uAPI RFC" --author "Bryan O'Donoghue" --year 2026 \
  --url https://lkml.iu.edu/2604.3/02474.html \
  --takes "The first step toward using the hardware ISP; until then cameras are raw capture plus libcamera's software ISP."
so --id libcamera-softisp-fosdem-2026 --title "libcamera SoftISP status update" --year 2026 \
  --url https://fosdem.org/2026/schedule/event/libcamera-softisp \
  --takes "A software ISP (on the GPU since 0.7) gives a viewable stream on phones: the camera stage's road on mainline today."
so --id iio-sensor-proxy-libssc --title "iio-sensor-proxy: libssc support" \
  --url https://gitlab.freedesktop.org/hadess/iio-sensor-proxy/-/merge_requests/381 \
  --takes "Sensors behind Qualcomm's sensor DSP reach the desktop through libssc in iio-sensor-proxy."
so --id gnss-share --title gnss-share --by postmarketOS --url https://gitlab.postmarketos.org/postmarketOS/gnss-share \
  --takes "Feeds the modem's location engine (through ModemManager) to geoclue; no assisted GPS (XTRA) anywhere yet."
so --id pmaports-charging-sdl-1064 --title "pmaports issue 1064: charging-sdl" --by postmarketOS \
  --url https://gitlab.postmarketos.org/postmarketOS/pmaports/-/issues/1064 \
  --takes "Charging while off rests on an unmaintained tool that boot-loops at low battery: a gap, not a solved step."
so --id linmob-weekly-34-2026 --title "Weekly Linux phone update 34/2026" --author linmob --year 2026 \
  --url https://linmob.net/weekly-update-34-2026/ \
  --takes "Fairphone 6: cameras, audio and an emergency VoLTE call on mainline in 2026 - one report, the furthest any Qualcomm phone got."
so --id systemd-target --title "systemd.target" --by systemd \
  --url https://www.freedesktop.org/software/systemd/man/latest/systemd.target.html \
  --takes "A unit that does nothing but group others by its dependencies, and targets want targets: the shape of a goal step - a group of groups with no new table."
so --id lmdpdg --title "linux-mdss-dsi-panel-driver-generator" --by msm8916-mainline \
  --url https://github.com/msm8916-mainline/linux-mdss-dsi-panel-driver-generator \
  --takes "Generates a mainline DSI panel driver from the downstream device tree: the usual road to 'panel lit' on Qualcomm phones."

# What Android does on the Pixel 2 (walleye), measured read-only (2026-11-17)

Taken by the walleye keeper with plain `adb` reads on the phone as the author had left it (home screen, USB
debugging accepted, plugged into the lab machine, battery full). Nothing was installed, no setting changed, no
root, no flashing; the phone was returned to fastboot with `adb reboot bootloader` and its slot flags checked
afterwards (a and b: successful yes, unbootable no, retry-count 0; slot a current; unlocked yes: unchanged).
No serial number, IMEI, network name or account name is kept here. Files: `props-selected.txt` (chosen build
properties), `sensors-list.txt`, `boot-progress.txt` (the phone's own boot event log), `batterystats-summary.txt`.

## What is on the phone (measured)
| what | value |
|---|---|
| system | LineageOS 15 (Android 15, SDK 35), build lineage_walleye-userdebug BP1A.250505.005, built 2025-12-05, security patch 2025-11-01 |
| vendor image | stock Pixel 2, Android 11 fingerprint RP1A.201005.004.A1, release-keys |
| kernel | 4.4.302 (built 2025-12-05), aarch64, 8 cores (4 x CPU part 0x800, 4 x 0x801), Qualcomm MSM8998 |
| verified boot | orange (unlocked), file-based encryption on, ro.debuggable 1 (userdebug), `adb shell` is not root |
| memory | 3.7 GB RAM |
| storage | /data 51 GB on sda45 (31 GB used), system 2.4 GB (ext4 root), vendor 461 MB |
| display | 1080x1920, physical density 420 (set to 460) |
| cameras | 2 devices (rear, front) |
| CPU frequencies | cpu0 cluster 300 MHz to 1.90 GHz; cpu4 cluster 300 MHz to at least 2.21 GHz (the capture was cut there, the top is not known yet) |
| boot count | batterystats says 8 system starts |

## Sensors (measured, `dumpsys sensorservice`)
sensorservice lists 37 sensors, 29 of them hardware-level. The parts: LSM6DSM (accelerometer, gyroscope, step
detector and counter, thermometer; ST), AK09915 magnetometer (AKM), TMx490x proximity and light (AMS TAOS),
BMP280 pressure (Bosch), AK8789 hall effect (AKM), Elmyra squeeze sensor, two camera-sync sensors; the rest are
fused or gesture sensors (gravity, rotation vector, tilt, pickup, double twist, double tap, binned brightness).
The accelerometer runs 1 to 400 Hz with a 40960-event FIFO. Full list in `sensors-list.txt`.

## Battery (measured)
| what | value |
|---|---|
| capacity learned | 2709 mAh full (design 2805 mAh: 96.6 %), 922 charge cycles |
| state at the time | 100 %, 4385 mV, 30 C, charging on USB (USB powered, taper), gauge current 190 mA |
| charger | USB-C, source attached high current, up to 3 A allowed |

## Boot time (measured by the phone's event log, one boot after `adb reboot`)
From the start of the kernel: Zygote start 5.8 s, system server running 8.3 s, package manager ready 10.1 s,
activity manager ready (`boot_progress_ams_ready`) 12.0 s, screen enabled 13.3 s, boot animation stopped 17.8 s,
`sys.boot_completed` 1 by then. This leaves out the bootloader before the kernel starts (power on to the first
kernel line is not measured). Phone clock times in `boot-progress.txt` are the phone's own. The boot reason read
back "reboot,shell".

## Audio (partly measured, configuration only)
audio_flinger shows output threads at 48000 Hz, 16-bit and 24-bit packed, stereo (front left and right), to the
speaker device, all in standby. Music stream volume index 16 of 0 to 25 on the speaker. No tone was played:
the phone has no tone player (no tinyplay, tinymix) and nothing may be installed.

## Not known yet - and why
- **Sleep (suspend) current.** The phone was charging on USB, so the gauge's current is the charger's, not what the
  phone draws; there is no meter in the lab. batterystats holds long-run counters (7088 mAh discharge, 5788 mAh
  screen off, 5479 mAh deep doze over a stated 12 days) but its own start time (2026-11-17 12:14) contradicts the 12
  days, and its totals exceed the battery's size: these counters are not a measurement of the standby current, so no
  figure is given. Wi-Fi was on and connected (airplane mode on, Wi-Fi allowed over it) during all reads, so any later
  figure must say what the radios were doing.
- **Audio levels** (loudness, distortion, microphone noise): needs a tone source on the phone and a calibrated
  microphone in the lab; neither exists yet.
- **Boot time from power on**, **wake latency**, **camera, modem and GPS behaviour**, **thermal limits**
  (/sys/class/thermal is not readable without root): not read.
- **Real partition table** (/dev/block names are not readable by `adb shell`): only the mount sizes above.

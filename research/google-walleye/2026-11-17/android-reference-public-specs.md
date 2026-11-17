# What Android on the Pixel 2 gives as a reference, from public sources only (2026-11-17)

Nothing here was measured on our phone; every number is a published one, with its source id (sources table).
Measured values for walleye itself wait for backlog `google-walleye-lab/android-reference-walleye`.
Chip names marked XL come from a teardown of the Pixel 2 **XL** (taimen); walleye shares the SoC family and
most of the board design, but no source confirms the same chips on walleye. The vendor kernel's device tree
(see `vendor-kernel-hardware-inventory.md`) confirms several of them for walleye: TAS2557, DRV2624, PN81A.

## The reference to measure against
| area | what Android on this phone gives | source |
|---|---|---|
| display | 5.0 in AMOLED 1080x1920, 441 ppi; measured 6.6 to 426 cd/m2, PWM about 245 Hz; always-on display | wikipedia-pixel-2, notebookcheck-pixel-2 |
| touch | 10 points | notebookcheck-pixel-2 |
| battery | 2700 mAh Li-Ion, not removable (kernel: 4.4 V max cell); about 10 Wh by our reckoning (inference) | lineageos-wiki-data-walleye, kernel |
| charging | USB-C, no wireless, about 106 min full with the box charger | notebookcheck-pixel-2 |
| audio out | two front stereo speakers (about 89 dB(A) max), no 3.5 mm jack (USB-C adapter), Bluetooth 5.0 with aptX and aptX HD | notebookcheck-pixel-2, lineageos-wiki-data-walleye |
| sensor set to count | accelerometer, gyro, magnetometer, barometer, proximity, ambient light, Hall, Active Edge squeeze, rear fingerprint, step detector/counter, sensor hub | wikipedia-pixel-2 (via CNX), notebookcheck-pixel-2 |
| chips (XL teardown) | IMU STMicro LSM6DSM; magnetometer AKM AK09915C; barometer Bosch BMP280; Hall AKM AK8789; light ams TMD4903 (likely); ranger ST VL53L0X; amp TI TAS2557; haptics TI DRV2624; PMICs PM8998 + PMI8998; charger SMB1381; NFC NXP PN81A (likely); Wi-Fi/BT Murata module (possible); eSIM ST33G1M2; Pixel Visual Core SR3HX | ifixit-pixel-2-xl-teardown |
| cameras | rear 12.2 MP Sony IMX362 f/1.8 with phase and laser autofocus and OIS; front 8 MP Sony IMX179 f/2.4 | wikipedia-pixel-2 |
| radio | LTE Cat. 15, Wi-Fi 802.11ac 2.4/5 GHz (sources disagree on 2x2 MIMO), GPS+GLONASS+BeiDou+Galileo, NFC, eSIM plus nano-SIM | notebookcheck-pixel-2, wikipedia-pixel-2 |
| runtime on Android | idle Wi-Fi off, minimum brightness 24 h 17 min; web 9 h 35 min; video 9 h 24 min; worst case 2 h 41 min; field: 4 to 5+ h screen-on, 15 to 17 h unplugged a day | notebookcheck-pixel-2, droidlife-pixel-2-battery |
| idle behaviour | Doze: when unplugged, still and screen-off, network is suspended, wake locks ignored, alarms and jobs deferred, maintenance windows spread further apart; allow-while-idle alarms at most once per nine minutes per app | android-doze-standby |
| software life | launched Android 8.0, last Android 11, last build RP1A.201005.004.A1 (December 2020), support ended October 2020; LineageOS keeps 16.0 to 22.2 | pixel-2-final-update, lineageos-wiki-data-walleye |

## What no public source gave (not known yet)
Standby drain per hour for the small Pixel 2 (reviews give runtimes, not standby current); speaker levels
under a fixed test signal; sensor rates and the real sensor list of walleye (`dumpsys sensorservice` of
walleye was not found published); charger wattage and USB-PD profile; UFS generation; the official Google
spec page (consent wall) and GSMArena (pay wall) were not readable.

## How to use it
A "as good as Android" check for walleye needs the three numbers only the phone can give, measured with
Android booted (if it still boots): suspend current with screen off, the sensor list with rates, speaker
level at a fixed tone. Until then the published runtimes above are context, not targets.

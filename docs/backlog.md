<!-- Generated from data/ by .tad/tools/render.py. Do not edit by hand. -->

# Backlog

<a id="first-real-boot"></a>
### Boot the current sm7150-mainline kernel on the phone via lab-agent and record dmesg + audio card list

Status
: open

Note
: The first real job: proves the whole lab-agent loop end to end on real hardware, and gives a verified baseline instead of secondhand notes.

Opened
: 2026-11-04


<a id="kernel-fork-repo"></a>
### Fork sm7150-mainline/linux into linux-phone-oco and wire it into lab-agent's build/boot jobs

Status
: open

Opened
: 2026-11-04


<a id="custom-matrix-render"></a>
### A custom render.py that draws support_status as a real device x component matrix, not one page-section per row

Status
: open

Note
: The generic engine renders it as plain rows for now (it has no reason to detect this shape specially); a matrix is much easier to scan at a glance once there is more than one device.

Opened
: 2026-11-04


<a id="verify-headphone-mic-earpiece"></a>
### Verify headphone, mic and earpiece status directly on hardware instead of relying on the secondhand pmaports note

Status
: open

Note
: The source only confirms mic/earpiece are broken as a group; headphone output specifically was never separately confirmed one way or the other.

Opened
: 2026-11-04


<a id="off-state-charging"></a>
### The phone cannot stay off: shutdown and a charger both boot pmOS

Status
: open

Note
: Seen 2026-11-09. poweroff in pmOS boots pmOS again. The same shutdown from the EOS recovery on the phone stays off, until a charger is plugged in; then pmOS boots instead of Android-style off-mode charging (battery on screen, system off). So the hardware can stay off; pmOS or the boot chain does not. Not diagnosed. After the audio work.

Opened
: 2026-11-09


<a id="adsp-sensor-crash-loop"></a>
### The ADSP crashes every 13-25 s, restarting audio each time

Status
: in-progress

Note
: Measured on the stock 7.1-rc3 kernel: 42 crashes in an hour, always sensor_process SNS_REG_INIT (sns_registry_sensor.c), then fatal error, crash detected in adsp, recovering adsp. Likely cause of speaker sound for a few seconds, then nothing. hexagonrpcd serves the sensor registry and refuses every write (apps_std.c); the ADSP asks to write registry/../sns_reg_version and temp.json. Its virtual tree maps only persist/sensors/registry/registry, so the version marker one level up is never found. The phone own persist partition has sensors/registry/sns_reg_version (version=2); the packaged surya dir lacks it. Experiments so far (on the phone, reversible): -R drop-in moved the failure; adding the marker did not help; copying the real registry was invalid (cp -a kept uid 1000 and 0600 modes, so the daemon could no longer read anything). Next: restore permissions and retest; then map sns_reg_version in hexagonrpcd (an upstreamable change) or make the registry writable.

Opened
: 2026-11-09


<a id="wcd937x-dt-aoncc"></a>
### WCD937x device tree: drop aoncc, clock the VA macro from q6afecc

Status
: in-progress

Note
: The boot hang (RCU stalls) with the WCD937x patch is the aoncc clock controller at 0x03380000, an SM8250 address with nothing near it in the SM7150 tree: with only aoncc disabled the phone boots (2026-11-09). Without aoncc the VA macro has no mclk, so the macros, SoundWire and the sound card stay deferred. Fix as SM8250 does: no aoncc, VA macro mclk from q6afecc. Audit tools and results in linux-phone-oco/surya-lab and on linux-phone-oco/linux#1.

Opened
: 2026-11-09

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
: Cause found 2026-11-09 by tracing every request the ADSP makes (a verbose hexagonrpcd build on the phone): the sensors service (hexagonrpcd -s) attaches the ADSP sensor process, whose registry init re-reads the sensor configs and needs to write (temp.json); hexagonrpcd refuses all writes, the firmware asserts (SNS_REG_INIT) and the whole ADSP restarts, taking audio with it. No registry state fixes it (packaged, or the phone own from persist, readable, with the version marker - which hexagonrpcd also never serves: a real gap, patch drafted). Fix in place on the phone: hexagonrpcd-adsp-sensorspd masked. Result: 0 ADSP crashes across three boots and many minutes, the POCO X3 sound card up at about 12 s, playback without crashes. Trade-off: no ADSP sensors, which did not work anyway. Next: propose upstream (do not start sensorspd on surya until registry writes are supported; serve sns_reg_version in hexagonrpcd); see sensors-registry-writes.

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


<a id="sensors-registry-writes"></a>
### ADSP sensors: let hexagonrpcd serve a writable sensor registry

Status
: open

Note
: The sensors firmware on SM7150 (surya) rebuilds its registry from the configs at start and writes temp.json beside it; hexagonrpcd refuses every write by design, and does not serve registry/../sns_reg_version either. Sensors need both: the version marker served (patch drafted against hexagonrpc v0.5.0-20) and writes to a per-device writable copy of the registry (as Android persist is writable). An upstream change to linux-msm/hexagonrpc; until then the sensors service stays off on surya.

Opened
: 2026-11-09


<a id="audio-cold-boot-race"></a>
### One cold boot came up without audio services

Status
: open

Note
: With the sensors service off, one boot (2026-11-09) never announced the ADSP audio services, so no sound card until the ADSP was restarted by hand. Not reproduced in two further valid cold boots (audio services about 0.1-0.2 s after the ADSP, card present). Watch for it; if it recurs, check whether the in-kernel pd-mapper was loaded before the ADSP booted.

Opened
: 2026-11-09


<a id="upstream-tas2562-slot-length"></a>
### Upstream: tas2562 sets the I2S slot length from the sample width

Status
: open

Note
: Kernel patch on linux-phone-oco/linux branch fix/tas2562-i2s-slot-length (one commit, compiles for arm64, verified on surya as a module built from the exact v7.1_rc3 source). Send to sm7150-mainline and to ALSA upstream (alsa-devel, the TAS2562 maintainers), signed off by the user.

Opened
: 2026-11-09


<a id="upstream-ucm-surya-stereo"></a>
### Upstream: stereo speaker UCM profile for surya

Status
: open

Note
: surya-lab ucm/Xiaomi/surya/HiFi.conf: two channels, top amplifier (0x4d) left, bottom (0x4c) right. For alsa-ucm-conf (Xiaomi/surya), once the kernel fix is accepted or at least posted.

Opened
: 2026-11-09


<a id="try-shells"></a>
### Try every mobile shell with working sound

Status
: in-progress

Note
: Switched in place with surya-lab ui/switch.sh (postmarketOS UI packages, tinydm for all; no reflash, the sound fixes stay). Phosh: runs, stereo verified by ear 2026-11-09. Next: Plasma Mobile, GNOME Mobile; Sxmo was the starting shell.

Opened
: 2026-11-09


<a id="microphone"></a>
### Microphone: check, and make it work

Status
: in-progress

Note
: The microphones go through the WCD9375 codec, which the stock device tree does not wire up (the sound card has only the speaker). Needs the device-tree work on linux-phone-oco/linux PR #1 (aoncc dropped, VA macro clocked from q6afecc; built and audited, not yet booted). Test idea: play a tone on the speaker and record it, so the check needs no ears. Boot test needs the user nearby (a hang needs the power button). Prior art found by the kernel-activity feed (2026-11-10): upstream sm7150-mainline committed "WIP WCD stuff" to the surya device tree (7b00a934ace1, 2026-03-28, Aelin Reidel) and reverted it (6ec3051564fd, 2026-05-17). Read both, and why it was reverted, before booting our WCD9375 device tree. Built 2026-11-10 on the lab machine: a whole test kernel, 7.1.0-rc3-sm7150-wcd (the phone's exact v7.1_rc3 source + upstream's WIP WCD patch + our tas2562 fix; the pin-controller drivers it changes are built in, so modules alone cannot carry it): Image.gz, the Huaxing dtb and 828 modules under ~/Projects/surya-audio/kernel-rc3/{src-wcd,out-wcd}. Test plan, safe: a second systemd-boot entry (pmos-wcd.conf: its own kernel, initramfs and dtb), stock stays the default; a loader.conf with a 10 s menu (Nura ships none, so there is no menu); pick the entry with the volume keys, or try a one-shot boot; a hang falls back to stock on reboot. To check on the phone: whether the menu takes the volume keys, and an initramfs for the -wcd version (mkinitfs builds for the installed kernel). Needs the user nearby.

Opened
: 2026-11-09


<a id="org-board"></a>
### A board for linux-phone-oco

Status
: open

Note
: The user's idea: a shared board for the org, like lab-agent's. Later.

Opened
: 2026-11-09


<a id="phosh-usb"></a>
### Under Phosh the PC loses the phone over USB

Status
: open

Note
: After switching to Phosh (2026-11-09) the PC showed no USB device for the phone, so no SSH over USB; the user saw the same before, in an earlier Phosh try. Unclear yet: Phosh changing the USB gadget, or the cable (EarPods were being plugged in that evening). To check: lsusb on the PC and the gadget state on the phone (via wifi or the console) while in Phosh.

Opened
: 2026-11-09


<a id="plasma-silent"></a>
### Plasma Mobile: speakers silent, the chain playing

Status
: in-progress

Note
: Plasma Mobile (fresh Nura image, sound fixes applied on the phone): speakers were silent with the whole chain playing. Two causes, both confirmed: (1) the image restores a saved mixer state with both amplifiers' digital volume at 0 = -110 dB; (2) a tas2562 driver bug: setting the Digital Volume Control changes only the driver's cache, the chips (page 2, 0x0c-0x0f) stay at -110 dB. Writing 0x40000000 straight into both chips with i2cset made sound work: the user heard YouTube in Firefox, 2026-11-10. Not persistent: after a power-off the restore and the driver bug bring the silence back. Needed: the driver fix (upstream-tas2562-volume), and until then a boot-time step that writes the volume into the chips.

Opened
: 2026-11-10


<a id="upstream-tas2562-volume"></a>
### Upstream: tas2562 digital volume writes do not reach the chips

Status
: open

Note
: See plasma-silent. Reproduce: set the Digital Volume Control, read page 2 registers 0x0c-0x0f live with i2cget. Then a driver fix (write through, or restore on power-up) and a report.

Opened
: 2026-11-10

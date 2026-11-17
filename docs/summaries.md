<!-- Generated from data/ by tad. Do not edit by hand. -->

# Summaries

### Row 1

About
: audio-mic

Date
: 2026-11-17

Says
: Both built-in microphones of surya work on mainline (2026-11-17): the bottom one (AMIC1) on the WCD9375's ADC1, the top one (AMIC3) on ADC2 at INP3 with its own master port 3, over the TX SoundWire bus (capture DAI 1), the TX macro's decimators and the DSP's TX_CODEC_DMA_TX_3; the sound server records them through UCM's Mic and TopMic. The phone proves it every boot: mic-hears-speaker and mic-top-hears-speaker find a soft 1 kHz beep 40-60 dB above the noise. Kernel: linux-phone-oco/linux test/surya-mic, four WCD9375 fixes (PRs 3-6). Decision 2026-11-17-microphones-analog-wcd-path, resting on microphones-are-analog. Dead ends, not to retry: DMICs and the VA macro's path - surya has no digital mics (the DMIC routes were Qualcomm's QRD board) and this ADSP refuses the VA port (bolero-v1-capture-family); start-up ringing then exact zeros means no input reaches the decimator - look at the SoundWire stream, not the DMA (mic-zeros-meant-no-input); the codec's sleep pin state pulled it off the bus (microphone-codec-drops-off). Test kernels are built from pushed branches (2026-11-17-test-kernels-from-branches). Open: upstream through sm7150-mainline PR 60 (mic-upstream); the headset mic not yet tried (verify-headphone-mic-earpiece). Pixel 2 and 2 XL: not known yet.

Condenses
: 2026-11-11-microphone-nearly, 2026-11-11-placed-word, 2026-11-11-recording-tries, 2026-11-11-the-codec-comes-up, 2026-11-11-the-microphone-frontier, 2026-11-11-the-recording-map, 2026-11-11-two-recording-tries, 2026-11-17-microphones-analog-wcd-path, 2026-11-17-research-microphones, 2026-11-17-test-kernels-from-branches, bolero-v1-capture-family, mic-zeros-meant-no-input, microphone-codec-drops-off, microphones-are-analog


### Row 2

About
: deep-sleep

Date
: 2026-11-17

Says
: Surya does not reach deep sleep yet, and a timed s2idle cycle can lose the phone. Measured twice on kernel 7.1.0-sm7150-calls+: (1) a cycle by hand ended after 2.4 s, woken by IRQ 157; (2) IRQ 157 is the Bluetooth UART (serial@88c000, hci0), and with Bluetooth rfkill-blocked a timed cycle (rtcwake -m freeze -s 60) hung the phone hard at suspend entry: no return on USB, it sat in the initramfs gadget until force-rebooted; suspend_stats 0/0, no log survived. Sleep counters (cxsd, aosd) still 0; the audio DSP has never slept. Not known: whether the hang is the unset RTC (reads 1970) not waking s2idle, or a crash entering s2idle. Next try needs a way back that does not depend on USB networking (hardware watchdog or timed reboot, RTC set first, a log that survives: sync, pstore/ramoops, serial console), and one change at a time; Bluetooth block alone is not yet shown to cure the IRQ 157 wake. The author removed surya's SIM on 2026-11-17, for now (device note and backlog item sim-removed-skips, docs PR 200); nothing before deep sleep needs it. Research: 2026-11-17-surya-s2idle-bt-blocked-hang, 2026-11-17-surya-first-s2idle-cycle. Note: devlab health fails on a missing tests/automatic/checks.sh in surya-lab; devlab suite run works.

Condenses
: 2026-11-10-suspend-crash-found, 2026-11-10-usb-flapping, 2026-11-17-1225-how-the-phone-stands, 2026-11-17-a-coordinator-per-lane, 2026-11-17-deep-sleep-measured-s2idle, 2026-11-17-deep-sleep-researched, 2026-11-17-surya-first-s2idle-cycle, 2026-11-17-surya-s2idle-bt-blocked-hang, 2026-11-17-surya-s2idle-wakes-at-once, qcom-sleep-blockers, qcom-sleep-path, qcom-wake-for-calls, sleep-other-ways, sm7150-cluster-params, surya-sleep-measured

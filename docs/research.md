<!-- Generated from data/ by tad. Do not edit by hand. -->

# Research

<a id="qcom-sleep-blockers"></a>
### qcom-sleep-blockers

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: What keeps a Qualcomm SoC out of its lowest state on mainline?

Found
: Any processor or bus vote left up: on a QCS8550 handheld, aosd, cxsd and ddr stayed at 0 until the USB controller's interconnect vote and the PCIe and LPASS (audio) votes were released, then it reached the floor at about 23 mA (2026-10). A DSP that never sleeps holds CX up; on surya the audio DSP has not slept once. FastRPC helpers attached across suspend crash the audio DSP: postmarketOS stops hexagonrpcd's helper before suspend on the Pixel 3a, as we saw on surya (24 of 24 attempts with rootpd attached). Wi-Fi (ath10k) floods the modem's IPC interrupt and blocks or breaks suspend on SDM845; surya is reported to wake at random while asleep, cause unknown.

Sources
: portareos-sleep-votes, pmaports-sargo-hexagonrpcd, pmaports-4783, pmaports-4823


<a id="qcom-sleep-path"></a>
### qcom-sleep-path

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: How does a Qualcomm phone reach its lowest power state on mainline?

Found
: Through s2idle and CPU idle, not suspend to RAM: the firmware offers no PSCI system suspend, so with userspace frozen the CPUs enter their idle states, the last one down takes the cluster power domain to its deepest state (PSCI OS-initiated mode, hierarchical CPU idle), and as the cluster powers off the application processor's RPMh sleep votes are flushed to the always-on subsystem (rpmh-rsc attached to the cluster domain). The always-on subsystem then lowers CX and DDR when no processor votes for them: CX collapse (cxsd), then AOSS sleep (aosd), the floor. The SoC counts each in its own memory (rpmh-stats, read through qcom_stats), so reaching the floor is measured, not inferred. Without OS-initiated mode the cluster domain would stay always on and the votes would never flush; surya's firmware has it.

Sources
: psci-osi-hierarchy, rpmh-rsc-cluster-pd, qcom-stats-binding, qcom-soc-sleep-states, nura-sdm845-wiki


<a id="qcom-wake-for-calls"></a>
### qcom-wake-for-calls

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: How does a Qualcomm phone on mainline wake for a call or a message?

Found
: The modem's messages (QMI over QRTR on glink) are handled even in s2idle (IRQF_NO_SUSPEND), but userspace is frozen, so nothing rings. The kernel cannot tell a call from a signal-strength update: there is one switch, the IPCRTR glink device's wakeup (/sys/bus/rpmsg/devices/4080000.remoteproc:glink-edge.IPCRTR.-1.-1/power/wakeup), which wakes for every modem message. postmarketOS (now Nura) pairs it on the OnePlus 6 with ModemManager's quick suspend/resume, which quiets the modem's notifications before suspend and resyncs after; that fixed calls signalled late or lost. It is still not dependable: on OnePlus 6/6T and the Pixel 3a waking for calls is reported not working (with the switch on the phone wakes at once; open since 2026-10), and with it on every modem event wakes the phone. surya's modem sits at the same address (remoteproc 4080000), so the same path applies; a SIM card is needed to prove it.

Sources
: nura-sdm845-wiki, nura-enchilada-wiki, pmaports-4194, pmaports-4989, pmaports-4783


<a id="sleep-other-ways"></a>
### sleep-other-ways

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: How else have phones got deep sleep that still rings?

Found
: Android's own kernel: Ubuntu Touch runs officially on surya through Halium with the vendor's 4.14 kernel and Android's opportunistic suspend (wakeup sources and autosleep, which mainline also has), claiming a day and more - deep sleep that works, at the price of the vendor's kernel and blobs and nothing upstream. A separate power-management core: Crust on the PinePhone sleeps the whole Allwinner SoC (about 80% less power) and the separate modem wakes it through its RI line; Qualcomm's always-on subsystem runs signed firmware, so nothing like Crust can be written for it, and its modem is inside the SoC. Push through sleep: only partly solved anywhere (PinePhone: WoWLAN pattern matching plus an RTC wake as a safety net). The postmarketOS SM7150 page lists suspend as working with no measurement behind it; we found no published standby current for mainline Qualcomm phones.

Sources
: ut-surya, lwn-autosleep, crust-pinephone, uninsane-push, nura-sm7150-wiki


<a id="sm7150-cluster-params"></a>
### sm7150-cluster-params

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: Does sm7150's device tree ask the firmware for the cluster states surya's firmware knows?

Found
: Apparently not, for the two deepest. sm7150.dtsi (sm7150-mainline, the same in our tree) carries three cluster states whose latencies are surya's own but whose PSCI parameters are SC7180's: 0x41000044 (cluster power collapse), 0x41001244 and 0x4100b244. surya's own Android device tree (lpm-levels, cluster mode shifted by 4) has l3-pc 0x4, cx-off 0x224 and llcc-off 0xc24 - that is 0x41000044, 0x41002244 and 0x4100c244; 0x4100c244 is also what SM8150, the closest sibling, uses for its one cluster sleep. On the phone the deepest state (0x4100b244) was never entered once at runtime. Whether the firmware rejects, demotes or honours SC7180's values is not known: it is the first thing a measured suspend settles. SM7150 is not yet in mainline: the 2025 upstreaming series is to be resent, so a correction can go into it.

Sources
: sm7150-dtsi-v72, surya-downstream-fdt, sm8150-cluster-idle, sm7150-upstream-series


<a id="surya-sleep-measured"></a>
### surya-sleep-measured

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: Where does surya's deep sleep stand, measured on the phone itself?

Found
: Measured 2026-11-17 on the test kernel 7.1.0-rc3-sm7150-wcd, read only. The kernel offers only s2idle, as on every Qualcomm phone. PSCI 1.1 runs in OS-initiated mode, and the CPU and cluster idle states are in use at runtime. The SoC's own sleep counters are readable (qcom_stats, from rpmh-stats at 0xc3f0000). Since boot: no suspend at all (suspend_stats success 0 - on USB the lab holds devlab-usb, and Sxmo holds sxmo_not_suspendable and sxmo_modem_warming_up); CX collapse (cxsd) 0, AOSS sleep (aosd) 0, DDR low-power states 0; the deepest cluster state (cluster-sleep-2) never entered once while the lighter two were entered thousands of times. The audio DSP never slept (adsp 0) while the compute DSP and the modem slept about 200 times each; no audio stream was open, yet the VA, TX and RX macros stayed active, and the command line carries soundwire_qcom.stay_awake=1 from the microphone hunt. So no measurement of deep sleep exists yet, and two things already seen would keep the SoC from its floor.

Sources
: soc-sleeps-check


<a id="health-landscape"></a>
### health-landscape

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-17

Question
: What already exists for measuring a phone's health on the phone, shipping it there, and letting agents work with it - in postmarketOS and in our own commons?

Found
: postmarketOS (docs.postmarketos.org/pmaports/main/ci/hardware-ci.html): tests ship as small shell files in postmarketos-test-* packages (suspend by an RTC wake alarm; bootrr, which checks per board, keyed by the device tree's compatible, that every expected driver probed) and run in the initramfs CI hook on their hardware CI (CI-tron gateway); surya has no bootrr board file yet. In the commons: the package conveyor (linux-package-distribution-oco/conveyor) already builds static aarch64-musl binaries with signed provenance and plans signed Alpine repositories for postmarketOS (cv-apk) and machines that receive updates, the phone next (cv-machines-refresh); agent access (creation-guidelines/agent-access-oco) plans every tool's structured door offered over MCP, in Rust with rmcp, naming devlab among the first (aa-two-doors). In lab-tools itself: devlab test ran surya's checks from the lab over SSH, health kept a baseline of what ever passed, watch ran health after each boot from the lab - nothing ran on the phone by itself, and the checks were one surya-specific file.


<a id="checking-calls-automatically"></a>
### checking-calls-automatically

Project
: linux-phone-oco/surya-lab

Date
: 2026-11-11

Question
: How can calls, messages and data be checked without a person?

Found
: Data checks itself: a small download over the mobile connection. A call needs someone to answer: a second phone on a test stand that answers and confirms, or a programmable telephone number that answers and plays a known tone the phone can hear. Until then, half-manual: the phone calls a person's number and the person confirms through the inbox.

Sources
: twilio-voice


<a id="microphone-codec-drops-off"></a>
### microphone-codec-drops-off

Project
: linux-phone-oco/surya-lab

Date
: 2026-11-17

Question
: Why does nothing come back from surya's main microphone, now that the WCD9375 enumerates and the sound card is made?

Found
: The codec dropped off both SoundWire buses because ASoC puts every idle component into its sleep pin state, and the codec's sleep state drove its active-low reset low (traced: snd_soc_bind_card committed it 0.24 ms before both interfaces went UNATTACHED). Without a sleep state the codec stays attached and capture prepares (linux-phone-oco/linux PR #4); the SoundWire pin-mux fix is PR #3. Capture still yields exact zeros: the built-in microphones are digital mics (vendor: TX DMIC1-3 on LPI gpio26-29, function 1, mic bias 1 and 3); this ADSP rejects the VA capture port, so they go through the TX macro to TX_CODEC_DMA_TX_3; with the VA DMIC clocks forced on the TX path still reads zeros, as it does from ADC1 - the next fault sits in the TX decimator to DSP leg. Details: research/microphone.md.

Sources
: vendor-sm6150-lpi-dtsi vendor-sm6150-audio-overlay lineage-sm6150-wcd937x


<a id="the-modem-with-a-sim"></a>
### the-modem-with-a-sim

Project
: linux-phone-oco/surya-lab

Date
: 2026-11-11

Question
: Why does the modem not go online once a SIM card is in?

Found
: With the SIM in (operator 1&1, card present and ready) the modem refuses every request to go online: its own operating mode reads shutting-down from the start of boot, and ModemManager gets DeviceNotReady. The modem processor boots cleanly; rmtfs and tqftpserv run; the kernel's pd-mapper module is loaded. Meanwhile the modem reads and writes /readwrite/lctoem.tmp over tqftpserv in an endless loop, with rsize=0 seek=0 options, each read ending at once - the same kind of loop that postmarketOS fixed for the Fairphone 4 and 5 with a tqftpserv that handles rsize and seek. A reboot with the SIM in place changed nothing.

Sources
: pmaports-tqftpserv-4747


<a id="wiki-against-our-checks"></a>
### wiki-against-our-checks

Project
: linux-phone-oco/surya-lab

Date
: 2026-11-11

Question
: What does the community report for surya, and where does it disagree with what our checks measure?

Found
: Of 19 parts, 9 agree. The wiki reports calls, SMS and NFC working where our checks say unknown (no SIM card yet); mobile data and Bluetooth working where we measured partial; the speaker partial where we measured it working; and the sensors working where we measured broken - possibly our own doing, since we masked the sensor service to stop the audio processor crashing on suspend. The claims were gathered earlier, on an unrecorded date; this comparison is of today.

Sources
: surya-wiki


<a id="bolero-v1-capture-family"></a>
### bolero-v1-capture-family

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: How do SM6150/SM7150 'bolero' boards and their siblings (SM7125 atoll, SM6115 bengal, QCS615 talos) record their microphones on mainline and open stacks, and what does the vendor's own model say?

Found
: Working on mainline, legacy q6afe firmware: SM7150 davinci (sm7150-mainline PR 60, open, -62 dBFS floor) and surya (pulpoff/linux-surya; and linux-phone-oco since 2026-11-17), both through analog mics on the WCD9375 -> TX SoundWire -> TX macro DEC (SWR_MIC) -> TX_CODEC_DMA_TX_3. The SM7150-specific trap: its TX SoundWire controller has one dout port, which shifts both the master port numbers (inputs from port 2) and the controller's DAIs (capture is DAI 1); SM7125, the template, has none, so its <&swr2 0> is right there. Nobody streams the VA port on SM6150/SM7150; both trees declare a VA link and leave out the DCODEC vote this ADSP refuses. The vendor (sm6150 bolero, qcom,va-without-decimation) uses the VA block only for MCLK, the fs counter and DMIC clocks, clocked from the TX macro's MCLK through bolero's mclk mux, and routes every TX and RX path to VA_MCLK; mainline gives the same through the VA macro's fsgen clock on the TX macro. No open implementation of va-without-decimation exists - only a board with real DMICs on this family would need it. SM6115/QRB4210 (Linaro RB2 v3) records DMICs through VA_CODEC_DMA_TX_0 with the DCODEC vote: not a template here. QCS615 upstream (2026-05) is AudioReach with an external DA7212, headset mic only. postmarketOS ships no microphone support for SM7150 (wiki: N, UCM speaker-only).

Sources
: sm7150-mainline-pr60,pulpoff-linux-surya,lineage-sm6150-bolero,sm7125-mainline-ucm-miatoll,qrb4210-rb2-audio-v3,qcs615-talos-evk-audio,pmos-sm7150-wiki


<a id="microphones-are-analog"></a>
### microphones-are-analog

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: Which microphones does surya have, and on which inputs?

Found
: Two built-in analog microphones on the WCD9375: the bottom one on AMIC1 (mic bias 1) into ADC1, the top one on AMIC3 (mic bias 3) into ADC2 with its input mux at INP3; the headset mic is AMIC2 (bias 2) on the same ADC2 at INP2. ADC1 comes back over the TX SoundWire bus on master port 2, ADC2 needs its own master port 3 (qcom,tx-port-mapping <2 3 4 5>): sharing port 2 with ADC1 lost the top mic and turned the bottom one to full-scale noise (pulpoff). No digital mics: pulpoff names LPI gpio7-11 NC, among them gpio8-11, the DMIC clock and data pins (vendor gpio26-29), and records both mics through ADC1/ADC2 on mainline. The TX DMIC1-3 routes read on 2026-11-17 come from sdmmagpie-qrd-overlay.dts, Qualcomm's QRD reference board kept in Xiaomi's tree, which declares the SWR_ADC0/ADC2 routes beside them. Measured on the phone (bring-up, 2026-11-17 04:37 UTC, test/surya-mic with <&swr2 1>): mic-records pass and mic-hears-speaker pass, a 1 kHz tone at -19.4 dBFS against -76.3 dBFS of noise through ADC1. The DMIC experiment (pins at mux 1, VA DMIC clocks on a switch) answered a question surya does not ask and is to be dropped.

Sources
: pulpoff-linux-surya,sm7150-mainline-pr60,xiaomi-sdmmagpie-qrd-overlay


<a id="mic-zeros-meant-no-input"></a>
### mic-zeros-meant-no-input

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: What made the TX decimator to codec DMA path deliver zeros, and what does a capture of zeros tell?

Found
: The decimator-to-DSP leg worked all along: each silent recording began with ~0.5 s of ringing (-1774 settling to exact 0), the high-pass filter draining a constant input - the decimator ran and its output reached TX_CODEC_DMA_TX_3, but no samples entered it. The cause was upstream of the decimator: the capture link named the TX SoundWire controller's DAI 0, its playback DAI (qcom_swrm_register_dais makes the first num_dout_ports DAIs playback, and this controller has one dout port), so sdw_stream_add_master was never called and the codec's ports never programmed. The same one-dout-port shift moves master port numbers by one (ports start at 2; swr2's qcom,ports-* arrays begin with 0xff). For DMICs the same reading held: with no clock on the pin the data line is static and the filter removes it. So: start-up ringing then exact zeros means no input reaches the decimator - look at the source (SoundWire stream, DMIC clock), not the DMA or the AFE port. The AFE port is the vendor's too: TX AIF1 on TX_CDC_DMA_TX_3 (45111 = 0xB037), accepted by this ADSP.

Sources
: pulpoff-linux-surya,sm7150-mainline-pr60,lineage-sm6150-bolero

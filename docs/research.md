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

About
: deep-sleep


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

About
: deep-sleep


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

About
: deep-sleep


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

About
: deep-sleep


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

About
: deep-sleep


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

About
: deep-sleep


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

About
: dl-reaches


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

About
: modem-calls


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

About
: audio-mic


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

About
: modem-data


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

About
: xiaomi-surya


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

About
: audio-mic


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

About
: audio-mic


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

About
: audio-mic


<a id="echo-call-number"></a>
### echo-call-number

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: Which public number can an automated call reach from a German mobile, that plays back what it hears, free or at the national rate?

Found
: Only one German public echo line is attested across sources and years: blueSIP's echo test, +49 89 721010 99701, a Munich landline number (landline rate: inside any German allnet flat, about 9 ct/min on plain prepaid), named in forums in 2005 and 2013, recommended in 2021, and still on Placetel's list (which gives no warranty). It plays back what it hears at once (an echo, not record-then-playback); no length limit is stated. The same provider's +49 89 721010 99702 plays a signal tone: a downlink-only control that needs no working uplink. sipgate's echo (10005) and test (10000) are SIP-internal short codes, not dialable from a mobile, and sipgate serves only business customers since 2025-06. Other European lines (portunity's 0211 237099929 from 2005, sip2sip's +31 20 8005161, a Dutch C*NET echo) are old and unconfirmed, and abroad costs more. No source confirms any line works from a mobile today, so the first supervised call settles it. Fallback that is certain to exist and free on German tariffs: the SIM's own mailbox (record a message, play it back by DTMF; slower and operator-specific).

Sources
: placetel-testrufnummern, ipphone-testrufnummern-2005, ipphone-testanrufe-2013, bitpage-bluesip-2021, prepaid-wiki-sipgate, sip2sip-testing

About
: modem-calls


<a id="call-audio-on-surya"></a>
### call-audio-on-surya

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: What does a voice call with sound both ways need on surya, and what is there now?

Found
: Read on the phone 2026-11-17 (devlab phone sh, read only): the modem is online now - LTE on Vodafone.de (26202), registered home, packet service attached, signal 71%, UE mode csps-1, voice-centric with PS (VoLTE) preferred, so a call goes VoLTE if the modem's IMS profile allows it, else falls back to GSM; ModemManager 1.25.95, libqmi 1.38, tqftpserv 1.3, rmtfs 1.3; callaudiod and q6voiced are installed; no calls listed. The kernel (7.1.0-sm7150-mic+, linux-phone-oco/linux test/surya-mic) has no VoiceMMode PCM and no Voice Mixer controls: q6voice is not in it. pulpoff/linux-surya (7.2.15 on surya) carries calls with audio both ways: q6voice from sdm845-mainline (MVM, CVS, CVP over APR) with the CVD 2.3 set-up SM7150 needs (from the CVP version), codec DMA ports, a zeroed command buffer and the start moved from startup to prepare; the device tree adds the APR services and a hostless VoiceMMode1 link (PCM 4, hw:0,4) that q6voiced opens per call; routing 'TERT_MI2S_RX Voice Mixer VoiceMMode1' and 'VoiceMMode1 Capture Mixer TX_CODEC_DMA_TX_3' (our kernel uses the same back-end names); 'VoiceMMode1 TX Topology' at 0x10F70 (none) since the default 0x10F71 sends silence without Xiaomi's calibration; and the uplink is silent unless a 1-channel capture runs on TX_CODEC_DMA_TX_3 for the whole call (their surya-call-uplink on MultiMedia3; 2 channels or a prepared-only stream do not do). callaudiod picks a UCM Voice Call verb (earpiece or speaker). The order: q6voice and the device tree first (the PCM and controls appear - check call-audio-path), then UCM Voice Call with the topology and the uplink capture, then a call.

Sources
: pulpoff-linux-surya

About
: modem-calls


<a id="echo-call-test-design"></a>
### echo-call-test-design

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: How can the phone itself decide that a call carried sound both ways?

Found
: Acoustically, through the paths a person uses, with the analysis in Rust: during the call the uplink capture that the call needs anyway (1 channel on TX_CODEC_DMA_TX_3, the bottom mic) is written to a file instead of thrown away. The phone plays a pattern of three short tones (e.g. 800, 1300, 1900 Hz, 200 ms each, 300 ms apart - inside the 300-3400 Hz every voice codec keeps) on the loudspeaker at the manifest's quiet level; the bottom mic hears it at once (proves the injection) and sends it up the call; the echo comes back down and plays on the earpiece, and the same mic hears it again 150-1500 ms later (the network's round trip; acoustic reflections are under 20 ms). A Goertzel envelope per frequency finds the pattern twice; the echo counts when the same order of tones recurs at one delay, 15 dB above the noise, and the delay is reported. Before the echo call, a call to the tone line (99702) proves the downlink alone, so a missing echo says uplink (or the line) rather than everything. Cost: one call of at most 25 s (dial, about 8 s to answer, 5 s of pattern, hang up; a hard timeout), at most once a day, a landline-rate number: inside a flat, or under 10 ct per day on prepaid. Skips cleanly, as unknown: no modem, no SIM, not registered, no voice interface, no call path (call-audio-path failing), the daily call already made, or the number unset in the manifest. A pass proves works for modem-calls. If q6voice exposes in-call record/playback ports (downstream's VOICE_RECORD_RX, incall music), a digital loop could replace the acoustic one later; unknown on this driver.

Sources
: pulpoff-linux-surya, placetel-testrufnummern

About
: modem-calls


<a id="health-suite-organisation"></a>
### health-suite-organisation

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: How should the phones' health suites be organised to cover every part and feature, stay quick to change and dependable, and avoid Python?

Found
: What is: devlab-health, a static Rust runner (lab-tools/health), runs shell checks on the phone after every boot in two layers (base, shell): 11 generic in lab-tools and 5 of surya's own in surya-lab; each prints 'pass|fail|skip TEST COMPONENT detail' and docs' tests table says what each pass proves. The weak spot is computation in shell: three of surya's checks carry a Goertzel filter written in awk and a tone made byte by byte with printf, because lab-tools' tested tone crate never reaches the phone. The phone has no Rust toolchain (it has python3, which the lab refuses), so rust-script (stable, 0.36 on the lab) cannot run there and would need a toolchain and network on the phone; Cargo's own single-file scripts (frontmatter, cargo PR 16569) are still nightly-only in Cargo 1.99. KTAP is the kernel's test output (ok/not ok, SKIP, nested suites) - a format our lines map onto if LAVA-style tools are ever wanted. Shape that fits: shell stays for what is a reading (sysfs, a command's output; ten readable lines), and anything with numbers, timing or a state machine (tones, echoes, calls, sleep counters) is a subcommand of one static multi-call Rust binary shipped with devlab-health (e.g. devlab-health tone find, devlab-health call echo), built with its unit tests and recorded fixtures on the lab and cross-built by health/build.sh; rust-script is the lab's prototyping and one-off analysis tool against recordings fetched from the phone, a prototype becoming a subcommand once it is kept. Coverage is read off the data: a query of every device's components with no test that proves works, and a layer per cost - base, shell, then telephony (calls and data, gated by budget and once a day) and witnessed (needs a person).

Sources
: rust-script, cargo-script-goal-2026, ktap-v1

About
: dl-reaches


<a id="mobile-data-check-budget"></a>
### mobile-data-check-budget

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: How can mobile data be checked after every boot within about 3 GB?

Found
: Per run: the modem registered and its bearer connected (mmcli), the bearer's interface found from ModemManager, then over that interface only (curl --interface, so Wi-Fi cannot pass for it): a DNS lookup, five pings to a fixed address (round trip, loss), and a 100 kB HTTPS download timed (speed.cloudflare.com/__down?bytes=100000 or a file the project hosts), about 150 kB with overheads. Boots run up to ~45 a day in bring-up, so about 7 MB on a heavy day; once a week a 5 MB download measures throughput. That is under 0.3 GB a month even on busy months: the 3 GB lasts most of a year at the worst rate and years at an ordinary one. A check also reads the bearer's own byte counters (the interface's /sys/class/net/IFACE/statistics before and after) so each run states what it used, and skips when the month's total passes a budget set in the manifest. Skips without a SIM, as the modem checks already do.

About
: modem-data


<a id="modem-online-tqftpserv"></a>
### modem-online-tqftpserv

Project
: linux-phone-oco/surya-lab

Date
: 2026-11-17

Question
: Why did surya's modem fail as soon as a SIM went in, and what makes mobile data work?

Found
: The modem looped 4769 times reading and writing /readwrite/lctoem.tmp: tqftpserv 1.1.1 (Alpine v3.24) never writes short WRQ files, so the state files stayed 0 bytes, the modem stayed in DMS mode shutting-down, UIM reported 'GW primary session index unknown' and ModemManager 'sim-missing'. tqftpserv 1.3 from Alpine edge (two packages, no other dependencies) fixed it on the next boot: mode online, Vodafone.de LTE, home registration, signal 71%. Mobile data then failed with 'Multiple PDN connection to same APN not allowed' when the NetworkManager connection named the APN web.vodafone.de: the modem's default profile attaches with an empty APN, which the network fills in. A gsm connection with no APN works: IPv4 and IPv6, 3/3 pings at 32 ms, 500 kB at 1.2 MB/s. The SIM sits in slot 2 (slot 1: no ATR), as pmaports #4441 found.

Sources
: pmaports-4441-tqftpserv

About
: modem-data


<a id="expert-agents-written-not-standing"></a>
### expert-agents-written-not-standing

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: Should linux-phone-oco keep standing expert sessions, one per hard domain (audio, modem, sleep...), with the orchestrator routing questions to them - or keep expertise somewhere else?

Found
: The world has tried it under several names - specialised workers under a supervisor, hierarchical teams, blackboard systems, stateful agents - and converges on one split: the expert is a role and a body of written knowledge; a session is a disposable worker that takes the role up. Gas Town says it outright (an agent is a persistent identity, sessions are cattle; any session can hand off and restart from its hook). Anthropic's long-running harness found compaction alone not enough and had every fresh session get up to speed from a progress file, git and a feature list; its context-engineering guide names notes outside the window as the tool for iterative work with milestones. Claude Code itself moved this way: subagents may keep a per-role MEMORY.md, and agent teams start each teammate from project context and a spawn prompt, never the lead's history, and do not restore teammates on resume. Against expertise held in a long context: models recall worse as input grows (Chroma, context rot; Anthropic's attention budget), repeated summarising erodes detail (ACE: context collapse, brevity bias), and a session of 1000-1800 messages re-reads all of it each turn - after an idle hour without the cache, at full price - so a standing expert answering an occasional question is the costliest and not the most reliable way to answer it. Against a central router: a supervisor that relays every message plays telephone - lower scores and more tokens than agents handing off directly (LangChain); misalignment between agents (lost context, withheld information) is one of the three failure groups in 1600 traces (MAST). What works (Cognition, 2026): one writer per thing, other agents adding intelligence not actions; a consult works best given a fork of the asker's full context. Blackboard systems route by a shared record agents read, not by a relay. For us: most of the audio expertise is already rows in docs (5 research, 2 decisions, 27 backlog items name the microphone); what is not written is the tacit part - dead ends, where the experiment patches are, what hung the phone - and it now lives in hand-over notes outside any repository.

Sources
: anthropic-context-engineering,anthropic-long-running-harness,claude-code-agent-teams,claude-code-subagent-memory,cognition-multi-agents-working,langchain-multi-agent-benchmark,ace-context-collapse,mast-mas-failures,chroma-context-rot,blackboard-llm-mas,letta-sleep-time

About
: expert-primer


<a id="kb-organisation-world"></a>
### kb-organisation-world

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: How do open practice and agent makers organise a knowledge base so that people and agents reach what they need without reading all of it?

Found
: They agree. (1) One small entry that is always read and routes onward, saying what each target is for: llms.txt, the root AGENTS.md (nearest wins), PhotoCraft's Read/Why orientation table, Johnny.Decimal's index, datapackage.json. (2) What is always loaded is kept small: CLAUDE.md under 200 lines, no more than ten per level, llms.txt's skippable Optional. (3) Detail in stages: Skills' name and line, then body, then linked files; Claude Code loads nested CLAUDE.md only when its subtree is touched; context engineering keeps lightweight identifiers - paths, stored queries - and loads content just in time. (4) Small units with stable addresses: evergreen notes whose titles work like APIs, numbered ADRs, Wikidata's Q and P ids. (5) Facts apart from explanation: Diátaxis' reference against explanation, Wikidata statements and infoboxes beside prose. (6) One decision per record, superseded rather than deleted (Nygard, MADR). (7) Every statement is about an item by its id and cites who says so (Wikidata). (8) Views are generated from the source data (PhotoCraft's scorecard, Mintlify's llms.txt). Tensions: hierarchy against association (fixed buckets vs dense links - a small fixed index with free links beneath answers both); one file against many (concatenation does not save context; loading on demand does). No source measured how much any of it speeds an agent - the measure here is docs' own (kb-navigation-measured).

Sources
: diataxis,llms-txt,agents-md,nygard-adr,madr,frictionless-data-package,docs-as-code,evergreen-notes,johnny-decimal,para-forte,wikidata-statements,wikipedia-infobox,anthropic-context-engineering,anthropic-agent-skills,claude-code-memory,photocraft-agents-md,mintlify-llms-txt

About
: idealkb-from-template


<a id="kb-navigation-measured"></a>
### kb-navigation-measured

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: How much must an agent read in docs today to answer a typical question, and what would an entry and a link cut it to?

Found
: Measured on main 2026-11-17 (bytes; about 4 per token). What is known of surya's microphone: there is no checked link from a record to what it is about - research, backlog and session_log have no such field, and decisions' about is free text in four spellings (microphone, features:microphone, linux-phone-oco/docs/features:microphone, a milestone id) and empty on 12 of 38. So an agent reads pages - research, decisions, backlog, support_status, feature_support: 206 KB, about 52k tokens - or greps data/ (79 KB of matched rows, noisy). The answer itself is 18 rows, 9.4 KB, about 2.3k tokens: 22 times less, but only reachable today by knowing the ids. What to do next on the modem: the backlog page is 84 KB (21k tokens); tad q backlog prints 327 KB in its box format (37 KB as csv) for all places; the answer is 2 open items, under 0.2 KB - found today only by matching words in titles. How to record a decision: tad statements answers it with every parameter in 3.5 KB (0.9k tokens), and practice 42 says it at session start - this one is already good. The entries: AGENTS.md (7 KB) is how to edit the data (setup, rules, recipes), not where knowledge is; README names 6 of 29 tables; the rendered index lists tables by count. Every session also reads 21 KB at start (practices and inbox). The rendered pages are 1.46 MB in all, 1 MB of them test_results. So the weight is not the entry files but the lack of a subject link: with an about link checked on every record table and a query about SUBJECT, the first two questions are one call of 2-10 KB.

Sources
: text-as-data-template

About
: kb-about-link


<a id="kb-organisation-commons"></a>
### kb-organisation-commons

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: What in the commons already does part of an ideal knowledge base, and would idealkb be one nature under a second name?

Found
: tad (creation-guidelines/tad-engine) is the engine: tables declared as data after Frictionless Table Schema, checked rows, canonical files, SQL, named queries and records with their header line as their description (tad statements is already an index of every question and record a base keeps). text-as-data-template is the template for a base kept as tad data - the same nature as idealkb - and has drifted: last changed 2026-11-04, still the vendored Python engine on a DuckDB schema that every base left on 2026-11-11 (as the vendored engines had drifted, three of four behind). ideal-project-playbook is how to run a software project - the loop, guards, CI, honesty - whose own docs/ is a tad base; its kit/templates for backlog, development log and idea page are records a base keeps as tables, and its findability test (real questions, the answer within the first three) is the measure a base needs. software-engineering-canon is a base itself (the spike the template came from). ideal-agent (grenudi/ideal-agent, 2026-11-17) is how agents work: practices, skills, hooks, and its own tad base; it keeps only what is general and leaves a project's domain in the project's data. ocoeco's marks (oco.toml exports, holds) and lenses say how a base fits the observatory's picture - its face, not its organisation. linux-phone-oco/docs is one tad base for every linux-phone place (2026-11-17-one-database), with prompts/ (role briefs), research/ (long prose), and rendered docs/ the face reads. Overlap: idealkb would be text-as-data-template under a second name; nothing else holds how knowledge is organised. Gap: no base links a record to what it is about, and no base has an entry that routes questions to queries.

Sources
: text-as-data-template

About
: idealkb-from-template


<a id="sensors-registry-rebuild"></a>
### sensors-registry-rebuild

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: Why does the ADSP sensors service crash-loop the audio DSP on surya, and what would stop it without changing the firmware?

Found
: Measured on the phone (read only, kept kernel 7.1.0-sm7150-calls+, 2026-11-17) and read in hexagonrpcd's source. At start the DSP's registry sensor compares each config it knows (the registry's sns_reg_config: 47 configs, every one recorded with data 1230768000 - 2009-01-01, Android's fixed vendor mtime) with the config files hexagonrpcd serves, and hexagonrpcd passes their real mtime: all 46 on the phone carry 1779945838 (the package's build time), and sns_pickup.json is listed but absent. Every config therefore looks changed, the DSP re-parses and writes (temp.json), hexagonrpcd refuses every write by design, and the DSP asserts (SNS_REG_INIT, sns_registry_sensor.c) and restarts with audio. The version marker sns_reg_version, whose absence also forces a rebuild elsewhere (hexagonrpc #19), cannot be served at all: the virtual persist/sensors/registry holds only its registry subdirectory. So no trial of 2026-11-09 had both conditions of an untouched registry - the marker reached and the configs unchanged; they disproved only a registry swap. Hypothesis to settle first: configs touched to 1230768000 (and no listed config missing) make the pre-parsed registry current, so nothing is written and the ADSP stays up. Independent of it: the same assert is open upstream on X1P42100 (#29, 2026-11-14) and was stopped by writes elsewhere (#19, #27).

Sources
: hexagonrpc-source,hexagonrpc-19,hexagonrpc-27,hexagonrpc-29,firmware-xiaomi-surya,libssc

About
: sensors


<a id="sensors-hardware-surya"></a>
### sensors-hardware-surya

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: Which sensors does surya carry, where, and is in-call proximity a real sensor?

Found
: All on the audio DSP's sensor core (no SLPI on SM7150), none on a bus Linux drives: the motion chip (accelerometer+gyroscope; one of bmi220, bmi26x, icm4x6xx, lsm6dso, probed by the DSP - the wiki names BMI220) on SPI instance 3; magnetometer AK09918 (ak0991x) on I2C 1 at 0x0c; adux1050, a capacitive SAR sensor for radio power, on I2C 1 at 0x2c (not the call proximity); Sensortek stk3a5x ambient light + infrared proximity on I2C 5 at 0x46, polled, near/far 12000/10000, one calibration value differing by panel (huaxing 2.0, tianma 1.0, chosen on Android by ro.boot.lcmtype through an apps-side get_property hexagonrpcd does not implement; the pre-parsed registry already holds stk3a5x). In-call proximity is that physical IR sensor: surya's tree has none of the ultrasound parts its sibling sweet carries (elliptic, mius, ro.vendor.audio.us), so the microphones and earpiece are not involved. The phone runs libssc 0.4.3 with ssccli, iio-sensor-proxy 3.9 with ssc support, and its udev tags fastrpc-adsp ssc-light, ssc-compass, ssc-accel, ssc-proximity; iio-sensor-proxy starts and waits ('registry sensor unavailable'). The suite's motion-and-light counted IIO devices only, so it could never pass through the sensor core.

Sources
: lineage-surya-tree,firmware-xiaomi-surya,wiki-surya-ssc-2024,iio-sensor-proxy-409,libssc

About
: sensors


<a id="sensors-family-state"></a>
### sensors-family-state

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: How far have SSC sensors got on SM7150 and its siblings on mainline, and what stopped them?

Found
: surya: reported working once (wiki 'SSC works', 2024-03-11, mainline 6.7.4, hexagonrpcd 0.3.x, setup unwritten), never re-checked; firmware-xiaomi-surya's registry is Android's own (mtimes 1230768000). davinci (SM7150): rarely works on v26.06, iio-sensor-proxy at 100% CPU (#4674), the audio failure loop from ADSP crashes (#3871); a fix serving the real persist (!8203) was closed unmerged. tucana works (mount matrix fixed); sweet light and accel, its proximity is ultrasonic; sunfish (Pixel 4a) does not. miatoll (SM7125, ADSP only like surya) works with a registry rebuilt on Linux (sns_reg_config 1720791834). Fairphone 4 (SM7225) works. Upstream: no hexagonrpcd release writes (v0.5.0, 2026-08, none); write support exists out of tree (#27 withdrawn, a -S state dir on SG6275P, a 700-line patch on X1P42100) and the maintainers have not settled where writes go. Other routes: Linux driving the sensor chips on the SSC buses fights the DSP for them (X1E) and needs drivers stk3a5x lacks; Ubuntu Touch on surya has sensors through Android's vendor kernel (Halium).

Sources
: wiki-surya-ssc-2024,pmaports-4674,pmaports-8203,pmaports-5941-miatoll,hexagonrpc-19,hexagonrpc-27,hexagonrpc-29,lkml-ssc-qup-from-apps,firmware-xiaomi-surya

About
: sensors


<a id="sensors-across-suspend"></a>
### sensors-across-suspend

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: Can the sensors helper stay attached across suspend, and what brings it back after?

Found
: postmarketOS stops sensorspd and rootpd before suspend (the units Conflicts=suspend.target; !5400 on the Pixel 3a, carried to systemd in !7303) and nothing restarts them: Restart=always does not fire on a conflict stop, by design - the helper is thought needed only while the DSP asks for its registry, and libssc talks QMI to the sensor service, not through hexagonrpcd. So after a first suspend on surya the sensors would have no helper; whether they keep working without it is unmeasured. One data point (SG6275P, #19) has a sensors helper with a writable registry surviving a 15 s rtcwake. surya's rootpd crash on suspend (24 of 24) is a separate helper; rootpd stays masked. No kernel fastrpc fix for suspend was found in 2025-2026; Qualcomm said in 2026-04 that a daemon attaching to a PD crashes the privileged PD and is being investigated.

Sources
: pmaports-sargo-suspend,hexagonrpc-19

About
: sensors


<a id="sensors-how-it-stands"></a>
### sensors-how-it-stands

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: The sensor hub on surya: how it stands, what was tried, what never to do again

Found
: 2026-11-17 (research-sensor-hub): broken by our own mask - hexagonrpcd-adsp-sensorspd and -rootpd masked in surya-lab device.toml; iio-sensor-proxy runs and waits for the registry. Way decided: the registry kept current (decision 2026-11-17-sensors-registry-kept-current); queue sensors-and-the-mask (10, first), sensors-without-crash (11), sensors-proximity-in-calls (12), sensors-registry-writes (13, fallback only), sleep-fastrpc-helpers (4) for suspend, sensors-upstream (no phone). Dead ends: swapping registries (packaged, or the phone's own persist with the marker beside it) - hexagonrpcd cannot serve the marker, so those trials changed nothing (2026-11-09, surya-lab adsp/registry-trial.sh, which counts crashes and can take the probe). Tools on the phone: ssccli --sensor proximity|light|accelerometer|magnetometer, monitor-sensor, busctl on net.hadess.SensorProxy. Never: unmask rootpd (the DSP dies at every suspend attempt); leave sensorspd crash-looping - each crash restarts the DSP that carries the microphones and calls; read /sys/kernel/debug/gpio or the LPI pinctrl at 62b40000 - the sensor core's pins are there. The sensor chips are not on any bus Linux drives.

Sources
: hexagonrpc-source,firmware-xiaomi-surya

About
: sensors


<a id="pixel-2-linux-survey"></a>
### pixel-2-linux-survey

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: What works on the Google Pixel 2 (walleye) and Pixel 2 XL (taimen) on Linux today, by published sources, and how does their SoC (MSM8998) relate to surya's SM7150?

Found
: A survey from published sources only (nothing touched, nothing measured here; every part of both phones is unknown, the reports sit in support_status notes and wiki_claims). (1) Nura (postmarketOS) wiki: only the Pixel 2 XL has a page (kernel field 5.10-rc2; 'Boots but no display output'; usbnet Y, flashing Y, screen N, battery N; page by Casey/kcxt, edited 2026-09-05, bot edit 2026-09-27); the Pixel 2 has none. (2) pmaports: neither device-google-walleye nor device-google-taimen exists in device/main, community or testing (listed 2026-11-17). (3) Mainline Linux: no Pixel 2 device tree; arm64/qcom has MSM8998 boards (OnePlus 5/5T, Xiaomi Mi 6, Sony yoshino, F(x)tec Pro1, HP Envy x2, Lenovo Miix 630, Asus NovaGo) and msm8998.dtsi was still edited on 2026-09-17. (4) The port lives out of tree: kcxt/linux-wahoo, created 2020-07-20, last pushed 2022-02-27; branch wahoo/5.17 has msm8998-google-taimen.dts, -walleye.dts and wahoo.dtsi, plus panel and DPU/DSC work (unfinished), and a taimen-5.11-submit branch whose mainline submission is not found upstream. (5) Other distributions: Ubuntu Touch has only a 16.04 (Halium, Android kernel) release for walleye, the current release does not support it (taimen page exists, not read); LineageOS 22.2 runs both on Android (kernel 4.4, AOSP branch android-msm-wahoo-4.4-android10-qpr3 shared by both). Not found for either: Mobian, Droidian, Sailfish, a pmOS issue or MR (search only; absence is not a report). SoC and surya: MSM8998 (Snapdragon 835, 2017) vs SM7150 (Snapdragon 732G). Per mainline msm8998.dtsi it has Adreno 540, DPU/MDSS with 10 nm DSI PHY, UFS 2.0, DWC3 USB with QMP PHYs, ADSP/SLPI/modem remoteprocs, Venus and the older RPM (rpm-msm8998, glink-smd-rpm), so what surya's SM7150 shares is the kind of block (UFS, DWC3/QMP USB, DSI/DPU display, remoteproc DSPs, SPMI PMIC) but not the drivers or tables: SM7150 itself is not in mainline Linux (surya runs the sm7150-mainline fork; the nearest mainline Qualcomm sibling is sdm670, the Pixel 3a), and MSM8998 has Adreno 5xx and RPM where SM7150 has Adreno 6xx and RPMh (our reading of the trees, not a source's claim). Sibling evidence for the SoC: the wiki's OnePlus 5 (archived, kernel field 6.0) reports touch, screen, wifi, Bluetooth, 3D, GPS Y and audio, mobile data, calls, SMS, sensors N: a different phone, stale, context only. Distance: surya has 12 of 20 parts working by its own tests; the Pixel 2 XL has 1 community 'works' (flashing), 1 'broken' (screen) and 19 unknown; the Pixel 2 has nothing reported.

Sources
: pixel2xl-pmos-wiki,kcxt-linux-wahoo,mainline-qcom-dts,pmaports-google-devices,ubuntu-touch-walleye,lineageos-wahoo,aosp-wahoo-kernel,pmos-wiki-oneplus5

About
: google-taimen


<a id="google-taimen-how-it-stands"></a>
### google-taimen-how-it-stands

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: How does the Pixel 2 XL (taimen) stand?

Found
: Far from surya. Nothing is measured here. By community report it boots mainline 5.10-rc2 on a basic device tree from an out-of-tree fork (kcxt/linux-wahoo, last push 2022-02-27), USB networking and flashing work, there is no display, the battery does not work. No mainline device tree, no pmaports package, no one has reported touch, audio, modem, wifi or the rest. Worth a lab test one day only as the cheap member of the pair, after surya's list: it is the one with a documented boot.

Sources
: pixel2xl-pmos-wiki,kcxt-linux-wahoo,mainline-qcom-dts,pmaports-google-devices

About
: google-taimen


<a id="google-walleye-how-it-stands"></a>
### google-walleye-how-it-stands

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: How does the Pixel 2 (walleye) stand?

Found
: Nothing reported on mainline: no wiki page, no pmaports package, no mainline device tree. Only the out-of-tree fork kcxt/linux-wahoo has a walleye device tree (wahoo/5.17), and nobody says it boots. Android (LineageOS 22.2) and an old Ubuntu Touch 16.04 port exist. Everything is unknown; test it only after taimen has shown the way, since both share the SoC and the kernel fork.

Sources
: kcxt-linux-wahoo,ubuntu-touch-walleye,lineageos-wahoo,pmaports-google-devices

About
: google-walleye


<a id="kb-navigation-remeasured"></a>
### kb-navigation-remeasured

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: With docs following ideal-knowledge-base 0.1.0, how much must an agent read to answer the three questions of kb-navigation-measured?

Found
: Measured on the branch that follows it, 2026-11-17 (bytes). The entry: AGENTS.md is 2.1 KB (was 7.9 KB) - two lines on what docs is, linux-phone's own questions, and idealkb's generic part; the editing recipes went to CONTRIBUTING.md. What is known of surya's microphone: tad q about --subject audio-mic, one call, 15.9 KB as csv (26 records about it now, against 18 before) - but 91 KB in tad's default box format, which pads every cell: the format is now the weight, not the finding (was 206 KB of pages). What to do next on the modem: tad q next --about modem, one call, 0.2 KB as csv, 1.8 KB as box (was an 84 KB page or 327 KB of tad q backlog). How to record a decision: the entry names tad r decision --project docs and tad statements (4.8 KB with every parameter; was 3.5 KB with fewer statements) - unchanged in kind. So two of the three questions are one call each, as the decision expected; what is left is tad printing compact rows when not at a terminal (idealkb backlog compact-query-output).

Sources
: text-as-data-template

About
: kb-entry


<a id="start-weight-measured"></a>
### start-weight-measured

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: What must a fresh linux-phone session read before its first useful action, per role, and is it within ideal-agent's budget (practice 45-keep-the-start-light: 32 KB a role, 3 KB a front file, 8 KB a brief)?

Found
: Measured 2026-11-17 on docs' main (495bbc6) with ideal-agent 0.2.1's scripts/start-weight, in bytes. Every role reads: the session start 14,353 (the practices without their reasons, and the inbox - 22.5 KB before ideal-agent #13 put the reasons a command away), skill and agent descriptions 4,057, lab-session-start 2,012, AGENTS.md 2,141, ideal-agent-linux-phone-oco/README.md 2,306 - 24,869 in all. Then the brief: bring-up 13,313 (38,182 in all: over the 32 KB budget, and the brief over 8 KB), orchestration 6,248 (31,117), phone-keeper 4,559 (29,428), feature-research 2,417 (27,286). Before #13 the same roles read 35-46 KB. The front files are within 3 KB. Whether summaries are due cannot be read yet: docs pins idealkb 0.1.0, whose about query has no summaries (0.3.0 comes with the weekly pin).

About
: agent-folder


<a id="open-handset-commons-model"></a>
### open-handset-commons-model

Project
: linux-phone-oco/docs

Date
: 2026-11-10

Question
: What must a phone have, structurally, to be a daily driver - judged from everything the open and proprietary platforms already built, learned and failed at?

Found
: Nine structural concepts, from ten projects, two operating systems and one firmware: Two Minds (a small always-on processor beside the main one, proven by Crust), Radio Wall, Notification Sovereignty, Consolidation Path, Platform Compatibility, Security Substrate, Update Covenant, Power Covenant, and the Observatory that maps every project against them. The open ecosystem's hard gaps are standby with push, a hardware security processor and long-term updates; Android and iOS solved them in closed ways. The model, its map and the prior-art files for Android/AOSP, iOS and GrapheneOS are the material; it is the why layer of the grand picture. (Moved into the dated layout on 2026-11-17.)

About
: lp-everything

Material
: research/open-handset-commons/2026-11-10/


<a id="kb-navigation-summarised"></a>
### kb-navigation-summarised

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: With docs at idealkb 0.3.0 and audio-mic summarised, how much must an agent read to know where surya's microphone stands?

Found
: Measured 2026-11-17 (bytes, tad q about --subject audio-mic --format csv): 4.8 KB, against 15.9 KB before the summary with the same 26 rows behind it (9.4 KB at 18 records) - the summary (1.3 KB) first, the status per device, the open work and tests in full, and the 14 condensed research, decision and log records by id on one line; --whole true gives the 15.9 KB. tad q about lists every subject with its weight and says which are due: audio-mic summarised; deep-sleep (15.7 KB), dl-reaches (10.9 KB) and sensors (11.3 KB) due. What grows now with each new record is about 30 bytes of id until the summary is renewed - at 4 KB since, the query says so.

About
: kb-summaries


<a id="2026-11-17-surya-first-s2idle-cycle"></a>
### 2026-11-17-surya-first-s2idle-cycle

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: Does surya's SoC reach its sleep floor in one measured s2idle on the kept kernel 7.1.0-sm7150-calls+?

Found
: No. One 60 s cycle by hand (USB gadget let go via soft_connect, rtcwake -m freeze -s 60, run as a transient systemd unit so it survives the link dropping; nohup in the ssh session is killed on exit). The phone slept the whole time: the pm8xxx_rtc_alarm interrupt fired once and suspend_stats success went 0 to 1, fail 0. The 2.4 s between the kernel log's suspend entry and exit, and between date readings, is only the clocks not counting sleep (monotonic and wall time stand still in s2idle here) - read the sleep from the RTC, not from date or dmesg. qcom_stats: cxsd 0, aosd 0, ddr 0 before and after; adsp never counted a sleep, cdsp 58, modem +7. Cluster domain: S1 usage 9417 to 9482 across the run, S2 (the deepest state) never entered. The suite's soc-sleeps now says fail: suspended, yet the SoC never reached its lowest state: cxsd 0, aosd 0; suspends this boot: 1; processors never asleep: adsp; wake locks: devlab-usb (devlab-health 20261117-115521). No hands needed: the phone woke by itself on the RTC alarm and came back over USB. Careful: reading /sys/power/wakeup_count blocks while a wakeup event is held (the lab's devlab-usb wake lock) - never read it without a timeout.

Sources
: devlab suite run 20261117-115521; /var/tmp/sleep-cycle/before and after on the phone

About
: deep-sleep


<a id="2026-11-17-surya-s2idle-wakes-at-once"></a>
### 2026-11-17-surya-s2idle-wakes-at-once

Brief
: surya's suspend ends at once: the serial's IRQ 157 (a storm, wake-armed) wakes s2idle; Bluetooth dies after it

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: Why does surya's s2idle end after about 2 s instead of 60, and what does the first measured cycle show?

Found
: Five cycles by hand (kept kernel 7.1.0-sm7150-calls+, one with the cluster parameters of surya's own firmware tables in the device tree) all end early: the RTC advanced a few seconds only, the suspend core goes from dpm_suspend_noirq end to dpm_resume_noirq begin in microseconds and the CPUs never enter s2idle's idle loop. A function trace names the wake: s2idle_wake <- pm_system_irq_wakeup <- irq_pm_handle_wakeup, during suspend_device_irqs, no wakeup source involved. The interrupt is IRQ 157, qcom_geni_serial_isr (the serial at 88c000, wake-enabled, count 200579 ten minutes after boot): the kernel logs 'irq 157: nobody cared' and disables it. So the cluster sleep parameters and the audio DSP cannot be judged yet: the SoC has not been let sleep once. Also seen: a suspend leaves Bluetooth hci0 dead (command tx timeout, Reading QCA version information failed -110) and pm_suspend hangs in hci_resume_dev for minutes - a reboot was needed. The soc-sleeps check says fail (suspends 1, cxsd 0, aosd 0, adsp never asleep). The earlier note that the phone slept the full 60 s was wrong: it read the RTC alarm interrupt count, which fires awake too.

Sources
: /var/tmp/sleep-cycle on the phone; devlab suite run 20261117-115521

About
: deep-sleep

Material
: research/deep-sleep/2026-11-17/

Supersedes
: 2026-11-17-surya-first-s2idle-cycle


<a id="coordinator-how-it-stands"></a>
### coordinator-how-it-stands

Brief
: Coordinator hand-over, 2026-11-17 13:00 UTC: deep sleep first; the keeper is on what wakes the phone; ideal-agent, idealkb and orchestration hold the general and conveyor work.

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: Where does the coordinator's work stand, for a fresh coordinator to take it up without the old session's 840k tokens?

Found
: ROLE: the author's one session for linux-phone-oco - relays his words to the working sessions, keeps docs' records true through tad, routes work by the weakest link; does not build. SESSIONS (list_sessions linked): orchestration local_325ef65d (devlab, the queue, the face, the agent folder, the patrol and the waker); the phone keeper, started by the waker (surya dispatcher) - the one holder of the phone; ideal-agent-ikb local_05818060 (general agent know-how: practices, skills, hooks, housekeeping); idealkb build local_b8ca2fb5 (ideal-knowledge-base; docs and ideal-agent follow it, 0.5.0); phone lover local_f93a213b (bring-up, retired to the upstream queue). IN FLIGHT: deep sleep - after a timed s2idle test surya showed the initramfs gadget (18d1:d001); the author force-rebooted it and the keeper was to check health and record it; the wake IRQ 157 is the Bluetooth UART. Next on the queue: the sensor hub (sensors-and-the-mask, sensors-without-crash), off-state charging; gps-measurable waits on a research session; telegram-at-provisioning waits on Alpine v3.24; upstream-alpine-tqftpserv is a request in the author's name. Ask: tad q phone-queue, tad q next. WAITING ON THE AUTHOR: hands for any phone reboot or physical test; his word before anything goes upstream in his name; whether to start a GPS or sensors research session. STANDING WORDS: nothing depends on ocoeco; everything through tad in docs, idealkb the layer on top; deep sleep first, hard features researched first; a small look around before any change, with sources; summaries kept current; Gmail and Claude Docs off by default; quiet test sounds; fewer, longer-lived roles renewed by hand-over; sign as grenudi upstream; patches by git send-email. DON'T: widen ocoeco for another project; send HTML mail to lists.sr.ht; let a session re-read history to start; devlab kernel remove on entries sharing a release; treat idealkb as tad. Read from the old coordinator's transcript (7007ce97, 12.9 MB, 1,222 turns) by a subagent that returned 2.5 KB; corrected against main: docs follows idealkb 0.4.0 and the bring-up brief is folded into the keeper's.

About
: agent-folder


<a id="orchestration-how-it-stands"></a>
### orchestration-how-it-stands

Brief
: Orchestration hand-over, 2026-11-17 13:00 UTC: conveyor sound, face drawn from docs alone, keeper flow live; open: dispatcher's permission mode, read-weight, start weight on the face.

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: Where does orchestration's work stand, for a fresh orchestration session to take it up without the old session's long context?

Found
: ROLE: owns the conveyor - lab-tools (devlab: phone, kernel try/keep/--dtb/remove, suite put from the Alpine package and the lab's main, gather once quiet, watch, guard for the phone, hazards, keeper lease), device-template, the package conveyor's Alpine path (alpine.yml, v1), docs' face (bin/face-data + engine, no ocoeco) and derive/queries - and tends the agents. Brief: ideal-agent-linux-phone-oco/orchestration.md; method: ideal-agent orchestrate-agents. LIVE: phone keeper flow (phone-keeper.md; lease devlab keeper; queue tad q phone-queue in the author's rank order, deep sleep first; waker = scheduled task linux-phone-keeper-waker titled surya dispatcher, hourly; patrol every 6 h). surya-keeper-2 held the lease at 12:49 UTC. OPEN, the author's: the dispatcher task's permission mode/model (its runs stall on the first prompt; Sonnet 5.5 medium proposed); whether dispatcher runs start from orchestration instead (visible in the left pane); gather.yml in five repos and land's observatory pings (passive ocoeco links, his call); archiving linux-phone-oco/lens; cards waiting: research charging, research GPS, programs on argenv. OPEN, orchestration's: run read-weight on surya-keeper-2's transcript and send ideal-agent its read and first-turn tokens (where read-weight lives was asked of ideal-agent); add read-weight to the patrol round; backlog start-weight-on-the-face, kernel-orphan-modules, health-carry-old-checks, guard items moved to ideal-agent. DO NOT UNDO: suite put reads the lab at main (a stale clone once regressed the phone); gather lands only after 15 quiet minutes; the face's data sorts like observe did and maps a non-linux-phone project field to docs; a kept kernel sorts 1-kept-* after tries; remove keeps shared modules. Notes: side-session-notes/local_12b18c70-.../orchestration-2026-11-17.md.

About
: agent-folder


<a id="2026-11-17-surya-s2idle-bt-blocked-hang"></a>
### 2026-11-17-surya-s2idle-bt-blocked-hang

Brief
: IRQ 157 is the Bluetooth UART; with it blocked, a timed s2idle cycle hung the phone hard (no way back on USB).

Project
: linux-phone-oco/surya-lab

Date
: 2026-11-17

Question
: What holds IRQ 157 up in surya's s2idle, and what does a timed cycle do once Bluetooth is blocked?

Found
: IRQ 157 is the Bluetooth UART: GICv3 hwirq 636 = serial@88c000 (interrupts 0x25c), with hci0 UP RUNNING on it (TX 444 KB, 1847 commands); the console UART ttyMSM0 is a88000, a different device with no wakeup attribute. With bluetooth rfkill-blocked, one timed cycle (soft_connect 0, rtcwake -m freeze -s 60, run as transient unit cycle1) did NOT return: the phone showed the pmOS initramfs gadget (18d1:d001) with no network until the author force-rebooted it (vol-down+power). The previous boot's journal ends at 12:37:25, the cycle script and its log are not on disk, suspend_stats this boot 0/0: so the phone went down hard right at suspend entry, losing the last seconds, and its wake path (the PMIC RTC reads 1970, epoch 1280063 s) did not bring it back. Not known yet: whether the hang is the RTC alarm not waking s2idle, a crash entering s2idle with the audio DSP up, or a reset; and whether the IRQ-157 wake was cured. Health after reboot: healthy, 36 pass, 0 fail. Next try needs a way back not depending on USB networking: a hardware watchdog or timed reboot, the RTC set first, a log written to a place that survives (sync, pstore/ramoops or a serial console).

About
: deep-sleep


<a id="2026-11-17-surya-way-back-inventory"></a>
### 2026-11-17-surya-way-back-inventory

Brief
: surya has the qcom_wdt watchdog, 4 MiB ramoops and a PMIC RTC (1970); the stock watchdog is stopped in late suspend, so no way back covers a hang inside s2idle

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: What does surya have, and what do mainline and others do, for a way back from a suspend that may not return?

Found
: On the phone: qcom_wdt (17c10000.watchdog) with /dev/watchdog0, ramoops 4 MiB reserved at 0x9d800000 with pstore (console 1 MiB), the PMIC RTC reading 1970 and settable with hwclock -w -u; the kernel has no suspend timeout of its own (no PM_DEBUG, hung-task, DPM watchdog). Mainline qcom-wdt.c registers late system sleep ops that STOP an active watchdog in suspend and start it on resume: so a hang before the late phase is covered by a watchdog, one inside s2idle is not. A module with that stop made optional (one parameter, no other change) builds for the running kernel (no MODVERSIONS; vermagic equals uname -r) and loads without a kernel rebuild or reboot-to-test; a reboot undoes it. The RTC alarm cannot be the way back: if the RTC wake does not reach the GIC out of s2idle the phone sleeps for good, which looks the same as a hang. A bite resets the SoC; whether it reaches a normal boot and whether ramoops survives it is what the dry run measures.

About
: deep-sleep

Material
: research/deep-sleep/2026-11-17-way-back/


<a id="2026-11-17-way-back-measured"></a>
### 2026-11-17-way-back-measured

Brief
: A 30 s watchdog fuse resets an idle or hung surya and it boots by itself; the BT-blocked s2idle hang reproduced at once (no log); pstore does not survive the reset

Project
: linux-phone-oco/surya-lab

Date
: 2026-11-17

Question
: Does the watchdog way back work (idle, through a suspend entry, in the hanging cycle), and what log survives?

Found
: Yes. Idle: reset in 31 s, phone back in ~1.5 min with no hands. Probe (Bluetooth on, s2idle 3 s): the patched qcom_wdt kept counting through the suspend and bit 31 s after arming. The cycle with Bluetooth blocked and a 15 s sleep hung again right at suspend entry (the journal ends at the cycle marker, no PM: suspend entry line, suspend_stats 0/0) and the watchdog reset the phone 30 s after arming, back in under a minute more, no hands. The qcom watchdog counts 32 s at most (BusyBox -T 50 is EINVAL; the default 30 s holds), so a cycle's sleep is at most 15 s. pstore/ramoops stayed empty after every reset (the reset does not keep it); the persistent journal, synced before the arm, is the log that survives up to the last second before the hang. The PMIC RTC cannot be set.

About
: deep-sleep

Material
: research/deep-sleep/2026-11-17-way-back/


<a id="2026-11-17-lpoco-health-landscape"></a>
### 2026-11-17-lpoco-health-landscape

Brief
: Tests on phones are small executables printing one line per case, shipped as packages; nothing is compiled on the device - so prebuilt static binaries or shell, not rust-script

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-17

Question
: How are tests organised, shipped and provisioned on Linux phones (postmarketOS, bootrr, LAVA, CI-tron, systemd), and where do rust-script tests plus a bundle crate fit?

Found
: postmarketOS (postmarketos-test aport, initramfs CI hook), bootrr, LAVA and CI-tron share one shape: a test is a small executable, a thin runner prints one pass/fail/skip line per case, the lab collects the lines, device facts live as data (bootrr boards; CI-tron's stored record = our manifest). Nobody compiles on the device. rust-script compiles on first run and needs rust+cargo on the phone (Alpine aarch64: 72 MiB download, 206 MiB installed, plus gcc/musl-dev/llvm-libs, network for crates): fine on the lab, poor on a phone. A bundle crate that depends on tests (nextest discovery, inventory/linkme registries) is sound as a runner design, but registries are unproven on aarch64 musl and link everything into one binary; one binary per test discovered by directory gives the same independence. Provisioning: an apk gives versions, uninstall and signatures at the price of a key and a repository; a lab push is fast and leaves no version record; push while it changes, package when settled. Not known yet: postmarketos-test contents, pmOS test-farm tooling, rust-script cache path, inventory/linkme on aarch64 musl, the systemd claims (read from memory only).

Sources
: pmos-ondevice-ci-mr,bootrr,lava-test-definition,ci-tron-components,rust-script-tool,alpine-rust-aarch64,nextest-how-it-works,alpine-abuild

About
: lpoco-health

Material
: research/lpoco-health/2026-11-17/


<a id="2026-11-17-qca-uart-wake-across-suspend"></a>
### 2026-11-17-qca-uart-wake-across-suspend

Brief
: The suspend wake is irq 158 (GPIO 41, the UART RX line, the serial's dedicated wake irq), not 157; the serial's power/wakeup is its mainline switch

Project
: linux-phone-oco/surya-lab

Date
: 2026-11-17

Question
: What ends surya's s2idle at once with Bluetooth up, and what do mainline and others do for a qca UART Bluetooth across suspend?

Found
: Measured 2026-11-17 on 7.1.0-sm7150-calls+ with ftrace and a kprobe on pm_system_irq_wakeup (suspend-wake-arm-trace.sh in the material): s2idle was ended by irq 158 ('88c000.serial:wakeup', msmgpio 41, edge), armed by dev_pm_arm_wake_irq in the late phase because the platform device 88c000.serial has power/wakeup enabled (qcom_geni_serial sets device_init_wakeup and dev_pm_set_dedicated_wake_irq when the DT gives a second interrupt: the RX pin). The main irq 157 (GIC 636) fires 6 times at the end of qca_suspend, which waits up to 2 s for the chip's sleep indication (hci_qca.c); no 'nobody cared' appeared in these tries. Mainline source read (torvalds/linux master): uart_suspend_port keeps the irq wake only if the tty device serial0 may wakeup (here disabled); hci_qca qca_wakeup() returns device_may_wakeup of the serdev controller and the Bluetooth core then arms a passive scan for suspend, so an RX edge from the chip is a wake by design; the switch is the serial's power/wakeup, a plain sysfs file. With it off for a cycle, s2idle ends by the RTC alarm (RTC counted 7 s for 5 asked, 7 s for 5, 17 s for 15) with hci0 up and scanning after. Not read this time: what postmarketOS ships for qca Bluetooth across suspend (only the earlier note of its hook stopping Bluetooth for the Pixel 3a FastRPC crash). The earlier hang on resume was seen with Bluetooth blocked; not reproduced with it unblocked and wakeup off.

Sources
: https://github.com/torvalds/linux/blob/master/drivers/tty/serial/qcom_geni_serial.c; https://github.com/torvalds/linux/blob/master/drivers/tty/serial/serial_core.c; https://github.com/torvalds/linux/blob/master/drivers/bluetooth/hci_qca.c

About
: deep-sleep

Material
: research/deep-sleep/2026-11-17/

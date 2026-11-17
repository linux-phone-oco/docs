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


<a id="2026-11-17-lpoco-health-landscape"></a>
### 2026-11-17-lpoco-health-landscape

Brief
: Phone tests are small executables printing one line per case; nobody compiles on the device; upstream pmOS covers only initramfs tests today, so we keep their shape and own the runner

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-17

Question
: How are tests organised, shipped and provisioned on Linux phones (postmarketOS, bootrr, LAVA, CI-tron, systemd), where do rust-script tests plus a bundle crate fit, and should we build fully on postmarketOS upstream?

Found
: postmarketOS (postmarketos-test subpackages, initramfs hook), bootrr, LAVA and CI-tron share one shape: a test is a small executable, a thin runner prints one pass/fail/skip line per case, the lab collects the lines, device facts live as data. Nobody compiles on the device. rust-script compiles on first run and needs rust+cargo on the phone (Alpine aarch64: 72 MiB download, 206 MiB installed plus gcc/musl-dev/llvm-libs, network for crates): fine on the lab, poor on a phone. A bundle crate that depends on tests (nextest discovery, inventory/linkme) is sound as design but unproven on aarch64 musl; one binary per test found by directory gives the same independence. Provisioning: an apk gives versions, uninstall and signatures at the price of a key and a repository (ours is published); a lab push is fast and leaves no version record. UPSTREAM (checked 2026-11-17; their sites now redirect to nura.eco): MRs on their GitLab with Alpine-style commit rules and approval rules; on-device tests are postmarketos-test-* subpackages run by an initramfs hook that halts the boot; only kernel/initramfs tests work today, boot and system tests (modem, Wi-Fi, audio, sleep - what we need) are not built; their farm is a CI-tron gateway with one OnePlus 6T, joining is token-gated and undocumented; Python is host-side only (pipeline generation, pmbootstrap) and costs nothing on the phone. Whether rhizcuts handle a GitLab subfolder is not known. Weighed: fully upstream (A), our runner with upstreamable shell files in their shape (B), a different shape (C). Chosen B. Not known yet: pmaports licence/CLA, fork-sync cost, bootrr contribution policy, rust-script cache path, inventory/linkme on aarch64 musl, the systemd claims (memory only).

Sources
: pmos-ondevice-ci-mr,pmos-hardware-ci,bootrr,lava-test-definition,ci-tron-components,rust-script-tool,alpine-rust-aarch64,nextest-how-it-works,alpine-abuild

About
: lpoco-health

Material
: research/lpoco-health/2026-11-17/


<a id="google-walleye-bootloader-first-look"></a>
### google-walleye-bootloader-first-look

Brief
: Pixel 2 in fastboot, read only: unlocked, A/B both slots successful, stock A/B layout, old bootloader with no fastbootd; which Android sits on it is not known yet

Project
: linux-phone-oco/google-walleye-lab

Date
: 2026-11-17

Question
: What does the Pixel 2's bootloader say about the phone, and does Android still sit on it, judged from read-only variables only?

Found
: Measured with `fastboot getvar all` (nothing flashed, booted or set): product walleye, hw-revision MP1, boot-mode FASTBOOT, unlocked yes, secure yes, kernel uefi, bootloader mw8998-003.0085.00, baseband g8998-00034-2006052136, slot-count 2, current-slot a, both slots successful=yes unbootable=no retry-count 0, max-download-size 512 MiB, avb 1.0.0 with user-settable key set, battery 4344 mV. Partitions listed with a size: boot_a/b 32 MiB raw, system_a/b 2560 MiB ext4, vendor_a/b 500 MiB ext4, userdata about 53 GiB ext4. is-userspace, slot-suffixes, snapshot-update-status and the sizes of vbmeta, dtbo and modem are not offered: an old bootloader, no fastbootd.
Inference: both slots carry the flags Android's boot control leaves after a good boot, and the partition table is the stock A/B layout, so an Android has run on each slot; userdata of 53 GiB fits the 64 GB model. Which Android, whether it still boots and whether userdata holds data is not known yet - the bootloader cannot say.
Not known yet: whether `fastboot boot` accepts a kernel built by us, and what it does afterwards; every Android reference measurement (sleep current, audio levels, sensors, boot time), backlog google-walleye-lab/android-reference-walleye - it needs the author to boot slot a, enable USB debugging and say when the phone is at the home screen; the paragraph is in the material README.
Next: a first `fastboot boot` try needs a kernel from the research sessions and devlab's fastboot mode (backlog lab-tools/devlab-fastboot-mode). The IMEI the bootloader prints was left out of the kept output.

About
: google-walleye

Material
: research/google-walleye/2026-11-17/


<a id="dropping-the-lpass-macros-hw-votes-at-runtime"></a>
### dropping-the-lpass-macros-hw-votes-at-runtime

Brief
: Dropping the LPASS macros' hw votes at runtime suspend does not wake the audio DSP's sleep: adsp stays 0, with or without it

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: Which LPASS vote keeps the audio DSP from sleeping with no stream open?

Found
: Not the macros' macro/dcodec votes alone: with them released at runtime suspend (patch kept in the material, upstream-aligned) a quiet cycle 15 bt-on still counts adsp 0, cxsd 0, aosd 0; stopping the voice, sensors and sound-server services changes nothing; the kept kernel has no stay_awake. Linux itself holds CX through the two active UARTs. Not known yet: what the DSP waits for (its own firmware, sensors PD, a vote by another subsystem).

About
: deep-sleep

Material
: research/deep-sleep/2026-11-17/


<a id="google-walleye-vendor-kernel-hardware"></a>
### google-walleye-vendor-kernel-hardware

Brief
: What the vendor's GPL kernel says walleye's hardware is: Samsung S6E3FA5 panel, Synaptics touch, WCD934x + TAS2557, DRV2624, PMI8998 charger and gauge, NQ NFC, WCN3990, sensors behind the SLPI

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: Which chip is each part of the Pixel 2 (walleye) and how is it wired, by Google's GPL wahoo kernel device tree and the mainline port's tree?

Found
: Read from the LineageOS copy of Google's wahoo kernel (4.4, branch lineage-22.2) and kcxt/linux-wahoo wahoo/5.17; observed facts only, nothing copied; table in research/google-walleye/2026-11-17/vendor-kernel-hardware-inventory.md.
Walleye is the HTC-built half of the pair: its files are under dts/htc/ and called "muskie"; one base plus one of two overlays by board revision (xa/xb/xc or xd/xe/a; our MP1 maps to one of them - not known yet). SoC MSM8998 v2.1 with PM8998, PMI8998 and PM8005.
Parts: panel Samsung S6E3FA5 5.0 in 1080x1920 command mode, 4 DSI lanes, reset GPIO94, TE GPIO10, rails PM8998 L14 1.8 V and L22 3.0 V, backlight by DCS (no WLED), always-on modes. Touch Synaptics DSX at I2C 0x20 on the BLSP1 QUP5 bus (GPIO87/88), IRQ GPIO125, reset GPIO89. Audio: WCD934x "Tavil" codec on SLIMbus, TI TAS2557 stereo speaker amp at I2C 0x4d, no jack; NXP TFA98xx amps are in the tree but disabled. Haptics TI DRV2624 (LRA 155 Hz, I2C 0x5a, reset GPIO95). LED: TI LP5562 on early revisions, PMI8998 RGB on later. Charger: PMI8998 SMB2 with Type-C PD, TPS61099 for USB host power, NXP PTN36241G redriver. Fuel gauge: PMI8998 FG gen3 with HTC battery module, 2700 mAh, 4.4 V. NFC: NXP NQ-class at 0x28 plus PN81A secure element on SPI. Fingerprint FPC1020 family (IRQ GPIO86, reset GPIO128). Wi-Fi and Bluetooth: Qualcomm WCN3990 (Bluetooth HCI on BLSP1 UART3). Cameras: two CCI sensors, rear with autofocus, OIS, EEPROM and flash, laser ranger at I2C 0x29; the sensor chips are not named in the tree (public specs: Sony IMX362 rear, IMX179 front). Pixel Visual Core ("Easel") on PCIe 0 with a BCM15602 PMIC and SPI. Storage UFS. Sensors (IMU, magnetometer, barometer, light, Hall) are not in the application processor's tree: the SLPI sensor-hub DSP owns them, firmware proprietary.
For a phone with no display: stock describes a RAM console (ramoops) at 0xa1100000, 2 MiB, plus an alternate at 0xa3800000; the mainline port uses 0xa1810000 instead and boots with console on ttyMSM1 (BLSP2 UART1) and a USB-gadget serial ttyGS0 - which address survives a reset on this phone is not known yet.
The mainline port's walleye file is 13 lines and sets no panel (the shared file's panel is taimen's LG one), and enables UFS, USB peripheral, one DSI, GPU, Wi-Fi, SLPI and ADSP, regulators - nothing for touch, audio, haptics, NFC, gauge, charger, cameras, sensors.
Not known yet: camera and sensor chips on walleye itself, touch controller model, codec exact part, fingerprint wiring, Active Edge sensing, UART test pads, which overlay MP1 uses.

Sources
: lineageos-kernel-google-wahoo,kcxt-wahoo-5-17-dts,ifixit-pixel-2-xl-teardown,aosp-wahoo-kernel

About
: google-walleye

Material
: research/google-walleye/2026-11-17/


<a id="google-walleye-android-reference-public"></a>
### google-walleye-android-reference-public

Brief
: What 'as good as Android' means on the Pixel 2 by public sources: 2700 mAh, stereo speakers no jack, a 10-sensor set, Doze; no public standby current

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: What does Android on the Pixel 2 give, by public specifications, that a Linux phone is measured against (sensors, sleep, audio, battery)?

Found
: Public sources only (table in research/google-walleye/2026-11-17/android-reference-public-specs.md). Android reference: 5.0 in AMOLED 1080x1920, 2700 mAh, two front stereo speakers about 89 dB(A), no 3.5 mm jack (USB-C audio, Bluetooth 5 with aptX HD), 12.2 MP rear with OIS and laser focus, 8 MP front, LTE Cat. 15, NFC, eSIM plus nano-SIM, rear fingerprint, Active Edge squeeze. Sensor set to count: accelerometer, gyro, magnetometer, barometer, proximity, light, Hall, squeeze, step counter and detector, behind a sensor hub. Chips (only from the Pixel 2 XL teardown, so likely not stated for walleye): LSM6DSM IMU, AK09915C magnetometer, BMP280 barometer, AK8789 Hall, TMD4903 light, VL53L0X ranger, TAS2557 amp, DRV2624 haptics; the vendor kernel confirms TAS2557, DRV2624 and a ranger for walleye. Android battery runs (Notebookcheck): idle Wi-Fi off 24 h 17 min, web 9 h 35 min, video 9 h 24 min; field 15 to 17 h unplugged a day. Doze (when unplugged, still, screen off): network suspended, wake locks ignored, alarms and jobs deferred, maintenance windows spread out. Last software Android 11, build RP1A.201005.004.A1, support ended October 2020.
Not known yet: standby current per hour (none published), real sensor list and rates on walleye, charger wattage, speaker level under a test tone. Only Android booted on our phone can give these (backlog google-walleye-lab/android-reference-walleye; needs the author).

Sources
: wikipedia-pixel-2,notebookcheck-pixel-2,ifixit-pixel-2-xl-teardown,lineageos-wiki-data-walleye,pixel-2-final-update,droidlife-pixel-2-battery,android-doze-standby

About
: google-walleye

Material
: research/google-walleye/2026-11-17/


<a id="google-walleye-how-others-booted"></a>
### google-walleye-how-others-booted

Brief
: Only taimen reached a shell on mainline (USB gadget console, black screen, a special dtbo); walleye has a tree nobody reports booting; a USB-C UART cable is tested on walleye

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: How did others boot Linux on the Pixel 2 family (boot image, A/B, fastboot boot, dtbo), what boots, and how did they reach a phone with no display?

Found
: Only the Pixel 2 XL (taimen) is reported to have booted mainline, by kcxt (Caleb Connolly) on an out-of-tree 5.10 to 5.17 fork, 2020 to 2022: black screen, USB networking to a shell, flashing works; a March 2021 mainline submission shows no sign of being merged. Walleye has a 13-line tree in the same fork and no report that it boots; neither phone is in pmaports (Pixel 3, 3 XL, 3a are). Ubuntu Touch (Halium 9, Android 4.4 kernel) has only an abandoned 16.04 port for walleye, with boot loops and no USB networking in the forum threads read.
How the no-display phone was reached: USB peripheral mode only (SuperSpeed dropped), kernel console on a USB serial gadget ttyGS0 plus ttyMSM1 earlycon, clk_ignore_unused; a UART through the USB-C sideband pins ('Android Debug Cable', 115200 baud) which the pmOS wiki lists as tested with walleye - enabled with `fastboot oem uart enable`; pstore only partly worked. What the bootloader wants (XL only, read): a dtbo partition holding an overlay with id 2704 (0xa90) or the bootloader refuses to boot; pmaports' Pixel 3 packages append the dtb to the kernel (4096-byte pages, kernel offset 0x8000, ramdisk 0x1000000), LineageOS uses Image.lz4-dtb with recovery in the boot partition and A/B, 8 MB dtbo. Detail and URLs in research/google-walleye/2026-11-17/how-others-booted-wahoo.md.
Not known yet: whether this phone's bootloader accepts `fastboot boot` of our image; the dtbo id walleye needs (the README is XL only; changing dtbo writes to the phone); whether `fastboot oem uart enable` only sets a RAM flag or writes something (until known, it is a change to the phone); the boot header version; slot handling for a Linux boot; any report for the small Pixel 2 booting mainline.
Ways forward: (1) read walleye's dtbo overlay ids without writing (from Android if it boots, or Google's factory image, a proprietary download - decision needed); (2) try a first `fastboot boot` of a kernel with appended dtb and a USB-gadget serial console once devlab's fastboot mode exists; (3) build the USB-C debug cable and enable the UART only after a decision on the oem command.

Sources
: pixel2xl-pmos-wiki,kcxt-linux-wahoo,kcxt-wahoo-5-17-dts,kcxt-dtbo-wahoo-mainline,lkml-taimen-dts-patch-2021,pmos-wiki-serial-cable,android-debug-cable-howto,pmaports-google-devices,lineageos-walleye-install,ubuntu-touch-walleye,ubports-walleye-forum,halium-usbnet-debug

About
: google-walleye

Material
: research/google-walleye/2026-11-17/


<a id="orchestration-2026-11-17-evening"></a>
### orchestration-2026-11-17-evening

Brief
: Orchestration hand-over, 2026-11-17 evening: try read by initramfs, phone-next, fastboot by serial landed; owed: a role keeper's read-weight, trimming the briefs, kernel-orphan-modules.

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: Where does orchestration's work stand, for a fresh orchestration session to take it up without this session's long context?

Found
: ROLE: orchestrator (ideal-agent card; brief ideal-agent-linux-phone-oco/orchestration.md, which now opens with Role/Name). Owns the conveyor - lab-tools (devlab; lpoco-health's packaging and the Alpine path are the conveyor's, its code is lpoco-health's), device-template, docs' face and its queries - and tends the agents. Notes: side-session-notes/local_325ef65d-55c6-44bd-85b9-53de24869d6e/orchestration-3.md.
LIVE: surya lane - waker scheduled task linux-phone-keeper-waker (hourly) only nudges the surya coordinator (local_0ecf107e), reading tad q phone-next; the coordinator starts keepers, which take tad q phone-next (one row). Walleye lane - walleye coordinator (local_7fb92f70); google-walleye (FA81N1A00790) sits in fastboot; devlab fastboot state|getvar|boot now|reboot now, by serial. devlab-watch@surya-lab runs ~/.local/bin/devlab built from ~/Projects/linux-phone-oco/lab-tools at main (1b35fc6); suite put --runner builds in that tree, so build devlab only from it. lpoco-health 0.1.7 published by the conveyor (lpoco-health-v tags); #78's provides + old-name links ship with the next release.
LANDED THIS TURN OF THE ROLE (2026-11-17): lab-tools 71 (kernel try reads the booted entry off cmdline initrd=initramfs-NAME), 72 (suite put --runner builds the runner), 79 (fastboot by serial; flash only with [fastboot] writes = true; guard refuses raw fastboot but devices/getvar/help); device-template 3; docs 202 (queries/phone-next.sql, 603 B vs 14.9 KB), 224 (decision 2026-11-17-fastboot-by-serial-writes-by-manifest).
OWED: (1) the read-weight of the first keeper the surya coordinator starts with Role: keeper / Name: lines (it was asked to send the session id) -> ideal-agent-roles local_dd7369b2, backlog measure-a-role-start; the 12:33 scheduled keeper read 75,649 tok / 39 KB, not comparable (route, connectors). (2) trim the briefs of what the role cards now say (renew thresholds, the read-only-when shape, recording rules said three times); start-weight after docs 230: phone-keeper 25.6 KB, surya lane 21.1, coordinator 22.4, orchestration 27.5. (3) lab-tools backlog by the weakest link: kernel-orphan-modules next (health-*, hear-* are lpoco-health's).
WAITS ON OTHERS: surya-lab surya-fastboot-serial (phone queue: devlab flash refuses surya until its manifest says [fastboot] serial, likely dc21014b unread, and writes = true); google-walleye-lab [fastboot] serial line (walleye coordinator's). The author's: dispatcher permission mode/model, gather.yml in five repos, archiving linux-phone-oco/lens, cards for charging, GPS, programs on argenv.
DO NOT UNDO: suite put takes the Alpine package and reads the lab at main; gather lands only after 15 quiet minutes; a kept kernel sorts 1-kept-* after tries; remove keeps shared modules; every fastboot call names its serial and nothing is written over fastboot without writes = true; kernel try trusts LoaderEntrySelected, then the running initramfs, then the release name.
SIGNS: land is killed (143) when its wait outlives the caller's timeout - run it in the background; make verify refreshes docs/ and IKB.md, run it twice or render first; a hook from before 0.3.2 re-roles a running session on any quoted Role: line - do not quote Role lines to older sessions.

About
: agent-folder

Supersedes
: orchestration-how-it-stands


<a id="android-reference-walleye-measured"></a>
### android-reference-walleye-measured

Brief
: Android on the Pixel 2, read only: LineageOS 15 on stock vendor, 37 sensors, 12 s to system ready; sleep current and audio levels not known yet

Project
: linux-phone-oco/google-walleye-lab

Date
: 2026-11-17

Question
: What does Android do on the Pixel 2 as the author left it - build, sensors, battery, boot time, audio - measured read-only, with nothing installed or changed?

Found
: Measured with plain adb reads, then back to fastboot with the slot flags unchanged: LineageOS 15 (Android 15, userdebug, built 2025-12-05, patch 2025-11-01) on a stock Android 11 Pixel 2 vendor image, kernel 4.4.302, MSM8998 (8 cores), 3.7 GB RAM, 51 GB data, 1080x1920. Sensorservice lists 37 sensors (LSM6DSM, AK09915, TMx490x, BMP280, AK8789, Elmyra, camera sync). Battery learned 2709 mAh of 2805 mAh design (96.6 %), 922 cycles. Boot, from the phone's own event log: system server at 8.3 s, package manager ready 10.1 s, ams_ready 12.0 s, boot animation done 17.8 s (kernel start to there; the bootloader stage is not counted). Audio config: stereo speaker output at 48 kHz.
Not known yet: sleep current (the phone was charging on USB, Wi-Fi was on, no meter; batterystats' long-run counters contradict themselves so no figure is given), audio levels (no tone source, no microphone), boot time from power-on, thermal limits, the real partition table. Needs next: a USB power meter or the battery path to measure standby with radios as stated, and a tone source plus a lab microphone.
Lesson for the keeper: adb authorization on this phone was lost at reboot until the author tapped Allow again, and the lab's adb server had to be restarted to see it; no reboot should be planned before "Always allow" is confirmed.

Sources
: google-walleye-bootloader-first-look

About
: android-reference

Material
: research/android-reference/2026-11-17/


<a id="walleye-mainline-prior-art"></a>
### walleye-mainline-prior-art

Brief
: No Google board in mainline v7.3; kcxt's walleye dts is a 13-line stub, porthole's taimen kernel (7.2.2 + 263 patches) is far ahead and carries an untested walleye board file

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: What exists for the Pixel 2 (walleye) on mainline: kcxt/linux-wahoo, the other trees, which nodes work, what is missing?

Found
: Mainline (v7.3, v7.4-rc3 out) has no msm8998-google-* file and nothing was submitted to the lists that a search finds.
kcxt/linux-wahoo (last push 2022-02-27, branch wahoo/5.17 = 5.17 fork of the MSM8998 community tree): msm8998-google-wahoo.dtsi (shared) + taimen.dts (LG SW43402 panel, qcom,msm-id 0x124 0x20001) + walleye.dts, which is 13 lines: model and compatible only, no qcom,msm-id, no panel or battery. The shared dtsi enables: UART (blsp2_uart1 earlycon), Bluetooth, pm8998/pm8005/pmi8998 regulators, qusb2phy + dwc3 as USB 2.0 peripheral only (SuperSpeed does not work), UFS + PHY, Wi-Fi, adsp/slpi/mss remoteprocs with wahoo firmware names, mdss/dsi0/DSC panel, Adreno 540 (GPU voltage raised as a hack), ramoops at 0xa1810000. Its bootargs in the dts is wrong with this bootloader (see walleye-first-boot-recipe). Per the Nura wiki (taimen, kernel 5.10-rc2): boots, USB networking works enough for a shell, needs clk_ignore_unused; display broken, battery broken, everything else untested.
porthole-dev/pmaports taimen-bringup (2026-10): kernel = kernel.org v7.2.2 + 263 numbered patches; taimen is a daily-driver port (display, GPU, touch, haptics, amps, wifi, modem, sensors, camera, suspend). For walleye only patch 0029: a 33-line board dts with a 2700 mAh battery taken from the published spec, "nobody has run this branch on an actual walleye device yet"; "no dedicated display or camera overrides" - walleye's panel and touch are not in it.
pmaports/Nura masters: no walleye or taimen package.
Missing for walleye (all unknown on the phone): display (S6E3FA5 command-mode panel: no mainline driver), touch (Synaptics RMI: driver in mainline, node missing), USB (taimen only), UFS (taimen only), Wi-Fi, modem, sound (amps differ from taimen), haptics (DRV2624, no mainline driver), fuel gauge (out of tree).

Sources
: kcxt-wahoo-5-17,kcxt-linux-wahoo,porthole-pmaports,pixel2xl-pmos-wiki,linux-v7-3-msm8998,pmaports-google-devices

About
: google-walleye

Material
: research/google-walleye/2026-11-17-mainline/


<a id="walleye-first-boot-recipe"></a>
### walleye-first-boot-recipe

Brief
: First boot: v0 boot.img, dtb appended with qcom,msm-id, no bootargs in the dts, USB 2.0 gadget instead of a display; whether fastboot boot works with a mainline dtb and the dtbo is not known

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: What does a first mainline boot of the Pixel 2 need, and what can and cannot fastboot boot do on this bootloader?

Found
: Image: boot header v0, base 0x0, kernel offset 0x8000, ramdisk 0x1000000, tags 0x100, page 4096 - verified by porthole against the stock TAIMEN boot.img; LineageOS's wahoo board config says tags 0x01E00000 / ramdisk 0x02000000 instead: two sets are reported, walleye's own stock boot.img header decides (not read yet). Boot partition is 32 MiB (getvar boot_a 0x2000000), max-download-size 0x20000000: size is no limit. The DTB is appended to the kernel; it must carry qcom,msm-id = <0x124 0x20001> (taimen has it, kcxt's walleye does not).
Cmdline (porthole): clk_ignore_unused ignore_loglevel panic=10 earlycon=msm_serial_dm,0xc1b0000 qcom_wdt.arm_on_probe=1 watchdog.open_timeout=300 reboot=w; kcxt adds console=ttyGS0,115200. No bootargs/stdout-path in the DTS: ABL appends the boot.img cmdline with fdt_appendprop_string, and a pre-existing bootargs hides it.
Display: command-mode panels, so no scanned-out framebuffer for simple-framebuffer; the first sign of life must be USB. Path: dwc3 peripheral, high-speed only, SuperSpeed PHY dropped, qcom,select-utmi-as-pipe-clk, assigned-clock-rates 19.2/60 MHz (works on taimen); initramfs with a configfs gadget (ACM console + RNDIS/ECM) and telnet/ssh on 172.16.42.1 (devlab's address). pstore: ramoops 0xa1810000/0x200000; a cold reset scrambles it, so the warm-reset/watchdog parameters matter. UART: the Pixel debug cable (see google-walleye-how-others-booted; fastboot oem uart enable is a change to the phone, undecided).
Bootloader (keeper's read-only getvar, google-walleye-bootloader-first-look): mw8998-003.0085.00, hw-revision MP1, unlocked, A/B both slots successful, avb_version 1.0.0, kernel:uefi, no fastbootd.
fastboot boot: TWRP's own instructions for walleye use it (xdaforums), but another report could not boot TWRP that way, and nobody reports a mainline kernel booted from RAM on any Pixel 2: NOT known. Also not known: whether ABL applies the stock dtbo of the active slot to a mainline DTB (taimen's bootloader refuses a kernel unless dtbo holds overlay id 2704 - kcxt's README, taimen only; porthole flashes its own stub into slot b), and what vbmeta/AVB does to an unsigned image on an unlocked phone. One try through devlab (walleye-first-fastboot-boot) answers all three; a refusal is an answer, and the stub dtbo is a write (the author's decision; backlog walleye-dtbo-overlay-id).

Sources
: porthole-pmaports,pixel2xl-pmos-wiki,kcxt-wahoo-5-17,kcxt-dtbo-wahoo-mainline,lineageos-kernel-google-wahoo,twrp-walleye-fastboot-boot,kerneltoast-wahoo-kernel,lkml-taimen-dts-patch-2021

About
: google-walleye

Material
: research/google-walleye/2026-11-17-mainline/


<a id="walleye-shortest-path"></a>
### walleye-shortest-path

Brief
: Shortest honest path: a tiny walleye dts on mainline v7.3 (v7.2.2 fallback), USB gadget initramfs, one fastboot boot; porthole's 263 patches come later, one at a time

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: What is the shortest honest path to a mainline fastboot boot of the Pixel 2, and which kernel is built first?

Found
: Path: (1) kernel.org v7.3 + a new msm8998-google-walleye.dts (own file, GPL, from the wahoo dtsi, carrying qcom,msm-id) with only what a USB-reachable initramfs needs: reserved memory, pm8998/pm8005/pmi8998 RPM regulators, qusb2phy + dwc3 peripheral, ramoops, UART; UFS, display, GPU, wifi, remoteprocs disabled (no firmware, no storage touched). (2) v0 boot.img with the dtb appended. (3) initramfs with a USB gadget. (4) one fastboot boot through devlab; proof = host sees the gadget and answers on 172.16.42.1. Display, touch, UFS, charger follow, each by the bring-up method.
Rejected: starting from porthole's 263-patch kernel (taimen-shaped, hard to tell what a walleye failure comes from; kept as the fallback and the patch source); kcxt's 5.17 (old, bootargs in the dts, no msm-id, unmaintained); a display-first or simple-framebuffer start (command-mode panel: no framebuffer to reuse); flashing dtbo/boot first (breaks decision walleye-fastboot-first; only if the one try shows ABL needs the stub dtbo, and then the author decides).
Unknown: see walleye-first-boot-recipe (walleye boot.img header, dtbo/ABL with a mainline dtb, vbmeta, whether a mainline kernel boots from RAM on a Pixel 2 at all).

Sources
: porthole-pmaports,kcxt-wahoo-5-17,linux-v7-3-msm8998,twrp-walleye-fastboot-boot

About
: google-walleye

Material
: research/google-walleye/2026-11-17-mainline/


<a id="walleye-mainline-reuse"></a>
### walleye-mainline-reuse

Brief
: Mainline v7.3 already holds MSM8998 DPU, DSI PHY, Adreno 540, UFS, dwc3, charger and RMI4 touch; the Pixel 2 needs a board file plus an S6E3FA5 command-mode panel driver, fuel gauge, DRV2624, TAS2557

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: Which MSM8998 boards are in mainline, and which nodes and drivers can walleye reuse; what do its parts need?

Found
: Boards in v7.3: msm8998-mtp, OnePlus 5/5T (cheeseburger/dumpling, common dtsi), Xiaomi Mi 6 (sagit), Sony Xperia XZ Premium/XZ1/XZ1 Compact (yoshino lilac/maple/poplar), F(x)tec Pro1, HP Envy x2, Asus Novago, Lenovo Miix 630. Best templates: OnePlus common dtsi (blsp1_i2c5 touch, gpio-keys, ufs, usb3 peripheral, wifi, ramoops, zap shader region, qcom,msm-id 292 0x20001 "required for bootloader to select correct board") and the Mi 6 (same i2c5 touch bus).
SoC pieces already in msm8998.dtsi: ufshc+ufsphy, dwc3+qusb2, mdss/dpu/dsi0+10nm PHY, adreno-540.1, gpucc, wcn3990 wifi, smmus, mss/adsp pas remoteprocs, pinctrl; pmi8998 charger + rradc + wled + lpg + flash; drivers rmi_i2c, rmi_f1a, qcom_smbx, stmfts.
Walleye parts (GPL downstream dtsi): Samsung S6E3FA5 5.0" 1080x1920 DSI command mode (TE on, reset gpio94, rails PM8998 L14 1.8 V and L22 3.0 V, DCS backlight: no WLED and no LAB/IBB, which taimen needs) - mainline has s6e3fa7/fc2x01/ha2/ha8 but no fa5, an out-of-tree fa5 driver exists (OnePlus 5, Jami Kettunen) and porthole's sw43402 shows the command-mode + DPU work that is needed; touch Synaptics RMI on i2c5@0x20, irq gpio125, reset gpio89, l6/l28 rails -> node only; haptics DRV2624 (driver out of tree, porthole 0018); speaker amp TI TAS2557 as on taimen (TFA98xx is in the tree but disabled, an older revision); codec WCD934x on SLIMbus; keys gpios 40/126/121; battery 2700 mAh/4.4 V; NFC PN81A, fingerprint FPC1020 later. Fuel gauge qcom_fg out of tree (porthole 0022).
Reuse rule: take the board file from the GPL wahoo dtsi (Caleb Connolly, Giuseppe Maggio; licence kept), patches from porthole one at a time when a part needs one.

Sources
: linux-v7-3-msm8998,kerneltoast-wahoo-kernel,lineageos-kernel-google-wahoo,kcxt-wahoo-5-17,porthole-pmaports

About
: google-walleye

Material
: research/google-walleye/2026-11-17-mainline/


<a id="2026-11-17-cleanroom-agents"></a>
### 2026-11-17-cleanroom-agents

Brief
: Clean room with agents works as an input wall (observer, scrubber, implementer, spec rows with evidence); walleye needs it for few MSM8998 parts; GPL vendor source needs none

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: How is clean-room reverse engineering best done with AI agents, and how should walleye's bring-up apply it?

Found
: Agents are now near-human at reading binaries (arXiv 2610.14960; 2608.11469 SRE-Bench: best agents solve ~27-32% of realistic ones), but no paper yet covers clean-room hardware bring-up; the practice does. AI "clean rooms" (ArtCraft: a rule on inputs; chardet 7.0: disputed) cannot prove the wall by the model's mind, only by what it was shown - so use an INPUT wall: observer (traces on the stock system, GPL vendor kernel source, public specs) writes spec rows with evidence kind + hash; a separate scrubber checks them for expression; the implementer sees only accepted rows, public specs and mainline; commits cite spec ids; per-session input log and taint register. Tools: mmiotrace/ftrace/dynamic debug/regmap/QMI logs/debugfs on the running stock system (Nouveau, Asahi m1n1 tracing, freedreno), never disassembly or vendor binaries (Asahi: 'without looking at the code'). Walleye: most MSM8998 parts are upstream and need no clean room; likely only panel init, sensor hub, audio calibration/topology, camera, vendor protocols. GPL vendor kernel (android-msm-wahoo, kcxt/linux-wahoo) is read and ported with licence kept - no clean room. EFF: clean room is good practice, not a legal requirement; no court has ruled on AI clean rooms. Not legal advice. Full proposal, table of parts and record design in the material.

Sources
: eff-reverse-engineering-faq,asahi-progress-2021-08,nouveau-mmiotrace,kyvero-clean-room-manual,wordcraft-agents-md,reversa-2605-18684,rare-2607-12507,humans-vs-machines-re-2610-14960,chardet-relicense-register,postmarketos-qualcomm-mainline

About
: google-walleye

Material
: research/cleanroom-agents/2026-11-17/


<a id="2026-11-17-adsp-stopped-cx-aosd-ddr-stay-0"></a>
### 2026-11-17-adsp-stopped-cx-aosd-ddr-stay-0

Brief
: With the audio DSP stopped - or all three DSPs - a measured cycle still counts cxsd 0, aosd 0, ddr 0: the audio DSP is not what holds the SoC

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: Which vote or clock keeps the audio DSP awake, and is the audio DSP what stops CX, AOSS and DDR from sleeping?

Found
: Measured 2026-11-17 on the kept kernel (7.1.0-sm7150-calls+, patched qcom_wdt), cycle 15 bt-on, as systemd-run units, nothing polled during a cycle.
(1) The DSP side, read awake: adsp, cdsp and modem remoteprocs running; qcom_stats adsp 0 (cdsp 56, modem 1798 counted): the three share one reader, so the layout is right for the subsystems; whether the ADSP firmware fills its own sleep-stats entry at all is not known yet. The only LPASS clocks enabled: LPASS_HW_MACRO (rx, tx macros and codec), TX_CORE_MCLK/NPL (rx, tx macros), fsgen - the macros' own clocks; the previous keeper's vote release did not change adsp.
(2) Others, read awake: genpd cx on at performance 256 with the two UARTs (88c000 Bluetooth, a88000) as devices; mx on 256; usb30_prim_gdsc on (USB gadget, the lab's link: qns_llcc/ebi avg 240000 peak 700000 are the USB's vote, cut by the cycle's gadget disconnect); ufs_phy_gdsc on; interconnect: only USB and the UARTs vote with bandwidth, the CPUs 8.7 GB/s peak; the PSCI cluster domain has states S0 (6 ms residency), S1 (8.5 ms) and S2 (9.8 ms): S2 entered once during the one cycle of that boot (s2idle count 1), so the cluster reached its deepest state.
(3) Floor test 1: adsp stopped for the cycle (offline, no LPASS clock left, no APR devices; the teardown logged a clk_unregister warning from tx_macro, harmless): cxsd 0, aosd 0, ddr 0 after. Floor test 2: adsp, cdsp and modem all offline: cxsd 0, aosd 0, ddr 0 after. Started again after: all three running; the sound card needed a clean reboot, then the suite: 35 pass, 0 fail.
Meaning: the audio DSP is not the (only) thing keeping CX, AOSS and DDR up: with no DSP running at all they still do not count. The cause is on the Apps side or in AOSS/RPMh: the sleep set (rpmh flush at cluster power-off), the cluster's PSCI state parameter (sleep-cluster-params), the remaining CX vote of the two UARTs, or WLAN/UFS. Not known yet: which; this kernel has no RPMh trace points (events: clk, regulator, interconnect, power/psci_domain_idle_enter only).
Not measured: a cycle with the UARTs closed; the PSCI state taken at the suspend; the live rpmh sleep-set contents.

About
: deep-sleep

Material
: research/deep-sleep/2026-11-17-adsp-floor/


<a id="2026-11-17-cluster-params-clean-yet-no-collapse"></a>
### 2026-11-17-cluster-params-clean-yet-no-collapse

Brief
: On the cluster-params dtb the cluster entered 0x4100c244 for a real 15 s s2idle, RPMh CX/MX at 0 and the sleep set clean but SH0 x=1,y=3; cxsd, aosd, ddr still 0

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: With surya's own cluster sleep parameters booted, does a timed cycle collapse CX/AOSS/DDR, and if not what is held?

Found
: See notes.md: cluster S2 used (genpd idle_states), wake by the RTC alarm after 15 s (trace clock stops in s2idle), CX/MX active votes 0, sleep set all zero except SH0 (x=1,y=3), stats cxsd/aosd/ddr 0 in 8 cycles. Cause not found in genpd, clk, icc or rpmh traces; candidates untested: SH0 owner, qcom_aoss prevent_* knobs, XO/VRM votes, USB gadget, display RSC.

About
: deep-sleep

Material
: research/deep-sleep/2026-11-17-cluster-params/


<a id="walleye-first-fastboot-boot-tries"></a>
### walleye-first-fastboot-boot-tries

Brief
: First fastboot boot tries on the Pixel 2: try a stayed in fastboot, try b left it and Android came back on slot b with slot a flagged unbootable; our kernel's life is not known yet

Project
: linux-phone-oco/google-walleye-lab

Date
: 2026-11-17

Question
: What did the Pixel 2 do when given the builder's first boot images with fastboot boot, and what did it leave behind?

Found
: Try a (boot-a.img, taimen offsets): sent, the phone stayed in fastboot, no USB event on the host for 60 s. Try b (boot-b.img, LineageOS offsets): image accepted, "Booting" then the phone left USB at once; 20 s later it was Android's adb gadget (18d1:4ee7), Android on slot b (an older LineageOS build than slot a's), boot reason reboot,ota. Nothing of ours answered: no serial port, no RNDIS/ECM, 172.16.42.1 silent, pstore empty. Whether our kernel ran is not known yet.
The bootloader's A/B logic changed the state, with no write command from us: after try b the phone reports current-slot b and slot a unbootable = yes (first look: slot a current, unbootable no). Slot a's Android is presumably intact; restoring the flags is `set_active a`, a write that needs a recorded decision and the author's word. devlab called try b "refused", though the host log shows the phone left fastboot; it should read slot flags before and after a try and say what changed. Until the author decides about the slot flags no further try should be made.

About
: walleye-first-fastboot-boot

Material
: research/walleye-first-fastboot-boot/2026-11-17/


<a id="2026-11-17-floor-research"></a>
### 2026-11-17-floor-research

Brief
: Nobody shows a phone-class SM7150/8150/845 reaching cxsd/aosd on mainline; surya's DSP floor tests were stops not never-started, holders' clocks never read; six ranked holders

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: Why do cxsd, aosd and ddr never count on surya after a real s2idle, and what is the way to the SoC floor?

Found
: See the material. Counters are the SoC's own (rpmh-stats; no client-votes field on this layout), so they are valid but name no culprit. It can be done on mainline s2idle: Acer Aspire 1 (sc7180, OSI) counts all three; X1E s2idle reaches 99.9% after subtracting icc-bwmon, PCIe, LPASS macro and console votes (AOSD only with the CDSP running); sm8250 RP5 stays 0/0 with camcc and DSI clock votes and the ADSP up. No system-level mode is missing: surya's cluster state equals downstream's and sm8150's, apps_rsc matches sc7180. Surya's weak points: the floor tests stopped DSPs that had run (their RPMh votes may stay latched) instead of never starting them; clk_summary was never captured (files empty) and the kernel command line (clk_ignore_unused?) is unrecorded; tag-7 icc votes and the a88000 serial vote through suspend (SH0 x=1,y=3). Ranked: DSP latched votes, unclaimed bootloader clocks, peripheral votes (USB/UFS/WLAN/UARTs), SH0 owner, AOSS prevent knobs, counter validity.

Sources
: floor-travkin-aspire1,floor-x1e-s2idle,floor-rp5-sm8250,floor-sleep-stats-v12,floor-osi-s2idle-rfc,floor-floral-pm,floor-oneplus6-stats

About
: deep-sleep

Material
: research/deep-sleep/2026-11-17-floor-research/


<a id="2026-11-17-sensorspd-probe-still-writes"></a>
### 2026-11-17-sensorspd-probe-still-writes

Brief
: Registry probe on the kept kernel: configs at mtime 1230768000, sensorspd alone unmasked - the DSP still writes (temp.json, sns_reg_version) and crashed 7 times in 150 s

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: Does the ADSP still write the registry once the 46 sensor configs match its record (sensors-and-the-mask, one boot, kept kernel 7.1.0-sm7150-calls+)?

Found
: Yes. With touch -d @1230768000 on the configs and sensorspd unmasked and started, hexagonrpcd logged ~70 times each 'Tried to open .../registry/../temp.json for writing' and '.../sns_reg_version for writing' (no such file), 'Could not read from directory: Bad file descriptor'; the DSP asserted SNS_REG_INIT sns_registry_sensor.c:94 (SNS_RC_SUCCESS == rc) and crashed 7 times in about 25 s of the 150 s (remoteproc crash #1-#7), then 'Handover signaled, but it already happened' every second; ssccli: QRTR node was removed from the bus. After stop, the audio card stayed gone: only a reboot restored it (health 35 pass 0 fail after). Mask and mtimes put back; nothing kept. So the rule in the item applies: the way turns to sensors-registry-writes. Note: count crashes by remoteproc 'crash detected in adsp' lines, not by awk on dmesg timestamps (the probe's own count read 0).

Sources
: hexagonrpc-19,hexagonrpc-27,hexagonrpc-29

About
: sensors


<a id="walleye-slot-flip-why"></a>
### walleye-slot-flip-why

Brief
: Why a failed fastboot boot flipped the Pixel 2's slots, how to restore, how to keep tries from flipping them

Project
: linux-phone-oco/google-walleye-lab

Date
: 2026-11-17

Question
: Why did two fastboot boot tries change the A/B state, how do we restore it, how do we keep tries from flipping it, and should tries run on slot b?

Found
: Probable, not proven: the Pixel 2's bootloader is Qualcomm-derived ABL (Google's build is not public). In Qualcomm's ABL source (CAF pie mirror, QcomModulePkg FastbootCmds.c, PartitionTableUpdate.c, avb/VerifiedBoot.c), `fastboot boot` runs LoadImageAndAuth on the active slot; when that fails, HandleActiveSlotUnbootable sets slot a's unbootable flag (leaving successful set - the odd pair we saw), makes b active because b is successful, and cold-resets before the reply (our "Status read failed"). So our kernel probably never ran, and panic=10 is not the cause. `fastboot boot` does not decrement retry-count; a kernel crash falls back to a normal boot of the stock boot partition; a slot that is successful=yes is never counted down.
set_active X (ABL source): makes the slot active at priority 3, retry 7, clears unbootable and successful; swaps the a/b partition-type GUIDs and switches the UFS boot LUN: metadata only, undone by set_active back. a stays successful=no until Android on a marks itself good. `--slot` is ignored by `boot`.
Pixel 2 reports: loops end in "Slot Unbootable: Load Error", fixed by set_active (UBports forum 5639); after 7 unsuccessful boots the bootloader switches slot (pmaports MR 3190); the Pixel 2 XL bootloader refuses a kernel unless dtbo holds overlay id 2704 (kcxt dtbo README) - the likely real cause of the failed authentication, unconfirmed for walleye.
Not known yet: the real failure point; why try a stayed in fastboot and whether it changed flags; why b shows retry 0 after the switch; whether Google's ABL matches Qualcomm's.
Ways: leave flags and try on b (no write; if b is flagged too, set_active is the way out); set_active a now (a stays successful=no, the next failed try flips again); set_active before each try (a write per try); flash a stub dtbo to the active slot (a write, no known way back: the stock dtbo cannot be read back by fastboot); image changes (os_version 0 in our header untested).

Sources
: https://github.com/tadiphone-caf/bootable_bootloader_edk2/tree/pie/QcomModulePkg, https://android.googlesource.com/platform/system/core/+/refs/heads/main/fastboot/fastboot.cpp, https://source.android.com/docs/core/ota/ab/ab_implement, https://android.googlesource.com/platform/hardware/qcom/bootctrl/+/refs/heads/main/boot_control.cpp, https://gitlab.com/postmarketOS/pmaports/-/merge_requests/3190, https://forums.ubports.com/topic/5639/no-luck-installing-on-my-pixel-2-walleye/8, https://gitlab.com/kcxt/dtbo-google-wahoo-mainline

About
: walleye-first-fastboot-boot


<a id="walleye-bootimage-header-public"></a>
### walleye-bootimage-header-public

Brief
: Public sources: walleye/taimen boot.img is header v0, base 0, page 4096; no dtb/dtbo fields in v0; os_version is set by the AOSP build, not by porthole's deviceinfo

Project
: linux-phone-oco/google-walleye-lab

Date
: 2026-11-17

Question
: What do LineageOS's wahoo build and porthole's mkbootimg inputs say about header version, page size, base and os_version, and does a v0 header fit walleye?

Found
: LineageOS wahoo (lineage-15.1 BoardConfig.mk): BOARD_KERNEL_BASE 0, PAGESIZE 4096, default kernel offset, tags 0x01E00000 and ramdisk 0x02000000 for walleye and muskie (0x80000/0x02500000/0x02700000 only for the kasan builds), no header-version, dtb or recovery_dtbo argument: header v0; BOARD_USES_RECOVERY_AS_BOOT and system-as-root, dtbo in its own partition. Porthole's taimen deviceinfo: header v0, base 0, kernel 0x8000, ramdisk 0x1000000, tags 0x100, pagesize 4096 'verified against the stock taimen boot.img', kernel with the dtb appended, dtbo flashed to its own partition, no os_version set. A v0 header has no dt size or recovery_dtbo field (those arrive with v1/v2), so v0 fits walleye as far as public sources say; walleye's own stock header is still not read. The two offset sets are the two publics': taimen's stock (a) and LineageOS's (b), and try a, with the stock offsets, did not leave fastboot while b did. os_version/patch level: the AOSP build writes them into every boot.img (PLATFORM_VERSION, PLATFORM_SECURITY_PATCH); no public source for walleye gives the value, so variants c and d use 8.1.0 / 2020-01 (a pick). Not known: whether ABL reads them, and whether the dtbo overlay id (backlog walleye-dtbo-overlay-id) or the signature/AVB footer decides instead; porthole flashes a stub dtbo, which we have not.

Sources
: lineageos-kernel-google-wahoo,porthole-pmaports

About
: walleye-bootimage


<a id="commons-and-device-bases-world"></a>
### commons-and-device-bases-world

Brief
: Open projects keep schema and process in the commons, each unit its own claim; the commons pulls and derives. Full: idealkb commons-and-unit-bases-world.

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: How should docs split general knowledge from per-device work, and how does it learn each device's progress?

Found
: Read and summarised in grenudi/ideal-knowledge-base (research commons-and-unit-bases-world, material research/commons-bases/2026-11-17/): Linux MAINTAINERS, devicetree bindings vs board dts, Debian ports wiki, Renovate, GitHub templates and Copier agree on a commons with schema and process and units that declare their own status; the commons pulls and derives, a status typed twice drifts. Measured here: test_results 1.3 MB of 2.0 MB; 40 of 81 docs backlog items, 34 of 49 research rows and 14 of 28 decisions name a device. Not read: postmarketOS, Fedora ARM.

About
: commons-only


<a id="walleye-first-fastboot-boot-tries-on-b"></a>
### walleye-first-fastboot-boot-tries-on-b

Brief
: Second tries on slot b: boot-a accepted (Booting OKAY) but not started, boot-b refused (Load Error); slot flags did not change; our kernel still not seen

Project
: linux-phone-oco/google-walleye-lab

Date
: 2026-11-17

Question
: What do boot-a.img and boot-b.img do with slot b active, with devlab's before/after slot report?

Found
: With b active (a unbootable, as left): try a - fastboot "Booting OKAY [0.052s]", the phone stays in fastboot, no USB event, nothing answers. Try b - "Booting FAILED (remote: 'Failed to load/authenticate boot image: Load Error')", stays in fastboot. Slot flags before and after were identical both times (current b; a unbootable yes, successful yes; b unbootable no, successful yes; retry-counts 0), so set-active was not needed and was not used; nothing written.
The first try b (17:37, slot a active) behaved differently: the phone left USB and Android came up on b with a flagged unbootable. Same image, so what decided is not known yet (the active slot, or something that changed in between). Our kernel has not been seen to start at all. Next: the builder's variant with os_version and patch level set; a dtbo stub stays the author's decision.

About
: walleye-first-fastboot-boot

Material
: research/walleye-first-fastboot-boot/2026-11-17-on-b/

Supersedes
: walleye-first-fastboot-boot-tries


<a id="orchestration-2026-11-17-night"></a>
### orchestration-2026-11-17-night

Brief
: Orchestration hand-over, 2026-11-17 night: fastboot slots told, briefs restored, docs split decided, template base reviewed; owed: role keeper read-weight, brief trimming.

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: Where does orchestration's work stand, for a fresh orchestration session to take it up without this session's long context?

Found
: ROLE: orchestrator (brief ideal-agent-linux-phone-oco/orchestration.md, which opens with its Role/Name lines). Owns the conveyor - lab-tools/devlab, device-template, the Alpine path, docs' face and queries - and tends the agents. Notes: side-session-notes/local_325ef65d-55c6-44bd-85b9-53de24869d6e/orchestration-3.md (state, signs, every landing of 2026-11-17).
LIVE: surya lane - surya coordinator (local_0ecf107e) starts keepers with Role: keeper / Name: surya-keeper-N / Also practices: 42 and phone-keeper.md by path; waker linux-phone-keeper-waker only nudges it, reading tad q phone-next --device xiaomi-surya. Walleye lane - walleye coordinator (local_7fb92f70); google-walleye in fastboot on slot b with slot a unbootable (its bootloader's doing in a RAM boot try); slot_switch stays false until its decision and the author's word. ~/.local/bin/devlab is built from ~/Projects/linux-phone-oco/lab-tools at main (d510232); devlab-watch@surya-lab restarted on it.
LANDED SINCE THE EVENING HAND-OVER: lab-tools 80 (fastboot boot reads the slots' flags before/after and says where the phone went; set-active gated by [fastboot] slot_switch); docs 242 (the eight briefs restored after 226 reverted 230's role start), the slots item closed, gather-into-device-base recorded; reviewed: device-template 4 (each device's own tad base: parts contract, phone-next/phone-queue/next without --device), docs 260 (backlog.device, lane-next; kept until the split moves rows).
DECIDED (the author, via the Top Coordinator): docs holds only what helps every device; each device has its own base from device-template; docs pulls parts and derives support_status (decision 2026-11-17-commons-and-device-bases; backlog tad q next --about commons-only). Next links: feed-device-bases (docs), move-device-rows (with each keeper), then lab-tools/gather-into-device-base (orchestration's, waits on the move) and launchers-per-device (roles).
OWED: the clean 'after' read-weight - the first keeper started with Role lines on ideal-agent 0.3.6+ (keeper-6: 80,864 tok/30 KB; keeper-7: 79,870 tok but every practice, the hook then skipped started sessions) -> ideal-agent-roles local_dd7369b2; trimming the briefs of what the role cards say; tad-engine sign: a conditional rule (needs requires device), after the split; lab-tools kernel-orphan-modules. lab-agent's future is the Top Coordinator's research (research-lab-agent); devlab's root-exec/board uses move only on its word.
WAITS ON OTHERS: surya-lab surya-fastboot-serial (devlab flash refuses surya until its manifest has [fastboot] serial, likely dc21014b unread, and writes = true); walleye's slot decision.
DO NOT UNDO: the previous hand-over's list; every fastboot call names its serial; no partition write without writes = true, no slot switch without slot_switch = true; a boot's verdict is where the phone went and the flags, not fastboot's exit.
SIGNS: rebase and read diff --stat origin/main...HEAD before land (226 reverted 230); land's commit title is at most 100 characters and a research brief at most 200; a hold sent after a yes may arrive after the landing - say hold before yes when a direction is open.

About
: agent-folder

Supersedes
: orchestration-2026-11-17-evening


<a id="walleye-first-fastboot-boot-tries-c-d"></a>
### walleye-first-fastboot-boot-tries-c-d

Brief
: boot-c and boot-d (os_version and patch level set): both refused with Load Error, phone stays in fastboot, no USB event, flags unchanged; no image has started our kernel

Project
: linux-phone-oco/google-walleye-lab

Date
: 2026-11-17

Question
: Does setting os_version and patch level in the header make the bootloader start our boot image?

Found
: Try c (boot-a plus the header os word) and try d (boot-b plus it), on slot b with devlab's before/after report: both fastboot "Booting FAILED (remote: 'Failed to load/authenticate boot image: Load Error')" after the 0.368 s transfer. The phone stayed in fastboot: 18d1:4ee0 in all 90 one-second lsusb polls after each, nothing new on USB (no Linux gadget, no serial port), host kernel log empty. Slot flags identical before and after (current b, a unbootable). No write, no set-active.
So the os_version/patch level word does not make the bootloader accept our images, and it turned boot-a's silent "Booting OKAY" into a Load Error. No image has started our kernel; what the loader dislikes (header, kernel format, dtb, missing dtbo) is not known yet. Open: a dtbo stub is a write and stays the author's decision; the builder may try other header fields or a kernel with the dtb as Android expects.

About
: walleye-first-fastboot-boot

Material
: research/walleye-first-fastboot-boot/2026-11-17-c-d/


<a id="walleye-load-error-how-it-stands"></a>
### walleye-load-error-how-it-stands

Brief
: Pixel 2 Load Error: format matches what Pixel 3 ABL accepts; likely causes are the dtbo overlay merge, missing board-id/pmic-id, slot state, the os word - a control image first

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: What does the Pixel 2 bootloader dislike in our boot images (Load Error), from public sources, and which variants should be tried next?

Found
: What is: four images, one kernel/dtb/initramfs, all v0 with the dtb appended to a gzipped Image (Image.gz+dtb). a (taimen offsets, os word 0) got "Booting OKAY" then silence; b (LineageOS offsets) first left fastboot (Android came back on slot b), later Load Error; c and d (a, b plus os_version 8.1.0 / patch 2020-01) both Load Error. The only difference between a and c is that header word.

What others show (not the Pixel 2 itself - nobody reports a mainline fastboot boot there):
1. The format is the accepted one. Stock ABL on the same line (Pixel 3) takes a gzipped kernel with the dtb appended in a v0 boot image (U-Boot's board doc), and postmarketOS boots blueline with exactly base 0 / kernel 0x8000 / ramdisk 0x1000000 / tags 0x100 / page 4096 / dtb appended (pmaports deviceinfo). Two differences from our images: pmaports sets second offset 0 (we use 0xf00000; second is empty, so it should not matter) and no os_version/patch level at all. So "header v0 vs what ABL expects" and "Image.gz-dtb vs Image+dtb" are not the likely cause; the os word is, if anything, the one thing we added that pmaports does not have.
2. ABL, not the kernel, picks and patches the dtb (Inoki, MSM8998 Nokia 8): DeviceTreeAppended scans the appended blobs and DeviceTreeCompatible matches qcom,msm-id, qcom,board-id and qcom,pmic-id. Our dts carries only msm-id (0x124 0x20001, as kcxt's taimen, which boots with msm-id alone); it has no board-id or pmic-id. Whether walleye's ABL accepts that is not known; the stock walleye dtb's ids are not read yet (not in the public sources reached today).
3. The bootloader merges a dtbo overlay into the dtb before the kernel starts (AOSP DTO). kcxt found the taimen bootloader refuses a mainline kernel unless the dtbo partition holds an overlay with id 2704, and flashes a stub. Stock overlays patch downstream nodes a mainline base does not have, so a failed merge is the best-fitting reading of an immediate "Load Error" that comes from the bootloader after the transfer. Not proven for walleye: the dtbo of slot b is an older LineageOS build's, its overlay table not read.
4. "Load Error" is not proof the image is bad. Known-good TWRP for walleye got the same words from fastboot boot (Android SE), and one XDA report says it appeared randomly and went away on restart. Our slot flags (a unbootable, current b) were left by the first try; whether they feed the refusal is not known.
5. "Booting OKAY" then silence (a) means the bootloader sent its OK and a later step failed or the kernel died before any sign of life; it is a different outcome from Load Error, and a is the only image that got it. The os word turning OKAY into Load Error says the refusal is sensitive to the header word - the likeliest reason is the bootloader comparing the os_version/patch level with the active slot's recorded one (not read anywhere; unknown).

Ranked causes (each has a try that tells it apart): (H1) overlay merge fails against a mainline base, so a stub dtbo or a dtb that survives the stock overlay is needed - only fixable by a write (dtbo_b stub) or by finding that slot b's dtbo is not the cause; (H2) dtb ids: msm-id only, no board-id/pmic-id; free to test on the host; (H3) state: slot flags or random Load Error; test with a control image; (H4) header word: only os word 0 passes, so keep 0.
Control first: a stock-format image known to boot on walleye (LineageOS or TWRP recovery for walleye, public) through the same fastboot boot path. If the control also gets Load Error, the cause is the phone's state and no image change helps; if it boots, the cause is in our image and the variants below tell which part. The control is a try, not a write.
Not read yet and worth reading without writing: walleye's stock boot.img header and dtb ids from a public LineageOS wahoo build (host only), slot b's dtbo overlay ids (pstore/Android adb read - keeper only).

Sources
: uboot-qcom-abl-gzip-dtb,pmaports-blueline-deviceinfo,inoki-abl-dt-selection,aosp-dto-multiple,se-walleye-twrp-load-error,xda-twrp-load-error-random,kcxt-dtbo-wahoo-mainline,porthole-pmaports,kcxt-wahoo-5-17-dts

About
: google-walleye


<a id="2026-11-17-sh0-and-aop-research"></a>
### 2026-11-17-sh0-and-aop-research

Brief
: SH0 is a keepalive LLCC BCM; its sleep residual is a TAG_ALWAYS consumer (QUP/uart8), not a latch; AOP QMP wiring equals sm8150, no-ack unexplained

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: What is SH0 x=1,y=3, who votes it, what do SDM845/SM8150/SC7180 do, and why does the AOP not ack QMP?

Found
: SH0 is not a holder someone took; it is a keepalive BCM. In mainline sm7150.c, bcm_sh0 is "SH0", keepalive, node qns_llcc, identical to sdm845, sm8150 and sc7180 (the sc7180 Acer Aspire 1 reaches cxsd/aosd/ddr counts with the same definition). bcm-voter.c forces keepalive BCMs to x=y=1 (or enable_mask) only in the AMC and WAKE buckets. The SLEEP bucket is aggregated from consumers' tags only, so a sleep-set SH0 x=1,y=3 means a consumer whose tag includes SLEEP (QCOM_ICC_TAG_ALWAYS = AMC|WAKE|SLEEP) has a path through qns_llcc with a tiny bandwidth. In sm7150.dtsi the candidates are the QUP nodes, which use TAG_ALWAYS interconnects (one serial toward gem_noc SLAVE_LLCC, near line 1259), the crypto engine (ALWAYS to EBI, line 460), and uart8 serial@a88000 (the debug UART), which the recorded cycles show at avg 1 peak 1 across suspend. The owner is a DT tag on a consumer, not a firmware latch.
Whether the SH0 sleep vote blocks aosd is NOT known yet: no source shows the sleep-set contents of the Aspire 1 or any SM7150-class phone; SH0 is only the sole non-zero sleep entry on surya, which makes it the cheapest subtraction.
QMP: the aoss_qmp node (c300000, spi 389, mboxes apss_shared 0, apss_shared at 17c00000) is identical to sm8150 and sc7180, so the wiring in the tree is not the difference. Open succeeds, every send times out: the AOP does not clear the length word after the kick; qmp_send gives no other signal. Downstream wiring (irq-reg-base 17c0000c, mask 1) could not be confirmed from a source this session - not known yet. QMP matters only for the aoss prevent knobs (cx_mol, ddr_mol; hypothesis 5, unlikely) and is not on the path to the SH0 owner.
Read from the tree at kernel-rc3; nothing on the phone was touched.

Sources
: sh0-bcm-voter-c,sh0-sm7150-icc,aoss-qmp-patchwork,floor-travkin-aspire1

About
: deep-sleep


<a id="walleye-stock-ids-recorded"></a>
### walleye-stock-ids-recorded

Brief
: Walleye's stock boot.img (LineageOS 22.2 20261113): header v0, offsets as our image a, one dtb with msm-id 0x124/0x20001 and no board-id/pmic-id; ids are in the dtbo table

Project
: linux-phone-oco/google-walleye-lab

Date
: 2026-11-17

Question
: What do walleye's stock boot header and dtb carry (page size, offsets, cmdline, os word, qcom,msm-id/board-id/pmic-id), and is a dtbo present?

Found
: Source: LineageOS official walleye boot.img, build 20261113, https://mirrorbits.lineageos.org/full/walleye/20261113/boot.img, 33554432 bytes, sha256 48dbc55c76ee47840e645707b6bf3ac322099c06358178ad8ddf2c6a53c17468 (equals the site's published value; kept at ~/Projects/walleye-build/control/boot.img, data only, never run on the host). download.lineageos.org publishes no recovery.img for walleye; on A/B the recovery is in boot. unpack_bootimg: header v0; page size 4096; kernel load 0x8000; ramdisk 0x1000000; second size 0 and address 0; tags 0x100 (base 0: taimen/blueline offsets, the same as our image a); os_version 15.0.0, os_patch_level 2026-11 (a nonzero os word; ours are 0, or 8.1.0/2020-01 in c,d); product name empty; cmdline: androidboot.hardware=walleye androidboot.console=ttyMSM0 lpm_levels.sleep_disabled=1 user_debug=31 msm_rtb.filter=0x37 ehci-hcd.park=3 service_locator.enable=1 swiotlb=2048 firmware_class.path=/vendor/firmware loop.max_part=7 raid=noautodetect usbcore.autosuspend=7 androidboot.dtbo_idx=3. Kernel: lz4 (sha256 0256983d1002752214fde5035f78ce07e088d167bad993f3f16e1e9f78162872), Linux 4.4.302 arm64, with ONE dtb appended at byte 17613814 (376259 bytes, sha256 37dd8612cab84bd96025bd5831eac194fcf1f10bc8f8f08ea6ff72717a8f5751): model 'Qualcomm Technologies, Inc. MSM8998 v2.1', compatible qcom,msm8998-mtp / qcom,msm8998 / qcom,mtp, qcom,msm-id <0x124 0x20001>; NO qcom,board-id and NO qcom,pmic-id at the root. Ramdisk is xz (sha256 a0d50bc3063f3fd60e93c067ca9b54d16e670b6171eb498decc294d658f5dcbf). So the stock dtb is matched on msm-id alone, as ours is. The board identity is in the dtbo: dtbo.img of the same build (8388608 bytes, sha256 fb09009b7946bf33d860ee94cadfabdfcf3cf63a872314bc650d9220486bb8f6, equals the site's) holds a DT table of 13 entries, ids 0x1bc (revs 0-4 and 0x80), 0x190, 0x490, 0x590, 0x690 and more; androidboot.dtbo_idx=3 names the one merged; the overlays carry no qcom,board-id. So variant f's premise (stock board-id/pmic-id to copy) does not hold: f adds qcom,board-id <8 0> only (what qcom,mtp means), a guess, no pmic-id.

Sources
: aosp-dto-multiple,inoki-abl-dt-selection

About
: walleye-loaderror-stock-ids


<a id="walleye-control-e-f-tries"></a>
### walleye-control-e-f-tries

Brief
: Control (LineageOS walleye boot.img) and our e, f all refused with Load Error on slot b: the cause is the phone's state, not our image

Project
: linux-phone-oco/google-walleye-lab

Date
: 2026-11-17

Question
: Does a real stock-format walleye image boot by fastboot boot where ours is refused?

Found
: No. The LineageOS 22.2 boot.img, boot-e and boot-f each got Load Error ('Failed to load/authenticate boot image') within a second of the transfer; the phone stayed in fastboot (18d1:4ee0 in all 90 polls each); slot flags unchanged. Files: research/walleye-first-fastboot-boot/2026-11-17-control-e-f. So our images are not the (only) cause; open: dtbo/vbmeta/slot a flags, all writes or the author's.

About
: google-walleye


<a id="2026-11-17-pr27-registry-try"></a>
### 2026-11-17-pr27-registry-try

Brief
: PR #27 hexagonrpcd on surya: DSP writes /../sns_reg_version (outside any mapped dir), PR answers ENOSYS; ADSP dropped, reboot twice

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: Does hexagonrpcd of PR #27 (40e5041), run over a writable state copy of the registry, stop the DSP's registry write crash on surya?

Found
: No, not as built. Built 40e5041 for the phone (static aarch64 by hand: no meson on the lab; sha256 c4557f04...), seeded a state root with sensors/persist/registry as a copy of the package registry (the layout build_persist_dir maps), one try as a transient unit, sensorspd attach. The DSP asked for /vendor/etc/sensors/sns_reg_config (not found; our tree has it under sensors/config) and for /../sns_reg_version, first read then write: the path is outside every mapped directory and the PR answers 'Function not implemented' on the write; then 'Could not fetch next FastRPC message: Broken pipe' within a second - the ADSP dropped and the audio card went. Nothing was written to the state copy. One reboot did not bring the DSP back (no apr services); the second did (35 pass, 0 fail). So a writable registry directory is not enough: sns_reg_version has to be served as a file at the path the DSP uses, and sns_reg_config found. Next try: serve /../sns_reg_version (virtual file at root, writable in the state copy) and map sns_reg_config; one try per boot, expect two reboots to recover after a crash.

Sources
: hexagonrpc-27,hexagonrpc-19

About
: sensors


<a id="walleye-control-on-slot-a-try"></a>
### walleye-control-on-slot-a-try

Brief
: Control boot.img on slot a: Load Error again; the slot state is not the cause. Phone back on b, fastboot reachable

Project
: linux-phone-oco/google-walleye-lab

Date
: 2026-11-17

Question
: Does the LineageOS control boot.img boot by fastboot boot with slot a active (the state of the very first tries)?

Found
: No. Per decision walleye-slot-set-active-a-once: devlab fastboot set-active now a (before: current b, a unbootable yes/successful yes/retry 0, b unbootable no/successful yes/retry 0; after: current a, a unbootable no/successful no/retry 1). devlab fastboot boot now control/boot.img (sha256 48dbc55c..., LineageOS 22.2 20261113): 'Sending boot.img OKAY', then 'Booting FAILED (remote: Failed to load/authenticate boot image: Load Error)'; still in fastboot after a minute; the try changed no flags. So the refusal is not caused by slot b being active or by a being flagged unbootable: the same stock image is refused on a too. Open causes: dtbo/vbmeta state (a write, the author's or coordinator's call), or fastboot boot on this bootloader never takes an image of this kind. Restored with set-active now b: current b, a unbootable no/successful no/retry 1, b unbootable no/successful no/retry 1 (set-active resets b's successful flag; both slots bootable, retry counts 1); fastboot reachable, nothing written.

About
: walleye-first-fastboot-boot


<a id="walleye-boot-refused-why-how-it-stands"></a>
### walleye-boot-refused-why-how-it-stands

Brief
: Load Error is not the slot flags (control refused on a too); the one accepted try came with healthy Android on a, so the next test restores that state, then cold restart, host checks, UART

Project
: linux-phone-oco/google-walleye-lab

Date
: 2026-11-17

Question
: Why does the Pixel 2's bootloader refuse even LineageOS's official boot.img by fastboot boot (Load Error), and what makes fastboot boot work on it?

Found
: What is: the control (LineageOS 22.2 20261113 boot.img, stock header, AVB footer, own dtb) is refused with "Failed to load/authenticate boot image: Load Error" on slot b and, per walleye-control-on-slot-a-try, on slot a too; so are our b-f. Seen to be accepted: our boot-b on the very first try (slot a active, phone entered fastboot from healthy Android): the phone left USB, Android came up on b, a flagged unbootable; and boot-a, "Booting OKAY" with nothing starting, on slot b. The same image was refused later. So the refusal is not the image's format and, after the slot-a try, not the active slot or the unbootable flag alone. The same string and A/B flip are reported for walleye since 2017 (XDA PSA); on other Qualcomm ABL phones it comes "randomly" and goes with a restart, another port or cable, set_active or a stock reflash.

Ranked causes now (each by what it predicts):
1. State left by the first tries that set_active does not undo. The one accepted try came from a phone booted into Android on a, with a successful=yes (Android marks it when boot completes). Now a is successful=no, retry 1, and b's flag was reset by our set-active (b successful no). Predicts: after Android boots on a to completion (marks it successful) and the phone is put into the bootloader from that Android, the control is accepted again. Cheapest and reversible; it is the exact first state. Not tested.
2. A bootloader that has stayed up since a failed boot (the 'restart cures it' reports). Predicts: a cold power-off and start into the bootloader, then the same try, is accepted. Not tested; also covered by 1, which reboots the phone.
3. dtbo (or vbmeta) of the active slot. The bootloader picks overlays from dtbo by id and rev and refuses if none fits (AOSP DTO; the taimen bootloader wants id 2704, kcxt). Slot b's is an older Lineage build's and a's is current, yet both refuse, so a mismatch with the new dtb is unlikely; a cause only if 1 and 2 fail. A write; stays named, with no way back for the stock dtbo (fastboot cannot read it back).
4. Host: old fastboot, USB port, cable. The transfer succeeds and the refusal comes back at "booting", so least likely; recorded with each try (fastboot --version).
5. AVB and lock state: the phone reports unlocked yes, where verification errors are warnings; not measured.

Not known yet: the bootloader's own reason. Google's ABL is not public (the CAF Qualcomm ABL only shows the shape) and fastboot has no read-only oem command that prints it. The way to see it is the serial log over the Pixel 2's Android Debug Cable (Nura wiki), which needs the author's hardware.

Vector chosen: restore the first state, since it is the only state in which an image was accepted: set-active a, boot Android on a normally to completion (a's own Android, nothing written), adb reboot bootloader, the control once; then, if still refused, cold power-off start and host checks; then UART; a write last.

Sources
: xda-fastboot-boot-ab-psa,xda-load-error-restart,kcxt-dtbo-wahoo,nura-taimen-wiki,aosp-dto-compile

About
: walleye-first-fastboot-boot


<a id="walleye-first-state-control-accepted"></a>
### walleye-first-state-control-accepted

Brief
: First state restored: control ACCEPTED by fastboot boot after Android completed on a; phone then left USB entirely (no adb/fastboot) - needs a hand power-cycle

Project
: linux-phone-oco/google-walleye-lab

Date
: 2026-11-17

Question
: Does restoring the first state (Android completed on slot a, adb reboot bootloader) make the bootloader accept the control boot.img?

Found
: Yes. set-active a, fastboot reboot, Android up on a (sys.boot_completed 1, slot _a). After adb reboot bootloader: current-slot a, a unbootable no/successful yes/retry 0, b unbootable no/successful no/retry 1. devlab fastboot boot now control/boot.img: left fastboot after 12 s. devlab's 'came back as Linux, USB network answering' is a false match: the 18d1:d001 gadget (Qualcomm SM7150, serial postmarketOS) on the bus is the surya phone; walleye FA81N1A00790 was on no USB, no adb, no fastboot for 6+ min. So cause 1 (state left by the first tries) is confirmed: Load Error follows the slot's successful flag, not the image. Nothing written. The lab has no power control for walleye, so it is not back in fastboot: a hand hold of power 10-30 s is needed (slot a is successful, so it boots Android on a; then adb reboot bootloader). Next: boot-b/e from the same first state; fix devlab's came-back check to match the manifest serial.

About
: walleye-first-fastboot-boot


<a id="2026-11-17-sh0-not-uart8"></a>
### 2026-11-17-sh0-not-uart8

Brief
: SH0 x=1,y=3 (0x5003c data 0x60004003) stays in the suspend sleep flush with uart8 disabled: uart8 is not its owner; the GENI driver forces tag ALWAYS on every QUP path

Project
: linux-phone-oco/surya-lab

Date
: 2026-11-17

Question
: Does the debug UART (uart8, a88000) hold the SH0 sleep vote?

Found
: Read-only: icc_summary on the kept kernel lists non-zero bw only for usb, a88000 (1), 88c000 BT (2, 3200 aggre1), cpus. Try 1: dtb with uart8 interconnect tags 7->3 (ACTIVE_ONLY): the kernel summary still shows tag 7 - qcom-geni-se sets ALWAYS on its paths whatever the DT says, so tags in the DT cannot subtract a QUP vote. Try 2: dtb with serial@a88000 disabled; booted (health showed audio failures on that boot only; the next normal boot is healthy). cycle 15 bt-on, rpmh trace: the suspend-time sleep flush (tcs 2 [sleep], 6 cmds) at 153.75 reads addr 0x5003c data 0x60004003 = SH0 x=1,y=3 unchanged; cxsd/aosd/ddr 0 -> 0. So uart8 is not the owner, and DT tag changes are the wrong tool for the QUP consumers. Next suspects: the BT UART 88c000 (in use in bt-on), other QUP/crypto always-consumers by driver unbind, or SH0 not coming from an icc consumer at all.

About
: deep-sleep


<a id="walleye-own-images-e-b-first-state"></a>
### walleye-own-images-e-b-first-state

Brief
: e and b accepted from the first state, neither started: no USB device, flags unchanged, phone stays in fastboot

Project
: linux-phone-oco/google-walleye-lab

Date
: 2026-11-17

Question
: Does fastboot boot of our images e and b start from the restored first state?

Found
: Both ACCEPTED (Booting OKAY) but not started: 90 s watch by serial, phone stays in fastboot, no new USB device, no 172.16.42.1 (172.16.42.2 is surya's), slot flags unchanged; acceptance is not the cause of silence

About
: walleye-first-fastboot-boot


<a id="walleye-bootstrap-method-how-it-stands"></a>
### walleye-bootstrap-method-how-it-stands

Brief
: Best-known bootstrap: feedback channel first, vendor kernel as known-good, then mainline by fastboot boot; lk2nd is not for MSM8998/ABL; walleye skipped the vendor-kernel step

Project
: linux-phone-oco/google-walleye-lab

Date
: 2026-11-17

Question
: What is the best-known way to bootstrap an Android phone to mainline almost from zero (pmOS, Mobian/Halium, sdm845/sm8150 communities, MSM8998 siblings), and how does the walleye lane's work compare?

Found
: THE METHOD, in order (pmOS Porting/Mainlining guides, Qualcomm mainline porting, Halium early-init, MSM8998 pages): 1 unlock, keep the stock boot.img and a way back to Android; read offsets/ids from it. 2 Get a feedback channel BEFORE mainline: UART first, then simple-framebuffer, ramoops last (pmOS order); for a no-display phone the USB gadget shell is the channel. 3 Vendor kernel first as a known-good: Halium/UBports/Droidian boot the vendor kernel with their own initramfs (telnet 192.168.2.15, break= levels) - it proves image format, offsets, cmdline, gadget, and shows ids, rails, reserved memory. pmOS recommends a downstream port as the base but no MSM8998 sibling did it; they went straight to mainline. 4 Board dts from msm8998-mtp: fix model/compatible/board-id, delete CoreSight nodes, match regulators, clk_ignore_unused (still the normal first flag, Dybcio 2025). 5 Image.gz + dtb appended, mkbootimg base 0 page 4096, initramfs with debug-shell and USB gadget; fastboot boot (OnePlus 5, Mi 6, Pixel 3 XL with a stub dtbo; OnePlus 5T OxygenOS 9 cannot fastboot boot - flash instead). 6 First shell over USB peripheral (QMP + QUSB2 PHY, dr_mode peripheral); Pixel 2 XL reached exactly this, black screen. 7 Then UFS (not on Sony), display, touch, radios; upstream with b4.
LK2ND: not a route. Its device list stops at msm8996, msm8998 is '?' in targets.md, no Pixel, and it is an LK fork loaded by LK-based aboot; Pixel 2 runs a Qualcomm ABL/UEFI-derived bootloader. Pixel 3/sdm845 recipe is plain fastboot boot plus a stub dtbo, not lk2nd. U-Boot as second stage under ABL exists for sdm845 (FOSDEM 2024), not known for msm8998. Whether an LK image could run under ABL is not known yet.
WALLEYE LANE vs THE METHOD: done - stock ids and header read from the public LineageOS image, boot images a-f (17 checks), gadget initramfs proven in QEMU, minimal dts, control test, and the finding that Load Error follows the slot's successful flag (control accepted only from the first state). Gaps: (a) step 3 never done - no image has run a kernel on this phone, so cmdline, ids, rails, ramoops address, and the gadget on real hardware are unseen; (b) step 2 - no feedback channel chosen: UART needs a cable and an oem decision, ramoops address unverified, simplefb unlikely (command-mode DSC panel); (c) the order: the lane went to its own mainline image before any known-good boot. The control (LineageOS boot.img, vendor 4.4 kernel) is accepted from the first state but then left USB with no sign for 6+ min, so even a stock image gives no feedback on this phone yet.
NOT KNOWN YET: whether the vendor kernel in the control reaches a configfs gadget (LineageOS kernels normally do for adb); whether fastboot oem uart enable persists; walleye's dtbo overlay id; first-shell method on taimen (flash vs fastboot boot); sm8150 practice and the FOSDEM 2024 slides were not read. pmOS wiki now at wiki.nura.eco behind a bot wall; read as raw wikitext.

Sources
: pmos-porting-new-device,pmos-mainlining-guide,pmos-qualcomm-mainline-porting,pmos-msm8998,oneplus5-mainline-jamikettunen,pmos-mi6-sagit,lk2nd-devices,pmaports-crosshatch-153,halium-early-init,ramoops-doc,android-debug-cable-howto,dybcio-ignore-unused,kcxt-dtbo-wahoo,xda-fastboot-boot-ab-psa

About
: google-walleye


<a id="2026-11-17-sh0-bt-blocked-cycle-resets"></a>
### 2026-11-17-sh0-bt-blocked-cycle-resets

Brief
: cycle 15 with Bluetooth blocked does not return: the phone reset, no reading; icc bw is 0 on every QUP/UFS/MMC path, so SH0 looks by-design

Project
: linux-phone-oco/surya-lab

Date
: 2026-11-17

Question
: Does blocking Bluetooth (88c000 quiet) drop the SH0 sleep vote?

Found
: On the kept kernel, way-back.sh enable then cycle 15 (BT blocked): the journal ends at 'cycle: sleep 15 s, fuse 30 s' and the phone came back after a reset (uptime 1 min, no pstore record), so the watchdog fired and no counters were read. icc_summary before the cycle: only usb (240000) and cpus carry bw on llcc/ebi; ufshc, i2c, spi, mmc, scm paths carry tag 7 at bw 0. So there is no consumer with bandwidth to subtract; SH0 x=1,y=3 may be by design and the holder elsewhere (clocks, GDSCs, counter validity). Wi-Fi after the reset stayed down: the saved SSID is not in range (the lab AP shows another name) - an environment change, not the cycle.

About
: deep-sleep

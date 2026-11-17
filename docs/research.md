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


<a id="bringup-tools-landscape"></a>
### bringup-tools-landscape

Brief
: No tool does build, swap and check of a boot image in Rust; the parts exist (header, cpio, dtb, compression) and the oracles are mkbootimg and avbtool, so we wrap.

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-17

Question
: What exists to build, unpack, swap and check Android boot images and initramfs for a phone bring-up, and what does walleye's shell do today?

Found
: What is: walleye's bring-up is 8 POSIX shell scripts (~520 lines) in google-walleye-lab/build plus tests/host/gadget-up.sh; they call mkbootimg, unpack_bootimg and avbtool (Python from android-tools), the kernel's gen_init_cpio, lz4, fdtget/fdtdump, with their own checks (check-bootimg, check-bisect count fields and fail). Their knowledge is worth keeping: header v0 offsets by variant, the appended dtb, the lz4 frame shape of the stock kernel, the AVB hash footer (algorithm NONE, padded to the control's size), the NET=43 address rewrite, xz because the 4.4 kernel has no gzip. surya's bring-up had no scripts (by hand). Earlier records already decided the family: backlog rust-toolset (one Rust toolset in lab-tools, rust-script for small scripts, pmbootstrap read as reference) and decision 2026-11-17-health-checks-shell-and-rust (shell for plain readings, Rust for logic, rust-script for prototypes and one-offs).
Others: nothing covers the whole job. Android's mkbootimg/unpack_bootimg/repack_bootimg and avbtool (Python) are the authoritative oracles; magiskboot (Rust+C++, GPL) has the model of swapping one part (unpack to a directory, change, repack with the original as template) but is aimed at rooting; abootimg-oxide 0.5.2 (Rust, MIT/Apache, 2026-06) reads and writes header v0-v4 and vendor_boot; abootcrafter has an update flow, no AVB; abl-exorcist (Rust, GPL) shells out to mkbootimg; no AVB crate exists on crates.io (avbroot, GPL, does vbmeta, is no library). Rust crates for the rest: cpio 0.4.2 (newc writer), flate2, lz4_flex (maintained), dtoolkit 0.5.0 (Google, dtb read/edit, young), fdt (read). pmbootstrap is Python, ~24k lines in 129 files; its deviceinfo names (header_version, base, kernel_offset, ramdisk_offset, tags_offset, pagesize, cmdline) are the vocabulary to reuse; the boot image is not built there. Mobian, Droidian (initramfs-tools-halium: shell hooks for an initramfs only), lk2nd (a bootloader, no host tooling): nothing to take. No tool checks an image against expected header fields; unpack_bootimg plus a comparison is all there is, which is what our check scripts do.
Not known yet: whether abootimg-oxide writes byte-identical v0 images; dtoolkit's maturity; whether cpio 0.4.2 reads; whether boot-deploy, Mobian and Halium scripts add anything (not read; the outside look was done by a read-only researcher from page summaries, so counts are weaker than a source read).
Where tools live today: lab-tools (its README: tools for bringing up and testing Linux phones, not tied to one device) is the one place already: devlab (the phone: fastboot, flash, kernel try, provision, keeper, health, MCP; 5.4k lines with rmcp and tokio), health (runs on the phone) and tone. Device repos hold data and thin scripts.

Sources
: aosp-mkbootimg,aosp-avbtool,magiskboot,abootimg-oxide,rust-bringup-crates,pmbootstrap-deviceinfo,abl-exorcist,abootcrafter

About
: bringup

Material
: research/bringup/2026-11-17/


<a id="bringup-home-follow-and-rhizoid"></a>
### bringup-home-follow-and-rhizoid

Brief
: A tool is followed by a pin, not files: device parts live beside it as data, hooks or a rust-script on the pinned library; rhizoid carries the cutting and slice cases and lacks three things.

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-17

Question
: How do device repositories use, extend, send back to and update from a tools home, side by side with no rebase, and where does rhizoid fit?

Found
: The question: a home for bring-up tools must also let device repositories use them, extend them with device-specific parts, send useful changes back and pull updates in, their own changes side by side with no rebase each time (the author's words, relayed by the coordinator; the problem git-rhizoid was started for). Extends research bringup-tools-landscape.
What is: the chain already decided (idealkb decision 2026-11-17-chain-follow-by-slice, research chain-follow-world): one pin-and-follow mechanism for data and briefs - a source names its generic files, a follower pins a release and keeps its own files, a changed generic file ends follow.sh with exit 3 and goes back as an upstream item (ikb upstream-item, form patch), weekly update-pins and a release gate; device bases follow idealkb and device-template that way. It lays a slice of files. Rhizoid (git-rhizoid.github.io, rhizoid repo) is for whole forks: a cutting is a fork owned and pinned, tracking branch pristine, patch branch merged from it, rhizoid's own metadata additive-only, so a diff of patch against tracking is a clean patch back; its CLI is typed but add/update/status are stubbed, its consumption side is open (design-consumption-side) and slice-consumption was added 2026-11-17 by the idealkb chain. devlab and lpoco-health already reach consumers as released packages (release-plz tags, the packaging conveyor), not as copied files.
Finding: a tool is not a slice. Compiled logic is followed by a version pin, not by files laid into the follower, so the rebase trouble does not arise for the tool at all as long as a device never edits the tool's tree: its own parts live in its own repository, beside the tool, in three levels. (1) Data: device.toml [boot] and the files it names (initramfs skeleton, dtb variants). (2) Hooks: executables the manifest names for a step (shell where stupid simple), called with the paths in arguments, a nonzero exit stops the job. (3) Logic: a rust-script file (or a small crate) in the device repository whose header depends on bringup's library at the pinned tag (rust-script and cargo take a git tag as a dependency). Only two things then need the follow machinery: the pin (a version line the follower owns) and the slice of files that go with the tool in device-template (the [boot] skeleton, hook examples). Sending back: a generic improvement is a pull request to lab-tools from the device's branch, recorded in the device base as an upstream item (form patch) against a lab-tools upstream row seeded beside idealkb and device-template; an update comes by a pin bump (the weekly job, a pull request per source). Side by side: the device's changes are files of its own, so a pin bump touches none of them; when a device must patch the tool itself before upstream takes it, that is a cutting of lab-tools consumed as a git dependency (Cargo [patch]) - rhizoid's exact case, rare because the three levels cover most.
Where rhizoid carries it, and what it lacks (recorded on its own backlog, git-rhizoid.github.io PR 28, not worked around): a cutting consumed by a language manager - writing and bumping the pin where cargo or rust-script reads it (cutting-as-cargo-dependency); one pin file, one bump, one verdict for slices, cuttings and tool versions together (followers-one-pin-bump); sending a patch back as a pull request on the person's word with the follower's own record of it (send-back-writes-the-upstream-item); and slice-consumption (already open) for the template files. Until rhizoid has them: idealkb's follow.sh and update-pins for the slices, a plain fork with a [patch] line for the rare cutting, recorded as a problem.
Not known yet: whether bringup's library API can stay stable enough for the third level while it is 0.x (the first builder's test of pin refusal tells); whether a host binary release (asset) or cargo install --git is the simpler install for a device lab (bringup-release settles it).

Sources
: rhizoid-repo,rhizoid-design-log,idealkb-chain-follow,rust-script-deps,cargo-git-and-patch

About
: bringup

Material
: research/bringup/2026-11-17/


<a id="bringup-family-names"></a>
### bringup-family-names

Brief
: Tool families share a prefix where others install them (git-, cargo-, pm); lab-tools: lpoco- for what is pinned or installed, short names stay for the lab's own devlab and tone.

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-17

Question
: Should linux-phone-oco's tools share one prefix (lpoco-bringup, lpoco-health; devlab, tone renamed or not), or none?

Found
: What is: lab-tools has devlab (host command, built from the clone, named in about 450 files of linux-phone-oco and in the MCP door's tool names), tone (a library crate and its command, not installed anywhere) and lpoco-health (a package shipped to phones, renamed from devlab-health when it became one, the old name kept as another name). Collisions checked 2026-11-17: crates.io already has a crate named tone (0.0.1); devlab, bringup and lpoco-bringup are not taken as crates, none is on the lab's PATH or in the Arch repositories.
How others do it: git-* and cargo-* are discovered by the prefix itself (a subcommand is any git-NAME or cargo-NAME on PATH) and complete at the prompt; pmbootstrap and pmaports carry pm for postmarketOS across the whole family; systemd uses a suffix (*ctl) for the same purpose. In each, the prefix marks the tools others install, and it names whose they are.
Finding: share the prefix where the tool is installed or pinned by others (lpoco-health, lpoco-bringup); keep the short names of the lab's own commands (devlab, tone) until they are installed elsewhere - renaming them now costs about 450 references, the installed path and the MCP tool names for no reader's gain, and the alias precedent (devlab-health kept as another name) makes the later rename cheap. A mixed family is acceptable when the rule is one sentence. Not known yet: when devlab is first pinned by a device repository (that triggers its rename).

Sources
: rhizoid-repo

About
: bringup


<a id="bringup-one-roof"></a>
### bringup-one-roof

Brief
: One roof: an lpoco dispatcher (git-style) runs lpoco-NAME programs, one pin, one release, one MCP door; each tool stays its own small crate; old names stay as aliases.

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-17

Question
: Should all lpoco tools sit under one command, one pin and one release (the author: one roof), and in what form?

Found
: Asked by the author after the prefix amendment: the point was to gather all tools of lpoco under one roof. Forms: (a) one lpoco command with subcommands, as git and cargo do - a dispatcher that runs lpoco-NAME found beside it or on PATH; (b) every tool renamed lpoco-* now, released together; (c) the prefix rule with devlab and tone deferred (the first amendment). What a roof buys: one install, one pin in device.toml [tools], one completion and man page, one MCP server, one place agents look. What it costs: ~450 references to devlab and the MCP tool names, softened by keeping the old names as other names (the lpoco-health precedent). Constraint: lpoco-health ships to phones as a small static binary (opt-level s, no tokio, no rmcp), so a single fat binary would grow the phone's program; a dispatcher keeps every tool its own crate and binary, testable and runnable alone. Finding: (a) as a dispatcher over lpoco-* programs, family released together with a version lockstep check, the new tool born as lpoco-bringup under it; devlab becomes lpoco lab (devlab kept as another name), tone lpoco tone, the MCP door becomes lpoco mcp. Not known yet: whether release-plz makes one family tag easily (the builder of lpoco-dispatcher settles it); whether a feature-gated single binary would later be simpler.

Sources
: rhizoid-repo

About
: bringup


<a id="orchestration-2026-11-17-late"></a>
### orchestration-2026-11-17-late

Brief
: Orchestration hand-over, 2026-11-17 late: both lanes moved into their own bases, docs pulls their parts; owed: derive-parts-in-base, about-across-bases, older items.

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: Where does orchestration's work stand, for a fresh orchestration session to take it up without this session's long context?

Found
: ROLE: orchestrator (brief ideal-agent-linux-phone-oco/orchestration.md). Notes and the move scripts (move-lane.sh, replay.sh, select.sh): side-session-notes/local_7d95b264-ad32-49ad-932a-7f19e9f9806d/move/.
DONE 2026-11-17 (decision 2026-11-17-commons-and-device-bases, all landed and read back from main): google-walleye-lab #14 and surya-lab #134 got their own tad bases from device-template; walleye's rows moved (google-walleye-lab #15, docs #353) and surya's (surya-lab #136 with all 143 runs identical row for row, docs #360), each under the lease orchestration-move, by the rule of decision 2026-11-17-moving-a-lane; the lane briefs (walleye-coordinator, surya-coordinator, phone-keeper), the five launchers and the waker read the lab's own base (phone-next, lane-next --needs, phone-stands) and record with ikb; device-template got lane-next and phone-stands; lab-tools #82 (gather files into the base; devlab-watch@surya-lab restarted on it); tad 0.7.1 (references by a table's key; pins bumped in the template and both labs); feed-device-bases (#355, #356) pulls each base's parts daily and devices.base names both labs (#361); the face rendered from the pulled parts. move-device-rows, gather-into-device-base, launchers-per-device done.
OPEN (commons-only): derive-parts-in-base (a base derives parts.measured from its own runs; until then surya's measured fields stay as seeded at the move), about-across-bases (abouts naming the device, a milestone or another base's subject were left empty in the move), device-template-follow; the older owed items of orchestration-2026-11-17-night (keeper read-weight, trimming briefs, kernel-orphan-modules) still stand.
WAITS ON OTHERS: the walleye coordinator closes docs PRs 335, 337, 310 and settles 316 (two unlanded s0n-try rows contradicting main; to be recorded in the lab if they hold).
SIGNS: a shared ~/.local/bin/tad was overwritten by another project's make setup (0.5.0) - install-tad.sh defaults to ~/.local/bin on a shared lab; jq's index(.) inside a pipe evaluates . against the array (bind $x first); the ideal-agent guard now refuses writing tad sql (TAD_SQL_WRITE_OK=1 for a recorded one-time migration); a refused command skips its git checkout too - read the branch before committing; land refuses a branch that puts back lines main changed; a pages build is not triggered by the feeds bot's push (the 3-hourly schedule catches up).
DO NOT UNDO: the previous hand-overs' lists; no walleye or surya rows land in docs any more - a lane records in its lab.

About
: agent-folder

Supersedes
: orchestration-2026-11-17-night


<a id="bringup-image-v0-oxide-writes-v0"></a>
### bringup-image-v0-oxide-writes-v0

Brief
: abootimg-oxide 0.5.2 writes the v0 header byte for byte as mkbootimg; the id (SHA-1 of three parts) and trailing padding are the caller's

Project
: linux-phone-oco/lab-tools

Date
: 2026-11-17

Question
: Does abootimg-oxide write header v0 byte-exact, or must pack wrap mkbootimg?

Found
: Measured 2026-11-17 with a scratch program against mkbootimg (android-tools, header v0, base 0, kernel 0x8000, ramdisk 0x1000000, tags 0x100, page 4096): the crate's header write gave bytes identical to mkbootimg for the whole length it wrote. Two gaps, both ours to fill: (1) full_write only seeks to boot_image_size, so the image ends before the last page's padding (15288 of 16384 bytes) - pack pads itself; (2) the header id: mkbootimg's v0 id is SHA-1 over kernel, ramdisk and second, each followed by its u32 size (three parts), while the crate's compute_hash_digest hashes five (adds recovery dtbo and dtb) - so for v0 the id is computed in our code. With both, pack equals mkbootimg for the plain header and with os_version/os_patch_level words (tests/pack_v0.rs, two cases). mkbootimg writes second address 0 when there is no second image, whatever second_offset says. Header::parse reads v0..v2 and v3/v4; this tool reads v0 only for now. Cost: binrw and thiserror come with the crate. Not known yet: v1/v2 write parity, vendor_boot.

About
: bringup-image-v0


<a id="principles-world"></a>
### principles-world

Brief
: Durable charters are small, on one page, with short stable ids as link targets; none enforces cite-not-restate, so check the link and measure the restating.

Project
: linux-phone-oco/docs

Date
: 2026-11-17

Question
: Where do linux-phone-oco's founding principles live, and how do briefs and guides cite them without restating?

Found
: Read: Debian Social Contract and DFSG (5 and 10 numbered points, versioned 1.0-1.2, cited as DFSG #n), Mozilla Manifesto (10 principles, anchors principles-01..10), Wikipedia five pillars (shortcuts WP:5P1..5, redirects keep citations after renames), Rust API guidelines (54 items with ids such as C-CASE that are the anchors), RFC 7282 and PEP 20 (cited by section or wording), the kernel's Developer's Certificate of Origin 1.1 (the version is part of the name), MADR decision drivers (local to one record). Not read: Arch principles (blocked), PEP 1, Nygard's ADR post, the Rust RFC process. Locally: the idea table holds the story (as good as Android, counted), conveyor concepts are five rows, restating lines sat in phone-keeper and device AGENTS.md; overlay-check (ideal-agent) flags a brief that restates ideal-agent's words by 6-word runs, 15 percent limit.

About
: no-manual-steps

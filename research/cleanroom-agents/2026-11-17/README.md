Clean-room reverse engineering with AI agents, and how walleye (Pixel 2, MSM8998) applies it: what the recent papers and the practice of the Linux reverse-engineering projects say, a role and record design that keeps the wall provable, and the walleye parts that need it. Researched 2026-11-17 by research-cleanroom-agents for the walleye coordinator. Not legal advice.

# 1. What the research says (and how far to trust it)

Read: abstracts of the papers below (arXiv ids as listed on the search index; the full text of Reversa only). Everything dated 2026 is as the index shows; I could not check the papers' peer review.

**Agents are now competitive at reading binaries, but that is not what a clean room wants.**
- Humans vs. Machines (arXiv 2610.14960): the best agents reach human-competitive understanding on two compact tasks, much faster; they "fetch greedily" and fill the context; scaling needs persistent analysis state and selective retrieval.
- SRE-Bench (2608.11469): on realistic, contamination-free binaries the best agents fully solve only about 27-32 %. CrackMeBench (2605.10597), CREBench (2604.03750), Reveree (2609.01185): small-scale benchmarks; failures sit in the *comprehension* stages, not the tooling; some flags are recalled from training data.
- Decompiler-refinement papers (2604.23940, 2603.14855, 2606.16162, 2601.14598 and others): the winning pattern is a loop of generate, compile, run, compare with the real behaviour. Execution feedback is what matters, not a bigger model. This is a *decompilation* line: it takes disassembly as input and so is the wrong tool for a clean room, but its loop (behavioural test as judge) is the right one for the implementing side.
- RARE (2607.12507): content inside the analysed binary can act as instructions or as fake independent evidence to an LLM analyst (35/40 adversarial binaries produced a planted unsafe action). Fix: binary-derived text is data only; tool calls are authorised outside the model; count evidence by origin, not by number of records. Applies directly to an observing agent that reads vendor logs, strings, firmware images.
- Apple Neural Engine paper (2606.22283): a public reverse-engineering report that labels every claim *measured*, *decompile-derived* or *predicted*. That labelling is a good provenance habit; for us only *measured* (and *from public spec* / *from GPL source*) may feed the implementers.
- Reversa (arXiv 2605.18684, May 2026, read in full): a multi-agent pipeline (scout, archaeologist, detective, architect, writer, reviewer) that turns a legacy system into specifications for agents; claims carry confidence and gaps, traceability matrices, Gherkin parity scenarios, human validation. One simple case (a COBOL ATM to Go: 517 claims, 53 parity scenarios; cutover not finished). It has no clean-room or legal discussion and its analysers read the source. Useful as a *spec shape*, not as a process.
- Closest to our job (hardware): no paper I found has an LLM agent infer register maps or protocols from MMIO traces. What exists is firmware rehosting/peripheral modelling (2608.29737, 2403.06281, 2509.07615), LLM driver co-evolution (2511.18924, 56 % compiled) and LLM kernel-API migration (2611.16215). Honest reading: **the research does not yet cover clean-room hardware bring-up; the practice does (section 3).** Hardware-in-the-loop feedback is what made agents work in the nearest study (Embedded Arena 2606.16190: 0 % without hardware feedback, success within three iterations with it).

**Practice reports on AI clean rooms (blogs, news; weaker evidence).**
- ArtCraft/storytold (Sept-Oct 2026): seven then thirteen Rust "clones" (PhotoCraft, WordCraft, DeckCraft ...) by about 8 parallel Claude agents, each owning one directory. Press says "clean-room"; I found **no source describing a two-team split** there. What is public in WordCraft's AGENTS.md: agents may observe the product black-box (run it, synthetic documents, window screenshots kept out of git) and read public specs (ECMA-376, ISO 29500, RTF, ODF); never read, disassemble or copy anything inside the app bundle (file names and listings only), never copy assets, strings, GPL code of other products; check and claim an issue before coding. So the ArtCraft "clean room" is a **rule on inputs** (observation plus public specs, nothing else), not an organisational wall. Reading by Claude of the running product's behaviour is the allowed channel. The craft-contrib/standards repo I tried to read returned 404 (private or moved): the checksum stamping is not verified by me. Sources: Gunter 2026-10-31, kingy.ai, flowtivity.ai, Engadget.
- Process manual (Kyvero-Vexus, 2026-03-21, a GitHub write-up, not peer reviewed): A-team observes and writes the spec; B-team implements from the spec and public references only; C-team audits. Controls: separate repositories with ACLs and separate channels; spec templates as the only A to B channel; signed taint declarations; taint register; an "expression scrub" review of the spec; test IDs mapped to spec clauses; commits citing spec sections; append-only signed logs, artifact hashes, CI gates that block a merge without spec/test linkage; an immutable evidence bundle; a contamination procedure (freeze, isolate, compare, purge, redo).
- chardet 7.0 (March 2026): a maintainer had Claude rewrite an LGPL library "from an empty repository" and relicensed to MIT; the original author objected. The dispute turns on exactly the proof questions below: the maintainers had seen the old code, and nobody can show what the model saw in training. No court has ruled (Register 2026-03-06, LWN, Phoronix). A second case: a Python rewrite of a leaked source map ("claw-code") (Marc Bara, Medium 2026-04-07) with the same open question. Also: purely AI-generated output may not be copyrightable, and clean-room is no defence against patents.
- Lesson of both: with a model, "the implementer never saw the original" cannot be proven by its mind. It can only be proven by **what was put in front of it**, i.e. records of inputs. That is the design below.

# 2. Legal and process practice (humans)

- EFF Coders' Rights reverse engineering FAQ: intermediate copying for interoperability has been held fair use (Sega v. Accolade 977 F.2d 1510; Sony v. Connectix); the district court in Sega said Accolade could have used a clean room, but the appeals court did not require it: clean room is good practice, not a legal requirement. Its advice: one team studies and writes a functional manual, a separate team writes original code from that manual alone; use the least intrusive technique first (observing signals between chips, stepping in a debugger) before disassembly; acquire the software legitimately; EULAs with no-reverse-engineering clauses can be enforced as contracts; DMCA section 1201 has only narrow interoperability exceptions; keep copies minimal. Talk to a lawyer.
- Nouveau: mmiotrace (in the kernel) records what a binary driver does through MMIO; demmio/envytools annotate it against a register database (rnndb); the mailing list names the Chinese-firewall method (one person reads and documents, another implements) and warns against using stolen documentation or copying a decompiled driver.
- Asahi Linux (progress report Aug 2021): a bespoke hypervisor (m1n1) runs macOS unmodified on the real hardware and traces MMIO; Python tracers decode GPIO, RTKit, the DCP protocol layer by layer; the traces are dumped and analysed offline, then turned into protocol implementations and documentation for Linux drivers. They state that disassembling Apple's drivers would put the project's copyright status in jeopardy and is also inefficient: they record accesses "without actually looking at the code". Later tracers for the GPU (Alyssa Rosenzweig) and DCP followed the same way.
- freedreno: Rob Clark instrumented the vendor userspace to trace register reads/writes, wrote a parser on envytools' librnn and an rnndb register database; cffdump/libwrap decode command streams. Panfrost: wrapper libraries dump command streams and shaders from the vendor driver; Collabora reverse-engineered the Mali-G78 (Valhall) ISA in about a month with a shader-dumping wrapper and a disassembler, then published the documentation. Note: Panfrost people also read vendor *binaries* (ISA work, shader disassembly) - the instruction set of the GPU is the observed thing there. That is a line walleye's rule does not cross (see section 4).
- postmarketOS (Qualcomm mainline porting wiki): the vendor's downstream kernel source is the first reference; the port is a device tree plus mainline drivers; firmware and a second-stage bootloader (lk2nd) are the usual hurdles. Source dumps of mainline for MSM8998 phones exist (OnePlus 5/5T); the Pixel 2 XL (taimen) boots mainline with a minimal DT and `clk_ignore_unused` (wiki) and a 2021 DT patch (Caleb Connolly) was not merged; display needs DSC.

# 3. How observing and implementing agents are best separated (synthesis)

Two designs exist; the second is what the evidence supports.
1. *Mind wall* (ArtCraft's reading, chardet): "this agent was told not to look". Cheap, but not provable, and a model's training data cannot be inspected.
2. *Input wall*: what an agent can be shown is the only thing it can have learned, so keep the inputs in two stores that cannot mix, and keep a log of what went into each session. The process manual above and the Nouveau/Asahi practice agree.

Roles (agents or people; each a fresh session with a written brief):
- **Observer** (dirty side): runs the stock system on the phone through the lab's tools, takes traces, reads GPL vendor source, writes *spec rows*. Output: spec rows and trace files only.
- **Scrubber/reviewer** (a different session from the observer): checks every spec row for expression (copied structure, names, comments, constants not needed for function), classifies each claim by source (below), rejects rows that cite forbidden input. This is the C-team and the only reader of both sides.
- **Implementer** (clean side): sees only accepted spec rows, public specifications and data sheets, mainline kernel source, the project's own tests; never the observer's raw material. Output: code citing spec ids.
- **Tester**: the phone's own tests (the project already requires them) judge the implementation against observed behaviour; failures go back as observed *behaviour*, not as a pointer into proprietary material.

Records that make the wall provable (all through ikb/tad, spec rows are data, code is code):
- Spec row per claim: id, what (register, message, sequence), value, *evidence kind* (`measured-trace`, `measured-behaviour`, `public-spec`, `gpl-source`), evidence file with a hash, tool and command that produced it, date, observer session, reviewer verdict. No row without an evidence file; no `disassembly` or `blob-string` kind exists.
- Input log per session (a session-log row): what the session was handed (spec ids, paths, hashes), what it ran. For an implementer: the list is its whole world. The brief itself is kept.
- Taint register: which sessions saw which material (observers: yes; implementers: no); an implementer session that sees raw material is discarded and its commits re-done.
- Commits and PRs cite spec ids; a CI check refuses a patch that cites none, or touches a path outside its role; a diff scan against the evidence folder for verbatim runs (a similarity check from the observer's side to the implementer's output at merge).
- Separate worktrees/paths: raw material lives outside the repository the implementers have (observer notes under research/, trace dumps with a hash in the row, not in git if large); implementers get a checkout without them.
- A prompt-injection rule (RARE): observer agents treat everything captured from the phone as data; logs cannot grant tool permissions.

Tools agents use without Ghidra (all observation of behaviour): ftrace and dynamic debug, `mmiotrace`-style and regmap tracing on mainline, Qualcomm's own stock-kernel debugfs and dmesg on the running stock system, QMI/QRTR message logs, `fastboot getvar`, the I2C/SPI/SoundWire bus logs, device-tree dumps from the running system (`/proc/device-tree`, `/sys/firmware`), clock and regulator summaries, pinctrl and gpio debugfs, `perf`, a logic analyser or a debug UART when hands are available, Asahi-style hypervisor tracing is not available on Pixel 2 (no EL2 control from a locked-down stock kernel).

# 4. For walleye (MSM8998): where it applies, and the line

The vendor kernel is **GPL v2** (the Pixel 2's Android kernel source, android-msm-wahoo, and the fork kcxt/linux-wahoo): reading it, porting it with copyright and licence kept, and citing it as `gpl-source` needs no clean room (this is the project's existing rule in phone-keeper.md). Most MSM8998 parts are already upstream (clocks, pinctrl, PMIC, UFS, USB, SDHCI, GPU a5xx via freedreno, remoteprocs, audio via apr/q6) and need **only a device tree and mainline drivers**, not a clean room. What a clean room may be needed for:

| Part | Clean room? | Why |
|---|---|---|
| Boot, SoC basics, storage, USB, PMIC | no | upstream drivers + the GPL DT of the fork |
| Display (DSC panel, DPU) | partly | panel init sequence is not in the GPL kernel if it is in the bootloader or a blob; observe by tracing DSI on the stock system and write the init as spec rows; mainline already has DSC. Panel data sheet is not public |
| Touch, sensors (the Pixel 2 uses a sensor hub / SLPI) | likely | if firmware is a blob, speak to it by observed messages |
| Camera (ISP, HAL) | yes, last | stock stack is closed; not a first milestone |
| Modem, Wi-Fi, Bluetooth | no for drivers (upstream ath10k/qrtr), yes only for any Google/vendor-specific protocol or calibration data; firmware blobs come from the phone's own partitions as the project says |
| Audio codec and DSP topology | partly | upstream codec drivers; the vendor "ACDB" calibration data and topology are observed on the stock system |
| GPU | no | freedreno a5xx; the GPU zap shader/firmware comes from the phone (Qualcomm signed); not read, only used |
| Haptics, NFC, fingerprint, Pixel Visual Core, Titan M | clean-room-only or out of scope | no open driver; decide later |

(That table is my judgement from the project's briefs and the upstream state I know; the walleye keeper's own recorded checks should replace each guess. Not known yet: what the stock kernel exports in debugfs for each part on walleye.)

**Never crosses the wall (for both sides, and into any record, note, commit):** vendor binaries and libraries (`/vendor`, `/system` blobs), firmware images read for their *content* (they may be *loaded* by the device, not read), disassembly or decompiler output of any proprietary code (Ghidra, objdump, IDA, strings dumps), proprietary header files or SDK docs under NDA or leaked, and anything written by someone who had them. GPL source of the kernel is fine; GPL source in userspace likewise as source, but its licence travels with it. A leaked or "found" data sheet counts as proprietary.

Asymmetry to keep from Asahi: reading a vendor *binary* to learn what it does is the thing they avoided; do the same. Panfrost-style ISA disassembly is **out** for walleye by our rule, even where the community does it; we do not need it (a5xx is upstream).

# 5. Proposed record design (small, uses what the knowledge base has)

- A spec row kind: `ikb concept` now (a spec row is a concept: id, name, summary, why, about), with the evidence fields in the summary until a `spec` record exists; propose a `spec` record with the fields above (a backlog item on docs, asked of tad owners, not built here).
- One decision per wall: `2026-11-17-walleye-input-wall` (inputs, not minds) with what was rejected (mind wall, ArtCraft style rule-only; full three-team process with signed declarations for a hobby project: too heavy).
- Role briefs: observer, scrubber, implementer (three short files under ideal-agent-linux-phone-oco, one paragraph each, linked from walleye-coordinator.md).
- The first trial: pick one part that surya has already solved (e.g. wcd9375 reset pin state), have an observer write spec rows from a stock-system trace, an implementer produce the DT/driver change from rows only, and check it against the phone's test: this measures whether the wall costs more than it saves. Not measured yet.

# 6. What is not known (never as broken, only as not yet checked)

- Whether any LLM-agent clean-room paper exists for hardware: none found; a deeper search may find one.
- Whether the ArtCraft house rules include an enforced wall: only the public AGENTS.md text was seen.
- Whether Google's factory image licence restricts reading its contents: not read.
- The legal status of AI-agent clean rooms: no court has ruled; these sources are blogs. Ask a lawyer before shipping anything derived from proprietary behaviour; GPL-source ports need none.

# Open Handset Commons

> *A conceptual model for open handsets, extracted from prior art and grounded in hardware reality.*
> *The model is the product. A working open handset is one possible output of the model.*
> *OHC's own role is to watch, map, and lift — not to build.*

---

## What This Is

Open Handset Commons is a conceptual framework and an ecosystem observatory — not a phone project, not a company, not a specification. It does two things.

**First:** it extracts durable principles from everything the open hardware and open source community has already built, learned, and failed at in the space of Linux smartphones — and from the proprietary platforms (Android, iOS) that have solved problems the open ecosystem hasn't reached yet.

**Second:** it watches the entire ecosystem, maps every project's progress against the model, and provides coordination infrastructure — CI/CD pipelines, progress boards — to the projects working within it. OHC does not build. It observes, maps, and lifts.

The method is borrowed from technical business analysis: catalogue the prior art without prejudice, find what overlaps (proven consensus), find what gaps remain (hard unsolved problems), lift those findings into named concepts — and be rigorous about which gaps actually belong in the model and which are real observations that sit outside OHC's scope.

---

## The Prior Art

Ten projects, two operating systems, and one firmware form the evidence base.

| Source | Type | Key contribution | Critical gap |
|---|---|---|---|
| **PinePhone** | Open Linux phone | Full software ecosystem; mainline Linux | No IP push during sleep |
| **Crust Firmware** | SCP standby firmware | Two Minds architecture proven; 80% power reduction | Sub-processor too small for network tasks |
| **Librem 5** | Open Linux phone | Physical radio isolation; created Phosh | No hardware security processor |
| **SPIRIT** | CM5 prototype | First open CM5 phone PCB; Quectel on CM5 proven | No Watchful Mind. Standby absent. |
| **HackBerryPi CM5** | CM5 handheld | CNC aluminium enclosure; slim form factor proven | No cellular modem |
| **OURphone** | Pi phone | Full phone stack on HAT modules; working 2024 | Module-only form factor |
| **ZeroPhone** | Pi phone (hist.) | First documented Pi phone; vocabulary established | 2G only; stalled |
| **Android / AOSP** | Proprietary OS | Power regime; HAL; security chip; OTA; push | Vendor lock-in at every layer |
| **iOS** | Proprietary OS | Secure Enclave; APNs; update covenant; power discipline | Total vendor dependency; no repairability |
| **GrapheneOS** | Open OS / closed HW | Daily driver without Google; user-enrolled verified boot | Hardware not open; Android-dependent |

Full analysis of each is in `prior-art/`. Analysis of overlaps and gaps is in `analysis/`.

---

## Nine Concepts

The prior art resolves into nine structural concepts. The first five are derived from the open ecosystem. The next three come from the proprietary platforms — gaps the open ecosystem has not yet closed that directly determine whether a handset can function as a daily driver. The ninth is OHC's own role.

Each concept earns its place by answering yes to one question: *does ignoring this concept prevent the device from functioning as a daily driver?* Observations that don't pass that test are real — they are documented in the Scope Boundary section — but they are not part of the structural model.

---

### 1. The Two Minds

**A handset is always two computers, not one.**

One — the Deep Mind — runs the OS and applications. Powerful, hungry, should sleep deeply when the user is away. Its natural state is **off**.

The other — the Watchful Mind — asks one question continuously: *has anything happened that warrants waking the other?* No user interface. No applications. Its natural state is **on**.

Crust firmware proves this on PinePhone via the AR100 sub-processor: 80% power reduction in deep sleep, call wakeup via the modem's Ring Indicator GPIO. Every open project without this separation has no standby answer and none is possible without it. The interface between the two minds is narrow by design — wakeup signal one way, context handoff the other on resume.

---

### 2. The Radio Wall

**The cellular radio is a contractor the computer hires. Not part of the computer.**

The modem is physically and logically separate. It communicates through a minimal, documented protocol (AT commands). It does not share memory with the main processor. It can be powered down independently. It can, in principle, be replaced.

This is an engineering necessity, not a security posture. Cellular modems operate under RF regulations completely alien to the rest of the computing stack. The two must evolve independently. Every successful open Linux phone (PinePhone, Librem 5) has the Wall. None that entangled the modem with the main SoC has succeeded in the open ecosystem.

---

### 3. Notification Sovereignty

**Push notifications are the rent paid to platform owners. An open handset eliminates the landlord.**

Android mandates Google FCM. iOS mandates APNs. The vendor is a mandatory intermediary in the delivery of every application notification. An open handset routes notifications through user-controlled infrastructure instead.

The Watchful Mind maintains a minimal persistent connection to the user's own relay server. The relay translates all app push sources into one lightweight protocol the Watchful Mind can handle within its constrained resources. When a notification arrives, the Watchful Mind decides whether to wake the Deep Mind. The platform vendor is not in this chain.

This is the only gap in the open prior art with zero implementations. Crust firmware wakes on an incoming call — a cellular hardware signal, no network stack required. It cannot wake on a Matrix message without the Deep Mind polling periodically and destroying battery life. The Watchful Mind in all prior art is too resource-constrained. The UnifiedPush standard solves the application-layer half. The Watchful Mind's network awareness is the open half. **This is OHC's primary technical contribution to the model.**

---

### 4. The Consolidation Path

**Form factor is not a design choice. It is the endpoint of a process.**

An open handset starts as stacked off-the-shelf modules. It ends as a single multilayer PCB. Same architecture, same interfaces, less volume at each step. The module stage proves the architecture works. The PCB stage proves form factor is achievable. The enclosure is designed last, around the fixed board — never first.

OURphone: stage one (working phone, stacked modules). SPIRIT: stage two (custom PCB, 3D-printed enclosure). HackBerryPi CM5: stage three — but without cellular, not yet a phone. No project has reached stage three as a phone with cellular and standby architecture. That is the next open point on the path.

---

### 5. Platform Compatibility as Precondition

**Driver support is the entry ticket, not a feature.**

Projects built on poorly-supported hardware spend their existence on driver work. postmarketOS ships on hundreds of devices, almost all in perpetual negotiation with incomplete driver support, closed GPU blobs, and SoC-specific suspend quirks. The structural problems — Two Minds, Notification Sovereignty, Security Substrate — are never reached because there is no time left.

A platform with full mainline Linux kernel support eliminates this cost entirely. The tradeoff (BCM2712 is not power-optimised for mobile) is a fixed, known constraint that can be designed around. Driver debt compounds indefinitely. Accept the fixed cost, reject the compounding one.

---

### 6. The Security Substrate

**There is a third mind in every proven handset. It guards only one thing: secrets.**

Apple Secure Enclave, Google Titan M2, Samsung Knox Vault — a dedicated security processor isolated from both the Deep Mind and the Watchful Mind. Its own OS. Its own boot chain. Its own encrypted memory. The encryption keys protecting user data live here. They never leave — not if the main OS is fully compromised, not with physical access to the device.

Without a Security Substrate, disk encryption is software-only. Encryption keys live in RAM. A cold-boot attack can extract them. This is not theoretical — it has been demonstrated against real devices.

**Every open Linux phone lacks this entirely.** The gap is not technological — the ATECC608A secure element costs under €2 and stores hardware-backed ECC keys that never leave the chip. Linux dm-verity and the Keyring subsystem are the software side. The integration has simply never been prioritised. That is the gap.

The Security Substrate is a prerequisite for the Update Covenant — they cannot be addressed independently.

---

### 7. The Update Covenant

**Every handset makes an implicit promise about its future. An open handset must make it explicit.**

Apple commits to 6-7 years of iOS updates per device. Google Pixel commits to 7 years. Updates arrive signed by a known key. The Security Substrate verifies the signature before installation. The device refuses to downgrade to known-vulnerable firmware. If an update fails, it rolls back.

Open handsets update via package managers — indefinitely in intention, but without a committed timeline, a signing authority, hardware-enforced verification, or rollback. GrapheneOS proves a community project can operate a credible signed OTA chain — but only because the Pixel's Titan M2 provides the hardware anchor. The Update Covenant without the Security Substrate is a policy without enforcement.

**The open structural advantage:** a device with open hardware has no vendor-imposed obsolescence. The Update Covenant, once established, can be transferred to any willing community maintainer. Proprietary devices die when the vendor decides. An open device with a community-maintained covenant has no built-in end of life.

---

### 8. The Power Covenant

**The hardware standby architecture is necessary but not sufficient. The OS must also prevent software from defeating sleep.**

The Two Minds solve the hardware dimension. The Power Covenant solves the software dimension: what prevents application code from holding the Deep Mind awake when the user is not present?

Android's answer: Doze Mode, App Standby Buckets, WorkManager — a declared, auditable system for background execution. Background work reduced over 68% since Android Marshmallow. iOS's answer is blunter: undeclared background processes are terminated. The OS decides when apps run in the background.

Open Linux phones have no enforced Power Covenant. Any process can hold a wakelock indefinitely. A single misbehaving application defeats the entire Two Minds architecture in software. The primitives exist — systemd-inhibit, cgroups, cpufreq governors, PowerTOP. The enforced, integrated regime built on them does not.

The Power Covenant and the Two Minds are one solution in two parts. Neither is complete without the other.

---

### 9. The Observatory

**OHC does not build handsets. It watches the ecosystem, maps progress, and lifts the infrastructure burden from projects working within it.**

The open handset ecosystem is not failing for lack of effort. It is failing for lack of coordination and shared infrastructure. Projects independently solve the same problems. Most have no CI/CD. Most have no integration with prior work. When a project stalls, its work becomes invisible rather than becoming the foundation for the next.

OHC is the Observatory: a persistent, live view of the entire ecosystem.

**Mapping** — every project catalogued and mapped against the nine concepts: which it implements, to what maturity, what remains open. This is the master board.

**CI integration** — for projects with existing pipelines, OHC integrates their build and test status into the master board. The board is driven by live signals, not manual updates.

**CI lifting** — for projects without CI/CD, OHC proactively offers to set up and maintain it. The project keeps full control of its code and decisions. OHC provides infrastructure, not direction.

**Outreach** — dormant projects are not deleted. Their state is preserved. OHC attempts periodic contact. If foundational work is at risk, OHC documents the fork path and seeks new maintainers.

**Gap reporting** — the master board generates reports: which concepts have no active project, which have overlapping work, which are closest to completion. New contributors are oriented toward gaps that matter.

The structural parallel is intentional. The Observatory watches the ecosystem the way the Watchful Mind watches the radio: persistent observation, minimal direct action, escalation when warranted.

---

## The Complete Architecture

```
╔══════════════════════════════════════════════════════════════╗
║                     THE DEEP LAYER                          ║
║  Full OS · Applications · User Interface                     ║
║  Power Covenant enforced here (wakelock discipline)          ║
║                                                              ║
║  Sleeps when user is away                                    ║
║  Wakes on Watchful signal                                    ║
║  Resumes with context from Watchful                          ║
╚═══════════════════════╤══════════════════════════════════════╝
                        │  narrow: wakeup signal + context handoff
╔═══════════════════════▼══════════════════════════════════════╗
║                   THE WATCHFUL LAYER                         ║
║  Always on · Minimal resources · No UI                       ║
║                                                              ║
║  Monitors Radio Layer (calls/SMS via Ring Indicator)         ║
║  Persistent connection to User Relay (push notifications)    ║
║  Stacks events during Deep sleep                             ║
║  Wakes Deep when warranted · Hands off context on resume     ║
╚═══════════╤══════════════════════════════════════════════════╝
            │  narrow: events up / commands down
╔═══════════▼══════════╗     ╔═════════════════════════════════╗
║   THE RADIO LAYER    ║     ║   USER RELAY                    ║
║                      ║     ║                                 ║
║  Cellular modem      ║     ║  Self-hosted · UnifiedPush      ║
║  AT command protocol ║     ║  Translates all app push        ║
║  Physically isolated ║     ║  to Watchful's protocol         ║
║  SIM / RF            ║     ║  No platform vendor             ║
╚══════════════════════╝     ╚═════════════════════════════════╝

╔══════════════════════════════════════════════════════════════╗
║               THE SECURITY SUBSTRATE                         ║
║  Parallel to all layers · Isolated from all layers           ║
║                                                              ║
║  Hardware root of trust · Keys never leave                   ║
║  Verified boot chain · Signs and checks firmware updates     ║
║  Prerequisite for the Update Covenant                        ║
╚══════════════════════════════════════════════════════════════╝

              ↑ everything above is what OHC maps ↑

╔══════════════════════════════════════════════════════════════╗
║                  THE OBSERVATORY (OHC)                       ║
║                                                              ║
║  Maps every project against the nine concepts                ║
║  Integrates CI/CD into the master board                      ║
║  Lifts CI infrastructure for projects that lack it           ║
║  Tracks dormancy · Publishes gap reports · Outreach          ║
╚══════════════════════════════════════════════════════════════╝
```

---

## Open vs. Proprietary — The Full Map

| Concept | Android | iOS | Open (best current) | Open gap |
|---|---|---|---|---|
| Two Minds | 🟡 Doze + USB wakeup | 🟡 Background modes | ✅ Crust/AR100 on PinePhone | Not on CM5 |
| Radio Wall | 🟡 Module, not isolated | 🟡 Module, not isolated | ✅ Librem 5 M.2 card | Enclosure stage |
| Notification Sovereignty | ❌ FCM mandatory | ❌ APNs mandatory | 🟡 UnifiedPush apps only | Watchful Mind not network-aware |
| Consolidation Path | ✅ Vendor-managed | ✅ Vendor-managed | 🟡 SPIRIT at stage 2 | Stage 3 not reached as phone |
| Platform Compatibility | 🟡 HAL layer required | ❌ Proprietary stack | ✅ Mainline Linux | **Open wins here** |
| Security Substrate | ✅ Titan M2 / Knox | ✅ Secure Enclave | ❌ Absent | Critical gap |
| Update Covenant | ✅ 7yr + A/B + hardware verify | ✅ 7yr + Secure Enclave verify | 🟡 Package updates only | No hardware anchor |
| Power Covenant | ✅ Doze + Buckets | ✅ Background termination | ❌ No enforced regime | Integration gap |
| Observatory | ❌ No equivalent | ❌ No equivalent | ❌ Absent | **OHC's primary contribution** |

Platform Compatibility is the one structural dimension where the open ecosystem has a genuine advantage over proprietary platforms. Full mainline Linux kernel support, no reverse engineering, no vendor cooperation required. The proprietary platforms are built on hardware locked to their own software. Open hardware works with any compliant OS by design.

---

## Scope Boundary

The following observations emerged from the prior art analysis and are documented honestly here — but they are **outside OHC's structural model.**

**Application sandboxing** — Android and iOS sandbox applications using Linux namespaces, seccomp, and cgroups. Open Linux phones don't enforce this by default. But: Linux has stronger sandboxing primitives than Android — they are what Android uses underneath. The gap is not conceptual or technological. It is default configuration and integration, which individual distributions and packaging systems (Flatpak on Phosh, Waydroid) are working on. OHC catalogues those projects but does not model sandboxing as a structural concept because the capability already exists and the approach is a distribution-level choice, not a handset-level one.

**App store curation** — Apple and Google pre-screen apps. This is centralized authority over what software users may install, which is structurally incompatible with the open handset model. The security tradeoff is noted and accepted.

**eSIM** — All proprietary handsets support eSIM. No open phone does. The hardware and software exist. The blocker is carrier certification — a commercial process, not an engineering one. Physical SIM works identically for all daily-driver use. OHC tracks this as a feature gap in the prior-art catalogue, not a structural model gap.

---

## Repository Structure

```
open-handset-commons/
│
├── prior-art/                          # Evidence base — one YAML per project
│   ├── pinephone.yaml
│   ├── librem5.yaml
│   ├── spirit.yaml
│   ├── hackberrypi-cm5.yaml
│   ├── ourphone-zerophone.yaml
│   ├── crust-firmware.yaml
│   ├── android-aosp.yaml
│   ├── ios.yaml
│   └── grapheneos.yaml
│
├── analysis/
│   └── gaps-and-overlaps.yaml
│
├── model/
│   ├── concepts.yaml                   # Concepts 1–5 (open ecosystem prior art)
│   ├── concepts-extended.yaml          # Concepts 6–9 + scope boundary
│   └── architecture.yaml              # Structural relationships between concepts
│
└── README.md
```

---

## Contributing

**New prior art.** Any project that contradicts, extends, or confirms a concept. Match the YAML schema. Be honest about gaps.

**Evidence that challenges a concept.** If an open handset project has implemented Notification Sovereignty or closed the Security Substrate gap, that is the most valuable possible contribution. Concepts are conclusions, not axioms.

**Scope challenges.** If an observation currently outside the model belongs inside it — or a concept currently inside should be demoted — that argument belongs here with evidence.

**Observatory participation.** If you maintain an open handset project and want your CI integrated into the master board, or want OHC to provide CI infrastructure, that is the Observatory's primary function.

---

## Prior Art Credits

- **Arsenijs Picugins** — ZeroPhone
- **GrapheneOS Project** — GrapheneOS
- **OURS Project** — OURphone
- **Pine64** — PinePhone hardware
- **Purism** — Librem 5; Phosh UI shell
- **Samuel Holland and Crust contributors** — Crust SCP firmware
- **smunaut and SPIRIT contributors** — SPIRIT CM5 phone PCB
- **UnifiedPush community** — Vendor-neutral push notification standard
- **ZitaoTech** — HackBerryPi CM5 enclosure design

---

*OHC claims no trademark and holds no affiliation with any hardware or software vendor.
All prior art remains the property of its respective authors and communities.*

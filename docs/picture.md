---
title: The grand picture
---

# The grand picture

**Goal:** Linux phones as good as Android and iOS, or better - shown with evidence, not claimed.
This page is the plan for showing where they stand and moving them forward. The site around it
is built from data, and is updated automatically wherever a machine can find the answer.

## Three layers

| Layer | Question | Source |
|---|---|---|
| **Why** | What must a phone have, structurally, to be a daily driver? | The nine concepts of Open Handset Commons (Two Minds, Radio Wall, Notification Sovereignty, Consolidation Path, Platform Compatibility, Security Substrate, Update Covenant, Power Covenant, Observatory), with their prior art |
| **What** | Which capabilities does a modern phone offer, and does each work on Android, on iOS, on Linux phones - and on which? | The **feature matrix**: every capability, in groups, against Android, iOS, the best current Linux phone, and each Linux stack |
| **Where** | Which parts of that work on *this* device, today? | **Devices**: one tab per device (surya first), each capability with its status and the evidence behind it |

## The feature matrix (the main screen)

Groups, each a set of capabilities a user would notice missing: calls and messages (voice,
VoLTE, SMS/MMS, voicemail, emergency calls); connectivity (mobile data, Wi-Fi, Bluetooth, hotspot,
NFC, GPS); audio (speakers, earpiece, headphones, microphones, Bluetooth audio); camera (photo,
video, both cameras, QR); display and input (touch, rotation, brightness, on-screen keyboard);
sensors; power (suspend with wakeups for calls and push, battery life, charging, off-mode
charging); security (encryption, verified boot, secure element, app isolation); updates (OTA,
rollback, years of support); apps (native apps, Android apps via Waydroid, app store); sync and
accounts (contacts, calendar, backup); everyday services (push notifications, payments, banking).

Each cell is a status - works, partial, missing, unknown - with evidence: a test result, a
source, a date. A cell nobody has checked says *unknown*, never *works*.

## Evidence: the conveyor

Status should come from things that can be re-checked, kept as data in this repository:

1. **Our test suites** (in the device lab, surya-lab, then device-independent). Three kinds:
   *automatic* (the machine checks it: the audio DSP is up, the speaker is stereo, a tone played
   on the speaker is heard by the microphone), *witnessed* (a person confirms what the machine
   cannot: "which speaker did you hear?", answered with a button), *manual* (needs hands: a call
   to a second phone). Each run writes results; results update the device pages.
2. **Upstream feeds**, collected on a schedule by CI: device statuses in postmarketOS (pmaports,
   wiki), kernel work for the SoC (the sm7150-mainline tree, patches on the mailing lists), the
   shells' releases (Phosh, Plasma Mobile, GNOME Mobile, Sxmo), project CI results.
3. **Our contributions upstream**, as a ledger: what we found, the fix, where it was sent, its
   state. Nothing is lost while it waits.

## How the orgs divide the work

- **linux-phone-oco** - the home: this site and its data (docs), the device labs (surya-lab), the
  kernel work (linux), the face (.github).
- **open-commons-observatory** - the method, domain-free: the observatory protocol, the prior-art
  schema, concept extraction. linux-phone-oco applies it to phones.
- **open-smartphone-commons** - superseded by linux-phone-oco; its profile points here.

## Phases

1. **Data model and site** - features, platforms and evidence as tables; the prior art imported
   from the research; the matrix and device tabs on GitHub Pages.
2. **The surya test suite** - the steps taken by hand on surya so far, turned into tests whose
   results feed the device page.
3. **Upstream feeds** - collectors on a schedule, so the matrix moves when the ecosystem moves.
4. **More devices**, and the tests made device-independent.

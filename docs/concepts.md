<!-- Generated from data/ by tad. Do not edit by hand. -->

# Concepts

<a id="one-baseline"></a>
### One baseline per device

Project
: linux-phone-oco/lab-tools

Summary
: Every check that ever passed is held to; a check outside a run's scope is not asked, rather than kept in a second baseline.

Why
: Two baselines would be two truths about one phone.


<a id="refuse-what-cannot-work"></a>
### The conveyor refuses what cannot work

Project
: linux-phone-oco/lab-tools

Summary
: Each mistake that cost a try becomes a refusal with a reason: a kernel that is not an EFI program, a listening test without the word that the microphone is placed.

Why
: A refusal costs a second; a lost try costs a reboot and a wrong theory.


<a id="read-the-record"></a>
### Read the device's own record first

Project
: linux-phone-oco/surya-lab

Summary
: Before cleaning up after an experiment, read what the device itself recorded: a boot entry's try counter, the bootloader's selection, the crash memory.

Why
: Three theories about the bootloader were wrong; the entry's counter settled it in one look.


<a id="relative-listening"></a>
### A placed microphone gives relative levels

Project
: linux-phone-oco/surya-lab

Summary
: A microphone placed by the phone tells which speaker is louder from where it stands, and whether there is sound at all - not absolute loudness.

Why
: Honest about what the instrument can say.


<a id="the-reference"></a>
### The phone is the reference

Project
: linux-phone-oco/surya-lab

Summary
: Kept in a known-working state at all times: every experiment is one try that falls back by itself, and the phone is checked well before and after.

Why
: A reference that drifts cannot tell a regression from a mistake.

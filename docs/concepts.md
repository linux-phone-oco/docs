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

About
: surya-tested


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

About
: audio-mic


<a id="the-reference"></a>
### The phone is the reference

Project
: linux-phone-oco/surya-lab

Summary
: Kept in a known-working state at all times: every experiment is one try that falls back by itself, and the phone is checked well before and after.

Why
: A reference that drifts cannot tell a regression from a mistake.


<a id="as-good-as-android"></a>
### As good as Android

Project
: linux-phone-oco/docs

Summary
: A phone running Linux that an ordinary person could use as their only phone and not feel they gave something up - counted one feature at a time.

Why
: The aim is plain and counted against Android's everyday use (the idea, section 05); without a measure it would be a hope.

Ord
: 1


<a id="measured-not-claimed"></a>
### Measured, not claimed

Project
: linux-phone-oco/docs

Summary
: A feature counts only when a test run has shown it works; what nobody measured is unknown, never broken.

Why
: The picture is honest or it is worth nothing: status is read off the runs (decision 2026-11-17-support-read-off-results).

Ord
: 2

Rests on
: ideal-agent


<a id="mainline-first"></a>
### Mainline first, everything upstream

Project
: linux-phone-oco/docs

Summary
: Work is done on mainline Linux and written to be sent upstream: each fix its own series, checkpatch-clean, to the upstream it belongs to; vendor code is read as a specification, never copied.

Why
: A fix kept in a fork helps one phone; a fix upstream helps every phone and stays maintained.

Ord
: 3

Rests on
: ideal-agent


<a id="no-manual-steps"></a>
### No manual steps outside tools

Project
: linux-phone-oco/docs

Summary
: What a person does twice becomes a command, a record or a test, so that bringing a phone up can run by itself; where hands or eyes are the measurement, the step is a witnessed test, said before and recorded.

Why
: The conveyor's point (the idea, section 03): the same known steps every time, by a person or an agent; manual_work counts what is still by hand and whether it is automated.

Ord
: 4

Rests on
: ideal-agent


<a id="rust-with-argenv"></a>
### Rust, with argenv

Project
: linux-phone-oco/docs

Summary
: linux-phone's tools are Rust, each declaring its command line and environment once with argenv.

Why
: One declaration gives the parser, the help, the man page and the completions, so they cannot disagree.

Ord
: 5

Rests on
: ideal-agent
